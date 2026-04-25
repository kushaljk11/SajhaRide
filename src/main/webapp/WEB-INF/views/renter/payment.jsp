<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String gateway = request.getParameter("gateway");
    String bookingId = request.getParameter("bookingId");
    String amount = request.getParameter("amount");
    if (bookingId == null || bookingId.isBlank()) {
        bookingId = "BK-10231";
    }
    if (amount == null || amount.isBlank()) {
        amount = "1200";
    }
    String normalizedGateway = gateway == null ? "ESEWA" : gateway.toUpperCase();
    String gatewayLabel = "ESEWA".equals(normalizedGateway) ? "eSewa" : ("KHALTI".equals(normalizedGateway) ? "Khalti" : "Cash on Pickup");
%>
<!DOCTYPE html>
<html>
<head>
    <title><%= gatewayLabel %> Payment Simulation | SajhaRide</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
</head>
<body class="min-h-screen bg-slate-100 text-gray-900">
<div class="mx-auto flex min-h-screen max-w-6xl flex-col justify-center px-4 py-8 sm:px-6 lg:px-8">
    <div class="grid gap-6 lg:grid-cols-[1.2fr_0.8fr]">
        <section class="rounded-3xl border border-white/60 bg-white p-6 shadow-lg ring-1 ring-black/5 sm:p-8">
            <p class="text-xs font-semibold uppercase tracking-[0.3em] text-red-700">Payment simulation</p>
            <h1 class="mt-2 text-3xl font-bold text-gray-900"><%= gatewayLabel %> checkout</h1>
            <p class="mt-3 text-sm leading-6 text-gray-600">This is a simulated checkout page for booking <span class="font-semibold text-gray-900"><%= bookingId %></span>. You can confirm payment, simulate a failure, or go back and choose a different method.</p>

            <div class="mt-6 rounded-3xl border <%= "KHALTI".equals(normalizedGateway) ? "border-purple-200 bg-purple-50" : ("CASH".equals(normalizedGateway) ? "border-amber-200 bg-amber-50" : "border-red-200 bg-red-50") %> p-5">
                <div class="flex items-center justify-between gap-4">
                    <div>
                        <p class="text-xs font-semibold uppercase tracking-wide <%= "KHALTI".equals(normalizedGateway) ? "text-purple-700" : ("CASH".equals(normalizedGateway) ? "text-amber-700" : "text-red-700") %>"><%= gatewayLabel %> UI</p>
                        <p class="mt-1 text-2xl font-bold text-gray-900">Rs. <%= amount %></p>
                    </div>
                    <div class="rounded-2xl bg-white px-4 py-3 text-right shadow-sm ring-1 ring-black/5">
                        <p class="text-xs uppercase tracking-wide text-gray-500">Booking</p>
                        <p class="text-lg font-semibold text-gray-900"><%= bookingId %></p>
                    </div>
                </div>

                <% if ("KHALTI".equals(normalizedGateway)) { %>
                <div class="mt-5 rounded-2xl bg-white p-4 shadow-sm ring-1 ring-purple-100">
                    <p class="text-sm font-semibold text-purple-800">Khalti Style Page</p>
                    <p class="mt-1 text-sm text-gray-600">Fast, clean checkout with a mobile-wallet style confirmation.</p>
                </div>
                <% } else if ("CASH".equals(normalizedGateway)) { %>
                <div class="mt-5 rounded-2xl bg-white p-4 shadow-sm ring-1 ring-amber-100">
                    <p class="text-sm font-semibold text-amber-800">Cash on Pickup</p>
                    <p class="mt-1 text-sm text-gray-600">Your booking will be confirmed now and you can pay when the vehicle is handed over.</p>
                </div>
                <% } else { %>
                <div class="mt-5 rounded-2xl bg-white p-4 shadow-sm ring-1 ring-red-100">
                    <p class="text-sm font-semibold text-red-800">eSewa UI Simulation</p>
                    <p class="mt-1 text-sm text-gray-600">A sandbox-style eSewa checkout that forwards into the existing payment initiation flow.</p>
                </div>
                <% } %>
            </div>
        </section>

        <aside class="rounded-3xl border border-gray-200 bg-white p-6 shadow-lg sm:p-8">
            <h2 class="text-lg font-semibold text-gray-900">Actions</h2>
            <p class="mt-2 text-sm text-gray-600">Use the buttons below to simulate success or failure.</p>

            <form action="<%= request.getContextPath() %>/renter/payment" method="post" class="mt-6 space-y-3">
                <input type="hidden" name="action" value="initiate" />
                <input type="hidden" name="gateway" value="<%= normalizedGateway %>" />
                <input type="hidden" name="bookingId" value="<%= bookingId %>" />
                <input type="hidden" name="amount" value="<%= amount %>" />

                <button type="submit" class="w-full rounded-2xl bg-red-800 px-4 py-3 text-sm font-semibold text-white transition hover:bg-red-900">
                    <%= "CASH".equals(normalizedGateway) ? "Confirm Booking" : "Pay Now" %>
                </button>
            </form>

            <% if (!"CASH".equals(normalizedGateway)) { %>
            <form action="<%= request.getContextPath() %>/renter/payment" method="get" class="mt-3 space-y-3">
                <input type="hidden" name="action" value="<%= "ESEWA".equals(normalizedGateway) ? "esewaFailure" : "khaltiReturn" %>" />
                <% if ("KHALTI".equals(normalizedGateway)) { %>
                <input type="hidden" name="pidx" value="demo-pidx-123" />
                <% } else { %>
                <input type="hidden" name="transaction_uuid" value="demo-txn-123" />
                <input type="hidden" name="total_amount" value="<%= amount %>" />
                <% } %>
                <button type="submit" class="w-full rounded-2xl border border-gray-300 bg-white px-4 py-3 text-sm font-semibold text-gray-700 transition hover:bg-gray-50">
                    Simulate Failure
                </button>
            </form>
            <% } %>

            <a href="<%= request.getContextPath() %>/renter/payments"
               class="mt-3 block w-full rounded-2xl border border-gray-300 bg-gray-50 px-4 py-3 text-center text-sm font-semibold text-gray-700 transition hover:bg-gray-100">Back to Payments</a>

            <div class="mt-6 rounded-2xl bg-slate-50 p-4 text-sm text-gray-600">
                <p class="font-semibold text-gray-900">Flow notes</p>
                <ul class="mt-2 list-disc space-y-1 pl-5">
                    <li>eSewa and Khalti still use the servlet-based payment flow.</li>
                    <li>Cash on pickup confirms the booking immediately in the UI.</li>
                    <li>Success and failure pages show booking/payment outcomes.</li>
                </ul>
            </div>
        </aside>
    </div>
</div>
</body>
</html>

