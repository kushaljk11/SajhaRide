<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.riderental.myriderental.model.Vehicle" %>
<%@ page import="com.riderental.myriderental.model.User" %>
<%@ page import="java.util.List" %>
<%
    User sessionUser = (User) session.getAttribute("loggedInUser");
    List<Vehicle> vehicles = (List<Vehicle>) request.getAttribute("vehicles");
    String keyword = request.getParameter("keyword") != null ? request.getParameter("keyword") : "";
    String type = request.getParameter("type") != null ? request.getParameter("type") : "";
    String errorMessage = (String) request.getAttribute("errorMessage");
%>
<html>
<head>
    <title>Browse Vehicles - SajhaRide</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 min-h-screen">

<!-- Navbar -->
<nav class="bg-white shadow-sm px-8 py-4 flex items-center justify-between">
    <a href="${pageContext.request.contextPath}/" class="text-xl font-bold text-red-700">SajhaRide</a>
    <div class="flex items-center gap-6">
        <a href="${pageContext.request.contextPath}/vehicles"
           class="text-sm font-semibold text-red-700">Browse Vehicles</a>
        <% if (sessionUser != null) { %>
        <% if ("RENTER".equals(sessionUser.getRole())) { %>
        <a href="${pageContext.request.contextPath}/renter/dashboard"
           class="text-sm text-gray-600 hover:text-red-700">Dashboard</a>
        <a href="${pageContext.request.contextPath}/booking/history"
           class="text-sm text-gray-600 hover:text-red-700">My Bookings</a>
        <% } else if ("OWNER".equals(sessionUser.getRole())) { %>
        <a href="${pageContext.request.contextPath}/owner/dashboard"
           class="text-sm text-gray-600 hover:text-red-700">Dashboard</a>
        <% } else if ("ADMIN".equals(sessionUser.getRole())) { %>
        <a href="${pageContext.request.contextPath}/admin/dashboard"
           class="text-sm text-gray-600 hover:text-red-700">Dashboard</a>
        <% } %>
        <a href="${pageContext.request.contextPath}/profile"
           class="text-sm text-gray-600 hover:text-red-700">Profile</a>
        <a href="${pageContext.request.contextPath}/logout"
           class="text-sm bg-red-700 text-white px-4 py-2 rounded-xl hover:bg-red-800">Logout</a>
        <% } else { %>
        <a href="${pageContext.request.contextPath}/login"
           class="text-sm bg-red-700 text-white px-4 py-2 rounded-xl hover:bg-red-800">Login</a>
        <% } %>
    </div>
</nav>

<div class="max-w-6xl mx-auto px-6 py-10">

    <!-- Page Header -->
    <div class="mb-8">
        <h1 class="text-3xl font-bold text-gray-900">Browse Vehicles</h1>
        <p class="text-gray-500 text-sm mt-1">Find the perfect vehicle for your trip across Nepal.</p>
    </div>

    <!-- Search and Filter Form -->
    <form action="${pageContext.request.contextPath}/vehicles" method="get"
          class="bg-white rounded-2xl shadow-sm p-5 mb-8 flex flex-col md:flex-row gap-4 items-end">

        <div class="flex-1">
            <label class="block text-sm font-medium text-gray-700 mb-2">Search</label>
            <input type="text" name="keyword" value="<%= keyword %>"
                   placeholder="Search by name, location or description..."
                   class="w-full px-4 py-3 rounded-xl border border-gray-200 bg-gray-50 text-sm
                          focus:outline-none focus:ring-2 focus:ring-red-700"/>
        </div>

        <div class="w-full md:w-48">
            <label class="block text-sm font-medium text-gray-700 mb-2">Vehicle Type</label>
            <select name="type"
                    class="w-full px-4 py-3 rounded-xl border border-gray-200 bg-gray-50 text-sm
                           focus:outline-none focus:ring-2 focus:ring-red-700">
                <option value="" <%= "".equals(type) ? "selected" : "" %>>All Types</option>
                <option value="BIKE" <%= "BIKE".equals(type) ? "selected" : "" %>>Bike</option>
                <option value="SCOOTER" <%= "SCOOTER".equals(type) ? "selected" : "" %>>Scooter</option>
                <option value="CAR" <%= "CAR".equals(type) ? "selected" : "" %>>Car</option>
            </select>
        </div>

        <button type="submit"
                class="bg-red-700 text-white px-6 py-3 rounded-xl text-sm font-semibold hover:bg-red-800 whitespace-nowrap">
            Search
        </button>

        <a href="${pageContext.request.contextPath}/vehicles"
           class="text-sm text-gray-500 hover:text-red-700 py-3 whitespace-nowrap">Clear</a>
    </form>

    <!-- Error Message -->
    <% if (errorMessage != null && !errorMessage.isBlank()) { %>
    <div class="mb-6 bg-red-50 border border-red-200 text-red-700 text-sm rounded-xl px-4 py-3">
        <%= errorMessage %>
    </div>
    <% } %>

    <!-- Vehicle Grid -->
    <% if (vehicles == null || vehicles.isEmpty()) { %>
    <div class="bg-white rounded-2xl shadow-sm p-16 text-center">
        <p class="text-gray-400 text-lg">No vehicles found.</p>
        <% if (!keyword.isBlank() || !type.isBlank()) { %>
        <a href="${pageContext.request.contextPath}/vehicles"
           class="mt-4 inline-block bg-red-700 text-white px-6 py-3 rounded-xl text-sm font-semibold hover:bg-red-800">
            Clear Search
        </a>
        <% } %>
    </div>
    <% } else { %>
    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
        <% for (Vehicle vehicle : vehicles) { %>
        <div class="bg-white rounded-2xl shadow-sm overflow-hidden hover:shadow-md transition">

            <!-- Vehicle Image -->
            <div class="h-48 bg-gray-100 flex items-center justify-center overflow-hidden">
                <% if (vehicle.getImagePath() != null && !vehicle.getImagePath().isBlank()) { %>
                <img src="${pageContext.request.contextPath}/<%= vehicle.getImagePath() %>"
                     alt="<%= vehicle.getVehicleName() %>"
                     class="w-full h-full object-cover"/>
                <% } else { %>
                <span class="text-gray-300 text-sm">No image</span>
                <% } %>
            </div>

            <!-- Vehicle Info -->
            <div class="p-5">
                <div class="flex items-start justify-between mb-1">
                    <h3 class="font-semibold text-gray-900 text-base"><%= vehicle.getVehicleName() %></h3>
                    <span class="text-xs bg-gray-100 text-gray-600 px-2 py-1 rounded-full">
                        <%= vehicle.getVehicleType() %>
                    </span>
                </div>

                <p class="text-xs text-gray-400 mb-3">📍 <%= vehicle.getLocation() %></p>

                <p class="text-sm text-gray-600 mb-4 line-clamp-2">
                    <%= vehicle.getDescription() != null ? vehicle.getDescription() : "" %>
                </p>

                <div class="flex items-center justify-between">
                    <p class="text-red-700 font-bold text-lg">
                        Rs. <%= String.format("%.0f", vehicle.getPricePerDay()) %>
                        <span class="text-xs font-normal text-gray-400">/day</span>
                    </p>
                    <a href="${pageContext.request.contextPath}/booking/request?vehicleId=<%= vehicle.getVehicleId() %>"
                       class="bg-red-700 text-white text-xs px-4 py-2 rounded-xl hover:bg-red-800 font-semibold">
                        Book Now
                    </a>
                </div>
            </div>
        </div>
        <% } %>
    </div>
    <% } %>
</div>

</body>
</html>