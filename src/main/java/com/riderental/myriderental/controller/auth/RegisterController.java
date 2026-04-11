package com.riderental.myriderental.controller.auth;

import com.riderental.myriderental.dao.UserDAO;
import com.riderental.myriderental.model.User;
import com.riderental.myriderental.util.PasswordUtil;
import com.riderental.myriderental.util.ValidationUtil;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/register")
@MultipartConfig
public class RegisterController extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("/views/auth/register.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String phoneNumber = request.getParameter("phoneNumber");
        String address = request.getParameter("address");
        String role = request.getParameter("role") != null ? request.getParameter("role") : "USER";
        if (ValidationUtil.isBlank(fullName) || ValidationUtil.isBlank(email)
                || ValidationUtil.isBlank(password) || ValidationUtil.isBlank(phoneNumber)
                || ValidationUtil.isBlank(address)) {
            forwardWithMessage(request, response, "All required fields must be filled.");
            return;
        }

        try {
            if (userDAO.findByEmail(email) != null) {
                forwardWithMessage(request, response, "An account with this email already exists.");
                return;
            }

            User user = new User();
            user.setFullName(fullName.trim());
            user.setEmail(email.trim().toLowerCase());
            user.setPassword(PasswordUtil.hashPassword(password));
            user.setPhoneNumber(phoneNumber.trim());
            user.setAddress(address.trim());
            user.setRole(role);
            user.setTrustScore(0);
            user.setAccountStatus("ACTIVE");
            user.setProfileImagePath(saveProfileImage(request.getPart("profileImage"), request));

            User savedUser = userDAO.create(user);
            request.getSession().setAttribute("loggedInUser", savedUser);
            response.sendRedirect(request.getContextPath() + "/profile");
        } catch (SQLException e) {
            throw new ServletException("Unable to register user", e);
        }
    }

    private void forwardWithMessage(HttpServletRequest request, HttpServletResponse response, String message)
            throws ServletException, IOException {
        request.setAttribute("errorMessage", message);
        doGet(request, response);
    }

    private String saveProfileImage(Part profileImage, HttpServletRequest request) throws IOException, ServletException {
        if (profileImage == null || profileImage.getSize() == 0) {
            return null;
        }

        String submittedFileName = profileImage.getSubmittedFileName();
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
        java.io.File uploadsDir = new java.io.File(uploadsPath);
        if (!uploadsDir.exists() && !uploadsDir.mkdirs()) {
            throw new ServletException("Unable to create uploads directory");
        }

        profileImage.write(new java.io.File(uploadsDir, fileName).getAbsolutePath());
        return "uploads/" + fileName;
    }
}
