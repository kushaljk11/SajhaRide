package com.riderental.myriderental.controller.home;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * Controller for handling the "About Us" page view.
 */
@WebServlet("/aboutus")
public class AboutusController extends HttpServlet {
    /**
     * Serves the about us page.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/landing/aboutus.jsp")
                .forward(request, response);
    }
}
