package com.riderental.myriderental.controller.owner;

import com.riderental.myriderental.dao.MessageDAO;
import com.riderental.myriderental.dao.UserDAO;
import com.riderental.myriderental.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/**
 * Controller for handling the chat interface for owners.
 */
@WebServlet("/owner/chat")
public class OwnerChatController extends HttpServlet {

    private final MessageDAO messageDAO = new MessageDAO();
    private final UserDAO userDAO = new UserDAO();

    /**
     * Handles GET requests to display the chat interface.
     * @param request the HTTP request
     * @param response the HTTP response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
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
            // Get contacted users
            List<Integer> contactIds = messageDAO.getContactedUserIds(sessionUser.getUserId());
            
            // Check if user came from "Chat" button
            String targetUserIdParam = request.getParameter("userId");
            if (targetUserIdParam != null) {
                try {
                    int targetId = Integer.parseInt(targetUserIdParam);
                    if (!contactIds.contains(targetId) && targetId != sessionUser.getUserId()) {
                        contactIds.add(targetId);
                    }
                    request.setAttribute("activeUserId", targetId);
                } catch (NumberFormatException ignored) {}
            }
            
            List<User> contacts = new ArrayList<>();
            for (Integer id : contactIds) {
                User contact = userDAO.findById(id);
                if (contact != null) contacts.add(contact);
            }
            
            request.setAttribute("contacts", contacts);
            
            request.getRequestDispatcher("/WEB-INF/views/owner/chat.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            throw new ServletException("Unable to load owner chat", e);
        }
    }

    /**
     * Retrieves the logged-in user from the session.
     * @param request the HTTP request
     * @return the logged-in User, or null if not found
     */
    private User getSessionUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session == null ? null : (User) session.getAttribute("loggedInUser");
    }

    /**
     * Ensures that the requesting user has owner access. Redirects otherwise.
     * @param request the HTTP request
     * @param response the HTTP response
     * @return true if the user is an owner, false otherwise
     * @throws IOException if an I/O error occurs during redirection
     */
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

