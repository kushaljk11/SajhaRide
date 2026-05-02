<%@ page contentType="text/html;charset=UTF-8" language="java" import="com.riderental.myriderental.dao.PaymentDAO.Payment,java.util.List" %>
<%
  List<Payment> payments = (List<Payment>) request.getAttribute("payments");
  if (payments == null) payments = java.util.Collections.emptyList();
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>SajhaRide - Payments</title>
  <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="h-screen overflow-hidden bg-gray-100 text-gray-900">
<div class="flex h-full">
  <jsp:include page="components/sidebar.jsp" />

  <div class="flex min-w-0 flex-1 flex-col overflow-hidden">
    <jsp:include page="components/topbar.jsp" />

    <main class="flex-1 overflow-y-auto px-6 py-6 sm:px-8">
      <section class="mb-6 flex flex-col gap-4 lg:flex-row lg:items-center lg:justify-between">
        <div>
          <p class="text-xs font-semibold uppercase tracking-[0.18em] text-red-700">Payments</p>
          <h1 class="mt-2 text-4xl font-semibold tracking-tight text-gray-900">Payment Transactions</h1>
          <p class="mt-2 text-sm text-gray-600">Track completed payments from renters and monitor payout status.</p>
        </div>
      </section>

      <section class="mb-6 grid grid-cols-1 gap-4 md:grid-cols-4">
        <article class="rounded-2xl border border-red-100 bg-white p-4 shadow-sm">
          <p class="text-xs uppercase tracking-[0.14em] text-red-800">Today Received</p>
          <p class="mt-2 text-3xl font-semibold text-gray-900">NPR ${requestScope.todayReceived}</p>
        </article>
        <article class="rounded-2xl border border-red-100 bg-white p-4 shadow-sm">
          <p class="text-xs uppercase tracking-[0.14em] text-red-800">This Week</p>
          <p class="mt-2 text-3xl font-semibold text-gray-900">NPR ${requestScope.weekReceived}</p>
        </article>
        <article class="rounded-2xl border border-red-100 bg-white p-4 shadow-sm">
          <p class="text-xs uppercase tracking-[0.14em] text-red-800">Pending Payout</p>
          <p class="mt-2 text-3xl font-semibold text-gray-900">NPR ${requestScope.pendingPayout}</p>
        </article>
        <article class="rounded-2xl border border-red-100 bg-red-800 p-4 shadow-sm">
          <p class="text-xs uppercase tracking-[0.14em] text-red-100">Total Settled</p>
          <p class="mt-2 text-3xl font-semibold text-white">NPR ${requestScope.settledTotal}</p>
        </article>
      </section>

      <section class="rounded-2xl border border-red-100 bg-white p-5 shadow-sm">
        <div class="mb-4 flex items-center justify-between">
          <div>
            <h2 class="text-2xl font-semibold text-gray-900">Recent Transactions</h2>
            <p class="mt-1 text-sm text-gray-500">Latest successful and pending payment records</p>
          </div>
          <div class="rounded-lg border border-red-100 bg-red-50 px-3 py-1.5 text-xs font-semibold text-red-800">Live data</div>
        </div>

        <div class="overflow-x-auto">
          <table class="min-w-full text-left text-sm">
            <thead>
              <tr class="border-b border-gray-200 text-xs uppercase tracking-[0.12em] text-gray-500">
                <th class="px-3 py-3 font-semibold">Txn ID</th>
                <th class="px-3 py-3 font-semibold">Renter</th>
                <th class="px-3 py-3 font-semibold">Vehicle</th>
                <th class="px-3 py-3 font-semibold">Date</th>
                <th class="px-3 py-3 font-semibold">Amount</th>
                <th class="px-3 py-3 font-semibold">Gateway</th>
                <th class="px-3 py-3 font-semibold">Payment Status</th>
                <th class="px-3 py-3 font-semibold">Booking Status</th>
              </tr>
            </thead>
            <tbody>
            <%
              if (!payments.isEmpty()) {
                for (Payment p : payments) {
                  String paymentStatus = p.getStatus() == null ? "PENDING" : p.getStatus().trim().toUpperCase();
                  String bookingStatus = p.getBookingStatus() == null ? "-" : p.getBookingStatus().trim().toUpperCase();
            %>
            <tr class="border-b border-gray-100">
              <td class="px-3 py-3 font-semibold text-gray-900">TXN-<%= p.getPaymentId() %></td>
              <td class="px-3 py-3"><%= p.getRenterName() == null ? "-" : p.getRenterName() %></td>
              <td class="px-3 py-3"><%= p.getVehicleName() == null ? "-" : p.getVehicleName() %></td>
              <td class="px-3 py-3"><%= p.getCreatedAt() == null ? "-" : p.getCreatedAt().toLocalDateTime().toLocalDate() %></td>
              <td class="px-3 py-3 font-semibold text-gray-900">NPR <%= String.format(java.util.Locale.US, "%,.2f", p.getAmount()) %></td>
              <td class="px-3 py-3"><%= p.getGateway() == null ? "-" : p.getGateway() %></td>
              <td class="px-3 py-3"><span class="rounded-full px-3 py-1 text-xs font-semibold <%= "SUCCESS".equals(paymentStatus) ? "bg-emerald-100 text-emerald-700" : ("FAILED".equals(paymentStatus) ? "bg-rose-100 text-rose-700" : "bg-amber-100 text-amber-700") %>"><%= paymentStatus %></span></td>
              <td class="px-3 py-3"><%= bookingStatus %></td>
            </tr>
            <%
                }
              } else {
            %>
            <tr>
              <td colspan="8" class="px-3 py-8 text-center text-gray-500">No payment transactions found for this owner.</td>
            </tr>
            <% } %>
            </tbody>
          </table>
        </div>
      </section>
    </main>
  </div>
</div>
</body>
</html>
