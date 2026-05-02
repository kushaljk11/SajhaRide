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

/**
 * Controller for handling new vehicle listings by owners.
 */
@WebServlet("/owner/add-vehicle")
@MultipartConfig
public class AddNewPost extends HttpServlet {

    private final VehicleDAO vehicleDAO = new VehicleDAO();

    /**
     * Handles GET requests to display the add vehicle form.
     * @param request the HTTP request
     * @param response the HTTP response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
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

    /**
     * Handles POST requests to process the creation of a new vehicle listing.
     * @param request the HTTP request
     * @param response the HTTP response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
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
            // Set image to null initially, we'll update it after getting the ID
            vehicle.setImagePath(null);
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

            Vehicle createdVehicle = vehicleDAO.create(vehicle);
            
            // Now save the image using the newly generated vehicle ID
            String imagePath = saveVehicleImage(request.getPart("vehicleImage"), request, createdVehicle.getVehicleId());
            if (imagePath != null) {
                createdVehicle.setImagePath(imagePath);
                vehicleDAO.update(createdVehicle);
            }

            response.sendRedirect(request.getContextPath() + "/owner/myvehicle?success=created");
        } catch (SQLException e) {
            throw new ServletException("Unable to create owner vehicle", e);
        }
    }

    /**
     * Ensures that the requesting user has owner access.
     * @param request the HTTP request
     * @param response the HTTP response
     * @return true if the user is an owner, false otherwise
     * @throws IOException if an I/O error occurs during redirection
     */
    private boolean ensureOwnerAccess(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        User loggedInUser = session == null ? null : (User) session.getAttribute("loggedInUser");

        if (loggedInUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }

        String role = loggedInUser.getRole() == null ? "" : loggedInUser.getRole().trim();
        if ("owner".equalsIgnoreCase(role) || "renter".equalsIgnoreCase(role)) {
            if ("owner".equalsIgnoreCase(role)) {
                try {
                    com.riderental.myriderental.dao.UserDAO userDAO = new com.riderental.myriderental.dao.UserDAO();
                    User freshUser = userDAO.findById(loggedInUser.getUserId());
                    if (freshUser != null && !freshUser.isVerified()) {
                        request.getSession().setAttribute("profileError", "You must be verified before you can list a vehicle. Please upload your verification documents.");
                        response.sendRedirect(request.getContextPath() + "/profile");
                        return false;
                    }
                } catch (Exception e) {
                    if (!loggedInUser.isVerified()) {
                        request.getSession().setAttribute("profileError", "You must be verified before you can list a vehicle. Please upload your verification documents.");
                        response.sendRedirect(request.getContextPath() + "/profile");
                        return false;
                    }
                }
            }
            return true;
        }

        response.sendRedirect(request.getContextPath() + "/login");
        return false;
    }

    /**
     * Retrieves the logged-in user from the session.
     * @param request the HTTP request
     * @return the logged-in User, or null if not found
     */
    private User getSessionUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session == null ? null : (User) session.getAttribute("loggedInUser");
    }

    /**
     * Trims a string value safely.
     * @param value the string to trim
     * @return the trimmed string, or empty string if null
     */
    private String trim(String value) {
        return value == null ? "" : value.trim();
    }

    /**
     * Parses a double value safely.
     * @param value the string to parse
     * @return the parsed double, or 0.0 if invalid
     */
    private double parseDouble(String value) {
        try {
            return value == null || value.isBlank() ? 0.0 : Double.parseDouble(value.trim());
        } catch (NumberFormatException e) {
            return 0.0;
        }
    }

    /**
     * Resolves the availability status of a vehicle.
     * @param raw the raw status string
     * @return the normalized status string
     */
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

    /**
     * Saves an uploaded vehicle image to the server.
     * @param imagePart the Part containing the uploaded image
     * @param request the HTTP request
     * @param vehicleId the ID of the vehicle
     * @return the relative path to the saved image, or null if no image was uploaded
     * @throws IOException if an I/O error occurs
     * @throws ServletException if a servlet-specific error occurs
     */
    private String saveVehicleImage(Part imagePart, HttpServletRequest request, int vehicleId) throws IOException, ServletException {
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

        String fileName = vehicleId + extension;
        String uploadsPath = request.getServletContext().getRealPath("/uploads/vehicle");
        File uploadsDir = new File(uploadsPath);
        if (!uploadsDir.exists() && !uploadsDir.mkdirs()) {
            throw new ServletException("Unable to create uploads directory");
        }

        imagePart.write(new File(uploadsDir, fileName).getAbsolutePath());
        return "uploads/vehicle/" + fileName;
    }
}
