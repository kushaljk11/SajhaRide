package com.riderental.myriderental.controller.vehicle;

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

/**
 * Controller for handling vehicle updates by owners.
 */
@WebServlet("/owner/vehicle/update")
@MultipartConfig
public class UpdateVehicleController extends HttpServlet {

	private final VehicleDAO vehicleDAO = new VehicleDAO();

	/**
	 * Handles GET requests to display the vehicle update form.
	 * @param request the HTTP request
	 * @param response the HTTP response
	 * @throws ServletException if a servlet-specific error occurs
	 * @throws IOException if an I/O error occurs
	 */
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String vehicleIdParam = request.getParameter("vehicleId");
		if (vehicleIdParam == null || vehicleIdParam.isBlank()) {
			response.sendRedirect(request.getContextPath() + "/owner/myvehicle");
			return;
		}

		try {
			int vehicleId = Integer.parseInt(vehicleIdParam);
			Vehicle vehicle = vehicleDAO.findById(vehicleId);
			User sessionUser = getSessionUser(request);
			if (sessionUser == null) {
				response.sendRedirect(request.getContextPath() + "/login");
				return;
			}
			if (vehicle == null || vehicle.getOwnerId() != sessionUser.getUserId()) {
				response.sendRedirect(request.getContextPath() + "/owner/myvehicle");
				return;
			}

			request.setAttribute("vehicle", vehicle);
			request.setAttribute("pageHeading", "Edit Vehicle");
			request.setAttribute("submitLabel", "Update Vehicle");
			request.setAttribute("formAction", request.getContextPath() + "/owner/vehicle/update");
			request.getRequestDispatcher("/WEB-INF/views/owner/add-vehicle.jsp").forward(request, response);
		} catch (NumberFormatException | SQLException e) {
			throw new ServletException("Unable to load vehicle for editing", e);
		}
	}

	/**
	 * Handles POST requests to process the vehicle update.
	 * @param request the HTTP request
	 * @param response the HTTP response
	 * @throws ServletException if a servlet-specific error occurs
	 * @throws IOException if an I/O error occurs
	 */
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String vehicleIdParam = request.getParameter("vehicleId");
		if (vehicleIdParam == null || vehicleIdParam.isBlank()) {
			response.sendRedirect(request.getContextPath() + "/owner/myvehicle");
			return;
		}

		try {
			int vehicleId = Integer.parseInt(vehicleIdParam);
			Vehicle existing = vehicleDAO.findById(vehicleId);
			User sessionUser = getSessionUser(request);
			if (sessionUser == null) {
				response.sendRedirect(request.getContextPath() + "/login");
				return;
			}
			if (existing == null || existing.getOwnerId() != sessionUser.getUserId()) {
				response.sendRedirect(request.getContextPath() + "/owner/myvehicle");
				return;
			}

			existing.setVehicleName(trim(request.getParameter("vehicleName")));
			existing.setVehicleType(trim(request.getParameter("vehicleType")));
			existing.setDescription(trim(request.getParameter("description")));
			existing.setPricePerDay(parseDouble(request.getParameter("pricePerDay")));
			existing.setLocation(trim(request.getParameter("location")));
			existing.setAvailabilityStatus(resolveAvailability(request.getParameter("availabilityStatus")));

			String imagePath = saveVehicleImage(request.getPart("vehicleImage"), request, existing.getVehicleId());
			if (imagePath != null) {
				existing.setImagePath(imagePath);
			}

			vehicleDAO.update(existing);
			response.sendRedirect(request.getContextPath() + "/owner/myvehicle?success=updated");
		} catch (NumberFormatException | SQLException e) {
			throw new ServletException("Unable to update vehicle", e);
		}
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
	private String trim(String value) { return value == null ? "" : value.trim(); }

	/**
	 * Parses a double value safely.
	 * @param value the string to parse
	 * @return the parsed double, or 0.0 if invalid
	 */
	private double parseDouble(String value) {
		try { return value == null || value.isBlank() ? 0.0 : Double.parseDouble(value.trim()); }
		catch (NumberFormatException e) { return 0.0; }
	}

	/**
	 * Resolves the availability status of a vehicle.
	 * @param raw the raw status string
	 * @return the normalized status string
	 */
	private String resolveAvailability(String raw) {
		if (raw == null || raw.isBlank()) return "AVAILABLE";
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
		if (imagePart == null || imagePart.getSize() == 0) return null;
		String submittedFileName = imagePart.getSubmittedFileName();
		if (submittedFileName == null || submittedFileName.isBlank()) return null;

		String extension = "";
		int dotIndex = submittedFileName.lastIndexOf('.');
		if (dotIndex >= 0) extension = submittedFileName.substring(dotIndex);

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
