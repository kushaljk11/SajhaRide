package com.riderental.myriderental.controller.owner;

import com.riderental.myriderental.dao.VehicleDAO;
import com.riderental.myriderental.model.User;
import com.riderental.myriderental.model.Vehicle;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDateTime;

@WebServlet("/owner/add-vehicle")
@MultipartConfig
public class AddNewPost extends HttpServlet {

    private final VehicleDAO vehicleDAO = new VehicleDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!ensureOwnerAccess(request, response)) {
            return;
        }

        request.setAttribute("pageHeading", "List Your Vehicle");
        request.setAttribute("submitLabel", "List My Vehicle");
        request.setAttribute("formAction", request.getContextPath() + "/owner/add-vehicle");
        request.getRequestDispatcher("/WEB-INF/views/owner/add-vehicle.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!ensureOwnerAccess(request, response)) {
            return;
        }

        try {
            User sessionUser = getSessionUser(request);
            if (sessionUser == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }
            Vehicle vehicle = new Vehicle();
            vehicle.setOwnerId(sessionUser.getUserId());
            vehicle.setVehicleName(trim(request.getParameter("vehicleName")));
            vehicle.setVehicleType(trim(request.getParameter("vehicleType")));
            vehicle.setPricePerDay(parseDouble(request.getParameter("pricePerDay")));
            vehicle.setLocation(trim(request.getParameter("location")));
            vehicle.setDescription(trim(request.getParameter("description")));
            vehicle.setAvailabilityStatus(resolveAvailability(request.getParameter("availabilityStatus")));
            vehicle.setImagePath(saveVehicleImage(request.getPart("vehicleImage"), request));
            vehicle.setCreatedAt(LocalDateTime.now());

            if (vehicle.getVehicleName().isBlank() || vehicle.getVehicleType().isBlank() || vehicle.getLocation().isBlank()) {
                request.setAttribute("errorMessage", "Vehicle name, type and location are required.");
                request.setAttribute("pageHeading", "List Your Vehicle");
                request.setAttribute("submitLabel", "List My Vehicle");
                request.setAttribute("formAction", request.getContextPath() + "/owner/add-vehicle");
                request.setAttribute("vehicle", vehicle);
                request.getRequestDispatcher("/WEB-INF/views/owner/add-vehicle.jsp").forward(request, response);
                return;
            }

            vehicleDAO.create(vehicle);
            response.sendRedirect(request.getContextPath() + "/owner/myvehicle?success=created");
        } catch (SQLException e) {
            throw new ServletException("Unable to create owner vehicle", e);
        }
    }

    private boolean ensureOwnerAccess(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        User loggedInUser = session == null ? null : (User) session.getAttribute("loggedInUser");

        if (loggedInUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }

        String role = loggedInUser.getRole() == null ? "" : loggedInUser.getRole().trim();
        if ("owner".equalsIgnoreCase(role) || "renter".equalsIgnoreCase(role)) {
            return true;
        }

        response.sendRedirect(request.getContextPath() + "/login");
        return false;
    }

    private User getSessionUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session == null ? null : (User) session.getAttribute("loggedInUser");
    }

    private String trim(String value) {
        return value == null ? "" : value.trim();
    }

    private double parseDouble(String value) {
        try {
            return value == null || value.isBlank() ? 0.0 : Double.parseDouble(value.trim());
        } catch (NumberFormatException e) {
            return 0.0;
        }
    }

    private String resolveAvailability(String raw) {
        if (raw == null || raw.isBlank()) {
            return "AVAILABLE";
        }
        String normalized = raw.trim().toUpperCase();
        return switch (normalized) {
            case "AVAILABLE", "RENTED", "MAINTENANCE" -> normalized;
            default -> "AVAILABLE";
        };
    }

    private String saveVehicleImage(Part imagePart, HttpServletRequest request) throws IOException, ServletException {
        if (imagePart == null || imagePart.getSize() == 0) {
            return null;
        }

        String submittedFileName = imagePart.getSubmittedFileName();
        if (submittedFileName == null || submittedFileName.isBlank()) {
            return null;
        }

        String extension = "";
        int dotIndex = submittedFileName.lastIndexOf('.');
        if (dotIndex >= 0) {
            extension = submittedFileName.substring(dotIndex);
        }

        String fileName = System.currentTimeMillis() + "-" + Math.abs(submittedFileName.hashCode()) + extension;
        String uploadsPath = request.getServletContext().getRealPath("/uploads");
        File uploadsDir = new File(uploadsPath);
        if (!uploadsDir.exists() && !uploadsDir.mkdirs()) {
            throw new ServletException("Unable to create uploads directory");
        }

        imagePart.write(new File(uploadsDir, fileName).getAbsolutePath());
        return "uploads/" + fileName;
    }
}
