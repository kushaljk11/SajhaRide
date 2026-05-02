package com.riderental.myriderental.controller.admin;

import com.riderental.myriderental.dao.VehicleDAO;
import com.riderental.myriderental.model.User;
import com.riderental.myriderental.model.Vehicle;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDateTime;

/**
 * Controller for adding a new vehicle from the admin panel.
 */
@WebServlet("/admin/vehicles/create")
public class AddVehicleController extends HttpServlet {

    private final VehicleDAO vehicleDAO = new VehicleDAO();

    /**
     * Shows the add vehicle form.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        request.getRequestDispatcher("/WEB-INF/views/admin/add-vehicle.jsp").forward(request, response);
    }

    /**
     * Processes the submission to create a new vehicle.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            String vehicleName = request.getParameter("vehicleName");
            String vehicleType = request.getParameter("vehicleType");
            String pricePerDayStr = request.getParameter("pricePerDay");
            String location = request.getParameter("location");
            String description = request.getParameter("description");
            String imagePath = request.getParameter("imagePath");

            if (vehicleName == null || vehicleName.isBlank() || vehicleType == null || vehicleType.isBlank() ||
                    pricePerDayStr == null || pricePerDayStr.isBlank() || location == null || location.isBlank()) {
                request.setAttribute("error", "All required fields must be filled");
                request.getRequestDispatcher("/WEB-INF/views/admin/add-vehicle.jsp").forward(request, response);
                return;
            }

            double pricePerDay = Double.parseDouble(pricePerDayStr);

            // Get logged-in user ID as owner
            HttpSession session = request.getSession(false);
            User loggedInUser = (User) session.getAttribute("loggedInUser");
            int ownerId = loggedInUser.getUserId();

            Vehicle newVehicle = new Vehicle();
            newVehicle.setVehicleName(vehicleName);
            newVehicle.setVehicleType(vehicleType);
            newVehicle.setPricePerDay(pricePerDay);
            newVehicle.setLocation(location);
            newVehicle.setOwnerId(ownerId);
            newVehicle.setDescription(description);
            newVehicle.setImagePath(imagePath);
            newVehicle.setAvailabilityStatus("AVAILABLE");
            newVehicle.setCreatedAt(LocalDateTime.now());

            vehicleDAO.create(newVehicle);
            response.sendRedirect(request.getContextPath() + "/admin/vehicles?success=created");

        } catch (NumberFormatException e) {
            throw new ServletException("Invalid price format", e);
        } catch (SQLException e) {
            throw new ServletException("Unable to create vehicle", e);
        }
    }

    private boolean isAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        User loggedIn = session == null ? null : (User) session.getAttribute("loggedInUser");
        if (loggedIn == null) return false;
        String role = loggedIn.getRole() == null ? "" : loggedIn.getRole().trim();
        return "ADMIN".equalsIgnoreCase(role);
    }
}



