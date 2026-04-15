<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.riderental.myriderental.model.Booking" %>
<%@ page import="com.riderental.myriderental.model.Vehicle" %>
<%@ page import="com.riderental.myriderental.model.User" %>
<%@ page import="java.util.List" %>
<%
    User sessionUser = (User) session.getAttribute("loggedInUser");
    if (sessionUser == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    List<Vehicle> vehicles = (List<Vehicle>) request.getAttribute("vehicles");
    List<Booking> pendingBookings = (List<Booking>) request.getAttribute("pendingBookings");
    List<Booking> allBookings = (List<Booking>) request.getAttribute("allBookings");
    double totalEarnings = request.getAttribute("totalEarnings") != null
            ? (double) request.getAttribute("totalEarnings") : 0.0;
    int totalVehicles = request.getAttribute("totalVehicles") != null
            ? (int) request.getAttribute("totalVehicles") : 0;
    int totalBookings = request.getAttribute("totalBookings") != null
            ? (int) request.getAttribute("totalBookings") : 0;
    int pendingCount = request.getAttribute("pendingCount") != null
            ? (int) request.getAttribute("pendingCount") : 0;
    String successMessage = (String) request.getAttribute("successMessage");
%>
<html>
<head>
    <title>Owner Dashboard - SajhaRide</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 min-h-screen">

<!-- Navbar -->
<nav class="bg-white shadow-sm px-8 py-4 flex items-center justify-between">
    <a href="${pageContext.request.contextPath}/owner/dashboard"
       class="text-xl font-bold text-red-700">SajhaRide</a>
    <div class="flex items-center gap-6">
        <a href="${pageContext.request.contextPath}/owner/dashboard"
           class="text-sm font-semibold text-red-700">Dashboard</a>
        <a href="${pageContext.request.contextPath}/my-vehicles"
           class="text-sm text-gray-600 hover:text-red-700">My Vehicles</a>
        <a href="${pageContext.request.contextPath}/profile"
           class="text-sm text-gray-600 hover:text-red-700">Profile</a>
        <a href="${pageContext.request.contextPath}/logout"
           class="text-sm bg-red-700 text-white px-4 py-2 rounded-xl hover:bg-red-800">Logout</a>
    </div>
</nav>

<div class="max-w-6xl mx-auto px-6 py-10">

    <!-- Header -->
    <div class="mb-8 flex items-center justify-between">
        <div>
            <h1 class="text-3xl font-bold text-gray-900">Owner Dashboard</h1>
            <p class="text-gray-500 text-sm mt-1">
                Welcome back, <%= sessionUser.getFullName() %>. Manage your fleet and bookings.
            </p>
        </div>
        <a href="${pageContext.request.contextPath}/vehicle/add"
           class="bg-red-700 text-white px-5 py-3 rounded-xl text-sm font-semibold hover:bg-red-800">
            + Add New Vehicle
        </a>
    </div>

    <!-- Success Message -->
    <% if (successMessage != null && !successMessage.isBlank()) { %>
    <div class="mb-6 bg-green-50 border border-green-200 text-green-700 text-sm rounded-xl px-4 py-3">
        <%= successMessage %>
    </div>
    <% } %>

    <!-- Stats Cards -->
    <div class="grid grid-cols-1 md:grid-cols-4 gap-4 mb-10">

        <div class="bg-white rounded-2xl shadow-sm p-6">
            <p class="text-gray-400 text-xs font-medium uppercase tracking-wide">Total Vehicles</p>
            <p class="text-4xl font-bold text-gray-900 mt-2"><%= totalVehicles %></p>
        </div>

        <div class="bg-white rounded-2xl shadow-sm p-6">
            <p class="text-gray-400 text-xs font-medium uppercase tracking-wide">Total Bookings</p>
            <p class="text-4xl font-bold text-gray-900 mt-2"><%= totalBookings %></p>
        </div>

        <div class="bg-yellow-50 rounded-2xl shadow-sm p-6 border border-yellow-100">
            <p class="text-yellow-600 text-xs font-medium uppercase tracking-wide">Pending Requests</p>
            <p class="text-4xl font-bold text-yellow-700 mt-2"><%= pendingCount %></p>
        </div>

        <div class="bg-green-50 rounded-2xl shadow-sm p-6 border border-green-100">
            <p class="text-green-600 text-xs font-medium uppercase tracking-wide">Total Earnings</p>
            <p class="text-2xl font-bold text-green-700 mt-2">
                Rs. <%= String.format("%.2f", totalEarnings) %>
            </p>
        </div>

    </div>

    <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">

        <!-- Pending Booking Requests -->
        <div class="bg-white rounded-2xl shadow-sm overflow-hidden">
            <div class="px-6 py-4 border-b border-gray-100">
                <h2 class="text-lg font-semibold text-gray-900">Pending Booking Requests</h2>
            </div>

            <% if (pendingBookings == null || pendingBookings.isEmpty()) { %>
            <div class="px-6 py-10 text-center">
                <p class="text-gray-400 text-sm">No pending requests at the moment.</p>
            </div>
            <% } else { %>
            <div class="divide-y divide-gray-100">
                <% for (Booking booking : pendingBookings) { %>
                <div class="px-6 py-4">
                    <div class="flex items-center justify-between mb-1">
                        <p class="font-medium text-gray-900">
                            <%= booking.getVehicleName() != null ? booking.getVehicleName() : "N/A" %>
                        </p>
                        <span class="text-xs bg-yellow-100 text-yellow-700 px-3 py-1 rounded-full font-semibold">
                            PENDING
                        </span>
                    </div>
                    <p class="text-xs text-gray-400 mb-1">
                        Renter: <%= booking.getRenterName() != null ? booking.getRenterName() : "N/A" %>
                    </p>
                    <p class="text-xs text-gray-400 mb-3">
                        Dates: <%= booking.getStartDate() %> to <%= booking.getEndDate() %>
                        &nbsp;|&nbsp;
                        Rs. <%= String.format("%.2f", booking.getTotalPrice()) %>
                    </p>
                    <div class="flex gap-2">
                        <form action="${pageContext.request.contextPath}/booking/approve"
                              method="post" class="inline">
                            <input type="hidden" name="bookingId"
                                   value="<%= booking.getBookingId() %>"/>
                            <button type="submit"
                                    class="bg-green-600 text-white text-xs px-4 py-2 rounded-lg hover:bg-green-700 font-semibold">
                                Approve
                            </button>
                        </form>
                        <form action="${pageContext.request.contextPath}/booking/reject"
                              method="post" class="inline">
                            <input type="hidden" name="bookingId"
                                   value="<%= booking.getBookingId() %>"/>
                            <button type="submit"
                                    class="bg-red-100 text-red-700 text-xs px-4 py-2 rounded-lg hover:bg-red-200 font-semibold">
                                Reject
                            </button>
                        </form>
                    </div>
                </div>
                <% } %>
            </div>
            <% } %>
        </div>

        <!-- My Vehicles -->
        <div class="bg-white rounded-2xl shadow-sm overflow-hidden">
            <div class="px-6 py-4 border-b border-gray-100 flex items-center justify-between">
                <h2 class="text-lg font-semibold text-gray-900">My Vehicles</h2>
                <a href="${pageContext.request.contextPath}/my-vehicles"
                   class="text-sm text-red-700 font-medium hover:underline">Manage All</a>
            </div>

            <% if (vehicles == null || vehicles.isEmpty()) { %>
            <div class="px-6 py-10 text-center">
                <p class="text-gray-400 text-sm">You have no vehicles listed yet.</p>
                <a href="${pageContext.request.contextPath}/vehicle/add"
                   class="mt-4 inline-block bg-red-700 text-white px-5 py-2 rounded-xl text-sm font-semibold hover:bg-red-800">
                    Add Vehicle
                </a>
            </div>
            <% } else { %>
            <div class="divide-y divide-gray-100">
                <%
                    int vCount = 0;
                    for (Vehicle vehicle : vehicles) {
                        if (vCount >= 4) break;
                        vCount++;
                %>
                <div class="px-6 py-4 flex items-center justify-between">
                    <div>
                        <p class="font-medium text-gray-900"><%= vehicle.getVehicleName() %></p>
                        <p class="text-xs text-gray-400">
                            <%= vehicle.getVehicleType() %> &nbsp;|&nbsp;
                            Rs. <%= String.format("%.2f", vehicle.getPricePerDay()) %>/day
                        </p>
                    </div>
                    <%
                        String vstatus = vehicle.getAvailabilityStatus();
                        String vbadge = "text-xs px-3 py-1 rounded-full font-semibold ";
                        if ("AVAILABLE".equals(vstatus)) vbadge += "bg-green-100 text-green-700";
                        else if ("RENTED".equals(vstatus)) vbadge += "bg-blue-100 text-blue-700";
                        else vbadge += "bg-gray-100 text-gray-600";
                    %>
                    <span class="<%= vbadge %>"><%= vstatus %></span>
                </div>
                <% } %>
            </div>
            <% } %>
        </div>

    </div>
</div>

</body>
</html>