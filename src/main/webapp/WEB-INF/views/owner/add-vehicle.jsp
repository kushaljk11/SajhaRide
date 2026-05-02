<%@ page contentType="text/html;charset=UTF-8" language="java" import="com.riderental.myriderental.model.Vehicle,jakarta.servlet.http.HttpServletRequest" %>
<%
  Vehicle vehicle = (Vehicle) request.getAttribute("vehicle");
  String pageHeading = (String) request.getAttribute("pageHeading");
  String submitLabel = (String) request.getAttribute("submitLabel");
  String formAction = (String) request.getAttribute("formAction");
  if (pageHeading == null) pageHeading = "List Your Vehicle";
  if (submitLabel == null) submitLabel = "List My Vehicle";
  if (formAction == null) formAction = request.getContextPath() + "/owner/add-vehicle";
  String vehicleName = vehicle != null && vehicle.getVehicleName() != null ? vehicle.getVehicleName() : "";
  String vehicleType = vehicle != null && vehicle.getVehicleType() != null ? vehicle.getVehicleType() : "CAR";
  String pricePerDay = vehicle != null ? String.valueOf(vehicle.getPricePerDay()) : "";
  String location = vehicle != null && vehicle.getLocation() != null ? vehicle.getLocation() : "";
  String description = vehicle != null && vehicle.getDescription() != null ? vehicle.getDescription() : "";
  String availabilityStatus = vehicle != null && vehicle.getAvailabilityStatus() != null ? vehicle.getAvailabilityStatus() : "AVAILABLE";
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>SajhaRide - <%= pageHeading %></title>
  <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="h-screen overflow-hidden bg-gray-100 text-gray-900">
<div class="flex h-full">
  <jsp:include page="components/sidebar.jsp" />

  <div class="flex min-w-0 flex-1 flex-col overflow-hidden">
    <jsp:include page="components/topbar.jsp" />

    <main class="flex-1 overflow-y-auto px-6 py-6 sm:px-8">
      <section class="mb-6">
        <h1 class="text-3xl font-semibold tracking-tight text-gray-900"><%= pageHeading %></h1>
        <p class="mt-2 max-w-2xl text-sm leading-6 text-gray-600">Add or update a vehicle listing using real owner account data.</p>
      </section>

      <%
        String errorMessage = (String) request.getAttribute("errorMessage");
        if (errorMessage != null && !errorMessage.isBlank()) {
      %>
      <div class="mb-6 rounded-2xl border border-rose-200 bg-rose-50 px-4 py-3 text-sm font-medium text-rose-800">
        <%= errorMessage %>
      </div>
      <%
        }
      %>

      <section class="grid grid-cols-1 gap-6 xl:grid-cols-5">
        <div class="space-y-6 xl:col-span-3">
          <article class="rounded-2xl border border-red-100 bg-white p-5 shadow-sm">
            <div class="mb-4 flex items-center gap-2">
              <span class="inline-flex h-5 w-5 items-center justify-center rounded-full border border-red-200 bg-red-50 text-red-800">
                <svg class="h-3.5 w-3.5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
                  <circle cx="12" cy="12" r="9"></circle>
                  <path d="M12 8v5"></path>
                  <path d="M12 16h.01"></path>
                </svg>
              </span>
              <h2 class="text-2xl font-semibold text-gray-900">Vehicle Information</h2>
            </div>

            <form class="space-y-4" action="<%= formAction %>" method="post" enctype="multipart/form-data">
              <%
                if (vehicle != null) {
              %>
              <input type="hidden" name="vehicleId" value="<%= vehicle.getVehicleId() %>" />
              <% } %>

              <div>
                <label for="vehicleName" class="mb-1.5 block text-sm font-semibold text-gray-700">Vehicle Name</label>
                <input id="vehicleName" name="vehicleName" type="text" value="<%= vehicleName %>" placeholder="e.g., Mahindra Scorpio 4WD" class="w-full rounded-xl border border-gray-200 bg-gray-50 px-4 py-3 text-sm text-gray-700 placeholder:text-gray-400 focus:border-red-300 focus:outline-none focus:ring-2 focus:ring-red-100" />
              </div>

              <div class="grid grid-cols-1 gap-4 md:grid-cols-2">
                <div>
                  <label for="vehicleType" class="mb-1.5 block text-sm font-semibold text-gray-700">Vehicle Type</label>
                  <select id="vehicleType" name="vehicleType" class="w-full rounded-xl border border-gray-200 bg-gray-50 px-4 py-3 text-sm text-gray-700 focus:border-red-300 focus:outline-none focus:ring-2 focus:ring-red-100">
                    <option value="CAR" <%= "CAR".equalsIgnoreCase(vehicleType) ? "selected" : "" %>>Car</option>
                    <option value="BIKE" <%= "BIKE".equalsIgnoreCase(vehicleType) ? "selected" : "" %>>Bike</option>
                    <option value="SCOOTER" <%= "SCOOTER".equalsIgnoreCase(vehicleType) ? "selected" : "" %>>Scooter</option>
                    <option value="VAN" <%= "VAN".equalsIgnoreCase(vehicleType) ? "selected" : "" %>>Van</option>
                    <option value="TRUCK" <%= "TRUCK".equalsIgnoreCase(vehicleType) ? "selected" : "" %>>Truck</option>
                  </select>
                </div>

                <div>
                  <label for="pricePerDay" class="mb-1.5 block text-sm font-semibold text-gray-700">Price Per Day</label>
                  <div class="flex items-center rounded-xl border border-gray-200 bg-gray-50 px-4 py-3">
                    <span class="text-sm font-semibold text-red-800">NPR</span>
                    <input id="pricePerDay" name="pricePerDay" type="number" min="0" step="100" value="<%= pricePerDay %>" class="ml-2 w-full bg-transparent text-sm text-gray-700 focus:outline-none" />
                  </div>
                </div>
              </div>

              <div class="grid grid-cols-1 gap-4 md:grid-cols-2">
                <div>
                  <label for="location" class="mb-1.5 block text-sm font-semibold text-gray-700">Location</label>
                  <input id="location" name="location" type="text" value="<%= location %>" placeholder="Kathmandu" class="w-full rounded-xl border border-gray-200 bg-gray-50 px-4 py-3 text-sm text-gray-700 placeholder:text-gray-400 focus:border-red-300 focus:outline-none focus:ring-2 focus:ring-red-100" />
                </div>

                <div>
                  <label for="availabilityStatus" class="mb-1.5 block text-sm font-semibold text-gray-700">Availability</label>
                  <select id="availabilityStatus" name="availabilityStatus" class="w-full rounded-xl border border-gray-200 bg-gray-50 px-4 py-3 text-sm text-gray-700 focus:border-red-300 focus:outline-none focus:ring-2 focus:ring-red-100">
                    <option value="AVAILABLE" <%= "AVAILABLE".equalsIgnoreCase(availabilityStatus) ? "selected" : "" %>>Available</option>
                    <option value="RENTED" <%= "RENTED".equalsIgnoreCase(availabilityStatus) ? "selected" : "" %>>Booked / Rented</option>
                    <option value="MAINTENANCE" <%= "MAINTENANCE".equalsIgnoreCase(availabilityStatus) ? "selected" : "" %>>Maintenance</option>
                  </select>
                </div>
              </div>

              <div>
                <label for="description" class="mb-1.5 block text-sm font-semibold text-gray-700">Description</label>
                <textarea id="description" name="description" rows="5" placeholder="Tell potential renters about the features, maintenance history, and specific rules..." class="w-full resize-none rounded-xl border border-gray-200 bg-gray-50 px-4 py-3 text-sm text-gray-700 placeholder:text-gray-400 focus:border-red-300 focus:outline-none focus:ring-2 focus:ring-red-100"><%= description %></textarea>
              </div>

              <div>
                <label for="vehicleImage" class="mb-1.5 block text-sm font-semibold text-gray-700">Vehicle Photo</label>
                <input id="vehicleImage" name="vehicleImage" type="file" accept="image/*" class="w-full rounded-xl border border-gray-200 bg-gray-50 px-4 py-3 text-sm text-gray-700 focus:border-red-300 focus:outline-none focus:ring-2 focus:ring-red-100" />
                <% if (vehicle != null && vehicle.getImagePath() != null && !vehicle.getImagePath().isBlank()) { %>
                <p class="mt-2 text-xs text-gray-500">Current image: <%= vehicle.getImagePath() %></p>
                <% } %>
              </div>

              <div class="flex flex-col gap-3 pt-2 sm:flex-row">
                <button type="submit" class="rounded-xl bg-red-800 px-6 py-3 text-base font-semibold text-white shadow-lg shadow-red-200 transition hover:bg-red-900"><%= submitLabel %></button>
                <a href="<%= request.getContextPath() %>/owner/myvehicle" class="rounded-xl border border-gray-200 bg-white px-6 py-3 text-center text-base font-semibold text-gray-700 shadow-sm transition hover:bg-gray-50">Cancel</a>
              </div>
            </form>
          </article>
        </div>

        <div class="space-y-6 xl:col-span-2">
          <article class="rounded-2xl border border-red-100 bg-white p-5 shadow-sm">
            <h2 class="text-2xl font-semibold text-gray-900">Availability &amp; Status</h2>
            <p class="mt-2 text-sm text-gray-600">The dashboard uses the current availability status from the database.</p>
            <div class="mt-4 rounded-xl border border-gray-200 bg-gray-50 px-4 py-4 text-sm text-gray-700">
              <p class="font-semibold text-gray-800">Default listing status</p>
              <p class="mt-1 text-xs text-gray-600">New vehicle posts default to <span class="font-semibold text-red-800">AVAILABLE</span> unless you change it here.</p>
            </div>
          </article>

          <article class="rounded-2xl border border-red-100 bg-white p-5 shadow-sm">
            <h2 class="text-2xl font-semibold text-gray-900">Vehicle Photos</h2>
            <p class="mt-2 text-sm text-gray-600">Upload a clear front-side photo to improve booking confidence.</p>
          </article>

          <article class="rounded-2xl border border-red-100 bg-white p-5 shadow-sm">
            <h3 class="text-lg font-semibold text-gray-900">Listing Checklist</h3>
            <ul class="mt-3 space-y-2 text-sm text-gray-700">
              <li class="flex items-center gap-2"><span class="inline-block h-2 w-2 rounded-full bg-red-800"></span> Vehicle name and type added</li>
              <li class="flex items-center gap-2"><span class="inline-block h-2 w-2 rounded-full bg-red-800"></span> Daily price and location set</li>
              <li class="flex items-center gap-2"><span class="inline-block h-2 w-2 rounded-full bg-red-800"></span> At least one image uploaded</li>
            </ul>
          </article>
        </div>
      </section>
    </main>
  </div>
</div>
</body>
</html>
