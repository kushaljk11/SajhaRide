package com.riderental.myriderental.controller.vehicle;

import com.riderental.myriderental.dao.VehicleDAO;
import com.riderental.myriderental.model.Vehicle;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/vehicle-details")
public class VehicleDetailsController extends HttpServlet {

    private final VehicleDAO vehicleDAO = new VehicleDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isBlank()) {
            request.setAttribute("errorMessage", "Not found");
            request.getRequestDispatcher("/WEB-INF/views/vehicle/vehicle-details.jsp").forward(request, response);
            return;
        }

        try {
            int id = Integer.parseInt(idParam);
            if (id <= 0) {
                request.setAttribute("errorMessage", "Not found");
                request.getRequestDispatcher("/WEB-INF/views/vehicle/vehicle-details.jsp").forward(request, response);
                return;
            }

            Vehicle vehicle = vehicleDAO.findById(id);
            if (vehicle == null) {
                request.setAttribute("errorMessage", "Not found");
            } else {
                request.setAttribute("vehicle", vehicle);
            }

            request.getRequestDispatcher("/WEB-INF/views/vehicle/vehicle-details.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Not found");
            request.getRequestDispatcher("/WEB-INF/views/vehicle/vehicle-details.jsp").forward(request, response);
        } catch (SQLException e) {
            request.setAttribute("errorMessage", "Unable to load vehicle details right now.");
            request.getRequestDispatcher("/WEB-INF/views/vehicle/vehicle-details.jsp").forward(request, response);
        }
    }
}


