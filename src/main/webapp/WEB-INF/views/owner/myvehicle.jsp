<%-- Created by IntelliJ IDEA. User: kusha Date: 4/16/2026 Time: 10:14 AM To
change this template use File | Settings | File Templates. --%> <%@ page
contentType="text/html;charset=UTF-8" language="java" import="com.riderental.myriderental.model.Vehicle,java.util.List" %>
<%
  List<Vehicle> vehicles = (List<Vehicle>) request.getAttribute("vehicles");
  if (vehicles == null) {
    vehicles = java.util.Collections.emptyList();
  }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>SajhaRide - My Vehicles</title>
  <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="h-screen overflow-hidden bg-gray-100 text-gray-900">
<div class="flex h-full">
  <jsp:include page="components/sidebar.jsp" />

  <div class="flex min-w-0 flex-1 flex-col overflow-hidden">
    <jsp:include page="components/topbar.jsp" />

    <main class="flex-1 overflow-y-auto px-6 py-6 sm:px-8">
      <section class="mb-6 flex flex-col gap-4 lg:flex-row lg:items-start lg:justify-between">
        <div class="min-w-0 flex-1">
          <p class="text-xs font-semibold uppercase tracking-[0.18em] text-red-700">Fleet Management</p>
          <h1 class="mt-2 text-3xl font-semibold tracking-tight text-gray-900">Manage Your Listed Fleet</h1>
          <p class="mt-2 max-w-2xl text-sm text-gray-600">Oversee your vehicle listings, update availability status, and track booking performance across Nepal.</p>
        </div>
        <div>
          <a href="<%= request.getContextPath() %>/owner/add-vehicle" class="inline-flex items-center gap-2 rounded-xl bg-red-800 px-5 py-3 text-sm font-semibold text-white shadow-lg shadow-red-200 transition hover:bg-red-900">
            <svg class="h-4 w-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true"><path d="M12 5v14"></path><path d="M5 12h14"></path></svg>
            Add New Vehicle
          </a>
        </div>
      </section>

      <section class="mb-6 grid grid-cols-1 gap-4 sm:grid-cols-2 xl:grid-cols-4">
        <article class="rounded-2xl border border-blue-100 bg-white p-5 shadow-sm">
          <p class="text-xs font-semibold text-blue-700">Total Fleet</p>
          <p class="mt-3 text-3xl font-semibold text-gray-900">${requestScope.totalVehicles} <span class="text-xl font-semibold text-gray-700">Units</span></p>
        </article>
        <article class="rounded-2xl border border-emerald-100 bg-white p-5 shadow-sm">
          <p class="text-xs font-semibold text-emerald-700">Available Now</p>
          <p class="mt-3 text-3xl font-semibold text-gray-900">${requestScope.availableVehicles} <span class="text-xl font-semibold text-gray-700">Units</span></p>
        </article>
        <article class="rounded-2xl border border-sky-100 bg-white p-5 shadow-sm">
          <p class="text-xs font-semibold text-sky-700">Booked / Rented</p>
          <p class="mt-3 text-3xl font-semibold text-gray-900">${requestScope.bookedVehicles} <span class="text-xl font-semibold text-gray-700">Units</span></p>
        </article>
        <article class="rounded-2xl border border-amber-100 bg-white p-5 shadow-sm">
          <p class="text-xs font-semibold text-amber-700">Maintenance</p>
          <p class="mt-3 text-3xl font-semibold text-gray-900">${requestScope.maintenanceVehicles} <span class="text-xl font-semibold text-gray-700">Units</span></p>
        </article>
      </section>

      <section class="grid grid-cols-1 gap-5 md:grid-cols-2 2xl:grid-cols-3">
        <%
          if (!vehicles.isEmpty()) {
            for (Vehicle v : vehicles) {
              String status = v.getAvailabilityStatus() == null ? "AVAILABLE" : v.getAvailabilityStatus().trim().toUpperCase();
              String img = (v.getImagePath() == null || v.getImagePath().isBlank()) ? (request.getContextPath() + "/images/about.png") : (request.getContextPath() + "/" + v.getImagePath().replace("\\", "/"));
              String type = v.getVehicleType() == null ? "-" : v.getVehicleType();
        %>
        <article class="overflow-hidden rounded-2xl border border-gray-200 bg-white shadow-sm transition hover:shadow-md">
          <div class="relative">
            <img src="<%= img %>" alt="<%= v.getVehicleName() %>" class="h-52 w-full object-cover" />
            <span class="absolute left-3 top-3 inline-flex items-center rounded-full px-3 py-1 text-[11px] font-bold uppercase tracking-wide text-white <%= "AVAILABLE".equals(status) ? "bg-emerald-700" : ("RENTED".equals(status) ? "bg-sky-600" : "bg-amber-600") %>"><%= status %></span>
          </div>
          <div class="p-4">
            <div class="flex items-start justify-between gap-4">
              <div>
                <h2 class="text-xl font-semibold leading-tight text-gray-900"><%= v.getVehicleName() %></h2>
                <p class="mt-1 text-sm text-gray-600"><%= type %> • <%= v.getLocation() == null ? "" : v.getLocation() %></p>
              </div>
              <p class="text-right text-xl font-semibold text-red-800">NPR <%= String.format(java.util.Locale.US, "%,.2f", v.getPricePerDay()) %><br /><span class="text-xs font-medium uppercase tracking-wide text-gray-500">per day</span></p>
            </div>
            <div class="mt-3 text-sm text-gray-600"><%= v.getDescription() == null ? "No description provided." : v.getDescription() %></div>
            <div class="mt-4 flex items-center gap-2 border-t border-gray-100 pt-4">
              <a href="<%= request.getContextPath() %>/owner/vehicle/update?vehicleId=<%= v.getVehicleId() %>" class="flex-1 rounded-lg border border-gray-300 bg-gray-50 px-4 py-2 text-sm font-semibold text-gray-700 transition hover:bg-gray-100">Edit</a>
              <a href="<%= request.getContextPath() %>/owner/bookings" class="flex-1 rounded-lg border border-blue-300 bg-blue-50 px-4 py-2 text-sm font-semibold text-blue-700 transition hover:bg-blue-100">View Bookings</a>
              <form action="<%= request.getContextPath() %>/owner/vehicle/delete" method="post" onsubmit="return confirm('Delete this vehicle?');">
                <input type="hidden" name="vehicleId" value="<%= v.getVehicleId() %>" />
                <button class="rounded-lg border border-red-200 bg-red-50 px-3 py-2 text-sm font-semibold text-red-700 transition hover:bg-red-100" type="submit" aria-label="Delete vehicle">
                  <svg class="h-4 w-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true"><path d="M3 6h18"></path><path d="M8 6V4h8v2"></path><path d="M10 11v6"></path><path d="M14 11v6"></path><path d="M5 6l1 14h12l1-14"></path></svg>
                </button>
              </form>
            </div>
          </div>
        </article>
        <%
            }
          } else {
        %>
        <div class="col-span-full rounded-2xl border border-dashed border-gray-300 bg-white p-8 text-center text-gray-500">
          No vehicles found. Start by adding your first vehicle listing.
        </div>
        <% } %>
      </section>
    </main>
  </div>
</div>
</body>
</html>
