<%@ page contentType="text/html;charset=UTF-8" language="java" import="jakarta.servlet.http.HttpServletRequest" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>SajhaRide - Booking Management</title>
  <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="h-screen overflow-hidden bg-gray-50 text-gray-900">
<div class="flex h-full">
  <jsp:include page="components/sidebar.jsp" />

  <%-- ctx helper for scriptlets --%>
  <%
    String ctx = ((HttpServletRequest) request).getContextPath();
  %>

  <div class="flex min-w-0 flex-1 flex-col overflow-hidden">
    <jsp:include page="components/topbar.jsp" />

    <main class="flex-1 overflow-y-auto px-6 py-6 sm:px-8">
      <section class="mb-6 flex flex-col gap-4 lg:flex-row lg:items-center lg:justify-between">
        <div>
          <p class="text-xs font-semibold uppercase tracking-[0.18em] text-red-700">Dashboard</p>
          <h1 class="mt-2 text-4xl font-semibold tracking-tight text-gray-900">Booking Management</h1>
          <p class="mt-2 text-sm text-gray-600">Review reservations, monitor revenue, and handle cancellations from one screen.</p>
        </div>
        <div class="flex flex-wrap gap-3">
          <a href="<%= ctx + "/admin/bookings/export-csv" %>" class="rounded-xl border border-gray-200 bg-white px-4 py-2.5 text-sm font-semibold text-gray-700 shadow-sm transition hover:bg-gray-100">Export CSV</a>
          <a href="<%= ctx + "/admin/bookings/create" %>" class="rounded-xl bg-red-800 px-4 py-2.5 text-sm font-semibold text-white shadow-sm transition hover:bg-red-900">+ New Booking</a>
        </div>
      </section>

      <section class="grid grid-cols-1 gap-4 md:grid-cols-4">
        <article class="rounded-3xl bg-white p-4 shadow-sm ring-1 ring-gray-200">
          <p class="text-xs font-semibold uppercase tracking-[0.14em] text-blue-700">Total Bookings</p>
          <p class="mt-3 text-3xl font-semibold text-gray-900"><%= request.getAttribute("totalBookings") == null ? 0 : request.getAttribute("totalBookings") %></p>
        </article>
        <article class="rounded-3xl bg-white p-4 shadow-sm ring-1 ring-gray-200">
          <p class="text-xs font-semibold uppercase tracking-[0.14em] text-red-700">Total Revenue</p>
          <p class="mt-3 text-3xl font-semibold text-gray-900">NPR <%= request.getAttribute("totalRevenue") == null ? 0 : request.getAttribute("totalRevenue") %></p>
        </article>
        <article class="rounded-3xl bg-white p-4 shadow-sm ring-1 ring-gray-200">
          <p class="text-xs font-semibold uppercase tracking-[0.14em] text-emerald-700">Active Rides</p>
          <p class="mt-3 text-3xl font-semibold text-gray-900">--</p>
          <p class="mt-2 text-sm text-gray-500">Stable</p>
        </article>
        <article class="rounded-3xl bg-white p-4 shadow-sm ring-1 ring-gray-200">
          <p class="text-xs font-semibold uppercase tracking-[0.14em] text-rose-700">Cancellations</p>
          <p class="mt-3 text-3xl font-semibold text-gray-900">--</p>
          <p class="mt-2 text-sm text-gray-500">-</p>
        </article>
      </section>

      <section class="mt-6 rounded-3xl border border-gray-200 bg-white p-5 shadow-sm">
        <div class="mb-5 flex flex-col gap-3 lg:flex-row lg:items-center lg:justify-between">
          <div class="flex flex-wrap gap-3 text-sm">
            <div class="rounded-xl border border-gray-200 bg-gray-50 px-4 py-3 text-gray-700">Jan 01, 2024 - Jan 30, 2024</div>
            <select class="rounded-xl border border-gray-200 bg-white px-4 py-3 text-gray-700 outline-none focus:border-red-300 focus:ring-2 focus:ring-red-100">
              <option>All Statuses</option>
              <option>Active</option>
              <option>Completed</option>
              <option>Pending</option>
              <option>Cancelled</option>
            </select>
            <select class="rounded-xl border border-gray-200 bg-white px-4 py-3 text-gray-700 outline-none focus:border-red-300 focus:ring-2 focus:ring-red-100">
              <option>All Vehicles</option>
              <option>Bike</option>
              <option>SUV</option>
              <option>EV</option>
            </select>
          </div>
          <div class="text-sm text-gray-500">Sort by: <span class="font-semibold text-gray-700">Newest First</span></div>
        </div>

        <div class="overflow-x-auto">
          <table class="min-w-full text-left text-sm">
            <thead>
            <tr class="border-b border-gray-200 text-xs uppercase tracking-[0.12em] text-gray-500">
              <th class="px-3 py-3 font-semibold">Booking ID</th>
              <th class="px-3 py-3 font-semibold">Renter User</th>
              <th class="px-3 py-3 font-semibold">Owner User</th>
              <th class="px-3 py-3 font-semibold">Vehicle</th>
              <th class="px-3 py-3 font-semibold">Dates</th>
              <th class="px-3 py-3 font-semibold">Status</th>
              <th class="px-3 py-3 font-semibold">Total Amount</th>
              <th class="px-3 py-3 font-semibold text-right">Action</th>
            </tr>
            </thead>
            <tbody>
            <%
              java.util.List<com.riderental.myriderental.model.Booking> bookings = (java.util.List<com.riderental.myriderental.model.Booking>) request.getAttribute("bookings");
              if (bookings != null) {
                for (com.riderental.myriderental.model.Booking b : bookings) {
            %>
            <tr class="border-b border-gray-100">
              <td class="px-3 py-4 font-semibold text-gray-900">#<%= b.getBookingId() %></td>
              <td class="px-3 py-4">
                <p class="font-semibold text-gray-900"><%= b.getRenterName() == null ? b.getUserId() : b.getRenterName() %></p>
                <p class="text-xs text-gray-500">Renter</p>
              </td>
              <td class="px-3 py-4">
                <p class="font-semibold text-gray-900"><%= b.getVehicleName() == null ? b.getVehicleId() : b.getVehicleName() %></p>
                <p class="text-xs text-gray-500">Owner</p>
              </td>
              <td class="px-3 py-4"><%= b.getVehicleName() == null ? ("#" + b.getVehicleId()) : b.getVehicleName() %></td>
              <td class="px-3 py-4 text-gray-600"><%= b.getStartDate() %> - <%= b.getEndDate() %><br /><span class="text-xs text-gray-400"><%= java.time.temporal.ChronoUnit.DAYS.between(b.getStartDate(), b.getEndDate()) %> Days</span></td>
              <td class="px-3 py-4"><span class="rounded-full bg-emerald-100 px-3 py-1 text-xs font-semibold text-emerald-700"><%= b.getStatus() %></span></td>
              <td class="px-3 py-4 font-semibold text-gray-900">NPR <%= b.getTotalPrice() %></td>
              <td class="px-3 py-4 text-right">
                <a href="<%= ctx + "/admin/bookings/view?id=" + b.getBookingId() %>" class="rounded-lg border border-gray-200 px-3 py-2 text-xs font-semibold text-gray-700 hover:bg-gray-50">View</a>
              </td>
            </tr>
            <%    }
              } else {
            %>
            <tr><td colspan="8" class="px-3 py-4 text-center text-gray-500">No bookings found.</td></tr>
            <% } %>
            </tbody>
          </table>
        </div>

        <div class="mt-4 flex flex-col gap-4 border-t border-gray-100 pt-4 text-sm text-gray-500 lg:flex-row lg:items-center lg:justify-between">
          <p>Showing 1 to 4 of 1,284 entries</p>
          <div class="flex items-center gap-2">
            <button class="rounded-lg border border-gray-200 bg-gray-50 px-3 py-2 text-gray-400">&lt;</button>
            <button class="rounded-lg bg-red-800 px-3 py-2 font-semibold text-white">1</button>
            <button class="rounded-lg border border-gray-200 px-3 py-2 text-gray-700 hover:bg-gray-50">2</button>
            <button class="rounded-lg border border-gray-200 px-3 py-2 text-gray-700 hover:bg-gray-50">3</button>
            <button class="rounded-lg border border-gray-200 bg-gray-50 px-3 py-2 text-gray-400">&gt;</button>
          </div>
        </div>
      </section>

      <section class="mt-6 grid grid-cols-1 gap-6 xl:grid-cols-[1.2fr_0.8fr]">
        <article class="rounded-3xl border border-gray-200 bg-white p-5 shadow-sm">
          <h2 class="text-2xl font-semibold text-gray-900">Booking Volume Trend</h2>
          <div class="mt-6 flex h-56 items-end gap-3 rounded-3xl bg-gray-50 p-6">
            <div class="h-16 flex-1 rounded-t-xl bg-red-100"></div>
            <div class="h-26 flex-1 rounded-t-xl bg-red-200"></div>
            <div class="h-18 flex-1 rounded-t-xl bg-red-100"></div>
            <div class="h-34 flex-1 rounded-t-xl bg-red-300"></div>
            <div class="h-22 flex-1 rounded-t-xl bg-red-200"></div>
            <div class="h-40 flex-1 rounded-t-xl bg-red-300"></div>
            <div class="h-30 flex-1 rounded-t-xl bg-red-200"></div>
          </div>
          <div class="mt-4 grid grid-cols-7 text-center text-[11px] font-semibold uppercase tracking-[0.18em] text-gray-400">
            <span>Mon</span><span>Tue</span><span>Wed</span><span>Thu</span><span>Fri</span><span>Sat</span><span>Sun</span>
          </div>
        </article>

        <article class="rounded-3xl bg-red-800 p-6 text-white shadow-sm">
          <p class="text-xs font-semibold uppercase tracking-[0.2em] text-red-100">Review Pending Approvals</p>
          <h2 class="mt-3 text-3xl font-semibold">14 Requests</h2>
          <p class="mt-3 text-sm leading-6 text-red-50">You have 14 booking requests waiting for manual verification. Check riders, payment proof, and vehicle status before approving.</p>
          <button class="mt-8 rounded-xl bg-white px-5 py-3 text-sm font-semibold text-red-800 transition hover:bg-red-50">Verify Now</button>
        </article>
      </section>
    </main>
  </div>
</div>
</body>
</html>

