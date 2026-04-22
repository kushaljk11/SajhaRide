package com.riderental.myriderental.controller.renter;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/renter/saved")
public class RenterSavedController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
     request.getRequestDispatcher("/WEB-INF/views/renter/saved.jsp").forward(request,  response);
    }
}
