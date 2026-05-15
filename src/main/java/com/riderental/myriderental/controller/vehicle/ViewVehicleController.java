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
import java.time.LocalDate;
import java.util.List;

/**
 * Controller for viewing the list of vehicles and searching.
 */
@WebServlet(urlPatterns = {"/vehicles", "/vehicles/list"})
public class ViewVehicleController extends HttpServlet {

    private final VehicleDAO vehicleDAO = new VehicleDAO();

    /**
     * Handles GET requests to display the vehicle list or search results.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String keyword = request.getParameter("keyword");
        String type = request.getParameter("type");
        String location = request.getParameter("location");
        String startDateParam = request.getParameter("startDate");
        String endDateParam = request.getParameter("endDate");

        try {
            LocalDate startDate = parseDate(startDateParam);
            LocalDate endDate = parseDate(endDateParam);
            String errorMessage = validateDateFilter(startDateParam, endDateParam, startDate, endDate);

            List<Vehicle> vehicles = vehicleDAO.search(keyword, type, location, startDate, endDate);

            request.setAttribute("vehicles", vehicles);
            request.setAttribute("keyword", keyword);
            request.setAttribute("type", type);
            request.setAttribute("location", location);
            request.setAttribute("startDate", startDateParam);
            request.setAttribute("endDate", endDateParam);
            request.setAttribute("errorMessage", errorMessage);
            request.getRequestDispatcher("/WEB-INF/views/vehicle/vehicle-list.jsp")
                    .forward(request, response);

        } catch (SQLException e) {
            throw new ServletException("Unable to load vehicles", e);
        }
    }

    private LocalDate parseDate(String value) {
        if (value == null || value.isBlank()) {
            return null;
        }
        try {
            return LocalDate.parse(value.trim());
        } catch (Exception e) {
            return null;
        }
    }

    private String validateDateFilter(String startDateParam, String endDateParam,
                                      LocalDate startDate, LocalDate endDate) {
        boolean hasStartDate = startDateParam != null && !startDateParam.isBlank();
        boolean hasEndDate = endDateParam != null && !endDateParam.isBlank();

        if (!hasStartDate && !hasEndDate) {
            return null;
        }
        if (!hasStartDate || !hasEndDate || startDate == null || endDate == null) {
            return "Please enter both valid start and end dates to filter by availability.";
        }
        if (endDate.isBefore(startDate) || endDate.isEqual(startDate)) {
            return "End date must be after start date.";
        }
        return null;
    }
}
