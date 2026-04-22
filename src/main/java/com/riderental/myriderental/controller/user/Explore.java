package com.riderental.myriderental.controller.user;

import com.riderental.myriderental.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/explore")
public class Explore extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User loggedInUser = session == null ? null : (User) session.getAttribute("loggedInUser");

        if (loggedInUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String role = loggedInUser.getRole();
        if (!"owner".equalsIgnoreCase(role) && !"renter".equalsIgnoreCase(role)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        request.setAttribute("viewRole", role.toLowerCase());
        request.getRequestDispatcher("/WEB-INF/views/user/explore.jsp").forward(request, response);
    }
}
