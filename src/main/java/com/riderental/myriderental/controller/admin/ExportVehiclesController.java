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
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.List;

/**
 * Controller for exporting vehicle data to a CSV file.
 */
@WebServlet("/admin/vehicles/export-csv")
public class ExportVehiclesController extends HttpServlet {

    private final VehicleDAO vehicleDAO = new VehicleDAO();

    /**
     * Handles GET requests to generate and download the vehicles CSV file.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check admin access
        if (!isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            // Fetch all vehicles
            List<Vehicle> vehicles = vehicleDAO.findAll();

            // Set response headers for CSV download
            response.setContentType("text/csv");
            response.setHeader("Content-Disposition", "attachment; filename=\"vehicles_" + System.currentTimeMillis() + ".csv\"");

            PrintWriter writer = response.getWriter();

            // Write CSV header
            writer.println("Vehicle ID,Vehicle Name,Vehicle Type,Owner ID,Location,Price Per Day,Availability Status,Created At");

            // Write vehicle data
            if (vehicles != null) {
                for (Vehicle v : vehicles) {
                    writer.println(escapeCSV(v.getVehicleId()) + "," +
                            escapeCSV(v.getVehicleName()) + "," +
                            escapeCSV(v.getVehicleType()) + "," +
                            escapeCSV(v.getOwnerId()) + "," +
                            escapeCSV(v.getLocation()) + "," +
                            escapeCSV(v.getPricePerDay()) + "," +
                            escapeCSV(v.getAvailabilityStatus()) + "," +
                            escapeCSV(v.getCreatedAt() != null ? v.getCreatedAt().toString() : ""));
                }
            }

            writer.flush();
            writer.close();

        } catch (SQLException e) {
            throw new ServletException("Unable to export vehicles", e);
        }
    }

    private String escapeCSV(Object value) {
        if (value == null) return "";
        String str = value.toString();
        if (str.contains(",") || str.contains("\"") || str.contains("\n")) {
            return "\"" + str.replace("\"", "\"\"") + "\"";
        }
        return str;
    }

    private boolean isAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        User loggedIn = session == null ? null : (User) session.getAttribute("loggedInUser");
        if (loggedIn == null) return false;
        String role = loggedIn.getRole() == null ? "" : loggedIn.getRole().trim();
        return "ADMIN".equalsIgnoreCase(role);
    }
}

