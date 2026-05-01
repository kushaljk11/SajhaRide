package com.riderental.myriderental.controller.renter;

import com.riderental.myriderental.dao.PaymentDAO;
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

@WebServlet("/renter/payments")
public class RenterPaymentController extends HttpServlet {
    private final PaymentDAO paymentDAO = new PaymentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User sessionUser = getSessionUser(request);
        if (sessionUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            List<PaymentDAO.Payment> payments = paymentDAO.findByRenterId(sessionUser.getUserId());

            double totalSpent = paymentDAO.sumAmountByRenterAndStatus(sessionUser.getUserId(), "SUCCESS");
            double pendingAmount = paymentDAO.sumAmountByRenterAndStatus(sessionUser.getUserId(), "PENDING");
            long paidCount = payments.stream().filter(p -> "SUCCESS".equalsIgnoreCase(p.getStatus())).count();
            long pendingCount = payments.stream().filter(p -> "PENDING".equalsIgnoreCase(p.getStatus())).count();

            PaymentDAO.Payment firstPending = payments.stream()
                    .filter(p -> "PENDING".equalsIgnoreCase(p.getStatus()))
                    .findFirst()
                    .orElse(null);

            request.setAttribute("payments", payments);
            request.setAttribute("totalSpent", totalSpent);
            request.setAttribute("pendingAmount", pendingAmount);
            request.setAttribute("paidCount", paidCount);
            request.setAttribute("pendingCount", pendingCount);
            request.setAttribute("firstPendingPayment", firstPending);

            request.getRequestDispatcher("/WEB-INF/views/renter/payments.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Unable to load renter payments", e);
        }
    }

    private User getSessionUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session == null ? null : (User) session.getAttribute("loggedInUser");
    }
}
