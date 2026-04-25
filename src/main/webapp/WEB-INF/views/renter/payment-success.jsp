<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
	String message = (String) request.getAttribute("message");
	String bookingId = (String) request.getAttribute("bookingId");
	String paymentMethod = (String) request.getAttribute("paymentMethod");
	if (message == null || message.isBlank()) {
		message = "Payment completed successfully.";
	}
	if (paymentMethod == null || paymentMethod.isBlank()) {
		paymentMethod = "Payment";
	}
%>
<!DOCTYPE html>
<html>
<head>
	<title>Payment Success | SajhaRide</title>
	<script src="https://cdn.tailwindcss.com"></script>
	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
</head>
<body class="flex min-h-screen items-center justify-center bg-green-50 px-4 text-gray-900">
<div class="w-full max-w-2xl rounded-3xl border border-green-200 bg-white p-8 shadow-sm">
	<div class="inline-flex rounded-full bg-green-100 px-3 py-1 text-sm font-semibold text-green-800"><%= paymentMethod %> Success</div>
	<h1 class="mt-4 text-3xl font-bold text-gray-900">Booking confirmed</h1>
	<p class="mt-3 text-sm leading-6 text-gray-600"><%= message %></p>

	<% if (bookingId != null && !bookingId.isBlank()) { %>
	<div class="mt-6 rounded-2xl border border-green-100 bg-green-50 p-4 text-sm text-green-900">
		<p class="font-semibold">Booking ID</p>
		<p class="mt-1 text-lg font-bold"><%= bookingId %></p>
	</div>
	<% } %>

	<div class="mt-6 rounded-2xl bg-slate-50 p-4 text-sm text-gray-700">
		<p class="font-semibold text-gray-900">What happens next?</p>
		<ul class="mt-2 list-disc space-y-1 pl-5">
			<li>Your payment has been accepted in the simulation.</li>
			<li>The booking is marked as confirmed for the renter.</li>
			<li>You can return to the payments page or continue to the dashboard.</li>
		</ul>
	</div>

	<div class="mt-6 flex flex-wrap gap-3">
		<a href="<%= request.getContextPath() %>/renter/payments" class="rounded-xl bg-green-700 px-4 py-2.5 text-sm font-semibold text-white hover:bg-green-800">Back to Payments</a>
		<a href="<%= request.getContextPath() %>/renter/dashboard" class="rounded-xl border border-gray-300 bg-white px-4 py-2.5 text-sm font-semibold text-gray-700 hover:bg-gray-50">Go to Dashboard</a>
	</div>
</div>
</body>
</html>

