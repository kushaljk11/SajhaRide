<%@ page contentType="text/html;charset=UTF-8" language="java" import="com.riderental.myriderental.model.Booking,com.riderental.myriderental.model.User,java.util.List,jakarta.servlet.http.HttpServletRequest" %>
<%
  User ownerUser = (User) request.getAttribute("ownerUser");
  List<Booking> recentBookings = (List<Booking>) request.getAttribute("recentBookings");
  if (recentBookings == null) {
    recentBookings = java.util.Collections.emptyList();
  }
  String bookingStatusChartJson = (String) request.getAttribute("bookingStatusChartJson");
  String monthlyEarningsChartJson = (String) request.getAttribute("monthlyEarningsChartJson");
  String vehicleAvailabilityChartJson = (String) request.getAttribute("vehicleAvailabilityChartJson");
  if (bookingStatusChartJson == null) bookingStatusChartJson = "[]";
  if (monthlyEarningsChartJson == null) monthlyEarningsChartJson = "[]";
  if (vehicleAvailabilityChartJson == null) vehicleAvailabilityChartJson = "[]";
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>SajhaRide - Owner Dashboard</title>
  <script src="https://cdn.tailwindcss.com"></script>
  <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body class="h-screen overflow-hidden bg-gray-50 text-gray-900">
<div class="flex h-full">
  <jsp:include page="components/sidebar.jsp" />

  <div class="flex min-w-0 flex-1 flex-col overflow-hidden">
    <jsp:include page="components/topbar.jsp" />

    <main class="flex-1 overflow-y-auto px-6 py-6 sm:px-8">
      <section class="mb-6 flex flex-col gap-4 lg:flex-row lg:items-end lg:justify-between">
        <div>
          <p class="text-xs font-semibold uppercase tracking-[0.18em] text-red-700">Owner Overview</p>
          <h1 class="mt-2 text-4xl font-semibold tracking-tight text-gray-900">Dashboard Overview</h1>
          <p class="mt-2 max-w-2xl text-sm text-gray-600">
            Welcome back, <span class="font-semibold text-red-800"><%= ownerUser != null && ownerUser.getFullName() != null ? ownerUser.getFullName() : "Owner" %></span>.
            Here’s your live fleet, booking, and earnings summary.
          </p>
        </div>
        <div class="flex flex-wrap gap-3">
          <a href="<%= request.getContextPath() %>/owner/add-vehicle" class="rounded-xl bg-red-800 px-4 py-2.5 text-sm font-semibold text-white shadow-sm transition hover:bg-red-900">+ Add New Vehicle</a>
          <a href="<%= request.getContextPath() %>/owner/myvehicle" class="rounded-xl border border-gray-200 bg-white px-4 py-2.5 text-sm font-semibold text-gray-700 shadow-sm transition hover:bg-gray-100">View Fleet</a>
        </div>
      </section>

      <%
        String successMessage = (String) request.getAttribute("successMessage");
        if (successMessage != null && !successMessage.isBlank()) {
      %>
      <div class="mb-6 rounded-2xl border border-emerald-200 bg-emerald-50 px-4 py-3 text-sm font-medium text-emerald-800">
        <%= successMessage %>
      </div>
      <%
        }
      %>

      <section class="grid grid-cols-1 gap-4 sm:grid-cols-2 xl:grid-cols-4">
        <article class="rounded-3xl border border-blue-100 bg-white p-4 shadow-sm">
          <p class="text-xs font-semibold uppercase tracking-[0.14em] text-blue-700">Total Vehicles</p>
          <p class="mt-3 text-3xl font-semibold text-gray-900">${requestScope.totalVehicles}</p>
          <p class="mt-2 text-sm text-gray-500">All vehicles listed by you</p>
        </article>
        <article class="rounded-3xl border border-emerald-100 bg-white p-4 shadow-sm">
          <p class="text-xs font-semibold uppercase tracking-[0.14em] text-emerald-700">Available Vehicles</p>
          <p class="mt-3 text-3xl font-semibold text-gray-900">${requestScope.availableVehicles}</p>
          <p class="mt-2 text-sm text-gray-500">Ready for booking</p>
        </article>
        <article class="rounded-3xl border border-sky-100 bg-white p-4 shadow-sm">
          <p class="text-xs font-semibold uppercase tracking-[0.14em] text-sky-700">Booked Vehicles</p>
          <p class="mt-3 text-3xl font-semibold text-gray-900">${requestScope.bookedVehicles}</p>
          <p class="mt-2 text-sm text-gray-500">Currently rented</p>
        </article>
        <article class="rounded-3xl border border-violet-100 bg-white p-4 shadow-sm">
          <p class="text-xs font-semibold uppercase tracking-[0.14em] text-violet-700">Total Earnings</p>
          <p class="mt-3 text-3xl font-semibold text-gray-900">Rs. ${requestScope.totalEarnings}</p>
          <p class="mt-2 text-sm text-gray-500">Approved + completed bookings</p>
        </article>
        <article class="rounded-3xl border border-amber-100 bg-white p-4 shadow-sm">
          <p class="text-xs font-semibold uppercase tracking-[0.14em] text-amber-700">Pending Requests</p>
          <p class="mt-3 text-3xl font-semibold text-gray-900">${requestScope.pendingBookings}</p>
          <p class="mt-2 text-sm text-gray-500">Bookings awaiting response</p>
        </article>
        <article class="rounded-3xl border border-rose-100 bg-white p-4 shadow-sm">
          <p class="text-xs font-semibold uppercase tracking-[0.14em] text-rose-700">Approved Bookings</p>
          <p class="mt-3 text-3xl font-semibold text-gray-900">${requestScope.approvedBookings}</p>
          <p class="mt-2 text-sm text-gray-500">Confirmed reservations</p>
        </article>
        <article class="rounded-3xl border border-gray-200 bg-white p-4 shadow-sm sm:col-span-2 xl:col-span-2">
          <p class="text-xs font-semibold uppercase tracking-[0.14em] text-gray-700">Rejected / Cancelled</p>
          <p class="mt-3 text-3xl font-semibold text-gray-900">${requestScope.cancelledRejectedBookings}</p>
          <p class="mt-2 text-sm text-gray-500">Requests you declined or cancelled</p>
        </article>
      </section>

      <section class="mt-6 grid grid-cols-1 gap-6 xl:grid-cols-3">
        <article class="rounded-3xl border border-gray-200 bg-white p-5 shadow-sm xl:col-span-2">
          <div class="mb-4 flex items-center justify-between gap-3">
            <div>
              <h2 class="text-2xl font-semibold text-gray-900">Recent Bookings</h2>
              <p class="mt-1 text-sm text-gray-500">Latest booking requests for your vehicles</p>
            </div>
            <a href="<%= request.getContextPath() %>/owner/bookings" class="text-sm font-semibold text-red-700 hover:text-red-900">View All</a>
          </div>

          <div class="overflow-x-auto rounded-2xl border border-gray-100">
            <table class="min-w-full text-left text-sm">
              <thead class="bg-gray-50 text-xs uppercase tracking-[0.12em] text-gray-500">
              <tr>
                <th class="px-4 py-3 font-semibold">Booking</th>
                <th class="px-4 py-3 font-semibold">Renter</th>
                <th class="px-4 py-3 font-semibold">Vehicle</th>
                <th class="px-4 py-3 font-semibold">Dates</th>
                <th class="px-4 py-3 font-semibold">Amount</th>
                <th class="px-4 py-3 font-semibold">Status</th>
                <th class="px-4 py-3 font-semibold text-right">Action</th>
              </tr>
              </thead>
              <tbody>
              <%
                if (!recentBookings.isEmpty()) {
                  for (Booking booking : recentBookings) {
                    String status = booking.getStatus() == null ? "PENDING" : booking.getStatus().trim().toUpperCase();
              %>
              <tr class="border-t border-gray-100">
                <td class="px-4 py-3 font-semibold text-gray-900">#<%= booking.getBookingId() %></td>
                <td class="px-4 py-3"><%= booking.getRenterName() == null ? "User #" + booking.getUserId() : booking.getRenterName() %></td>
                <td class="px-4 py-3"><%= booking.getVehicleName() == null ? "Vehicle #" + booking.getVehicleId() : booking.getVehicleName() %></td>
                <td class="px-4 py-3 text-gray-600"><%= booking.getStartDate() %> - <%= booking.getEndDate() %></td>
                <td class="px-4 py-3 font-semibold text-gray-900">Rs. <%= String.format(java.util.Locale.US, "%,.2f", booking.getTotalPrice()) %></td>
                <td class="px-4 py-3">
                  <span class="rounded-full px-3 py-1 text-xs font-semibold <%= "APPROVED".equals(status) ? "bg-emerald-100 text-emerald-700" : ("COMPLETED".equals(status) ? "bg-blue-100 text-blue-700" : ("REJECTED".equals(status) || "CANCELLED".equals(status) ? "bg-rose-100 text-rose-700" : "bg-amber-100 text-amber-700")) %>"><%= status %></span>
                </td>
                <td class="px-4 py-3 text-right">
                  <% if ("PENDING".equals(status)) { %>
                  <div class="inline-flex gap-2">
                    <form action="<%= request.getContextPath() %>/booking/approve" method="post">
                      <input type="hidden" name="bookingId" value="<%= booking.getBookingId() %>" />
                      <button class="rounded-lg bg-emerald-600 px-3 py-2 text-xs font-semibold text-white hover:bg-emerald-700">Approve</button>
                    </form>
                    <form action="<%= request.getContextPath() %>/booking/reject" method="post" onsubmit="return confirm('Reject this booking request?');">
                      <input type="hidden" name="bookingId" value="<%= booking.getBookingId() %>" />
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
                <td colspan="7" class="px-4 py-8 text-center text-gray-500">No bookings found for this owner.</td>
              </tr>
              <% } %>
              </tbody>
            </table>
          </div>
        </article>

        <article class="rounded-3xl border border-gray-200 bg-white p-5 shadow-sm">
          <h2 class="text-2xl font-semibold text-gray-900">Fleet Snapshot</h2>
          <p class="mt-1 text-sm text-gray-500">Vehicle status distribution based on live records</p>
          <div class="mt-4 space-y-3">
            <div class="flex items-center justify-between rounded-2xl bg-gray-50 px-4 py-3">
              <span class="text-sm font-medium text-gray-700">Available</span>
              <span class="text-sm font-semibold text-emerald-700">${requestScope.availableVehicles}</span>
            </div>
            <div class="flex items-center justify-between rounded-2xl bg-gray-50 px-4 py-3">
              <span class="text-sm font-medium text-gray-700">Booked</span>
              <span class="text-sm font-semibold text-sky-700">${requestScope.bookedVehicles}</span>
            </div>
            <div class="flex items-center justify-between rounded-2xl bg-gray-50 px-4 py-3">
              <span class="text-sm font-medium text-gray-700">Maintenance</span>
              <span class="text-sm font-semibold text-amber-700">${requestScope.maintenanceVehicles}</span>
            </div>
          </div>
          <div class="mt-5 rounded-3xl bg-red-800 p-4 text-white">
            <p class="text-xs font-semibold uppercase tracking-[0.2em] text-red-100">Quick Action</p>
            <p class="mt-2 text-sm leading-6 text-red-50">Keep your fleet active by adding fresh listings and responding to requests quickly.</p>
            <a href="<%= request.getContextPath() %>/owner/add-vehicle" class="mt-4 inline-block rounded-xl bg-white px-4 py-2 text-sm font-semibold text-red-800 hover:bg-red-50">Add Vehicle</a>
          </div>
        </article>
      </section>

      <section class="mt-6 grid grid-cols-1 gap-6 xl:grid-cols-3">
        <article class="rounded-3xl border border-gray-200 bg-white p-5 shadow-sm">
          <h2 class="text-xl font-semibold text-gray-900">Booking Status</h2>
          <p class="mt-1 text-sm text-gray-500">Live booking status breakdown</p>
          <div class="relative mt-4 h-64 w-full">
            <canvas id="bookingStatusChart"></canvas>
          </div>
        </article>
        <article class="rounded-3xl border border-gray-200 bg-white p-5 shadow-sm">
          <h2 class="text-xl font-semibold text-gray-900">Monthly Earnings</h2>
          <p class="mt-1 text-sm text-gray-500">Approved/completed revenue by month</p>
          <div class="relative mt-4 h-64 w-full">
            <canvas id="monthlyEarningsChart"></canvas>
          </div>
        </article>
        <article class="rounded-3xl border border-gray-200 bg-white p-5 shadow-sm">
          <h2 class="text-xl font-semibold text-gray-900">Vehicle Availability</h2>
          <p class="mt-1 text-sm text-gray-500">Status distribution for your fleet</p>
          <div class="relative mt-4 h-64 w-full">
            <canvas id="vehicleAvailabilityChart"></canvas>
          </div>
        </article>
      </section>
    </main>
  </div>
</div>

<script type="application/json" id="bookingStatusSeries"><%= bookingStatusChartJson %></script>
<script type="application/json" id="monthlyEarningsSeries"><%= monthlyEarningsChartJson %></script>
<script type="application/json" id="vehicleAvailabilitySeries"><%= vehicleAvailabilityChartJson %></script>
<script>
  (function () {
    function readSeries(id) {
      var node = document.getElementById(id);
      if (!node) return [];
      try {
        return JSON.parse(node.textContent || "[]");
      } catch (e) {
        return [];
      }
    }

    var bookingSeries = readSeries("bookingStatusSeries");
    var earningsSeries = readSeries("monthlyEarningsSeries");
    var availabilitySeries = readSeries("vehicleAvailabilitySeries");

    function labels(series) {
      return series.map(function (item) { return item.label; });
    }
    function values(series) {
      return series.map(function (item) { return item.value; });
    }

    if (window.Chart && document.getElementById("bookingStatusChart")) {
      new Chart(document.getElementById("bookingStatusChart"), {
        type: "doughnut",
        data: {
          labels: labels(bookingSeries),
          datasets: [{
            data: values(bookingSeries),
            backgroundColor: ["#f59e0b", "#10b981", "#3b82f6", "#ef4444", "#8b5cf6"],
            borderWidth: 0
          }]
        },
        options: {
          responsive: true,
          maintainAspectRatio: false,
          plugins: { legend: { position: "bottom" } }
        }
      });
    }

    if (window.Chart && document.getElementById("monthlyEarningsChart")) {
      new Chart(document.getElementById("monthlyEarningsChart"), {
        type: "line",
        data: {
          labels: labels(earningsSeries),
          datasets: [{
            label: "Earnings",
            data: values(earningsSeries),
            borderColor: "#b91c1c",
            backgroundColor: "rgba(185, 28, 28, 0.12)",
            fill: true,
            tension: 0.35
          }]
        },
        options: {
          responsive: true,
          maintainAspectRatio: false,
          scales: {
            y: { beginAtZero: true, ticks: { precision: 0 } }
          },
          plugins: { legend: { display: false } }
        }
      });
    }

    if (window.Chart && document.getElementById("vehicleAvailabilityChart")) {
      new Chart(document.getElementById("vehicleAvailabilityChart"), {
        type: "bar",
        data: {
          labels: labels(availabilitySeries),
          datasets: [{
            label: "Vehicles",
            data: values(availabilitySeries),
            backgroundColor: ["#10b981", "#3b82f6", "#f59e0b"]
          }]
        },
        options: {
          responsive: true,
          maintainAspectRatio: false,
          indexAxis: "y",
          scales: {
            x: { beginAtZero: true, ticks: { precision: 0 } },
            y: { ticks: { autoSkip: false } }
          },
          plugins: { legend: { display: false } }
        }
      });
    }
  })();
</script>
</body>
</html>
