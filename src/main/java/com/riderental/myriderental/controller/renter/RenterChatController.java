package com.riderental.myriderental.controller.renter;

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
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/renter/chat")
public class RenterChatController extends HttpServlet {

    private final MessageDAO messageDAO = new MessageDAO();
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User sessionUser = getSessionUser(request);

        if (sessionUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            // Get contacted users
            List<Integer> contactIds = messageDAO.getContactedUserIds(sessionUser.getUserId());
            
            // Check if user came from "Chat with Owner" button
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
            
            request.getRequestDispatcher("/WEB-INF/views/renter/chat.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            throw new ServletException("Unable to load renter chat", e);
        }
    }

    private User getSessionUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session == null ? null : (User) session.getAttribute("loggedInUser");
    }
}

