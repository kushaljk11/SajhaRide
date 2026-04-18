<%--
  Created by IntelliJ IDEA.
  User: kusha
  Date: 4/18/2026
  Time: 8:42 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>SajhaRide</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body>
<div class="flex h-screen bg-gray-100">
    <%@ include file="/WEB-INF/views/renter/components/sidebar.jsp" %>

    <div class="flex flex-1 flex-col">
        <%@ include file="/WEB-INF/views/owner/components/topbar.jsp" %>

        <main class="flex-1 overflow-y-auto p-6">
            <h1 class="text-2xl font-semibold text-gray-800">Renter Dashboard</h1>
            <p class="mt-4 text-gray-600">Welcome to your dashboard! Here you can manage your bookings, view available vehicles, and update your profile.</p>
            <!-- Add more renter-specific content here -->
        </main>
    </div>
</body>
</html>
