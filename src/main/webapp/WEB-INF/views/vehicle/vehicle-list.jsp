<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.riderental.myriderental.model.Vehicle" %>
<%@ page import="java.util.List" %>
<%!
  @SuppressWarnings("unchecked")
  private List<Vehicle> vehicleList(Object value) {
    return value == null ? java.util.Collections.emptyList() : (List<Vehicle>) value;
  }
%>
<%
    List<Vehicle> vehicles = vehicleList(request.getAttribute("vehicles"));
    String keyword = (String) request.getAttribute("keyword");
    String type = (String) request.getAttribute("type");
    String errorMessage = (String) request.getAttribute("errorMessage");
    if (vehicles == null) {
        vehicles = java.util.Collections.emptyList();
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Vehicle Listings | SajhaRide</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-neutral-100 text-slate-900">
<%@ include file="/WEB-INF/views/landing/components/topbar.jsp" %>

<main class="mx-auto min-h-screen max-w-[1280px] px-4 py-8 sm:px-6 lg:px-8">
    <section class="mb-6 rounded-3xl bg-white p-6 shadow-sm ring-1 ring-slate-200">
        <div class="flex flex-col gap-4 lg:flex-row lg:items-end lg:justify-between">
            <div>
                <p class="text-xs font-semibold uppercase tracking-[0.18em] text-red-800">Browse vehicles</p>
                <h1 class="mt-2 text-3xl font-semibold text-slate-900">Available rides</h1>
                <p class="mt-2 text-sm text-slate-600">Click any vehicle card to open its full details page.</p>
            </div>
            <form action="<%= request.getContextPath() %>/vehicles/list" method="get" class="grid gap-3 sm:grid-cols-3 lg:w-[760px]">
                <label for="vehicleKeyword" class="sr-only">Search vehicles</label>
                <input id="vehicleKeyword" type="text" name="keyword" value="<%= keyword == null ? "" : keyword %>" placeholder="Search by name, location, or description"
                       class="h-11 rounded-xl border border-slate-200 bg-slate-50 px-4 text-sm outline-none focus:border-red-800" />
                <label for="vehicleType" class="sr-only">Vehicle type</label>
                <select id="vehicleType" name="type" class="h-11 rounded-xl border border-slate-200 bg-slate-50 px-4 text-sm outline-none focus:border-red-800">
                    <option value="">All Types</option>
                    <option value="CAR" <%= "CAR".equalsIgnoreCase(type) ? "selected" : "" %>>Car</option>
                    <option value="BIKE" <%= "BIKE".equalsIgnoreCase(type) ? "selected" : "" %>>Bike</option>
                    <option value="SCOOTER" <%= "SCOOTER".equalsIgnoreCase(type) ? "selected" : "" %>>Scooter</option>
                    <option value="VAN" <%= "VAN".equalsIgnoreCase(type) ? "selected" : "" %>>Van</option>
                    <option value="TRUCK" <%= "TRUCK".equalsIgnoreCase(type) ? "selected" : "" %>>Truck</option>
                </select>
                <button type="submit" class="h-11 rounded-xl bg-red-800 px-5 text-sm font-semibold text-white transition hover:bg-red-900">Search</button>
            </form>
        </div>
        <% if (errorMessage != null && !errorMessage.isBlank()) { %>
        <div class="mt-4 rounded-xl border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-800"><%= errorMessage %></div>
        <% } %>
    </section>

    <% if (vehicles.isEmpty()) { %>
    <section class="rounded-3xl bg-white p-8 text-center shadow-sm ring-1 ring-slate-200">
        <h2 class="text-2xl font-semibold text-slate-900">No vehicles found</h2>
        <p class="mt-2 text-sm text-slate-600">Try a different search term or come back later for fresh listings.</p>
    </section>
    <% } else { %>
    <section class="grid gap-5 sm:grid-cols-2 xl:grid-cols-4">
        <% for (Vehicle vehicle : vehicles) {
            String image = (vehicle.getImagePath() == null || vehicle.getImagePath().isBlank()) ? "images/about.png" : vehicle.getImagePath();
        %>
        <a href="<%= request.getContextPath() %>/vehicle-details?id=<%= vehicle.getVehicleId() %>"
           class="group overflow-hidden rounded-3xl bg-white shadow-sm ring-1 ring-slate-200 transition hover:-translate-y-0.5 hover:shadow-lg">
            <div class="relative h-48 overflow-hidden bg-slate-100">
                <img src="<%= request.getContextPath() %>/<%= image %>" alt="<%= vehicle.getVehicleName() %>"
                     class="h-full w-full object-cover transition duration-300 group-hover:scale-105" />
                <span class="absolute right-3 top-3 rounded-full px-3 py-1 text-[10px] font-bold uppercase tracking-wide <%= "AVAILABLE".equalsIgnoreCase(vehicle.getAvailabilityStatus()) ? "bg-emerald-100 text-emerald-700" : "bg-amber-100 text-amber-700" %>">
                    <%= vehicle.getAvailabilityStatus() == null ? "UNKNOWN" : vehicle.getAvailabilityStatus() %>
                </span>
            </div>
            <div class="p-4">
                <h2 class="text-xl font-semibold text-slate-900"><%= vehicle.getVehicleName() %></h2>
                <p class="mt-1 text-sm text-slate-500"><%= vehicle.getVehicleType() %> • <%= vehicle.getLocation() %></p>
                <p class="mt-3 text-sm leading-6 text-slate-600 line-clamp-2"><%= vehicle.getDescription() == null ? "" : vehicle.getDescription() %></p>
                <div class="mt-4 flex items-center justify-between border-t border-slate-100 pt-3">
                    <p class="text-lg font-semibold text-red-800">Rs. <%= String.format(java.util.Locale.US, "%,.2f", vehicle.getPricePerDay()) %>/day</p>
                    <span class="text-sm font-semibold text-[#154e75]">View Details</span>
                </div>
            </div>
        </a>
        <% } %>
    </section>
    <% } %>
</main>
</body>
</html>



