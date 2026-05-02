package com.riderental.myriderental.controller.home;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * Controller for handling the "Contact Us" page view.
 */
@WebServlet("/contact")
public class ContactController extends HttpServlet {
    /**
     * Serves the contact us page.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/landing/contact.jsp")
                .forward(request, response);
    }
}
