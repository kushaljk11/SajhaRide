<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
	String message = (String) request.getAttribute("message");
	String bookingId = request.getParameter("bookingId");
	String amount = request.getParameter("amount");
	if (message == null || message.isBlank()) {
		message = "Payment failed or was cancelled.";
	}
	if (bookingId == null || bookingId.isBlank()) {
		bookingId = "10231";
	}
	if (amount == null || amount.isBlank()) {
		amount = "1200";
	}
%>
<!DOCTYPE html>
<html>
<head>
	<title>Payment Failed | SajhaRide</title>
	<script src="https://cdn.tailwindcss.com"></script>
	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
</head>
<body class="flex min-h-screen items-center justify-center bg-red-50 px-4 text-gray-900">
<div class="w-full max-w-2xl rounded-3xl border border-red-200 bg-white p-8 shadow-sm">
	<div class="inline-flex rounded-full bg-red-100 px-3 py-1 text-sm font-semibold text-red-800">Payment Failed</div>
	<h1 class="mt-4 text-3xl font-bold text-gray-900">We couldn’t complete the payment</h1>
	<p class="mt-3 text-sm leading-6 text-gray-600"><%= message %></p>

	<div class="mt-6 rounded-2xl bg-slate-50 p-4 text-sm text-gray-700">
		<p class="font-semibold text-gray-900">Try again</p>
		<ul class="mt-2 list-disc space-y-1 pl-5">
			<li>Go back and choose eSewa, Khalti, or cash on pickup.</li>
			<li>For simulated gateway failures, the booking remains unconfirmed.</li>
		</ul>
	</div>

	<div class="mt-6 flex flex-wrap gap-3">
		<a href="<%= request.getContextPath() %>/renter/payments" class="rounded-xl bg-red-700 px-4 py-2.5 text-sm font-semibold text-white hover:bg-red-800">Back to Payments</a>
		<form action="<%= request.getContextPath() %>/renter/payment" method="post">
			<input type="hidden" name="action" value="initiate" />
			<input type="hidden" name="gateway" value="ESEWA" />
			<input type="hidden" name="bookingId" value="<%= bookingId %>" />
			<input type="hidden" name="amount" value="<%= amount %>" />
			<button type="submit" class="rounded-xl border border-gray-300 bg-white px-4 py-2.5 text-sm font-semibold text-gray-700 hover:bg-gray-50">Retry with eSewa</button>
		</form>
	</div>
</div>
</body>
</html>


