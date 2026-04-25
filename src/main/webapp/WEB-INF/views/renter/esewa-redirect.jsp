<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.riderental.myriderental.model.PaymentRequest" %>
<%
    PaymentRequest paymentRequest = (PaymentRequest) request.getAttribute("paymentRequest");
%>
<html>
<head>
    <title>Redirecting to eSewa...</title>
</head>
<body onload="document.getElementById('esewaForm').submit();">
<form id="esewaForm" action="<%= paymentRequest.getFormUrl() %>" method="POST">
    <input type="hidden" name="amount" value="<%= paymentRequest.getAmount() %>">
    <input type="hidden" name="tax_amount" value="<%= paymentRequest.getTaxAmount() %>">
    <input type="hidden" name="total_amount" value="<%= paymentRequest.getTotalAmount() %>">
    <input type="hidden" name="transaction_uuid" value="<%= paymentRequest.getTransactionUuid() %>">
    <input type="hidden" name="product_code" value="<%= paymentRequest.getProductCode() %>">
    <input type="hidden" name="product_service_charge" value="<%= paymentRequest.getProductServiceCharge() %>">
    <input type="hidden" name="product_delivery_charge" value="<%= paymentRequest.getProductDeliveryCharge() %>">
    <input type="hidden" name="success_url" value="<%= paymentRequest.getSuccessUrl() %>">
    <input type="hidden" name="failure_url" value="<%= paymentRequest.getFailureUrl() %>">
    <input type="hidden" name="signed_field_names" value="<%= paymentRequest.getSignedFieldNames() %>">
    <input type="hidden" name="signature" value="<%= paymentRequest.getSignature() %>">
</form>

<p>Redirecting to eSewa...</p>
</body>
</html>