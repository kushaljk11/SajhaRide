package com.riderental.myriderental.controller.auth;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Controller showing the registration success page.
 */
@WebServlet("/registration-success")
public class RegistrationSuccessController extends HttpServlet {
    /**
     * Handles GET requests to display the success message.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/auth/registration-success.jsp")
                .forward(request, response);
    }
}
