package com.riderental.myriderental.controller.renter;

import com.riderental.myriderental.dao.KycDAO;
import com.riderental.myriderental.model.KycVerification;
import com.riderental.myriderental.model.User;
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
import java.util.UUID;

@WebServlet("/user/kyc/upload")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 1, // 1 MB
    maxFileSize = 1024 * 1024 * 5,      // 5 MB
    maxRequestSize = 1024 * 1024 * 10   // 10 MB
)
public class UploadKycServlet extends HttpServlet {
    private final KycDAO kycDAO = new KycDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User user = session != null ? (User) session.getAttribute("loggedInUser") : null;
        
        if (user == null || (!"RENTER".equalsIgnoreCase(user.getRole()) && !"CUSTOMER".equalsIgnoreCase(user.getRole()))) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            return;
        }

        String documentType = request.getParameter("documentType");
        Part filePart = request.getPart("kycDocument");

        if (documentType == null || documentType.trim().isEmpty() || filePart == null || filePart.getSize() == 0) {
            request.getSession().setAttribute("profileError", "Please provide all required document information.");
            response.sendRedirect(request.getContextPath() + "/profile");
            return;
        }

        String submittedFileName = filePart.getSubmittedFileName();
        String extension = "";
        int dotIndex = submittedFileName.lastIndexOf('.');
        if (dotIndex > 0) {
            extension = submittedFileName.substring(dotIndex).toLowerCase();
        }

        if (!extension.equals(".pdf") && !extension.equals(".jpg") && !extension.equals(".jpeg") && !extension.equals(".png")) {
            request.getSession().setAttribute("profileError", "Invalid file type. Only PDF, JPG, and PNG are allowed.");
            response.sendRedirect(request.getContextPath() + "/profile");
            return;
        }

        // Store securely inside WEB-INF so it's not publicly accessible
        String uploadPath = request.getServletContext().getRealPath("/WEB-INF/uploads/kyc");
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        String fileName = UUID.randomUUID().toString() + extension;
        String filePath = uploadPath + File.separator + fileName;
        
        try {
            filePart.write(filePath);
            
            KycVerification kyc = new KycVerification();
            kyc.setUserId(user.getUserId());
            kyc.setDocumentPath("kyc/" + fileName); // store relative to kyc upload dir
            kyc.setDocumentType(documentType);
            
            kycDAO.createKycRequest(kyc);
            
            request.getSession().setAttribute("profileSuccess", "KYC document uploaded successfully and is pending review.");
        } catch (SQLException e) {
            request.getSession().setAttribute("profileError", "Database error occurred while saving verification request.");
            e.printStackTrace();
        } catch (Exception e) {
            request.getSession().setAttribute("profileError", "Error uploading file.");
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/profile");
    }
}
