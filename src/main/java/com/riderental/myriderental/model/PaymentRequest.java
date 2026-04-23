package com.riderental.myriderental.model;

public class PaymentRequest {

    // Common
    private String bookingId;
    private String gateway;
    private String amount;

    // eSewa fields
    private String taxAmount;
    private String totalAmount;
    private String transactionUuid;
    private String productCode;
    private String productServiceCharge;
    private String productDeliveryCharge;
    private String successUrl;
    private String failureUrl;
    private String signedFieldNames;
    private String signature;
    private String formUrl;

    // Khalti fields
    private String pidx;
    private String paymentUrl;
    private String purchaseOrderId;
    private String purchaseOrderName;

    public String getBookingId() { return bookingId; }
    public void setBookingId(String bookingId) { this.bookingId = bookingId; }

    public String getGateway() { return gateway; }
    public void setGateway(String gateway) { this.gateway = gateway; }

    public String getAmount() { return amount; }
    public void setAmount(String amount) { this.amount = amount; }

    public String getTaxAmount() { return taxAmount; }
    public void setTaxAmount(String taxAmount) { this.taxAmount = taxAmount; }

    public String getTotalAmount() { return totalAmount; }
    public void setTotalAmount(String totalAmount) { this.totalAmount = totalAmount; }

    public String getTransactionUuid() { return transactionUuid; }
    public void setTransactionUuid(String transactionUuid) { this.transactionUuid = transactionUuid; }

    public String getProductCode() { return productCode; }
    public void setProductCode(String productCode) { this.productCode = productCode; }

    public String getProductServiceCharge() { return productServiceCharge; }
    public void setProductServiceCharge(String productServiceCharge) { this.productServiceCharge = productServiceCharge; }

    public String getProductDeliveryCharge() { return productDeliveryCharge; }
    public void setProductDeliveryCharge(String productDeliveryCharge) { this.productDeliveryCharge = productDeliveryCharge; }

    public String getSuccessUrl() { return successUrl; }
    public void setSuccessUrl(String successUrl) { this.successUrl = successUrl; }

    public String getFailureUrl() { return failureUrl; }
    public void setFailureUrl(String failureUrl) { this.failureUrl = failureUrl; }

    public String getSignedFieldNames() { return signedFieldNames; }
    public void setSignedFieldNames(String signedFieldNames) { this.signedFieldNames = signedFieldNames; }

    public String getSignature() { return signature; }
    public void setSignature(String signature) { this.signature = signature; }

    public String getFormUrl() { return formUrl; }
    public void setFormUrl(String formUrl) { this.formUrl = formUrl; }

    public String getPidx() { return pidx; }
    public void setPidx(String pidx) { this.pidx = pidx; }

    public String getPaymentUrl() { return paymentUrl; }
    public void setPaymentUrl(String paymentUrl) { this.paymentUrl = paymentUrl; }

    public String getPurchaseOrderId() { return purchaseOrderId; }
    public void setPurchaseOrderId(String purchaseOrderId) { this.purchaseOrderId = purchaseOrderId; }

    public String getPurchaseOrderName() { return purchaseOrderName; }
    public void setPurchaseOrderName(String purchaseOrderName) { this.purchaseOrderName = purchaseOrderName; }
}
