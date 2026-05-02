package com.riderental.myriderental.controller.vehicle;

import com.riderental.myriderental.dao.VehicleDAO;
import com.riderental.myriderental.model.Vehicle;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

/**
 * Controller for viewing the list of vehicles and searching.
 */
@WebServlet(urlPatterns = {"/vehicles", "/vehicles/list"})
public class ViewVehicleController extends HttpServlet {

    private final VehicleDAO vehicleDAO = new VehicleDAO();

    /**
     * Handles GET requests to display the vehicle list or search results.
     * @param request the HTTP request
     * @param response the HTTP response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String keyword = request.getParameter("keyword");
        String type = request.getParameter("type");

        try {
            List<Vehicle> vehicles;

            // If search params present, use search — otherwise show all available
            if ((keyword != null && !keyword.isBlank()) || (type != null && !type.isBlank())) {
                vehicles = vehicleDAO.search(keyword, type);
            } else {
                vehicles = vehicleDAO.findAvailable();
            }

            request.setAttribute("vehicles", vehicles);
            request.setAttribute("keyword", keyword);
            request.setAttribute("type", type);
            request.getRequestDispatcher("/WEB-INF/views/vehicle/vehicle-list.jsp")
                    .forward(request, response);

        } catch (SQLException e) {
            throw new ServletException("Unable to load vehicles", e);
        }
    }
}