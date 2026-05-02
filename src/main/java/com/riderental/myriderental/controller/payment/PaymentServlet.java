package com.riderental.myriderental.controller.payment;

import com.riderental.myriderental.model.PaymentRequest;
import com.riderental.myriderental.model.PaymentResponse;
import com.riderental.myriderental.dao.PaymentDAO;
import com.riderental.myriderental.service.PaymentService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Servlet for handling payment initiation and verification flows via eSewa and Khalti.
 */
@WebServlet("/renter/payment")
public class PaymentServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(PaymentServlet.class.getName());

    private final PaymentService paymentService = new PaymentService();

    /**
     * Handles GET requests, primarily for processing redirects from payment gateways.
     */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");

        if ("esewaSuccess".equalsIgnoreCase(action)) {
            handleEsewaSuccess(req, resp);
        } else if ("esewaFailure".equalsIgnoreCase(action)) {
            handleEsewaFailure(req, resp);
        } else if ("khaltiReturn".equalsIgnoreCase(action)) {
            handleKhaltiReturn(req, resp);
        } else {
            resp.sendRedirect(req.getContextPath() + "/renter/payments");
        }
    }

    /**
     * Handles POST requests to initiate payments.
     */
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        String gateway = req.getParameter("gateway");

        if ("initiate".equalsIgnoreCase(action)) {
            if ("ESEWA".equalsIgnoreCase(gateway)) {
                handleEsewaInitiate(req, resp);
            } else if ("KHALTI".equalsIgnoreCase(gateway)) {
                handleKhaltiInitiate(req, resp);
            } else if ("CASH".equalsIgnoreCase(gateway) || "CASH_ON_PICKUP".equalsIgnoreCase(gateway)) {
                handleCashOnPickup(req, resp);
            } else {
                resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Unsupported gateway");
            }
        } else {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
        }
    }

    private void handleEsewaInitiate(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String bookingId = req.getParameter("bookingId");
        String amountParam = req.getParameter("amount");
        double amount;
        try {
            amount = Double.parseDouble(amountParam);
        } catch (NumberFormatException e) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid amount");
            return;
        }

        PaymentRequest paymentRequest = paymentService.buildEsewaRequest(bookingId, amount);

        // Build callback URLs from the current deployment URL (host/port/context path)
        String appBaseUrl = buildAppBaseUrl(req);
        paymentRequest.setSuccessUrl(appBaseUrl + "/renter/payment?action=esewaSuccess");
        paymentRequest.setFailureUrl(appBaseUrl + "/renter/payment?action=esewaFailure");

        // Save DB record as PENDING (best effort: do not block gateway redirect)
        PaymentDAO paymentDAO = new PaymentDAO();
        try {
            int bookingIdInt = Integer.parseInt(bookingId);
            paymentDAO.savePayment(
                    bookingIdInt,
                    "ESEWA",
                    amount,
                    paymentRequest.getTransactionUuid(),
                    null
            );
        } catch (SQLException | NumberFormatException e) {
            LOGGER.log(Level.WARNING, "Failed to persist pending eSewa payment, continuing with redirect", e);
        }

        req.setAttribute("paymentRequest", paymentRequest);
        req.getRequestDispatcher("/WEB-INF/views/renter/esewa-redirect.jsp")
                .forward(req, resp);
    }

    private String buildAppBaseUrl(HttpServletRequest req) {
        int port = req.getServerPort();
        boolean defaultHttp = "http".equalsIgnoreCase(req.getScheme()) && port == 80;
        boolean defaultHttps = "https".equalsIgnoreCase(req.getScheme()) && port == 443;
        String portPart = (defaultHttp || defaultHttps) ? "" : ":" + port;
        return req.getScheme() + "://" + req.getServerName() + portPart + req.getContextPath();
    }

    private void handleKhaltiInitiate(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        String bookingId = req.getParameter("bookingId");
        String amountParam = req.getParameter("amount");
        double amount;
        try {
            amount = Double.parseDouble(amountParam);
        } catch (NumberFormatException e) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid amount");
            return;
        }

        PaymentRequest paymentRequest = paymentService.initiateKhalti(bookingId, amount);

        // Save DB record as PENDING (best effort: do not block gateway redirect)
        PaymentDAO paymentDAO = new PaymentDAO();
        try {
            int bookingIdInt = Integer.parseInt(bookingId);
            paymentDAO.savePayment(
                    bookingIdInt,
                    "KHALTI",
                    amount,
                    null,
                    paymentRequest.getPidx()
            );
        } catch (SQLException | NumberFormatException e) {
            LOGGER.log(Level.WARNING, "Failed to persist pending Khalti payment, continuing with redirect", e);
        }

        resp.sendRedirect(paymentRequest.getPaymentUrl());
    }

    private void handleCashOnPickup(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String bookingId = req.getParameter("bookingId");
        String amount = req.getParameter("amount");

        req.setAttribute("message", "Booking confirmed for cash on pickup. Pay Rs. "
                + (amount == null ? "0" : amount)
                + " at the time of vehicle handover.");
        req.setAttribute("bookingId", bookingId);
        req.setAttribute("paymentMethod", "Cash on Pickup");
        req.getRequestDispatcher("/WEB-INF/views/renter/payment-success.jsp")
                .forward(req, resp);
    }

    private void handleEsewaSuccess(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String transactionUuid = req.getParameter("transaction_uuid");
        String totalAmount = req.getParameter("total_amount");

        PaymentResponse verification = paymentService.verifyEsewa(transactionUuid, totalAmount);

        PaymentDAO paymentDAO = new PaymentDAO();
        String messageDetail = verification.getMessage();

        if (verification.isSuccess()) {
            try {
                // Update DB status to SUCCESS
                paymentDAO.updatePaymentStatus(
                        "ESEWA",
                        transactionUuid,
                        "SUCCESS",
                        verification.getReferenceId()
                );
                messageDetail += " (Reference: " + verification.getReferenceId() + ")";
            } catch (SQLException e) {
                messageDetail = "Payment verified but failed to update database: " + e.getMessage();
            }
            req.setAttribute("message", messageDetail);
            req.getRequestDispatcher("/WEB-INF/views/renter/payment-success.jsp")
                    .forward(req, resp);
        } else {
            try {
                // Update DB status to FAILED
                paymentDAO.updatePaymentStatus(
                        "ESEWA",
                        transactionUuid,
                        "FAILED",
                        null
                );
            } catch (SQLException e) {
                // Log error but continue
            }
            req.setAttribute("message", messageDetail);
            req.getRequestDispatcher("/WEB-INF/views/renter/payment-failed.jsp")
                    .forward(req, resp);
        }
    }

    private void handleEsewaFailure(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String transactionUuid = req.getParameter("transaction_uuid");

        // Update DB status to FAILED if transaction UUID exists
        if (transactionUuid != null && !transactionUuid.isBlank()) {
            PaymentDAO paymentDAO = new PaymentDAO();
            try {
                paymentDAO.updatePaymentStatus("ESEWA", transactionUuid, "FAILED", null);
            } catch (SQLException e) {
                // Log error but continue
            }
        }

        req.setAttribute("message", "eSewa payment was cancelled or failed.");
        req.getRequestDispatcher("/WEB-INF/views/renter/payment-failed.jsp")
                .forward(req, resp);
    }

    private void handleKhaltiReturn(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String pidx = req.getParameter("pidx");

        PaymentResponse verification = paymentService.verifyKhalti(pidx);

        PaymentDAO paymentDAO = new PaymentDAO();
        String messageDetail = verification.getMessage();

        if (verification.isSuccess()) {
            try {
                // Update DB status to SUCCESS
                paymentDAO.updatePaymentStatus(
                        "KHALTI",
                        pidx,
                        "SUCCESS",
                        verification.getReferenceId()
                );
                messageDetail += " (Transaction: " + verification.getReferenceId() + ")";
            } catch (SQLException e) {
                messageDetail = "Payment verified but failed to update database: " + e.getMessage();
            }
            req.setAttribute("message", messageDetail);
            req.getRequestDispatcher("/WEB-INF/views/renter/payment-success.jsp")
                    .forward(req, resp);
        } else {
            try {
                // Update DB status to FAILED
                paymentDAO.updatePaymentStatus(
                        "KHALTI",
                        pidx,
                        "FAILED",
                        null
                );
            } catch (SQLException e) {
                // Log error but continue
            }
            req.setAttribute("message", messageDetail);
            req.getRequestDispatcher("/WEB-INF/views/renter/payment-failed.jsp")
                    .forward(req, resp);
        }
    }
}
