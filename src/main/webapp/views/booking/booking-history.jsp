<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.riderental.myriderental.model.Booking" %>
<%@ page import="com.riderental.myriderental.model.User" %>
<%@ page import="java.util.List" %>
<%
    User sessionUser = (User) session.getAttribute("loggedInUser");
    if (sessionUser == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    List<Booking> bookings = (List<Booking>) request.getAttribute("bookings");
    String successMessage = (String) request.getAttribute("successMessage");
    String errorMessage = (String) request.getAttribute("errorMessage");
%>
<html>
<head>
    <title>My Bookings - SajhaRide</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 min-h-screen">

<!-- Navbar -->
<nav class="bg-white shadow-sm px-8 py-4 flex items-center justify-between">
    <a href="${pageContext.request.contextPath}/renter/dashboard"
       class="text-xl font-bold text-red-700">SajhaRide</a>
    <div class="flex items-center gap-6">
        <a href="${pageContext.request.contextPath}/vehicles"
           class="text-sm text-gray-600 hover:text-red-700">Browse Vehicles</a>
        <a href="${pageContext.request.contextPath}/booking/history"
           class="text-sm font-semibold text-red-700">My Bookings</a>
        <a href="${pageContext.request.contextPath}/profile"
           class="text-sm text-gray-600 hover:text-red-700">Profile</a>
        <a href="${pageContext.request.contextPath}/logout"
           class="text-sm bg-red-700 text-white px-4 py-2 rounded-xl hover:bg-red-800">Logout</a>
    </div>
</nav>

<div class="max-w-6xl mx-auto px-6 py-10">

    <div class="mb-8">
        <h1 class="text-3xl font-bold text-gray-900">My Bookings</h1>
        <p class="text-gray-500 text-sm mt-1">Track all your vehicle rental requests and their status.</p>
    </div>

    <!-- Success Message -->
    <% if (successMessage != null && !successMessage.isBlank()) { %>
    <div class="mb-6 bg-green-50 border border-green-200 text-green-700 text-sm rounded-xl px-4 py-3">
        <%= successMessage %>
    </div>
    <% } %>

    <!-- Error Message -->
    <% if (errorMessage != null && !errorMessage.isBlank()) { %>
    <div class="mb-6 bg-red-50 border border-red-200 text-red-700 text-sm rounded-xl px-4 py-3">
        <%= errorMessage %>
    </div>
    <% } %>

    <!-- Bookings Table -->
    <% if (bookings == null || bookings.isEmpty()) { %>
    <div class="bg-white rounded-2xl shadow-sm p-12 text-center">
        <p class="text-gray-400 text-lg">You have no bookings yet.</p>
        <a href="${pageContext.request.contextPath}/vehicles"
           class="mt-4 inline-block bg-red-700 text-white px-6 py-3 rounded-xl text-sm font-semibold hover:bg-red-800">
            Browse Vehicles
        </a>
    </div>
    <% } else { %>
    <div class="bg-white rounded-2xl shadow-sm overflow-hidden">
        <table class="w-full text-sm">
            <thead class="bg-gray-50 border-b border-gray-200">
            <tr>
                <th class="text-left px-6 py-4 text-gray-500 font-medium">Vehicle</th>
                <th class="text-left px-6 py-4 text-gray-500 font-medium">Start Date</th>
                <th class="text-left px-6 py-4 text-gray-500 font-medium">End Date</th>
                <th class="text-left px-6 py-4 text-gray-500 font-medium">Total Price</th>
                <th class="text-left px-6 py-4 text-gray-500 font-medium">Status</th>
                <th class="text-left px-6 py-4 text-gray-500 font-medium">Booked On</th>
            </tr>
            </thead>
            <tbody class="divide-y divide-gray-100">
            <% for (Booking booking : bookings) { %>
            <tr class="hover:bg-gray-50">
                <td class="px-6 py-4 font-medium text-gray-900">
                    <%= booking.getVehicleName() != null ? booking.getVehicleName() : "N/A" %>
                    <span class="block text-xs text-gray-400">
                        <%= booking.getVehicleType() != null ? booking.getVehicleType() : "" %>
                    </span>
                </td>
                <td class="px-6 py-4 text-gray-600"><%= booking.getStartDate() %></td>
                <td class="px-6 py-4 text-gray-600"><%= booking.getEndDate() %></td>
                <td class="px-6 py-4 text-gray-900 font-semibold">
                    Rs. <%= String.format("%.2f", booking.getTotalPrice()) %>
                </td>
                <td class="px-6 py-4">
                    <%
                        String status = booking.getStatus();
                        String badgeClass = "px-3 py-1 rounded-full text-xs font-semibold ";
                        if ("APPROVED".equals(status)) badgeClass += "bg-green-100 text-green-700";
                        else if ("PENDING".equals(status)) badgeClass += "bg-yellow-100 text-yellow-700";
                        else if ("REJECTED".equals(status)) badgeClass += "bg-red-100 text-red-700";
                        else if ("COMPLETED".equals(status)) badgeClass += "bg-blue-100 text-blue-700";
                        else badgeClass += "bg-gray-100 text-gray-700";
                    %>
                    <span class="<%= badgeClass %>"><%= status %></span>
                </td>
                <td class="px-6 py-4 text-gray-400 text-xs">
                    <%= booking.getCreatedAt() != null
                            ? booking.getCreatedAt().toLocalDate().toString()
                            : "N/A" %>
                </td>
            </tr>
            <% } %>
            </tbody>
        </table>
    </div>
    <% } %>
</div>

</body>
</html>