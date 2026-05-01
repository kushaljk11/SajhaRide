<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.riderental.myriderental.model.Vehicle" %>
<%
  Vehicle vehicle = (Vehicle) request.getAttribute("vehicle");
  String errorMessage = (String) request.getAttribute("errorMessage");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title><%= vehicle != null ? vehicle.getVehicleName() : "Vehicle Details" %> | SajhaRide</title>
  <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-neutral-100 text-slate-900">
<%@ include file="/WEB-INF/views/landing/components/topbar.jsp" %>
<main class="mx-auto min-h-screen max-w-[1280px] px-4 py-8 sm:px-6 lg:px-8">
  <% if (vehicle == null) { %>
  <section class="rounded-3xl bg-white p-8 shadow-sm ring-1 ring-slate-200">
    <p class="text-xs font-semibold uppercase tracking-[0.18em] text-red-800">Vehicle details</p>
    <h1 class="mt-2 text-3xl font-semibold text-slate-900"><%= errorMessage == null ? "Not found" : errorMessage %></h1>
    <p class="mt-3 text-sm leading-6 text-slate-600">The vehicle you selected could not be loaded.</p>
    <a href="<%= request.getContextPath() %>/vehicles/list" class="mt-6 inline-flex rounded-xl bg-red-800 px-5 py-3 text-sm font-semibold text-white transition hover:bg-red-900">Back to listings</a>
  </section>
  <% } else { String image = (vehicle.getImagePath() == null || vehicle.getImagePath().isBlank()) ? "images/about.png" : vehicle.getImagePath(); String ownerImage = (vehicle.getOwnerProfileImagePath() == null || vehicle.getOwnerProfileImagePath().isBlank()) ? null : vehicle.getOwnerProfileImagePath(); %>
  <section class="grid gap-6 lg:grid-cols-[1.3fr_0.9fr]">
    <article class="overflow-hidden rounded-3xl bg-white shadow-sm ring-1 ring-slate-200">
      <div class="h-80 overflow-hidden bg-slate-100"><img src="<%= request.getContextPath() %>/<%= image %>" alt="<%= vehicle.getVehicleName() %>" class="h-full w-full object-cover" /></div>
      <div class="p-6 sm:p-8">
        <div class="flex flex-wrap items-start justify-between gap-4">
          <div><p class="text-xs font-semibold uppercase tracking-[0.18em] text-red-800">Vehicle details</p><h1 class="mt-2 text-3xl font-semibold text-slate-900"><%= vehicle.getVehicleName() %></h1><p class="mt-2 text-sm text-slate-500"><%= vehicle.getVehicleType() %> • <%= vehicle.getLocation() %></p></div>
          <div class="rounded-2xl bg-red-50 px-4 py-3 text-right ring-1 ring-red-100"><p class="text-xs font-semibold uppercase tracking-wide text-red-700">Price per day</p><p class="mt-1 text-2xl font-bold text-red-900">Rs. <%= String.format(java.util.Locale.US, "%,.2f", vehicle.getPricePerDay()) %></p></div>
        </div>
        <div class="mt-6 grid gap-4 sm:grid-cols-2"><div class="rounded-2xl bg-slate-50 p-4 ring-1 ring-slate-200"><p class="text-xs font-semibold uppercase tracking-wide text-slate-500">Status</p><p class="mt-1 text-lg font-semibold text-slate-900"><%= vehicle.getAvailabilityStatus() %></p></div><div class="rounded-2xl bg-slate-50 p-4 ring-1 ring-slate-200"><p class="text-xs font-semibold uppercase tracking-wide text-slate-500">Vehicle ID</p><p class="mt-1 text-lg font-semibold text-slate-900">#<%= vehicle.getVehicleId() %></p></div></div>
        <div class="mt-6"><h2 class="text-lg font-semibold text-slate-900">Description</h2><p class="mt-2 text-sm leading-7 text-slate-600"><%= vehicle.getDescription() == null ? "No description provided." : vehicle.getDescription() %></p></div>
      </div>
    </article>
    <aside class="space-y-6">
      <section class="rounded-3xl bg-white p-6 shadow-sm ring-1 ring-slate-200">
        <h2 class="text-xl font-semibold text-slate-900">Owner information</h2>
        <div class="mt-5 flex items-center gap-4"><div class="flex h-14 w-14 items-center justify-center overflow-hidden rounded-full bg-red-100 text-lg font-bold text-red-800 ring-4 ring-red-50"><% if (ownerImage != null) { %><img src="<%= request.getContextPath() %>/<%= ownerImage %>" alt="Owner photo" class="h-full w-full object-cover" /><% } else { %><%= vehicle.getOwnerName() == null || vehicle.getOwnerName().isBlank() ? "O" : vehicle.getOwnerName().substring(0,1).toUpperCase() %><% } %></div><div><h3 class="text-lg font-semibold text-slate-900"><%= vehicle.getOwnerName() == null ? "-" : vehicle.getOwnerName() %></h3><p class="text-sm text-slate-500"><%= vehicle.getOwnerEmail() == null ? "-" : vehicle.getOwnerEmail() %></p></div></div>
        <dl class="mt-5 space-y-3 text-sm"><div class="flex items-start justify-between gap-4 border-b border-slate-100 pb-3"><dt class="text-slate-500">Phone</dt><dd class="font-medium text-slate-900"><%= vehicle.getOwnerPhoneNumber() == null ? "-" : vehicle.getOwnerPhoneNumber() %></dd></div><div class="flex items-start justify-between gap-4 border-b border-slate-100 pb-3"><dt class="text-slate-500">Address</dt><dd class="text-right font-medium text-slate-900"><%= vehicle.getOwnerAddress() == null ? "-" : vehicle.getOwnerAddress() %></dd></div><div class="flex items-start justify-between gap-4"><dt class="text-slate-500">Location</dt><dd class="font-medium text-slate-900"><%= vehicle.getLocation() == null ? "-" : vehicle.getLocation() %></dd></div></dl>
      </section>
      <section class="rounded-3xl bg-white p-6 shadow-sm ring-1 ring-slate-200"><h2 class="text-xl font-semibold text-slate-900">Actions</h2><p class="mt-2 text-sm leading-6 text-slate-600">Book this vehicle or return to the listing.</p><div class="mt-5 flex flex-col gap-3"><a href="<%= request.getContextPath() %>/booking/request?vehicleId=<%= vehicle.getVehicleId() %>" class="inline-flex items-center justify-center rounded-xl bg-red-800 px-5 py-3 text-sm font-semibold text-white transition hover:bg-red-900">Book Now</a><a href="<%= request.getContextPath() %>/vehicles/list" class="inline-flex items-center justify-center rounded-xl border border-slate-300 bg-white px-5 py-3 text-sm font-semibold text-slate-700 transition hover:bg-slate-50">Back to Listings</a></div></section>
    </aside>
  </section>
  <% } %>
</main>
</body>
</html>
