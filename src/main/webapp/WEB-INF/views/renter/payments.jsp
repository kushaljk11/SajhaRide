<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.riderental.myriderental.model.User" %>
<%@ page import="com.riderental.myriderental.dao.PaymentDAO" %>
<%@ page import="java.util.List" %>
<%
    User paymentUser = (User) session.getAttribute("loggedInUser");
    List<PaymentDAO.Payment> payments = (List<PaymentDAO.Payment>) request.getAttribute("payments");
    Double totalSpent = (Double) request.getAttribute("totalSpent");
    Double pendingAmount = (Double) request.getAttribute("pendingAmount");
    Long paidCount = (Long) request.getAttribute("paidCount");
    Long pendingCount = (Long) request.getAttribute("pendingCount");
    PaymentDAO.Payment firstPendingPayment = (PaymentDAO.Payment) request.getAttribute("firstPendingPayment");

    if (payments == null) payments = java.util.Collections.emptyList();
    double ts = totalSpent == null ? 0.0 : totalSpent;
    double pa = pendingAmount == null ? 0.0 : pendingAmount;
    long paid = paidCount == null ? 0 : paidCount;
    long pending = pendingCount == null ? 0 : pendingCount;

    String firstName = "Rider";
    String esewaStatus = request.getParameter("esewa_status");
    String esewaMessage = request.getParameter("message");
    String safeEsewaMessage = esewaMessage == null ? "" : esewaMessage
            .replace("&", "&amp;")
            .replace("<", "&lt;")
            .replace(">", "&gt;")
            .replace("\"", "&quot;")
            .replace("'", "&#x27;");
    if (paymentUser != null && paymentUser.getFullName() != null && !paymentUser.getFullName().isBlank()) {
        String[] nameParts = paymentUser.getFullName().trim().split("\\s+");
        firstName = nameParts[0];
    }
%>
<html>
<head>
    <title>Payments | SajhaRide</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
</head>
<body class="h-screen overflow-hidden bg-[#f5f6fa] text-gray-900">
<div class="flex h-full">
    <%@ include file="/WEB-INF/views/renter/components/sidebar.jsp" %>

    <div class="flex min-w-0 flex-1 flex-col">
        <%@ include file="/WEB-INF/views/renter/components/topbar.jsp" %>

        <main class="flex-1 overflow-y-auto p-4 sm:p-6 lg:p-8">
            <% if (esewaStatus != null && !esewaStatus.isBlank()) { %>
            <div class="mb-4 rounded-xl border px-4 py-3 text-sm <%= "complete".equalsIgnoreCase(esewaStatus) ? "border-green-200 bg-green-50 text-green-800" : "border-yellow-200 bg-yellow-50 text-yellow-800" %>">
                <strong class="mr-2">eSewa:</strong>
                <%= !safeEsewaMessage.isBlank() ? safeEsewaMessage : ("complete".equalsIgnoreCase(esewaStatus) ? "Payment completed." : "Payment not completed.") %>
            </div>
            <% } %>

            <section class="rounded-3xl border border-red-100 bg-white p-5 shadow-sm sm:p-7">
                <h1 class="text-2xl font-semibold text-gray-900 sm:text-4xl">Payment Center</h1>
                <p class="mt-2 max-w-3xl text-sm leading-6 text-gray-600 sm:text-base">Welcome back, <span class="font-semibold text-red-800"><%= firstName %></span>. Track your recent transactions, monitor pending charges, and manage payment details from one clean dashboard.</p>
                <div class="mt-5 grid gap-3 sm:grid-cols-2 xl:grid-cols-4">
                    <article class="rounded-2xl border border-red-100 bg-red-50 p-4">
                        <p class="text-xs font-semibold uppercase tracking-wide text-red-700">Total Spent</p>
                        <p class="mt-2 text-2xl font-bold text-red-900">Rs. <%= String.format(java.util.Locale.US, "%,.2f", ts) %></p>
                        <p class="mt-1 text-xs text-red-700/80">Across successful payments</p>
                    </article>
                    <article class="rounded-2xl border border-gray-200 bg-white p-4">
                        <p class="text-xs font-semibold uppercase tracking-wide text-gray-500">Successful Payments</p>
                        <p class="mt-2 text-2xl font-bold text-gray-900"><%= paid %></p>
                        <p class="mt-1 text-xs text-gray-500">Completed transactions</p>
                    </article>
                    <article class="rounded-2xl border border-gray-200 bg-white p-4">
                        <p class="text-xs font-semibold uppercase tracking-wide text-gray-500">Pending</p>
                        <p class="mt-2 text-2xl font-bold text-gray-900">Rs. <%= String.format(java.util.Locale.US, "%,.2f", pa) %></p>
                        <p class="mt-1 text-xs text-gray-500"><%= pending %> unsettled transaction(s)</p>
                    </article>
                    <article class="rounded-2xl border border-gray-200 bg-white p-4">
                        <p class="text-xs font-semibold uppercase tracking-wide text-gray-500">Total Transactions</p>
                        <p class="mt-2 text-2xl font-bold text-gray-900"><%= payments.size() %></p>
                        <p class="mt-1 text-xs text-gray-500">Payment records</p>
                    </article>
                </div>
            </section>

            <section class="mt-6 grid gap-4 xl:grid-cols-[1.65fr_1fr]">
                <article class="rounded-2xl border border-gray-200 bg-white shadow-sm">
                    <div class="flex flex-wrap items-center justify-between gap-2 border-b border-gray-100 px-5 py-4 sm:px-6">
                        <div>
                            <h2 class="text-lg font-semibold text-gray-900">Recent Transactions</h2>
                            <p class="text-xs text-gray-500 sm:text-sm">Complete timeline of your latest payment activities</p>
                        </div>
                        <button type="button" class="rounded-lg border border-red-200 bg-red-50 px-3 py-2 text-xs font-semibold text-red-800 transition hover:bg-red-100 sm:text-sm">Download Statement</button>
                    </div>

                    <div class="overflow-x-auto">
                        <table class="min-w-full text-left text-sm">
                            <thead class="bg-gray-50 text-xs uppercase tracking-wide text-gray-500">
                            <tr>
                                <th class="px-5 py-3 font-semibold sm:px-6">Txn ID</th>
                                <th class="px-5 py-3 font-semibold sm:px-6">Booking</th>
                                <th class="px-5 py-3 font-semibold sm:px-6">Method</th>
                                <th class="px-5 py-3 font-semibold sm:px-6">Date</th>
                                <th class="px-5 py-3 font-semibold sm:px-6">Amount</th>
                                <th class="px-5 py-3 font-semibold sm:px-6">Status</th>
                            </tr>
                            </thead>
                            <tbody class="divide-y divide-gray-100">
                            <% if (payments.isEmpty()) { %>
                            <tr>
                                <td colspan="6" class="px-5 py-6 text-center text-sm text-gray-500 sm:px-6">No payment history found.</td>
                            </tr>
                            <% } %>
                            <% for (PaymentDAO.Payment payment : payments) {
                                String status = payment.getStatus() == null ? "PENDING" : payment.getStatus().toUpperCase();
                                String statusClass = "bg-red-100 text-red-800";
                                if ("SUCCESS".equals(status)) statusClass = "bg-red-800 text-white";
                                if ("FAILED".equals(status)) statusClass = "bg-gray-200 text-gray-700";
                                String transactionId = payment.getReferenceId();
                                if (transactionId == null || transactionId.isBlank()) {
                                    transactionId = payment.getTransactionUuid();
                                }
                                if (transactionId == null || transactionId.isBlank()) {
                                    transactionId = payment.getPidx();
                                }
                                if (transactionId == null || transactionId.isBlank()) {
                                    transactionId = "PMT-" + payment.getPaymentId();
                                }
                            %>
                            <tr class="hover:bg-red-50/30">
                                <td class="px-5 py-4 font-semibold text-gray-900 sm:px-6"><%= transactionId %></td>
                                <td class="px-5 py-4 sm:px-6">
                                    <p class="font-semibold text-gray-900">BK-<%= payment.getBookingId() %></p>
                                </td>
                                <td class="px-5 py-4 text-gray-700 sm:px-6"><%= payment.getGateway() %></td>
                                <td class="px-5 py-4 text-gray-700 sm:px-6"><%= payment.getCreatedAt() == null ? "-" : payment.getCreatedAt() %></td>
                                <td class="px-5 py-4 font-semibold text-gray-900 sm:px-6">Rs. <%= String.format(java.util.Locale.US, "%,.2f", payment.getAmount()) %></td>
                                <td class="px-5 py-4 sm:px-6"><span class="inline-flex rounded-full px-3 py-1 text-xs font-semibold <%= statusClass %>"><%= status %></span></td>
                            </tr>
                            <% } %>
                            </tbody>
                        </table>
                    </div>
                </article>

                <div class="grid gap-4">
                    <article class="rounded-2xl border border-gray-200 bg-white p-5 shadow-sm">
                        <h3 class="text-lg font-semibold text-gray-900">Pay Pending Amount</h3>
                        <p class="mt-1 text-sm text-gray-600">Settle your unsettled transaction securely in a few taps.</p>
                        <div class="mt-4 rounded-xl border border-red-100 bg-red-50 p-4">
                            <p class="text-xs font-semibold uppercase tracking-wide text-red-700">Due Now</p>
                            <p class="mt-1 text-3xl font-bold text-red-900">Rs. <%= String.format(java.util.Locale.US, "%,.2f", pa) %></p>
                            <p class="text-xs text-red-700/80"><%= firstPendingPayment == null ? "No pending payment found" : "For booking BK-" + firstPendingPayment.getBookingId() %></p>
                        </div>
                        <div class="mt-4 space-y-3">
                            <p class="text-sm font-semibold text-gray-700">Choose how you want to pay this pending booking.</p>

                            <% if (firstPendingPayment == null) { %>
                            <p class="rounded-lg bg-gray-100 px-3 py-2 text-sm text-gray-600">All pending payments are already settled.</p>
                            <% } else { %>

                            <div class="grid gap-3 sm:grid-cols-2">
                                <form action="<%= request.getContextPath() %>/renter/payment" method="post">
                                    <input type="hidden" name="action" value="initiate" />
                                    <input type="hidden" name="gateway" value="ESEWA" />
                                    <input type="hidden" name="bookingId" value="<%= firstPendingPayment.getBookingId() %>" />
                                    <input type="hidden" name="amount" value="<%= firstPendingPayment.getAmount() %>" />
                                    <button type="submit" class="w-full rounded-xl border border-red-200 bg-red-50 px-4 py-3 text-center text-sm font-semibold text-red-800 transition hover:bg-red-100">eSewa Payment</button>
                                </form>

                                <form action="<%= request.getContextPath() %>/renter/payment" method="post">
                                    <input type="hidden" name="action" value="initiate" />
                                    <input type="hidden" name="gateway" value="KHALTI" />
                                    <input type="hidden" name="bookingId" value="<%= firstPendingPayment.getBookingId() %>" />
                                    <input type="hidden" name="amount" value="<%= firstPendingPayment.getAmount() %>" />
                                    <button type="submit" class="w-full rounded-xl border border-purple-200 bg-purple-50 px-4 py-3 text-center text-sm font-semibold text-purple-800 transition hover:bg-purple-100">Khalti Payment</button>
                                </form>

                                <form action="<%= request.getContextPath() %>/renter/payment" method="post" class="sm:col-span-2">
                                    <input type="hidden" name="action" value="initiate" />
                                    <input type="hidden" name="gateway" value="CASH" />
                                    <input type="hidden" name="bookingId" value="<%= firstPendingPayment.getBookingId() %>" />
                                    <input type="hidden" name="amount" value="<%= firstPendingPayment.getAmount() %>" />
                                    <button type="submit" class="w-full rounded-xl border border-amber-200 bg-amber-50 px-4 py-3 text-center text-sm font-semibold text-amber-800 transition hover:bg-amber-100">Cash on Pickup</button>
                                </form>
                            </div>
                            <% } %>
                        </div>
                    </article>

                    <article class="rounded-2xl border border-gray-200 bg-white p-5 shadow-sm">
                        <h3 class="text-lg font-semibold text-gray-900">Latest Invoice Details</h3>
                        <div class="mt-4 space-y-2 text-sm">
                            <div class="flex items-center justify-between"><span class="text-gray-500">Invoice No.</span><span class="font-semibold text-gray-900">INV-2026-391</span></div>
                            <div class="flex items-center justify-between"><span class="text-gray-500">Transaction</span><span class="font-semibold text-gray-900">TXN-40921</span></div>
                            <div class="flex items-center justify-between"><span class="text-gray-500">Vehicle</span><span class="font-semibold text-gray-900">Honda Activa 6G</span></div>
                            <div class="flex items-center justify-between"><span class="text-gray-500">Rental Charges</span><span class="font-semibold text-gray-900">Rs. 1,050</span></div>
                            <div class="flex items-center justify-between"><span class="text-gray-500">Service Fee</span><span class="font-semibold text-gray-900">Rs. 100</span></div>
                            <div class="flex items-center justify-between"><span class="text-gray-500">Tax</span><span class="font-semibold text-gray-900">Rs. 50</span></div>
                            <hr class="my-3 border-gray-200" />
                            <div class="flex items-center justify-between text-base"><span class="font-semibold text-gray-900">Total</span><span class="font-bold text-red-800">Rs. 1,200</span></div>
                        </div>
                        <div class="mt-4 flex gap-2">
                            <button type="button" class="flex-1 rounded-lg border border-gray-300 bg-gray-50 px-3 py-2 text-sm font-semibold text-gray-700 transition hover:bg-gray-100">View PDF</button>
                            <button type="button" class="flex-1 rounded-lg bg-red-800 px-3 py-2 text-sm font-semibold text-white transition hover:bg-red-900">Email Copy</button>
                        </div>
                    </article>
                </div>
            </section>
        </main>
    </div>
</div>
</body>
</html>
