package com.riderental.myriderental.config;

public final class PaymentConfig {

    private PaymentConfig() {}

    // =========================
    // COMMON
    // =========================
    public static final String APP_BASE_URL = "http://localhost:8080/SajhaRide";

    // =========================
    // ESEWA
    // =========================
    public static final String ESEWA_GATEWAY = "ESEWA";
    public static final String ESEWA_PRODUCT_CODE = "EPAYTEST";
    public static final String ESEWA_SECRET_KEY = "8gBm/:&EnhH.1/q";
    public static final String ESEWA_FORM_URL =
            "https://rc-epay.esewa.com.np/api/epay/main/v2/form";
    public static final String ESEWA_STATUS_CHECK_URL =
            "https://rc.esewa.com.np/api/epay/transaction/status/";
    public static final String ESEWA_SUCCESS_URL =
            APP_BASE_URL + "/renter/payment?action=esewaSuccess";
    public static final String ESEWA_FAILURE_URL =
            APP_BASE_URL + "/renter/payment?action=esewaFailure";
    public static final String ESEWA_SIGNED_FIELD_NAMES =
            "total_amount,transaction_uuid,product_code";

    // =========================
    // KHALTI
    // =========================
    public static final String KHALTI_GATEWAY = "KHALTI";
    public static final String KHALTI_SECRET_KEY = "3eb4c022aa5749ab98e80bc32ec8559f";
    public static final String KHALTI_INITIATE_URL =
            "https://dev.khalti.com/api/v2/epayment/initiate/";
    public static final String KHALTI_LOOKUP_URL =
            "https://dev.khalti.com/api/v2/epayment/lookup/";
    public static final String KHALTI_RETURN_URL =
            APP_BASE_URL + "/renter/payment?action=khaltiReturn";
    public static final String KHALTI_WEBSITE_URL = APP_BASE_URL;
}