package com.riderental.myriderental.controller.vehicle;

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

@WebServlet("/owner/vehicle/delete")
public class DeleteVehicleController extends HttpServlet {

	private final VehicleDAO vehicleDAO = new VehicleDAO();

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		User sessionUser = getSessionUser(request);
		if (sessionUser == null || !isAllowedRole(sessionUser)) {
			response.sendRedirect(request.getContextPath() + "/login");
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
			if (vehicle == null || vehicle.getOwnerId() != sessionUser.getUserId()) {
				response.sendRedirect(request.getContextPath() + "/owner/myvehicle");
				return;
			}

			vehicleDAO.delete(vehicleId);
			response.sendRedirect(request.getContextPath() + "/owner/myvehicle?success=deleted");
		} catch (NumberFormatException | SQLException e) {
			throw new ServletException("Unable to delete vehicle", e);
		}
	}

	private User getSessionUser(HttpServletRequest request) {
		HttpSession session = request.getSession(false);
		return session == null ? null : (User) session.getAttribute("loggedInUser");
	}

	private boolean isAllowedRole(User user) {
		String role = user.getRole() == null ? "" : user.getRole().trim();
		return "owner".equalsIgnoreCase(role) || "renter".equalsIgnoreCase(role);
	}
}
