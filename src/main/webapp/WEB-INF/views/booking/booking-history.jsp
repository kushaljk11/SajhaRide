<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.riderental.myriderental.model.User" %>
<%@ page import="com.riderental.myriderental.model.Booking" %>
<%@ page import="java.util.List" %>
<%
    User sessionUser = (User) session.getAttribute("loggedInUser");
    List<Booking> bookings = (List<Booking>) request.getAttribute("bookings");
    String successMessage = (String) request.getAttribute("successMessage");
    String errorMessage = (String) request.getAttribute("errorMessage");

    if (bookings == null) bookings = java.util.Collections.emptyList();

    String firstName = "Rider";
    if (sessionUser != null && sessionUser.getFullName() != null && !sessionUser.getFullName().isBlank()) {
        firstName = sessionUser.getFullName().trim().split("\\s+")[0];
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>My Trips | SajhaRide</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
</head>
<body class="h-screen overflow-hidden bg-gray-50 text-gray-900">
<div class="flex h-full">
    <%@ include file="/WEB-INF/views/renter/components/sidebar.jsp" %>

    <div class="flex min-w-0 flex-1 flex-col">
        <%@ include file="/WEB-INF/views/renter/components/topbar.jsp" %>

        <main class="flex-1 overflow-y-auto p-6 lg:p-8">
            <div class="flex flex-wrap items-center justify-between gap-4">
                <div>
                    <h1 class="text-3xl font-semibold text-gray-900">My Trips</h1>
                    <p class="text-sm mt-2 text-gray-500">Hey <span class="font-semibold text-red-800"><%= firstName %></span>, here is your ride history.</p>
                </div>
                <a href="${pageContext.request.contextPath}/explore" class="inline-flex items-center rounded-xl bg-red-800 px-4 py-2 text-sm font-semibold text-white transition hover:bg-red-900">Book Another Ride</a>
            </div>

            <% if (successMessage != null && !successMessage.isBlank()) { %>
            <div class="mt-4 rounded-xl border border-green-200 bg-green-50 px-4 py-3 text-sm text-green-800">
                <%= successMessage %>
            </div>
            <% } %>
            <% if (errorMessage != null && !errorMessage.isBlank()) { %>
            <div class="mt-4 rounded-xl border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-800">
                <%= errorMessage %>
            </div>
            <% } %>

            <section class="mt-6">
                <div class="grid gap-4">
                    <% if (bookings.isEmpty()) { %>
                    <article class="rounded-2xl bg-white p-8 text-center shadow-sm ring-1 ring-gray-200">
                        <p class="text-gray-600">You haven't booked any rides yet.</p>
                        <a href="${pageContext.request.contextPath}/explore" class="mt-4 inline-block font-semibold text-red-800 hover:text-red-900">Start exploring</a>
                    </article>
                    <% } %>

                    <% for (Booking booking : bookings) {
                        String status = booking.getStatus() == null ? "PENDING" : booking.getStatus().toUpperCase();
                        String badgeClass = "bg-blue-100 text-blue-800";
                        if ("APPROVED".equals(status)) badgeClass = "bg-red-100 text-red-800";
                        if ("COMPLETED".equals(status)) badgeClass = "bg-emerald-100 text-emerald-800";
                        if ("REJECTED".equals(status) || "CANCELLED".equals(status)) badgeClass = "bg-gray-200 text-gray-700";
                    %>
                    <article class="rounded-2xl bg-white p-5 shadow-sm ring-1 ring-gray-200 hover:shadow-md transition">
                        <div class="flex flex-wrap items-start justify-between gap-3">
                            <div>
                                <h2 class="text-lg font-semibold text-gray-900"><%= booking.getVehicleName() %></h2>
                                <p class="text-sm text-gray-500">Owner: <%= booking.getOwnerName() == null ? "Unknown" : booking.getOwnerName() %></p>
                            </div>
                            <span class="inline-flex rounded-full px-3 py-1 text-xs font-semibold <%= badgeClass %>"><%= status %></span>
                        </div>
                        <div class="mt-4 grid gap-3 text-sm text-gray-600 sm:grid-cols-3">
                            <p><span class="font-semibold text-gray-900">Booking ID:</span> BK-<%= booking.getBookingId() %></p>
                            <p><span class="font-semibold text-gray-900">Date:</span> <%= booking.getStartDate() %> to <%= booking.getEndDate() %></p>
                            <p><span class="font-semibold text-gray-900">Total Price:</span> Rs. <%= String.format(java.util.Locale.US, "%,.2f", booking.getTotalPrice()) %></p>
                        </div>
                    </article>
                    <% } %>
                </div>
            </section>
        </main>
    </div>
</div>
</body>
</html>
