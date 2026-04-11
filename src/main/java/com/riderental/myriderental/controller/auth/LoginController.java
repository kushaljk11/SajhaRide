package com.riderental.myriderental.controller.auth;

import com.riderental.myriderental.dao.UserDAO;
import com.riderental.myriderental.model.User;
import com.riderental.myriderental.util.PasswordUtil;
import com.riderental.myriderental.util.ValidationUtil;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/login")
public class LoginController extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("/views/auth/login.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (ValidationUtil.isBlank(email) || ValidationUtil.isBlank(password)) {
            request.setAttribute("errorMessage", "Email and password are required.");
            doGet(request, response);
            return;
        }

        try {
            User user = userDAO.findByEmail(email.trim().toLowerCase());
            if (user == null || !PasswordUtil.matches(password, user.getPassword())) {
                request.setAttribute("errorMessage", "Invalid email or password.");
                doGet(request, response);
                return;
            }

            request.getSession().setAttribute("loggedInUser", user);

            String role = user.getRole();
             switch (role) {
                 case "ADMIN":
                     response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                     break;
                 case "OWNER" :
                     response.sendRedirect(request.getContextPath() + "/owner/dashboard");
                     break;
                 case "RENTER" :
                     response.sendRedirect(request.getContextPath() + "/render/dashboard");
                     break;
             }
        } catch (SQLException e) {
            throw new ServletException("Unable to login user", e);
        }
    }
}
