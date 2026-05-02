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

@WebServlet("/owner/vehicle/update")
@MultipartConfig
public class UpdateVehicleController extends HttpServlet {

	private final VehicleDAO vehicleDAO = new VehicleDAO();

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		if (!ensureOwnerAccess(request, response)) {
			return;
		}

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

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		if (!ensureOwnerAccess(request, response)) {
			return;
		}

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

			String imagePath = saveVehicleImage(request.getPart("vehicleImage"), request);
			if (imagePath != null) {
				existing.setImagePath(imagePath);
			}

			vehicleDAO.update(existing);
			response.sendRedirect(request.getContextPath() + "/owner/myvehicle?success=updated");
		} catch (NumberFormatException | SQLException e) {
			throw new ServletException("Unable to update vehicle", e);
		}
	}

	private boolean ensureOwnerAccess(HttpServletRequest request, HttpServletResponse response) throws IOException {
		User sessionUser = getSessionUser(request);
		if (sessionUser == null) {
			response.sendRedirect(request.getContextPath() + "/login");
			return false;
		}

		String role = sessionUser.getRole() == null ? "" : sessionUser.getRole().trim();
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

	private String trim(String value) { return value == null ? "" : value.trim(); }

	private double parseDouble(String value) {
		try { return value == null || value.isBlank() ? 0.0 : Double.parseDouble(value.trim()); }
		catch (NumberFormatException e) { return 0.0; }
	}

	private String resolveAvailability(String raw) {
		if (raw == null || raw.isBlank()) return "AVAILABLE";
		String normalized = raw.trim().toUpperCase();
		return switch (normalized) {
			case "AVAILABLE", "RENTED", "MAINTENANCE" -> normalized;
			default -> "AVAILABLE";
		};
	}

	private String saveVehicleImage(Part imagePart, HttpServletRequest request) throws IOException, ServletException {
		if (imagePart == null || imagePart.getSize() == 0) return null;
		String submittedFileName = imagePart.getSubmittedFileName();
		if (submittedFileName == null || submittedFileName.isBlank()) return null;

		String extension = "";
		int dotIndex = submittedFileName.lastIndexOf('.');
		if (dotIndex >= 0) extension = submittedFileName.substring(dotIndex);

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
