package com.riderental.myriderental.controller.admin;

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
 * Controller for adding a new vehicle from the admin panel.
 */
@WebServlet("/admin/vehicles/create")
@MultipartConfig
public class AddVehicleController extends HttpServlet {

    private final VehicleDAO vehicleDAO = new VehicleDAO();

    /**
     * Shows the add vehicle form.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/admin/add-vehicle.jsp").forward(request, response);
    }

    /**
     * Processes the submission to create a new vehicle.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String vehicleName = request.getParameter("vehicleName");
            String vehicleType = request.getParameter("vehicleType");
            String pricePerDayStr = request.getParameter("pricePerDay");
            String location = request.getParameter("location");
            String description = request.getParameter("description");

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
            newVehicle.setImagePath(null);
            newVehicle.setAvailabilityStatus("AVAILABLE");
            newVehicle.setCreatedAt(LocalDateTime.now());

            Vehicle createdVehicle = vehicleDAO.create(newVehicle);
            String imagePath = saveVehicleImage(request.getPart("imagePath"), request, createdVehicle.getVehicleId());
            if (imagePath != null) {
                createdVehicle.setImagePath(imagePath);
                vehicleDAO.update(createdVehicle);
            }

            response.sendRedirect(request.getContextPath() + "/admin/vehicles?success=created");

        } catch (NumberFormatException e) {
            throw new ServletException("Invalid price format", e);
        } catch (SQLException e) {
            throw new ServletException("Unable to create vehicle", e);
        }
    }

    private String saveVehicleImage(Part imagePart, HttpServletRequest request, int vehicleId)
            throws IOException, ServletException {
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



