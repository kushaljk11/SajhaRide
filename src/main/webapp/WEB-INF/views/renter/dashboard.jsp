<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.riderental.myriderental.model.User" %>
<%@ page import="com.riderental.myriderental.model.Vehicle" %>
<%@ page import="com.riderental.myriderental.model.Booking" %>
<%@ page import="java.util.List" %>
<%
    User dashboardUser = (User) session.getAttribute("loggedInUser");
    List<Vehicle> vehicles = (List<Vehicle>) request.getAttribute("vehicles");
    List<Booking> allBookings = (List<Booking>) request.getAttribute("allBookings");
    List<Booking> pendingBookings = (List<Booking>) request.getAttribute("pendingBookings");
    List<Booking> activeBookings = (List<Booking>) request.getAttribute("activeBookings");
    List<Booking> completedBookings = (List<Booking>) request.getAttribute("completedBookings");
    Integer totalVehicles = (Integer) request.getAttribute("totalVehicles");
    Integer totalBookings = (Integer) request.getAttribute("totalBookings");
    Integer pendingCount = (Integer) request.getAttribute("pendingCount");
    Integer activeCount = (Integer) request.getAttribute("activeCount");
    Double totalEarnings = (Double) request.getAttribute("totalEarnings");

    String firstName = "Rider";
    if (dashboardUser != null && dashboardUser.getFullName() != null && !dashboardUser.getFullName().isBlank()) {
        String[] nameParts = dashboardUser.getFullName().trim().split("\\s+");
        firstName = nameParts[0];
    }

    if (vehicles == null) vehicles = java.util.Collections.emptyList();
    if (allBookings == null) allBookings = java.util.Collections.emptyList();
    if (pendingBookings == null) pendingBookings = java.util.Collections.emptyList();
    if (activeBookings == null) activeBookings = java.util.Collections.emptyList();
    if (completedBookings == null) completedBookings = java.util.Collections.emptyList();

    int tv = totalVehicles == null ? vehicles.size() : totalVehicles;
    int tb = totalBookings == null ? allBookings.size() : totalBookings;
    int pc = pendingCount == null ? pendingBookings.size() : pendingCount;
    int ac = activeCount == null ? activeBookings.size() : activeCount;
    int cc = completedBookings.size();
    double earnings = totalEarnings == null ? 0.0 : totalEarnings;
%>
<html>
<head>
    <title>SajhaRide</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
</head>
<body class="h-screen overflow-hidden bg-gray-50 text-gray-900">
<div class="flex h-full">
    <%@ include file="/WEB-INF/views/renter/components/sidebar.jsp" %>

    <div class="flex min-w-0 flex-1 flex-col">
        <%@ include file="/WEB-INF/views/renter/components/topbar.jsp" %>

        <main class="flex-1 overflow-y-auto p-6 lg:p-8">
            <h1 class="text-3xl font-semibold text-gray-900">Renter Dashboard</h1>
            <p class="text-sm mt-1 text-gray-500">Welcome back, <span class="text-red-800 uppercase font-bold"><%= firstName %>.</span> Here is your latest listing and booking performance.</p>

            <section class="mt-4">
                <div class="grid gap-4 md:grid-cols-2 xl:grid-cols-4">
                    <article class="rounded-2xl bg-gray-50 p-4 ring-1 ring-gray-200">
                        <p class="text-sm font-semibold text-black">Listed Vehicles</p>
                        <p class="mt-3 text-3xl font-semibold text-gray-900"><%= tv %></p>
                        <p class="text-sm text-gray-500">Your active listings</p>
                    </article>

                    <article class="relative overflow-hidden rounded-2xl bg-red-800 p-4 text-white shadow-md">
                        <div class="absolute right-0 top-0 h-24 w-24 translate-x-6 -translate-y-6 rounded-full border border-white/25"></div>
                        <p class="text-sm font-semibold text-red-100">Active Bookings</p>
                        <p class="mt-3 text-3xl font-semibold"><%= ac %></p>
                        <p class="text-sm text-red-100">Approved and ongoing</p>
                    </article>

                    <article class="rounded-2xl bg-gray-50 p-4 ring-1 ring-gray-200">
                        <p class="text-sm font-semibold text-black">Total Bookings</p>
                        <p class="mt-3 text-3xl font-semibold text-gray-900"><%= tb %></p>
                        <p class="text-sm text-gray-500">Across all listed vehicles</p>
                    </article>

                    <article class="rounded-2xl bg-gray-50 p-4 ring-1 ring-gray-200">
                        <p class="text-sm font-semibold text-black">Pending Requests</p>
                        <p class="mt-3 text-3xl font-semibold text-gray-900"><%= pc %></p>
                        <p class="text-sm text-gray-500">Awaiting your response</p>
                    </article>
                </div>
            </section>

            <section class="mt-4">
                <article class="rounded-2xl bg-gray-50 p-4 ring-1 ring-gray-200">
                    <p class="text-sm font-semibold text-black">Completed Bookings</p>
                    <p class="mt-3 text-3xl font-semibold text-gray-900"><%= cc %></p>
                    <p class="text-sm text-gray-500">Total Earnings: Rs. <%= String.format(java.util.Locale.US, "%,.2f", earnings) %></p>
                </article>
            </section>

            <section class="mt-6">
                <div class="mb-4 flex flex-wrap items-center justify-between gap-3">
                    <div>
                        <h2 class="text-xl font-semibold text-gray-900">My Listed Vehicles</h2>
                        <p class="text-sm text-gray-500">Vehicles currently attached to your renter account.</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/renter/booking" class="inline-flex items-center rounded-xl border border-red-200 bg-red-50 px-4 py-2 text-sm font-semibold text-red-800 transition hover:bg-red-100">
                        Manage Requests
                    </a>
                </div>

                <div class="grid gap-4 sm:grid-cols-2 xl:grid-cols-4">
                    <% if (vehicles.isEmpty()) { %>
                    <article class="rounded-2xl bg-white p-5 ring-1 ring-gray-200 sm:col-span-2 xl:col-span-4">
                        <p class="text-sm text-gray-600">No vehicles listed yet. Add a vehicle first to receive booking requests and earnings.</p>
                    </article>
                    <% } %>
                    <% for (Vehicle vehicle : vehicles) { %>
                    <article class="group overflow-hidden rounded-2xl bg-gray-50 ring-1 ring-gray-200 transition hover:-translate-y-0.5 hover:shadow-sm">
                        <div class="h-32 overflow-hidden">
                            <img src="${pageContext.request.contextPath}/<%= (vehicle.getImagePath() == null || vehicle.getImagePath().isBlank()) ? "images/about.png" : vehicle.getImagePath() %>" alt="<%= vehicle.getVehicleName() %>" class="h-full w-full object-cover transition duration-300 group-hover:scale-105" />
                        </div>
                        <div class="p-4">
                            <h3 class="font-semibold text-gray-900"><%= vehicle.getVehicleName() %></h3>
                            <p class="mt-1 text-sm text-gray-500"><%= vehicle.getVehicleType() %> • <%= vehicle.getLocation() %></p>
                            <p class="mt-3 text-sm font-semibold text-red-800">Rs. <%= String.format(java.util.Locale.US, "%,.2f", vehicle.getPricePerDay()) %>/day</p>
                        </div>
                    </article>
                    <% } %>
                </div>
            </section>

            <section class="mt-6 rounded-2xl bg-white shadow-sm ring-1 ring-gray-200">
                <div class="flex flex-wrap items-center justify-between gap-3 border-b border-gray-100 px-6 py-5">
                    <h2 class="text-xl font-semibold text-gray-900">Recent Booking History</h2>
                    <a href="${pageContext.request.contextPath}/renter/booking" class="text-sm font-semibold text-red-800 hover:text-red-900">View All Requests</a>
                </div>

                <div class="overflow-x-auto">
                    <table class="min-w-full text-left text-sm">
                        <thead class="bg-gray-50 text-sm text-gray-400">
                            <tr>
                                <th class="px-6 py-4 font-semibold">Vehicle</th>
                                <th class="px-6 py-4 font-semibold">Date</th>
                                <th class="px-6 py-4 font-semibold">Status</th>
                                <th class="px-6 py-4 font-semibold">Total Price</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-gray-100">
                        <% if (allBookings.isEmpty()) { %>
                        <tr>
                            <td colspan="4" class="px-6 py-6 text-center text-sm text-gray-500">No bookings found yet.</td>
                        </tr>
                        <% } %>
                        <% for (int i = 0; i < allBookings.size() && i < 5; i++) {
                            Booking booking = allBookings.get(i);
                            String status = booking.getStatus() == null ? "PENDING" : booking.getStatus().toUpperCase();
                            String badgeClass = "bg-blue-100 text-blue-800";
                            if ("APPROVED".equals(status)) badgeClass = "bg-red-100 text-red-800";
                            if ("COMPLETED".equals(status)) badgeClass = "bg-emerald-100 text-emerald-800";
                            if ("REJECTED".equals(status)) badgeClass = "bg-gray-200 text-gray-700";
                        %>
                        <tr class="hover:bg-gray-50/80">
                            <td class="px-6 py-4">
                                <p class="font-semibold text-gray-900"><%= booking.getVehicleName() %></p>
                                <p class="text-xs text-gray-500">Request #BK-<%= booking.getBookingId() %></p>
                            </td>
                            <td class="px-6 py-4 text-gray-600"><%= booking.getStartDate() %> to <%= booking.getEndDate() %></td>
                            <td class="px-6 py-4"><span class="inline-flex rounded-full px-3 py-1 text-xs font-semibold <%= badgeClass %>"><%= status %></span></td>
                            <td class="px-6 py-4 font-semibold text-gray-900">Rs. <%= String.format(java.util.Locale.US, "%,.2f", booking.getTotalPrice()) %></td>
                        </tr>
                        <% } %>
                        </tbody>
                    </table>
                </div>
            </section>

            <section class="mt-6 grid gap-4 lg:grid-cols-[1.2fr_1fr]">
                <article class="overflow-hidden rounded-2xl bg-gradient-to-r from-red-900 via-red-800 to-red-700 p-6 text-white shadow-sm">
                    <h3 class="text-3xl font-semibold">Explore the Himalayas</h3>
                    <p class="mt-2 text-sm text-red-100">Rent an SUV for your next off-road adventure.</p>
                    <a href="${pageContext.request.contextPath}/explore" class="mt-5 inline-flex items-center rounded-xl bg-white px-4 py-2 text-sm font-semibold text-red-800 transition hover:bg-red-50">Explore SUVs</a>
                </article>

                <article class="rounded-2xl bg-white p-6 shadow-sm ring-1 ring-gray-200">
                    <h3 class="text-2xl font-semibold text-gray-900">Need Assistance?</h3>
                    <p class="mt-2 text-sm text-gray-500">Our 24/7 support team is here to help with your rides and bookings.</p>
                    <div class="mt-5 grid grid-cols-2 gap-3">
                        <button type="button" class="rounded-xl bg-gray-100 px-4 py-2.5 text-sm font-semibold text-gray-700 transition hover:bg-gray-200">Read FAQs</button>
                        <a href="${pageContext.request.contextPath}/contact" class="inline-flex items-center justify-center rounded-xl bg-red-800 px-4 py-2.5 text-sm font-semibold text-white transition hover:bg-red-900">Contact Support</a>
                    </div>
                </article>
            </section>
        </main>
    </div>
</div>
</body>
</html>
