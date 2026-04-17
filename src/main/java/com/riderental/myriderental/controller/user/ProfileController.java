package com.riderental.myriderental.controller.user;

import com.riderental.myriderental.dao.UserDAO;
import com.riderental.myriderental.model.User;
import com.riderental.myriderental.util.ValidationUtil;
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

@WebServlet("/profile")
@MultipartConfig
public class ProfileController extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User sessionUser = getSessionUser(request);
        if (sessionUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            User freshUser = userDAO.findById(sessionUser.getUserId());
            request.getSession().setAttribute("loggedInUser", freshUser);
            request.setAttribute("user", freshUser);
            request.getRequestDispatcher("/WEB-INF/views/user/profile.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Unable to load profile", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User sessionUser = getSessionUser(request);
        if (sessionUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String fullName = request.getParameter("fullName");
        String phoneNumber = request.getParameter("phoneNumber");
        String address = request.getParameter("address");

        if (ValidationUtil.isBlank(fullName) || ValidationUtil.isBlank(phoneNumber) || ValidationUtil.isBlank(address)) {
            request.setAttribute("errorMessage", "Full name, phone number, and address are required.");
            request.setAttribute("user", sessionUser);
            request.getRequestDispatcher("/views/user/profile.jsp").forward(request, response);
            return;
        }

        try {
            User user = userDAO.findById(sessionUser.getUserId());
            user.setFullName(fullName.trim());
            user.setPhoneNumber(phoneNumber.trim());
            user.setAddress(address.trim());

            String uploadedPath = saveProfileImage(request.getPart("profileImage"), request);
            if (uploadedPath != null) {
                user.setProfileImagePath(uploadedPath);
            }

            userDAO.updateProfile(user);
            request.getSession().setAttribute("loggedInUser", user);
            response.sendRedirect(request.getContextPath() + "/profile?updated=true");
        } catch (SQLException e) {
            throw new ServletException("Unable to update profile", e);
        }
    }

    private User getSessionUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session == null ? null : (User) session.getAttribute("loggedInUser");
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
        File uploadsDir = new File(uploadsPath);
        if (!uploadsDir.exists() && !uploadsDir.mkdirs()) {
            throw new ServletException("Unable to create uploads directory");
        }

        profileImage.write(new File(uploadsDir, fileName).getAbsolutePath());
        return "uploads/" + fileName;
    }
}
