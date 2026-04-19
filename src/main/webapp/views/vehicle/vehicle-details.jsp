<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.riderental.myriderental.model.Vehicle" %>
<%@ page import="com.riderental.myriderental.model.User" %>
<%
    User sessionUser = (User) session.getAttribute("loggedInUser");
    Vehicle vehicle = (Vehicle) request.getAttribute("vehicle");
    String errorMessage = (String) request.getAttribute("errorMessage");

    if (vehicle == null) {
        response.sendRedirect(request.getContextPath() + "/vehicles");
        return;
    }
%>
<html>
<head>
    <title><%= vehicle.getVehicleName() %> - SajhaRide</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 min-h-screen">

<!-- Navbar -->
<nav class="bg-white shadow-sm px-8 py-4 flex items-center justify-between">
    <a href="${pageContext.request.contextPath}/" class="text-xl font-bold text-red-700">SajhaRide</a>
    <div class="flex items-center gap-6">
        <a href="${pageContext.request.contextPath}/vehicles"
           class="text-sm text-gray-600 hover:text-red-700">Browse Vehicles</a>
        <% if (sessionUser != null) { %>
        <% if ("RENTER".equals(sessionUser.getRole())) { %>
        <a href="${pageContext.request.contextPath}/booking/history"
           class="text-sm text-gray-600 hover:text-red-700">My Bookings</a>
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

<div class="max-w-5xl mx-auto px-6 py-10">

    <!-- Back Link -->
    <a href="${pageContext.request.contextPath}/vehicles"
       class="text-sm text-gray-500 hover:text-red-700 mb-6 inline-block">
        ← Back to Vehicles
    </a>

    <div class="grid grid-cols-1 lg:grid-cols-2 gap-8">

        <!-- Left: Vehicle Info -->
        <div>
            <!-- Vehicle Image -->
            <div class="bg-white rounded-2xl overflow-hidden shadow-sm mb-6 h-72 flex items-center justify-center">
                <% if (vehicle.getImagePath() != null && !vehicle.getImagePath().isBlank()) { %>
                <img src="${pageContext.request.contextPath}/<%= vehicle.getImagePath() %>"
                     alt="<%= vehicle.getVehicleName() %>"
                     class="w-full h-full object-cover"/>
                <% } else { %>
                <span class="text-gray-300 text-sm">No image available</span>
                <% } %>
            </div>

            <!-- Vehicle Details Card -->
            <div class="bg-white rounded-2xl shadow-sm p-6">
                <div class="flex items-start justify-between mb-3">
                    <h1 class="text-2xl font-bold text-gray-900"><%= vehicle.getVehicleName() %></h1>
                    <span class="text-xs bg-gray-100 text-gray-600 px-3 py-1 rounded-full font-medium">
                        <%= vehicle.getVehicleType() %>
                    </span>
                </div>

                <p class="text-sm text-gray-400 mb-4">📍 <%= vehicle.getLocation() %></p>

                <p class="text-gray-600 text-sm leading-relaxed mb-6">
                    <%= vehicle.getDescription() != null ? vehicle.getDescription() : "No description provided." %>
                </p>

                <!-- Price and Status -->
                <div class="flex items-center justify-between border-t border-gray-100 pt-4">
                    <div>
                        <p class="text-xs text-gray-400 mb-1">Price per day</p>
                        <p class="text-2xl font-bold text-red-700">
                            Rs. <%= String.format("%.0f", vehicle.getPricePerDay()) %>
                            <span class="text-sm font-normal text-gray-400">/day</span>
                        </p>
                    </div>
                    <%
                        String avStatus = vehicle.getAvailabilityStatus();
                        String avBadge = "text-xs px-3 py-1 rounded-full font-semibold ";
                        if ("AVAILABLE".equals(avStatus)) avBadge += "bg-green-100 text-green-700";
                        else if ("RENTED".equals(avStatus)) avBadge += "bg-blue-100 text-blue-700";
                        else avBadge += "bg-gray-100 text-gray-500";
                    %>
                    <span class="<%= avBadge %>"><%= avStatus %></span>
                </div>
            </div>
        </div>

        <!-- Right: Booking Form -->
        <div>
            <div class="bg-white rounded-2xl shadow-sm p-6 sticky top-6">
                <h2 class="text-xl font-bold text-gray-900 mb-1">Book This Vehicle</h2>
                <p class="text-gray-400 text-sm mb-6">Select your rental dates to submit a booking request.</p>

                <!-- Error Message -->
                <% if (errorMessage != null && !errorMessage.isBlank()) { %>
                <div class="mb-5 bg-red-50 border border-red-200 text-red-700 text-sm rounded-xl px-4 py-3">
                    <%= errorMessage %>
                </div>
                <% } %>

                <% if ("AVAILABLE".equals(vehicle.getAvailabilityStatus())) { %>

                <% if (sessionUser != null && "RENTER".equals(sessionUser.getRole())) { %>
                <!-- Booking Form for logged-in renters -->
                <form action="${pageContext.request.contextPath}/booking/request" method="post"
                      class="space-y-5">

                    <input type="hidden" name="vehicleId" value="<%= vehicle.getVehicleId() %>"/>

                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-2">Start Date</label>
                        <input type="date" name="startDate" required
                               min="<%= java.time.LocalDate.now().plusDays(1) %>"
                               class="w-full px-4 py-3 rounded-xl border border-gray-200 bg-gray-50 text-sm
                                          focus:outline-none focus:ring-2 focus:ring-red-700"/>
                    </div>

                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-2">End Date</label>
                        <input type="date" name="endDate" required
                               min="<%= java.time.LocalDate.now().plusDays(2) %>"
                               class="w-full px-4 py-3 rounded-xl border border-gray-200 bg-gray-50 text-sm
                                          focus:outline-none focus:ring-2 focus:ring-red-700"/>
                    </div>

                    <!-- Price Calculator -->
                    <div class="bg-gray-50 rounded-xl p-4 text-sm text-gray-600 border border-gray-100">
                        <p class="mb-1">Price per day:
                            <span class="font-semibold text-gray-900">
                                    Rs. <%= String.format("%.0f", vehicle.getPricePerDay()) %>
                                </span>
                        </p>
                        <p class="text-xs text-gray-400">Total will be calculated based on your selected dates.</p>
                    </div>

                    <button type="submit"
                            class="w-full py-3 rounded-xl bg-red-700 text-white font-semibold
                                       hover:bg-red-800 transition text-sm">
                        Submit Booking Request
                    </button>

                    <p class="text-xs text-gray-400 text-center">
                        Your request will be sent to the owner for approval.
                    </p>
                </form>

                <% } else if (sessionUser == null) { %>
                <!-- Not logged in -->
                <div class="text-center py-6">
                    <p class="text-gray-500 text-sm mb-4">You need to be logged in as a renter to book this vehicle.</p>
                    <a href="${pageContext.request.contextPath}/login"
                       class="bg-red-700 text-white px-6 py-3 rounded-xl text-sm font-semibold hover:bg-red-800">
                        Login to Book
                    </a>
                </div>

                <% } else { %>
                <!-- Logged in but not a renter (owner or admin) -->
                <div class="text-center py-6">
                    <p class="text-gray-400 text-sm">Only renters can book vehicles.</p>
                </div>
                <% } %>

                <% } else { %>
                <!-- Vehicle not available -->
                <div class="text-center py-8">
                    <div class="bg-blue-50 border border-blue-100 rounded-xl px-4 py-6">
                        <p class="text-blue-700 font-semibold text-sm mb-1">This vehicle is currently unavailable.</p>
                        <p class="text-blue-500 text-xs">Please check back later or browse other vehicles.</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/vehicles"
                       class="mt-4 inline-block bg-red-700 text-white px-6 py-3 rounded-xl text-sm font-semibold hover:bg-red-800">
                        Browse Other Vehicles
                    </a>
                </div>
                <% } %>

            </div>
        </div>

    </div>
</div>

</body>
</html>