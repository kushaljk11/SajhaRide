package com.riderental.myriderental.controller.owner;

import com.riderental.myriderental.dao.OwnerDashboardDAO;
import com.riderental.myriderental.model.Booking;
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

@WebServlet("/owner/chat")
public class OwnerChatController extends HttpServlet {

    private final OwnerDashboardDAO ownerDashboardDAO = new OwnerDashboardDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!ensureOwnerAccess(request, response)) {
            return;
        }

        User sessionUser = getSessionUser(request);
        if (sessionUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            List<Booking> conversations = ownerDashboardDAO.findRecentBookings(sessionUser.getUserId(), 5);
            request.setAttribute("conversationBookings", conversations);
            request.setAttribute("selectedBooking", conversations.isEmpty() ? null : conversations.get(0));
            request.setAttribute("ownerUser", sessionUser);
            request.getRequestDispatcher("/WEB-INF/views/owner/chat.jsp")
                    .forward(request, response);

        } catch (SQLException e) {
            throw new ServletException("Unable to load owner chat", e);
        }
    }

    private User getSessionUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session == null ? null : (User) session.getAttribute("loggedInUser");
    }

    private boolean ensureOwnerAccess(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        User loggedInUser = session == null ? null : (User) session.getAttribute("loggedInUser");

        if (loggedInUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }

        String role = loggedInUser.getRole() == null ? "" : loggedInUser.getRole().trim();
        if ("owner".equalsIgnoreCase(role) || "renter".equalsIgnoreCase(role)) {
            return true;
        }


        response.sendRedirect(request.getContextPath() + "/login");
        return false;
    }
}

