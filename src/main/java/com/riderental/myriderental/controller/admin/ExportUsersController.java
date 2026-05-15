package com.riderental.myriderental.controller.admin;

import com.riderental.myriderental.dao.UserDAO;
import com.riderental.myriderental.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.List;

/**
 * Controller for exporting user data to a CSV file.
 */
@WebServlet("/admin/users/export-csv")
public class ExportUsersController extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    /**
     * Handles GET requests to generate and download the users CSV file.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Fetch all users
            List<User> users = userDAO.findAll();

            // Set response headers for CSV download
            response.setContentType("text/csv");
            response.setHeader("Content-Disposition", "attachment; filename=\"users_" + System.currentTimeMillis() + ".csv\"");

            PrintWriter writer = response.getWriter();

            // Write CSV header
            writer.println("User ID,Full Name,Email,Phone,Role,Account Status,Created At");

            // Write user data
            if (users != null) {
                for (User u : users) {
                    writer.println(escapeCSV(u.getUserId()) + "," +
                            escapeCSV(u.getFullName()) + "," +
                            escapeCSV(u.getEmail()) + "," +
                            escapeCSV(u.getPhoneNumber()) + "," +
                            escapeCSV(u.getRole()) + "," +
                            escapeCSV(u.getAccountStatus()) + "," +
                            escapeCSV(u.getCreatedAt() != null ? u.getCreatedAt().toString() : ""));
                }
            }

            writer.flush();
            writer.close();

        } catch (SQLException e) {
            throw new ServletException("Unable to export users", e);
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
}

