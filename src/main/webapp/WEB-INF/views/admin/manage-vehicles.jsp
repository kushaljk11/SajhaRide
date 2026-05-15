<%@ page contentType="text/html;charset=UTF-8" language="java" import="jakarta.servlet.http.HttpServletRequest" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>SajhaRide - Vehicle Management</title>
  <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="h-screen overflow-hidden bg-gray-50 text-gray-900">
<% if ("created".equalsIgnoreCase(request.getParameter("success"))) { %>
<div id="vehicleSuccessToast" class="fixed right-6 top-6 z-50 flex max-w-sm items-start gap-3 rounded-xl border border-emerald-200 bg-white px-4 py-3 text-sm text-gray-800 shadow-lg">
  <div class="mt-0.5 flex h-6 w-6 shrink-0 items-center justify-center rounded-full bg-emerald-100 text-emerald-700">
    <svg class="h-4 w-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true"><path d="M20 6 9 17l-5-5"></path></svg>
  </div>
  <div>
    <p class="font-semibold text-gray-900">Vehicle added successfully</p>
    <p class="mt-0.5 text-xs text-gray-500">The new listing has been added to inventory.</p>
  </div>
  <button type="button" class="ml-2 text-gray-400 transition hover:text-gray-700" aria-label="Dismiss notification" onclick="document.getElementById('vehicleSuccessToast').remove()">
    <svg class="h-4 w-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true"><path d="M18 6 6 18"></path><path d="m6 6 12 12"></path></svg>
  </button>
</div>
<script>
  window.setTimeout(function () {
    var toast = document.getElementById('vehicleSuccessToast');
    if (toast) toast.remove();
  }, 4000);
</script>
<% } %>
<div class="flex h-full">
  <jsp:include page="components/sidebar.jsp" />

  <%-- context path helper for scriptlets --%>
  <%
    String ctx = ((HttpServletRequest) request).getContextPath();
    String keyword = (String) request.getAttribute("keyword");
    String type = (String) request.getAttribute("type");
    String status = (String) request.getAttribute("status");
    if (keyword == null) keyword = "";
    if (type == null) type = "";
    if (status == null) status = "";
  %>

  <div class="flex min-w-0 flex-1 flex-col overflow-hidden">
    <jsp:include page="components/topbar.jsp" />

    <main class="flex-1 overflow-y-auto px-6 py-6 sm:px-8">
      <section class="mb-6 flex flex-col gap-4 lg:flex-row lg:items-center lg:justify-between">
        <div>
          <p class="text-xs font-semibold uppercase tracking-[0.18em] text-red-700">Management</p>
          <h1 class="mt-2 text-4xl font-semibold tracking-tight text-gray-900">Vehicle Inventory</h1>
          <p class="mt-2 text-sm text-gray-600">Audit and regulate listings across the platform.</p>
        </div>
        <div class="flex flex-wrap gap-3">
          <a href="<%= ctx + "/admin/vehicles/export-csv" %>" class="rounded-xl border border-gray-200 bg-white px-5 py-3 text-sm font-semibold text-gray-700 shadow-sm transition hover:bg-gray-100">Export CSV</a>
          <a href="<%= ctx + "/admin/vehicles/create" %>" class="rounded-xl bg-red-800 px-5 py-3 text-sm font-semibold text-white shadow-sm transition hover:bg-red-900">+ New Listing</a>
        </div>
      </section>

      <section class="grid grid-cols-1 gap-4 sm:grid-cols-2 xl:grid-cols-4">
        <article class="rounded-3xl bg-white p-4 shadow-sm ring-1 ring-gray-200">
          <p class="text-xs font-semibold uppercase tracking-[0.14em] text-emerald-700">Active Posts</p>
          <p class="mt-3 text-3xl font-semibold text-gray-900"><%= request.getAttribute("activePosts") != null ? request.getAttribute("activePosts") : "0" %></p>
          <p class="mt-2 text-sm text-emerald-700">AVAILABLE vehicles</p>
        </article>
        <article class="rounded-3xl bg-white p-4 shadow-sm ring-1 ring-gray-200">
          <p class="text-xs font-semibold uppercase tracking-[0.14em] text-amber-700">Awaiting Approval</p>
          <p class="mt-3 text-3xl font-semibold text-gray-900"><%= request.getAttribute("awaitingApproval") != null ? request.getAttribute("awaitingApproval") : "0" %></p>
          <p class="mt-2 text-sm text-amber-700">PENDING vehicles</p>
        </article>
        <article class="rounded-3xl bg-white p-4 shadow-sm ring-1 ring-gray-200">
          <p class="text-xs font-semibold uppercase tracking-[0.14em] text-rose-700">Blocked Listings</p>
          <p class="mt-3 text-3xl font-semibold text-gray-900"><%= request.getAttribute("blockedListings") != null ? request.getAttribute("blockedListings") : "0" %></p>
          <p class="mt-2 text-sm text-rose-700">BLOCKED/MAINTENANCE</p>
        </article>
        <article class="rounded-3xl bg-white p-4 shadow-sm ring-1 ring-gray-200">
          <p class="text-xs font-semibold uppercase tracking-[0.14em] text-slate-700">Total Booking Value</p>
          <p class="mt-3 text-3xl font-semibold text-gray-900">Rs. <%= String.format("%.0f", request.getAttribute("totalBookingValue") != null ? (Double) request.getAttribute("totalBookingValue") : 0) %></p>
          <p class="mt-2 text-sm text-gray-500">Total revenue</p>
        </article>
      </section>

      <section class="mt-6 rounded-3xl border border-gray-200 bg-white p-5 shadow-sm">
        <form action="<%= ctx %>/admin/vehicles" method="get" class="mb-5 flex flex-col gap-4 lg:flex-row lg:items-center lg:justify-between">
          <div class="flex flex-wrap gap-2 text-sm">
            <button type="submit" name="status" value="" class="rounded-full px-4 py-2 font-semibold <%= status.isBlank() ? "bg-red-800 text-white" : "bg-gray-100 text-gray-600" %>">All Posts</button>
            <button type="submit" name="status" value="AVAILABLE" class="rounded-full px-4 py-2 font-semibold <%= "AVAILABLE".equalsIgnoreCase(status) ? "bg-red-800 text-white" : "bg-gray-100 text-gray-600" %>">Active</button>
            <button type="submit" name="status" value="PENDING" class="rounded-full px-4 py-2 font-semibold <%= "PENDING".equalsIgnoreCase(status) ? "bg-red-800 text-white" : "bg-gray-100 text-gray-600" %>">Pending</button>
            <button type="submit" name="status" value="BLOCKED" class="rounded-full px-4 py-2 font-semibold <%= "BLOCKED".equalsIgnoreCase(status) ? "bg-red-800 text-white" : "bg-gray-100 text-gray-600" %>">Blocked</button>
            <button type="submit" name="status" value="DELETED" class="rounded-full px-4 py-2 font-semibold <%= "DELETED".equalsIgnoreCase(status) ? "bg-red-800 text-white" : "bg-gray-100 text-gray-600" %>">Deleted</button>
          </div>
          <div class="flex flex-wrap items-center gap-3">
            <input type="text" name="keyword" value="<%= keyword %>" placeholder="Search vehicles" class="rounded-xl border border-gray-200 bg-white px-4 py-3 text-gray-700 outline-none focus:border-red-300 focus:ring-2 focus:ring-red-100" />
            <select name="type" class="rounded-xl border border-gray-200 bg-white px-4 py-3 text-gray-700 outline-none focus:border-red-300 focus:ring-2 focus:ring-red-100">
              <option value="">All Vehicle Types</option>
              <option value="CAR" <%= "CAR".equalsIgnoreCase(type) ? "selected" : "" %>>Car</option>
              <option value="BIKE" <%= "BIKE".equalsIgnoreCase(type) ? "selected" : "" %>>Bike</option>
              <option value="SCOOTER" <%= "SCOOTER".equalsIgnoreCase(type) ? "selected" : "" %>>Scooter</option>
              <option value="VAN" <%= "VAN".equalsIgnoreCase(type) ? "selected" : "" %>>Van</option>
              <option value="TRUCK" <%= "TRUCK".equalsIgnoreCase(type) ? "selected" : "" %>>Truck</option>
            </select>
            <input type="hidden" name="status" value="<%= status %>" />
            <button type="submit" class="rounded-xl border border-gray-200 bg-white px-4 py-3 text-gray-700 transition hover:bg-gray-50">Filter</button>
            <a href="<%= ctx %>/admin/vehicles" class="rounded-xl border border-gray-200 bg-gray-50 px-4 py-3 text-gray-600 transition hover:bg-gray-100">Reset</a>
          </div>
        </form>

        <div class="overflow-x-auto">
          <table class="min-w-full text-left text-sm">
            <thead>
            <tr class="border-b border-gray-200 text-xs uppercase tracking-[0.12em] text-gray-500">
              <th class="px-3 py-3 font-semibold">Vehicle Details</th>
              <th class="px-3 py-3 font-semibold">Owner</th>
              <th class="px-3 py-3 font-semibold">Vehicle Type</th>
              <th class="px-3 py-3 font-semibold">Pricing</th>
              <th class="px-3 py-3 font-semibold">Status</th>
              <th class="px-3 py-3 font-semibold text-right">Actions</th>
            </tr>
            </thead>
            <tbody>
            <%
              java.util.List<com.riderental.myriderental.model.Vehicle> vehicles = (java.util.List<com.riderental.myriderental.model.Vehicle>) request.getAttribute("vehicles");
              if (vehicles != null) {
                for (com.riderental.myriderental.model.Vehicle v : vehicles) {
            %>
            <tr class="border-b border-gray-100">
              <td class="px-3 py-4">
                <div class="flex items-center gap-3">
                  <img src="<%= v.getImagePath() == null || v.getImagePath().isBlank() ? (ctx + "/images/about.png") : v.getImagePath() %>" alt="<%= v.getVehicleName() %>" class="h-12 w-16 rounded-lg object-cover" />
                  <div>
                    <p class="font-semibold text-gray-900"><%= v.getVehicleName() %></p>
                    <p class="text-xs text-gray-500"><%= v.getLocation() == null ? "" : v.getLocation() %></p>
                  </div>
                </div>
              </td>
              <td class="px-3 py-4">
                <p class="font-semibold text-gray-900"><%= v.getOwnerId() %></p>
                <p class="text-xs text-gray-500">Owner ID</p>
              </td>
              <td class="px-3 py-4"><span class="rounded-full bg-blue-100 px-3 py-1 text-xs font-semibold text-blue-700"><%= v.getVehicleType() == null ? "-" : v.getVehicleType() %></span></td>
              <td class="px-3 py-4 font-semibold text-gray-900">Rs. <%= v.getPricePerDay() %> <span class="text-xs font-normal text-gray-500">/day</span></td>
              <td class="px-3 py-4"><span class="rounded-full bg-emerald-100 px-3 py-1 text-xs font-semibold text-emerald-700"><%= v.getAvailabilityStatus() == null ? "Unknown" : v.getAvailabilityStatus() %></span></td>
              <td class="px-3 py-4 text-right">
                <div class="inline-flex gap-2">
                  <a href="<%= ctx + "/admin/vehicles/view?id=" + v.getVehicleId() %>" class="rounded-lg border border-gray-200 px-3 py-2 text-xs font-semibold text-gray-700 hover:bg-gray-50">View</a>
                  <a href="<%= ctx + "/admin/vehicles/edit?id=" + v.getVehicleId() %>" class="rounded-lg border border-gray-200 px-3 py-2 text-xs font-semibold text-gray-700 hover:bg-gray-50">Edit</a>
                </div>
              </td>
            </tr>
            <%    }
              } else {
            %>
            <tr><td colspan="6" class="px-3 py-4 text-center text-gray-500">No vehicles found.</td></tr>
            <% } %>
            </tbody>
          </table>
        </div>

        <div class="mt-4 flex flex-col gap-4 border-t border-gray-100 pt-4 text-sm text-gray-500 md:flex-row md:items-center md:justify-between">
          <p>Showing <%= request.getAttribute("filteredVehicleCount") != null ? request.getAttribute("filteredVehicleCount") : "0" %> of <%= request.getAttribute("totalVehicles") != null ? request.getAttribute("totalVehicles") : "0" %> vehicles</p>
          <div class="flex items-center gap-2">
            <button class="rounded-lg border border-gray-200 bg-gray-50 px-3 py-2 text-gray-400">&lt;</button>
            <button class="rounded-lg bg-red-800 px-3 py-2 font-semibold text-white">1</button>
            <button class="rounded-lg border border-gray-200 px-3 py-2 text-gray-700 hover:bg-gray-50">2</button>
            <button class="rounded-lg border border-gray-200 px-3 py-2 text-gray-700 hover:bg-gray-50">3</button>
            <button class="rounded-lg border border-gray-200 px-3 py-2 text-gray-700 hover:bg-gray-50">...</button>
            <button class="rounded-lg border border-gray-200 px-3 py-2 text-gray-700 hover:bg-gray-50">135</button>
            <button class="rounded-lg border border-gray-200 bg-gray-50 px-3 py-2 text-gray-400">&gt;</button>
          </div>
        </div>
      </section>

      <section class="mt-6 grid grid-cols-1 gap-6 xl:grid-cols-[1.3fr_0.7fr]">
        <article class="rounded-3xl bg-red-800 p-6 text-white shadow-sm">
          <h2 class="text-3xl font-semibold">Automated Fraud Detection</h2>
          <p class="mt-3 max-w-2xl text-sm leading-6 text-red-50">Our new monitoring algorithm is currently tracking suspicious listings. Automated blocking will trigger if identity verification fails within 48 hours.</p>
          <button class="mt-6 rounded-xl bg-white px-5 py-3 text-sm font-semibold text-red-800 transition hover:bg-red-50">Review Flags</button>
        </article>

        <article class="rounded-3xl border border-gray-200 bg-white p-6 shadow-sm">
          <p class="text-xs font-semibold uppercase tracking-[0.2em] text-gray-400">Popular Demand</p>
          <h2 class="mt-2 text-2xl font-semibold text-gray-900">SUV Season is Here</h2>
          <ul class="mt-5 space-y-3 text-sm text-gray-600">
            <li class="flex gap-2"><span class="mt-1 h-2 w-2 rounded-full bg-red-500"></span> Search for 4WD up by 45%</li>
            <li class="flex gap-2"><span class="mt-1 h-2 w-2 rounded-full bg-red-500"></span> Kathmandu-Pokhara routes peak</li>
            <li class="flex gap-2"><span class="mt-1 h-2 w-2 rounded-full bg-red-500"></span> Avg. rental price: Rs. 5.5k</li>
          </ul>
        </article>
      </section>
    </main>
  </div>
</div>
</body>
</html>

