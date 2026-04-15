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
    List<Booking> allBookings = (List<Booking>) request.getAttribute("allBookings");
    int totalBookings = request.getAttribute("totalBookings") != null
            ? (int) request.getAttribute("totalBookings") : 0;
    int pendingCount = request.getAttribute("pendingCount") != null
            ? (int) request.getAttribute("pendingCount") : 0;
    int approvedCount = request.getAttribute("approvedCount") != null
            ? (int) request.getAttribute("approvedCount") : 0;
    int completedCount = request.getAttribute("completedCount") != null
            ? (int) request.getAttribute("completedCount") : 0;
%>
<html>
<head>
    <title>Renter Dashboard - SajhaRide</title>
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
           class="text-sm text-gray-600 hover:text-red-700">My Bookings</a>
        <a href="${pageContext.request.contextPath}/profile"
           class="text-sm text-gray-600 hover:text-red-700">Profile</a>
        <a href="${pageContext.request.contextPath}/logout"
           class="text-sm bg-red-700 text-white px-4 py-2 rounded-xl hover:bg-red-800">Logout</a>
    </div>
</nav>

<div class="max-w-6xl mx-auto px-6 py-10">

    <!-- Welcome Header -->
    <div class="mb-8 flex items-center justify-between">
        <div>
            <h1 class="text-3xl font-bold text-gray-900">
                Welcome back, <%= sessionUser.getFullName() %>
            </h1>
            <p class="text-gray-500 text-sm mt-1">
                Here is a summary of your rental activity.
            </p>
        </div>
        <a href="${pageContext.request.contextPath}/vehicles"
           class="bg-red-700 text-white px-5 py-3 rounded-xl text-sm font-semibold hover:bg-red-800">
            Browse Vehicles
        </a>
    </div>

    <!-- Stats Cards -->
    <div class="grid grid-cols-1 md:grid-cols-4 gap-4 mb-10">

        <div class="bg-white rounded-2xl shadow-sm p-6">
            <p class="text-gray-400 text-xs font-medium uppercase tracking-wide">Total Bookings</p>
            <p class="text-4xl font-bold text-gray-900 mt-2"><%= totalBookings %></p>
        </div>

        <div class="bg-yellow-50 rounded-2xl shadow-sm p-6 border border-yellow-100">
            <p class="text-yellow-600 text-xs font-medium uppercase tracking-wide">Pending</p>
            <p class="text-4xl font-bold text-yellow-700 mt-2"><%= pendingCount %></p>
        </div>

        <div class="bg-green-50 rounded-2xl shadow-sm p-6 border border-green-100">
            <p class="text-green-600 text-xs font-medium uppercase tracking-wide">Approved</p>
            <p class="text-4xl font-bold text-green-700 mt-2"><%= approvedCount %></p>
        </div>

        <div class="bg-blue-50 rounded-2xl shadow-sm p-6 border border-blue-100">
            <p class="text-blue-600 text-xs font-medium uppercase tracking-wide">Completed</p>
            <p class="text-4xl font-bold text-blue-700 mt-2"><%= completedCount %></p>
        </div>

    </div>

    <!-- Recent Bookings Table -->
    <div class="bg-white rounded-2xl shadow-sm overflow-hidden">
        <div class="px-6 py-4 border-b border-gray-100 flex items-center justify-between">
            <h2 class="text-lg font-semibold text-gray-900">Recent Booking History</h2>
            <a href="${pageContext.request.contextPath}/booking/history"
               class="text-sm text-red-700 font-medium hover:underline">View All</a>
        </div>

        <% if (allBookings == null || allBookings.isEmpty()) { %>
        <div class="px-6 py-12 text-center">
            <p class="text-gray-400">You have not made any bookings yet.</p>
            <a href="${pageContext.request.contextPath}/vehicles"
               class="mt-4 inline-block bg-red-700 text-white px-5 py-2 rounded-xl text-sm font-semibold hover:bg-red-800">
                Find a Vehicle
            </a>
        </div>
        <% } else { %>
        <table class="w-full text-sm">
            <thead class="bg-gray-50 border-b border-gray-100">
            <tr>
                <th class="text-left px-6 py-3 text-gray-500 font-medium">Vehicle</th>
                <th class="text-left px-6 py-3 text-gray-500 font-medium">Start Date</th>
                <th class="text-left px-6 py-3 text-gray-500 font-medium">End Date</th>
                <th class="text-left px-6 py-3 text-gray-500 font-medium">Total Price</th>
                <th class="text-left px-6 py-3 text-gray-500 font-medium">Status</th>
            </tr>
            </thead>
            <tbody class="divide-y divide-gray-100">
            <%
                int count = 0;
                for (Booking booking : allBookings) {
                    if (count >= 5) break;
                    count++;
            %>
            <tr class="hover:bg-gray-50">
                <td class="px-6 py-4 font-medium text-gray-900">
                    <%= booking.getVehicleName() != null ? booking.getVehicleName() : "N/A" %>
                    <span class="block text-xs text-gray-400">
                        <%= booking.getVehicleType() != null ? booking.getVehicleType() : "" %>
                    </span>
                </td>
                <td class="px-6 py-4 text-gray-600"><%= booking.getStartDate() %></td>
                <td class="px-6 py-4 text-gray-600"><%= booking.getEndDate() %></td>
                <td class="px-6 py-4 font-semibold text-gray-900">
                    Rs. <%= String.format("%.2f", booking.getTotalPrice()) %>
                </td>
                <td class="px-6 py-4">
                    <%
                        String status = booking.getStatus();
                        String badge = "px-3 py-1 rounded-full text-xs font-semibold ";
                        if ("APPROVED".equals(status)) badge += "bg-green-100 text-green-700";
                        else if ("PENDING".equals(status)) badge += "bg-yellow-100 text-yellow-700";
                        else if ("REJECTED".equals(status)) badge += "bg-red-100 text-red-700";
                        else if ("COMPLETED".equals(status)) badge += "bg-blue-100 text-blue-700";
                        else badge += "bg-gray-100 text-gray-700";
                    %>
                    <span class="<%= badge %>"><%= status %></span>
                </td>
            </tr>
            <% } %>
            </tbody>
        </table>
        <% } %>
    </div>
</div>

</body>
</html>