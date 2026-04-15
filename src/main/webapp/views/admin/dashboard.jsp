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
    List<Booking> recentBookings = (List<Booking>) request.getAttribute("recentBookings");
    List<User> recentUsers = (List<User>) request.getAttribute("recentUsers");
    int totalUsers = request.getAttribute("totalUsers") != null
            ? (int) request.getAttribute("totalUsers") : 0;
    int totalVehicles = request.getAttribute("totalVehicles") != null
            ? (int) request.getAttribute("totalVehicles") : 0;
    int totalBookings = request.getAttribute("totalBookings") != null
            ? (int) request.getAttribute("totalBookings") : 0;
    int pendingBookings = request.getAttribute("pendingBookings") != null
            ? (int) request.getAttribute("pendingBookings") : 0;
    int approvedBookings = request.getAttribute("approvedBookings") != null
            ? (int) request.getAttribute("approvedBookings") : 0;
    int rejectedBookings = request.getAttribute("rejectedBookings") != null
            ? (int) request.getAttribute("rejectedBookings") : 0;
    double totalRevenue = request.getAttribute("totalRevenue") != null
            ? (double) request.getAttribute("totalRevenue") : 0.0;
%>
<html>
<head>
    <title>Admin Dashboard - SajhaRide</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 min-h-screen">

<!-- Navbar -->
<nav class="bg-white shadow-sm px-8 py-4 flex items-center justify-between">
    <a href="${pageContext.request.contextPath}/admin/dashboard"
       class="text-xl font-bold text-red-700">SajhaRide Admin</a>
    <div class="flex items-center gap-6">
        <a href="${pageContext.request.contextPath}/admin/dashboard"
           class="text-sm font-semibold text-red-700">Dashboard</a>
        <a href="${pageContext.request.contextPath}/admin/users"
           class="text-sm text-gray-600 hover:text-red-700">Users</a>
        <a href="${pageContext.request.contextPath}/admin/vehicles"
           class="text-sm text-gray-600 hover:text-red-700">Vehicles</a>
        <a href="${pageContext.request.contextPath}/admin/bookings"
           class="text-sm text-gray-600 hover:text-red-700">Bookings</a>
        <a href="${pageContext.request.contextPath}/logout"
           class="text-sm bg-red-700 text-white px-4 py-2 rounded-xl hover:bg-red-800">Logout</a>
    </div>
</nav>

<div class="max-w-7xl mx-auto px-6 py-10">

    <!-- Header -->
    <div class="mb-8">
        <h1 class="text-3xl font-bold text-gray-900">Dashboard Overview</h1>
        <p class="text-gray-500 text-sm mt-1">
            Welcome, <%= sessionUser.getFullName() %>. Here is the full platform summary.
        </p>
    </div>

    <!-- KPI Cards Row 1 -->
    <div class="grid grid-cols-1 md:grid-cols-4 gap-4 mb-6">

        <div class="bg-white rounded-2xl shadow-sm p-6">
            <p class="text-gray-400 text-xs font-medium uppercase tracking-wide">Total Users</p>
            <p class="text-4xl font-bold text-gray-900 mt-2"><%= totalUsers %></p>
        </div>

        <div class="bg-white rounded-2xl shadow-sm p-6">
            <p class="text-gray-400 text-xs font-medium uppercase tracking-wide">Total Vehicles</p>
            <p class="text-4xl font-bold text-gray-900 mt-2"><%= totalVehicles %></p>
        </div>

        <div class="bg-white rounded-2xl shadow-sm p-6">
            <p class="text-gray-400 text-xs font-medium uppercase tracking-wide">Total Bookings</p>
            <p class="text-4xl font-bold text-gray-900 mt-2"><%= totalBookings %></p>
        </div>

        <div class="bg-green-50 rounded-2xl shadow-sm p-6 border border-green-100">
            <p class="text-green-600 text-xs font-medium uppercase tracking-wide">Total Revenue</p>
            <p class="text-2xl font-bold text-green-700 mt-2">
                Rs. <%= String.format("%.2f", totalRevenue) %>
            </p>
        </div>

    </div>

    <!-- KPI Cards Row 2 -->
    <div class="grid grid-cols-1 md:grid-cols-3 gap-4 mb-10">

        <div class="bg-yellow-50 rounded-2xl shadow-sm p-6 border border-yellow-100">
            <p class="text-yellow-600 text-xs font-medium uppercase tracking-wide">Pending Bookings</p>
            <p class="text-4xl font-bold text-yellow-700 mt-2"><%= pendingBookings %></p>
        </div>

        <div class="bg-green-50 rounded-2xl shadow-sm p-6 border border-green-100">
            <p class="text-green-600 text-xs font-medium uppercase tracking-wide">Approved Bookings</p>
            <p class="text-4xl font-bold text-green-700 mt-2"><%= approvedBookings %></p>
        </div>

        <div class="bg-red-50 rounded-2xl shadow-sm p-6 border border-red-100">
            <p class="text-red-600 text-xs font-medium uppercase tracking-wide">Rejected Bookings</p>
            <p class="text-4xl font-bold text-red-700 mt-2"><%= rejectedBookings %></p>
        </div>

    </div>

    <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">

        <!-- Recent Bookings Table -->
        <div class="bg-white rounded-2xl shadow-sm overflow-hidden">
            <div class="px-6 py-4 border-b border-gray-100">
                <h2 class="text-lg font-semibold text-gray-900">Recent Bookings</h2>
            </div>

            <% if (recentBookings == null || recentBookings.isEmpty()) { %>
            <div class="px-6 py-10 text-center">
                <p class="text-gray-400 text-sm">No bookings yet.</p>
            </div>
            <% } else { %>
            <table class="w-full text-sm">
                <thead class="bg-gray-50 border-b border-gray-100">
                <tr>
                    <th class="text-left px-6 py-3 text-gray-500 font-medium">Vehicle</th>
                    <th class="text-left px-6 py-3 text-gray-500 font-medium">Renter</th>
                    <th class="text-left px-6 py-3 text-gray-500 font-medium">Price</th>
                    <th class="text-left px-6 py-3 text-gray-500 font-medium">Status</th>
                </tr>
                </thead>
                <tbody class="divide-y divide-gray-100">
                <%
                    int bCount = 0;
                    for (Booking booking : recentBookings) {
                        if (bCount >= 6) break;
                        bCount++;
                %>
                <tr class="hover:bg-gray-50">
                    <td class="px-6 py-3 font-medium text-gray-900">
                        <%= booking.getVehicleName() != null ? booking.getVehicleName() : "N/A" %>
                    </td>
                    <td class="px-6 py-3 text-gray-600">
                        <%= booking.getRenterName() != null ? booking.getRenterName() : "N/A" %>
                    </td>
                    <td class="px-6 py-3 text-gray-900">
                        Rs. <%= String.format("%.2f", booking.getTotalPrice()) %>
                    </td>
                    <td class="px-6 py-3">
                        <%
                            String st = booking.getStatus();
                            String bc = "px-2 py-1 rounded-full text-xs font-semibold ";
                            if ("APPROVED".equals(st)) bc += "bg-green-100 text-green-700";
                            else if ("PENDING".equals(st)) bc += "bg-yellow-100 text-yellow-700";
                            else if ("REJECTED".equals(st)) bc += "bg-red-100 text-red-700";
                            else if ("COMPLETED".equals(st)) bc += "bg-blue-100 text-blue-700";
                            else bc += "bg-gray-100 text-gray-600";
                        %>
                        <span class="<%= bc %>"><%= st %></span>
                    </td>
                </tr>
                <% } %>
                </tbody>
            </table>
            <% } %>
        </div>

        <!-- Recent Users Table -->
        <div class="bg-white rounded-2xl shadow-sm overflow-hidden">
            <div class="px-6 py-4 border-b border-gray-100">
                <h2 class="text-lg font-semibold text-gray-900">Recent Users</h2>
            </div>

            <% if (recentUsers == null || recentUsers.isEmpty()) { %>
            <div class="px-6 py-10 text-center">
                <p class="text-gray-400 text-sm">No users yet.</p>
            </div>
            <% } else { %>
            <table class="w-full text-sm">
                <thead class="bg-gray-50 border-b border-gray-100">
                <tr>
                    <th class="text-left px-6 py-3 text-gray-500 font-medium">Name</th>
                    <th class="text-left px-6 py-3 text-gray-500 font-medium">Email</th>
                    <th class="text-left px-6 py-3 text-gray-500 font-medium">Role</th>
                    <th class="text-left px-6 py-3 text-gray-500 font-medium">Status</th>
                </tr>
                </thead>
                <tbody class="divide-y divide-gray-100">
                <%
                    int uCount = 0;
                    for (User user : recentUsers) {
                        if (uCount >= 6) break;
                        uCount++;
                %>
                <tr class="hover:bg-gray-50">
                    <td class="px-6 py-3 font-medium text-gray-900">
                        <%= user.getFullName() %>
                    </td>
                    <td class="px-6 py-3 text-gray-600">
                        <%= user.getEmail() %>
                    </td>
                    <td class="px-6 py-3">
                        <%
                            String role = user.getRole();
                            String rc = "px-2 py-1 rounded-full text-xs font-semibold ";
                            if ("ADMIN".equals(role)) rc += "bg-purple-100 text-purple-700";
                            else if ("OWNER".equals(role)) rc += "bg-blue-100 text-blue-700";
                            else rc += "bg-gray-100 text-gray-600";
                        %>
                        <span class="<%= rc %>"><%= role %></span>
                    </td>
                    <td class="px-6 py-3">
                        <%
                            String as = user.getAccountStatus();
                            String ac = "px-2 py-1 rounded-full text-xs font-semibold ";
                            if ("ACTIVE".equals(as)) ac += "bg-green-100 text-green-700";
                            else if ("BLOCKED".equals(as)) ac += "bg-red-100 text-red-700";
                            else ac += "bg-yellow-100 text-yellow-700";
                        %>
                        <span class="<%= ac %>"><%= as %></span>
                    </td>
                </tr>
                <% } %>
                </tbody>
            </table>
            <% } %>
        </div>

    </div>
</div>

</body>
</html>