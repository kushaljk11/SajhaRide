package com.riderental.myriderental.controller.admin;

import com.riderental.myriderental.dao.KycDAO;
import com.riderental.myriderental.model.KycVerification;
import com.riderental.myriderental.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

/**
 * Controller for handling KYC verifications by admins.
 */
@WebServlet("/admin/kyc")
public class AdminKycServlet extends HttpServlet {
    private final KycDAO kycDAO = new KycDAO();

    /**
     * Displays a list of pending KYC verifications.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User user = session != null ? (User) session.getAttribute("loggedInUser") : null;
        
        if (user == null || !"ADMIN".equalsIgnoreCase(user.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            return;
        }

        try {
            List<KycVerification> pendingKycs = kycDAO.findAllPending();
            request.setAttribute("pendingKycs", pendingKycs);
            request.getRequestDispatcher("/WEB-INF/views/admin/manage-kyc.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Unable to load pending KYC requests", e);
        }
    }

    /**
     * Processes KYC approval or rejection actions.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User user = session != null ? (User) session.getAttribute("loggedInUser") : null;
        
        if (user == null || !"ADMIN".equalsIgnoreCase(user.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            return;
        }

        String action = request.getParameter("action");
        String kycIdParam = request.getParameter("kycId");

        if (action == null || kycIdParam == null) {
            session.setAttribute("errorMessage", "Invalid request parameters.");
            response.sendRedirect(request.getContextPath() + "/admin/kyc");
            return;
        }

        try {
            int kycId = Integer.parseInt(kycIdParam);
            
            if ("approve".equals(action)) {
                boolean success = kycDAO.updateStatus(kycId, "APPROVED", null, user.getUserId());
                if (success) {
                    KycVerification kyc = kycDAO.findById(kycId);
                    if (kyc != null) {
                        com.riderental.myriderental.dao.UserDAO userDAO = new com.riderental.myriderental.dao.UserDAO();
                        User kycUser = userDAO.findById(kyc.getUserId());
                        if (kycUser != null) {
                            kycUser.setVerified(true);
                            userDAO.update(kycUser);
                        }
                        com.riderental.myriderental.dao.NotificationDAO notifDAO = new com.riderental.myriderental.dao.NotificationDAO();
                        com.riderental.myriderental.model.Notification notif = new com.riderental.myriderental.model.Notification();
                        notif.setUserId(kyc.getUserId());
                        notif.setMessage("Congratulations! Your KYC document has been approved and your account is now verified.");
                        notifDAO.create(notif);
                    }
                    session.setAttribute("successMessage", "KYC verification approved successfully.");
                } else {
                    session.setAttribute("errorMessage", "Failed to approve KYC.");
                }
            } else if ("reject".equals(action)) {
                String reason = request.getParameter("reason");
                if (reason == null || reason.trim().isEmpty()) {
                    session.setAttribute("errorMessage", "Rejection reason is required.");
                    response.sendRedirect(request.getContextPath() + "/admin/kyc");
                    return;
                }
                boolean success = kycDAO.updateStatus(kycId, "REJECTED", reason.trim(), user.getUserId());
                if (success) {
                    KycVerification kyc = kycDAO.findById(kycId);
                    if (kyc != null) {
                        com.riderental.myriderental.dao.NotificationDAO notifDAO = new com.riderental.myriderental.dao.NotificationDAO();
                        com.riderental.myriderental.model.Notification notif = new com.riderental.myriderental.model.Notification();
                        notif.setUserId(kyc.getUserId());
                        notif.setMessage("Your KYC document was rejected. Reason: " + reason.trim());
                        notifDAO.create(notif);
                    }
                    session.setAttribute("successMessage", "KYC verification rejected.");
                } else {
                    session.setAttribute("errorMessage", "Failed to reject KYC.");
                }
            } else {
                session.setAttribute("errorMessage", "Unknown action.");
            }
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "Invalid KYC ID.");
        } catch (SQLException e) {
            session.setAttribute("errorMessage", "Database error occurred.");
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/admin/kyc");
    }
}
