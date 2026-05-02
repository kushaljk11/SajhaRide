package com.riderental.myriderental.controller.renter;

import com.riderental.myriderental.dao.SavedVehicleDAO;
import com.riderental.myriderental.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/renter/saved/add")
public class SaveVehicleController extends HttpServlet {

    private final SavedVehicleDAO savedVehicleDAO = new SavedVehicleDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User sessionUser = session == null ? null : (User) session.getAttribute("loggedInUser");

        if (sessionUser == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        try {
            int vehicleId = Integer.parseInt(request.getParameter("vehicleId"));
            String action = request.getParameter("action"); // "add" or "remove"

            if ("remove".equals(action)) {
                savedVehicleDAO.removeSavedVehicle(sessionUser.getUserId(), vehicleId);
            } else {
                savedVehicleDAO.addSavedVehicle(sessionUser.getUserId(), vehicleId);
            }
            
            response.setStatus(HttpServletResponse.SC_OK);
            response.sendRedirect(request.getContextPath() + "/renter/saved");
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error saving vehicle");
        }
    }
}
