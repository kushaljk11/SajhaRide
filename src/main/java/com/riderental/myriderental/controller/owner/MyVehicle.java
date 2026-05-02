package com.riderental.myriderental.controller.owner;

import com.riderental.myriderental.dao.OwnerDashboardDAO;
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
import java.util.List;

@WebServlet("/owner/myvehicle")
public class MyVehicle extends HttpServlet {

    private final VehicleDAO vehicleDAO = new VehicleDAO();
    private final OwnerDashboardDAO ownerDashboardDAO = new OwnerDashboardDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User sessionUser = getSessionUser(request);
        if (sessionUser == null || !ensureOwnerAccess(sessionUser)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            int ownerId = sessionUser.getUserId();
            List<Vehicle> vehicles = vehicleDAO.findByOwner(ownerId);

            request.setAttribute("vehicles", vehicles);
            request.setAttribute("totalVehicles", vehicles.size());
            request.setAttribute("availableVehicles", ownerDashboardDAO.countAvailableVehicles(ownerId));
            request.setAttribute("bookedVehicles", ownerDashboardDAO.countBookedVehicles(ownerId));
            request.setAttribute("maintenanceVehicles", ownerDashboardDAO.countMaintenanceVehicles(ownerId));
            request.getRequestDispatcher("/WEB-INF/views/owner/myvehicle.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Unable to load owner vehicles", e);
        }
    }

    private User getSessionUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session == null ? null : (User) session.getAttribute("loggedInUser");
    }

    private boolean ensureOwnerAccess(User loggedInUser) {
        String role = loggedInUser.getRole() == null ? "" : loggedInUser.getRole().trim();
        return "owner".equalsIgnoreCase(role) || "renter".equalsIgnoreCase(role);
    }
}
