package com.riderental.myriderental.controller.user;

import com.riderental.myriderental.dao.VehicleDAO;
import com.riderental.myriderental.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.List;
import com.riderental.myriderental.model.Vehicle;

/**
 * Controller for displaying the vehicle exploration page.
 */
@WebServlet("/explore")
public class Explore extends HttpServlet {
    /**
     * Handles GET requests to display the explore page with available vehicles.
     * @param request the HTTP request
     * @param response the HTTP response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
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

        try {
            String location = request.getParameter("location");
            String type = request.getParameter("type");
            String startDateParam = request.getParameter("startDate");
            String endDateParam = request.getParameter("endDate");
            String maxPriceParam = request.getParameter("maxPrice");

            LocalDate startDate = parseDate(startDateParam);
            LocalDate endDate = parseDate(endDateParam);
            Double maxPrice = parsePrice(maxPriceParam);

            VehicleDAO vehicleDAO = new VehicleDAO();
            List<Vehicle> vehicles = vehicleDAO.search(null, type, location, startDate, endDate);
            if (maxPrice != null) {
                vehicles = vehicles.stream()
                        .filter(vehicle -> vehicle.getPricePerDay() <= maxPrice)
                        .toList();
            }

            request.setAttribute("vehicles", vehicles);
            request.setAttribute("location", location);
            request.setAttribute("type", type);
            request.setAttribute("startDate", startDateParam);
            request.setAttribute("endDate", endDateParam);
            request.setAttribute("maxPrice", maxPriceParam);
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading vehicles");
        }

        request.getRequestDispatcher("/WEB-INF/views/user/explore.jsp").forward(request, response);
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

    private Double parsePrice(String value) {
        if (value == null || value.isBlank()) {
            return null;
        }
        try {
            return Double.parseDouble(value.trim());
        } catch (NumberFormatException e) {
            return null;
        }
    }
}
