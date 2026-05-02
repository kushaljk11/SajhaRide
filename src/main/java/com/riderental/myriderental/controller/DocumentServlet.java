package com.riderental.myriderental.controller;

import com.riderental.myriderental.dao.KycDAO;
import com.riderental.myriderental.model.KycVerification;
import com.riderental.myriderental.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.sql.SQLException;

/**
 * Servlet for securely serving user document files, such as KYC uploads.
 */
@WebServlet("/document/kyc")
public class DocumentServlet extends HttpServlet {
    private final KycDAO kycDAO = new KycDAO();

    /**
     * Handles GET requests to retrieve and display a document file.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
            
        HttpSession session = request.getSession(false);
        User user = session != null ? (User) session.getAttribute("loggedInUser") : null;
        
        if (user == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Unauthorized");
            return;
        }

        String kycIdParam = request.getParameter("id");
        if (kycIdParam == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing document ID");
            return;
        }

        try {
            int kycId = Integer.parseInt(kycIdParam);
            KycVerification kyc = kycDAO.findById(kycId);
            
            if (kyc == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Document not found");
                return;
            }

            // Access control: only ADMIN or the OWNER can view
            boolean isAdmin = "ADMIN".equalsIgnoreCase(user.getRole());
            boolean isOwner = kyc.getUserId() == user.getUserId();
            
            if (!isAdmin && !isOwner) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
                return;
            }

            String relativePath = kyc.getDocumentPath();
            String fullPath = request.getServletContext().getRealPath("/WEB-INF/uploads/" + relativePath);
            File file = new File(fullPath);
            
            if (!file.exists()) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "File missing on server");
                return;
            }

            String contentType = getServletContext().getMimeType(file.getName());
            if (contentType == null) {
                contentType = "application/octet-stream";
            }

            response.setContentType(contentType);
            response.setHeader("Content-Length", String.valueOf(file.length()));
            response.setHeader("Content-Disposition", "inline; filename=\"" + file.getName() + "\"");
            
            Files.copy(file.toPath(), response.getOutputStream());
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid ID");
        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        }
    }
}
