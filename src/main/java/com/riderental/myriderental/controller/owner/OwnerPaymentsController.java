package com.riderental.myriderental.controller.owner;

import com.riderental.myriderental.dao.PaymentDAO;
import com.riderental.myriderental.dao.PaymentDAO.Payment;
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

@WebServlet("/owner/payments")
public class OwnerPaymentsController extends HttpServlet {

    private final PaymentDAO paymentDAO = new PaymentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User sessionUser = getSessionUser(request);
        if (sessionUser == null || !ensureOwnerAccess(sessionUser)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            int ownerId = sessionUser.getUserId();
            List<Payment> payments = paymentDAO.findByOwnerId(ownerId);

            request.setAttribute("payments", payments);
            request.setAttribute("todayReceived", paymentDAO.sumAmountByOwnerAndToday(ownerId, "SUCCESS"));
            request.setAttribute("weekReceived", paymentDAO.sumAmountByOwnerAndCurrentWeek(ownerId, "SUCCESS"));
            request.setAttribute("pendingPayout", paymentDAO.sumPendingOwnerPayout(ownerId));
            request.setAttribute("settledTotal", paymentDAO.sumAmountByOwnerAndStatus(ownerId, "SUCCESS"));
            request.getRequestDispatcher("/WEB-INF/views/owner/payments.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Unable to load owner payments", e);
        }
    }

    private User getSessionUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session == null ? null : (User) session.getAttribute("loggedInUser");
    }

    private boolean ensureOwnerAccess(User user) {
        String role = user.getRole() == null ? "" : user.getRole().trim();
        return "owner".equalsIgnoreCase(role) || "renter".equalsIgnoreCase(role);
    }
}
