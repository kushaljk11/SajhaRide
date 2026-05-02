<%@ page contentType="text/html;charset=UTF-8" language="java" import="com.riderental.myriderental.model.Booking,java.util.List" %>
<%
  List<Booking> bookings = (List<Booking>) request.getAttribute("bookings");
  if (bookings == null) bookings = java.util.Collections.emptyList();
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>SajhaRide - Booking Requests</title>
  <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="h-screen overflow-hidden bg-gray-100 text-gray-900">
<div class="flex h-full">
  <jsp:include page="components/sidebar.jsp" />

  <div class="flex min-w-0 flex-1 flex-col overflow-hidden">
    <jsp:include page="components/topbar.jsp" />

    <main class="flex-1 overflow-y-auto px-6 py-6 sm:px-8">
      <section class="mb-6">
        <p class="text-xs font-semibold uppercase tracking-[0.18em] text-red-700">Booking Requests</p>
        <h1 class="mt-2 text-3xl font-semibold tracking-tight text-gray-900">Manage Your Booking Requests</h1>
        <p class="mt-2 text-sm text-gray-600">Review and manage incoming rental requests for your vehicles.</p>
      </section>

      <section class="grid grid-cols-1 gap-4 md:grid-cols-4">
        <article class="rounded-2xl border border-red-100 bg-white p-5 shadow-sm">
          <p class="text-xs font-semibold uppercase tracking-[0.14em] text-gray-500">Total Bookings</p>
          <p class="mt-3 text-3xl font-semibold text-gray-900">${requestScope.totalBookings}</p>
        </article>
        <article class="rounded-2xl border border-amber-100 bg-white p-5 shadow-sm">
          <p class="text-xs font-semibold uppercase tracking-[0.14em] text-amber-700">Pending</p>
          <p class="mt-3 text-3xl font-semibold text-gray-900">${requestScope.pendingCount}</p>
        </article>
        <article class="rounded-2xl border border-emerald-100 bg-white p-5 shadow-sm">
          <p class="text-xs font-semibold uppercase tracking-[0.14em] text-emerald-700">Approved</p>
          <p class="mt-3 text-3xl font-semibold text-gray-900">${requestScope.approvedCount}</p>
        </article>
        <article class="rounded-2xl border border-rose-100 bg-white p-5 shadow-sm">
          <p class="text-xs font-semibold uppercase tracking-[0.14em] text-rose-700">Rejected/Cancelled</p>
          <p class="mt-3 text-3xl font-semibold text-gray-900">${requestScope.cancelledRejectedCount}</p>
        </article>
      </section>

      <section class="mt-6 rounded-2xl border border-red-100 bg-white p-5 shadow-sm">
        <div class="mb-4 flex items-center justify-between gap-4">
          <div>
            <h2 class="text-2xl font-semibold text-gray-900">Recent Requests</h2>
            <p class="mt-1 text-sm text-gray-500">All booking requests for your vehicles</p>
          </div>
          <div class="rounded-lg border border-red-100 bg-red-50 px-3 py-1.5 text-xs font-semibold text-red-800">Live data</div>
        </div>

        <div class="overflow-x-auto">
          <table class="min-w-full text-left text-sm">
            <thead>
            <tr class="border-b border-gray-200 text-xs uppercase tracking-[0.12em] text-gray-500">
              <th class="px-3 py-3 font-semibold">Booking</th>
              <th class="px-3 py-3 font-semibold">Renter</th>
              <th class="px-3 py-3 font-semibold">Vehicle</th>
              <th class="px-3 py-3 font-semibold">Dates</th>
              <th class="px-3 py-3 font-semibold">Amount</th>
              <th class="px-3 py-3 font-semibold">Status</th>
              <th class="px-3 py-3 font-semibold text-right">Actions</th>
            </tr>
            </thead>
            <tbody>
            <%
              if (!bookings.isEmpty()) {
                for (Booking b : bookings) {
                  String status = b.getStatus() == null ? "PENDING" : b.getStatus().trim().toUpperCase();
            %>
            <tr class="border-b border-gray-100">
              <td class="px-3 py-4 font-semibold text-gray-900">#<%= b.getBookingId() %></td>
              <td class="px-3 py-4"><%= b.getRenterName() == null ? "User #" + b.getUserId() : b.getRenterName() %></td>
              <td class="px-3 py-4"><%= b.getVehicleName() == null ? "Vehicle #" + b.getVehicleId() : b.getVehicleName() %></td>
              <td class="px-3 py-4 text-gray-600"><%= b.getStartDate() %> - <%= b.getEndDate() %></td>
              <td class="px-3 py-4 font-semibold text-gray-900">Rs. <%= String.format(java.util.Locale.US, "%,.2f", b.getTotalPrice()) %></td>
              <td class="px-3 py-4"><span class="rounded-full px-3 py-1 text-xs font-semibold <%= "APPROVED".equals(status) ? "bg-emerald-100 text-emerald-700" : ("COMPLETED".equals(status) ? "bg-blue-100 text-blue-700" : ("REJECTED".equals(status) || "CANCELLED".equals(status) ? "bg-rose-100 text-rose-700" : "bg-amber-100 text-amber-700")) %>"><%= status %></span></td>
              <td class="px-3 py-4 text-right">
                <% if ("PENDING".equals(status)) { %>
                <div class="inline-flex gap-2">
                  <form action="<%= request.getContextPath() %>/booking/approve" method="post">
                    <input type="hidden" name="bookingId" value="<%= b.getBookingId() %>" />
                    <button class="rounded-lg bg-emerald-600 px-3 py-2 text-xs font-semibold text-white hover:bg-emerald-700">Approve</button>
                  </form>
                  <form action="<%= request.getContextPath() %>/booking/reject" method="post" onsubmit="return confirm('Reject this booking request?');">
                    <input type="hidden" name="bookingId" value="<%= b.getBookingId() %>" />
                    <button class="rounded-lg bg-rose-600 px-3 py-2 text-xs font-semibold text-white hover:bg-rose-700">Reject</button>
                  </form>
                </div>
                <% } else { %>
                <span class="text-xs text-gray-400">No action</span>
                <% } %>
              </td>
            </tr>
            <%
                }
              } else {
            %>
            <tr>
              <td colspan="7" class="px-3 py-8 text-center text-gray-500">No bookings found for this owner.</td>
            </tr>
            <% } %>
            </tbody>
          </table>
        </div>
      </section>

      <section class="mt-6 grid grid-cols-1 gap-4 md:grid-cols-3">
        <article class="rounded-2xl border border-red-100 bg-red-800 p-5 text-white shadow-sm">
          <p class="text-sm text-red-100">Income Estimate</p>
          <p class="mt-3 text-4xl font-semibold">Rs. ${requestScope.totalEarnings}</p>
          <p class="mt-1 text-xs text-red-100">Potential earnings from approved requests</p>
        </article>
        <article class="rounded-2xl border border-red-100 bg-white p-5 shadow-sm">
          <p class="text-sm text-red-800">Pending Requests</p>
          <p class="mt-3 text-4xl font-semibold text-gray-900">${requestScope.pendingCount}</p>
          <p class="mt-1 text-xs text-gray-500">Bookings awaiting your response</p>
        </article>
        <article class="rounded-2xl border border-red-100 bg-white p-5 shadow-sm">
          <p class="text-sm text-red-800">Trusted Renters</p>
          <p class="mt-3 text-4xl font-semibold text-gray-900">${requestScope.approvedCount}</p>
          <p class="mt-1 text-xs text-gray-500">Bookings you've already approved</p>
        </article>
      </section>
    </main>
  </div>
</div>
</body>
</html>
