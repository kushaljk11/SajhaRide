<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.riderental.myriderental.model.User" %>
<%@ page import="com.riderental.myriderental.model.Booking" %>
<%@ page import="java.util.List" %>
<% 
    User bookingUser = (User) session.getAttribute("loggedInUser");
    List<Booking> ownerBookings = (List<Booking>) request.getAttribute("ownerBookings");
    List<Booking> renterBookings = (List<Booking>) request.getAttribute("renterBookings");
    
    Integer totalRequests = (Integer) request.getAttribute("totalRequests");
    Integer pendingCount = (Integer) request.getAttribute("pendingCount");
    Integer activeCount = (Integer) request.getAttribute("activeCount");
    Integer completedCount = (Integer) request.getAttribute("completedCount");
    Integer totalTrips = (Integer) request.getAttribute("totalTrips");
    
    String successMessage = (String) request.getAttribute("successMessage");
    String errorMessage = (String) request.getAttribute("errorMessage");

    if (ownerBookings == null) ownerBookings = java.util.Collections.emptyList();
    if (renterBookings == null) renterBookings = java.util.Collections.emptyList();

    int tr = totalRequests == null ? ownerBookings.size() : totalRequests;
    int pc = pendingCount == null ? 0 : pendingCount;
    int ac = activeCount == null ? 0 : activeCount;
    int cc = completedCount == null ? 0 : completedCount;

    String firstName = "Rider";
    if (bookingUser != null && bookingUser.getFullName() != null && !bookingUser.getFullName().isBlank()) {
        String[] nameParts = bookingUser.getFullName().trim().split("\\s+");
        firstName = nameParts[0];
    }
%>
<html>
<head>
    <title>My Bookings | SajhaRide</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <script>
        function switchTab(tabId) {
            document.querySelectorAll('.tab-content').forEach(el => el.classList.add('hidden'));
            document.querySelectorAll('.tab-btn').forEach(el => {
                el.classList.remove('border-red-800', 'text-red-800');
                el.classList.add('border-transparent', 'text-gray-500', 'hover:text-gray-700', 'hover:border-gray-300');
            });
            document.getElementById(tabId).classList.remove('hidden');
            const activeBtn = document.getElementById('btn-' + tabId);
            activeBtn.classList.remove('border-transparent', 'text-gray-500', 'hover:text-gray-700', 'hover:border-gray-300');
            activeBtn.classList.add('border-red-800', 'text-red-800');
        }
    </script>
</head>
<body class="h-screen overflow-hidden bg-gray-50 text-gray-900">
    <div class="flex h-full">
        <%@ include file="/WEB-INF/views/renter/components/sidebar.jsp" %>
        <div class="flex min-w-0 flex-1 flex-col">
            <%@ include file="/WEB-INF/views/renter/components/topbar.jsp" %>
            <main class="flex-1 overflow-y-auto p-6 lg:p-8">
                <div class="sm:flex sm:items-center sm:justify-between">
                    <div>
                        <h1 class="text-3xl font-semibold text-gray-900">My Bookings</h1>
                        <p class="text-sm mt-2 text-gray-500">Hey <span class="font-semibold text-red-800"><%= firstName %></span>, manage your trips and incoming requests here.</p>
                    </div>
                </div>

                <% if (successMessage != null && !successMessage.isBlank()) { %>
                    <div class="mt-4 rounded-xl border border-green-200 bg-green-50 px-4 py-3 text-sm text-green-800"><%= successMessage %></div>
                <% } %>
                <% if (errorMessage != null && !errorMessage.isBlank()) { %>
                    <div class="mt-4 rounded-xl border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-800"><%= errorMessage %></div>
                <% } %>

                <div class="mt-6 border-b border-gray-200">
                    <nav class="-mb-px flex space-x-8" aria-label="Tabs">
                        <button id="btn-tab-trips" onclick="switchTab('tab-trips')" class="tab-btn whitespace-nowrap border-b-2 py-4 px-1 text-sm font-medium border-red-800 text-red-800">My Trips</button>
                        <button id="btn-tab-requests" onclick="switchTab('tab-requests')" class="tab-btn whitespace-nowrap border-b-2 py-4 px-1 text-sm font-medium border-transparent text-gray-500 hover:border-gray-300 hover:text-gray-700">Incoming Requests</button>
                    </nav>
                </div>

                <!-- My Trips Tab -->
                <div id="tab-trips" class="tab-content mt-6">
                    <div class="grid gap-4">
                        <% if (renterBookings.isEmpty()) { %>
                            <article class="rounded-2xl bg-white p-8 text-center shadow-sm ring-1 ring-gray-200">
                                <p class="text-gray-600">You haven't booked any rides yet.</p>
                                <a href="${pageContext.request.contextPath}/explore" class="mt-4 inline-block font-semibold text-red-800 hover:text-red-900">Start exploring</a>
                            </article>
                        <% } else { %>
                            <% for (Booking booking : renterBookings) { 
                                String status = booking.getStatus() == null ? "PENDING" : booking.getStatus().toUpperCase();
                                String badgeClass = "bg-blue-100 text-blue-800";
                                if ("APPROVED".equals(status)) badgeClass = "bg-red-100 text-red-800";
                                if ("COMPLETED".equals(status)) badgeClass = "bg-emerald-100 text-emerald-800";
                                if ("REJECTED".equals(status)) badgeClass = "bg-gray-200 text-gray-700";
                            %>
                            <article class="rounded-2xl bg-white p-5 shadow-sm ring-1 ring-gray-200 transition hover:-translate-y-0.5 hover:shadow-md">
                                <div class="flex flex-wrap items-start justify-between gap-3">
                                    <div>
                                        <h2 class="text-lg font-semibold text-gray-900"><%= booking.getVehicleName() %></h2>
                                        <p class="text-sm text-gray-500">Vehicle Type: <%= booking.getVehicleType() %></p>
                                    </div>
                                    <span class="inline-flex rounded-full px-3 py-1 text-xs font-semibold <%= badgeClass %>"><%= status %></span>
                                </div>
                                <div class="mt-4 grid gap-3 text-sm text-gray-600 sm:grid-cols-3">
                                    <p><span class="font-semibold text-gray-900">Booking ID:</span> BK-<%= booking.getBookingId() %></p>
                                    <p><span class="font-semibold text-gray-900">Date:</span> <%= booking.getStartDate() %> to <%= booking.getEndDate() %></p>
                                    <p><span class="font-semibold text-gray-900">Total:</span> Rs. <%= String.format(java.util.Locale.US, "%,.2f", booking.getTotalPrice()) %></p>
                                </div>
                            </article>
                            <% } } %>
                    </div>
                </div>

                <!-- Incoming Requests Tab -->
                <div id="tab-requests" class="tab-content hidden mt-6">
                    <div class="grid gap-4 md:grid-cols-4 mb-6">
                        <article class="rounded-2xl bg-gray-50 p-4 ring-1 ring-gray-200">
                            <p class="text-sm font-semibold text-gray-500">Total Requests</p>
                            <p class="mt-2 text-3xl font-semibold text-gray-900"><%= tr %></p>
                        </article>
                        <article class="rounded-2xl bg-red-800 p-4 text-white shadow-sm">
                            <p class="text-sm font-semibold text-red-100">Pending</p>
                            <p class="mt-2 text-3xl font-semibold"><%= pc %></p>
                        </article>
                        <article class="rounded-2xl bg-gray-50 p-4 ring-1 ring-gray-200">
                            <p class="text-sm font-semibold text-gray-500">Approved</p>
                            <p class="mt-2 text-3xl font-semibold text-gray-900"><%= ac %></p>
                        </article>
                        <article class="rounded-2xl bg-gray-50 p-4 ring-1 ring-gray-200">
                            <p class="text-sm font-semibold text-gray-500">Completed</p>
                            <p class="mt-2 text-3xl font-semibold text-gray-900"><%= cc %></p>
                        </article>
                    </div>

                    <div class="grid gap-4">
                        <% if (ownerBookings.isEmpty()) { %>
                            <article class="rounded-2xl bg-white p-5 shadow-sm ring-1 ring-gray-200 text-center">
                                <p class="text-sm text-gray-600">No booking requests are available yet.</p>
                            </article>
                        <% } else { %>
                            <% for (Booking booking : ownerBookings) { 
                                String status = booking.getStatus() == null ? "PENDING" : booking.getStatus().toUpperCase();
                                String badgeClass = "bg-blue-100 text-blue-800";
                                if ("APPROVED".equals(status)) badgeClass = "bg-red-100 text-red-800";
                                if ("COMPLETED".equals(status)) badgeClass = "bg-emerald-100 text-emerald-800";
                                if ("REJECTED".equals(status)) badgeClass = "bg-gray-200 text-gray-700";
                            %>
                            <article class="rounded-2xl bg-white p-5 shadow-sm ring-1 ring-gray-200 transition hover:-translate-y-0.5 hover:shadow-md">
                                <div class="flex flex-wrap items-start justify-between gap-3">
                                    <div>
                                        <h2 class="text-lg font-semibold text-gray-900"><%= booking.getVehicleName() %></h2>
                                        <p class="text-sm text-gray-500">Renter: <%= booking.getRenterName() == null ? "-" : booking.getRenterName() %></p>
                                    </div>
                                    <span class="inline-flex rounded-full px-3 py-1 text-xs font-semibold <%= badgeClass %>"><%= status %></span>
                                </div>
                                <div class="mt-4 grid gap-3 text-sm text-gray-600 sm:grid-cols-3">
                                    <p><span class="font-semibold text-gray-900">Booking ID:</span> BK-<%= booking.getBookingId() %></p>
                                    <p><span class="font-semibold text-gray-900">Date:</span> <%= booking.getStartDate() %> to <%= booking.getEndDate() %></p>
                                    <p><span class="font-semibold text-gray-900">Total:</span> Rs. <%= String.format(java.util.Locale.US, "%,.2f", booking.getTotalPrice()) %></p>
                                </div>
                                <% if ("PENDING".equals(status)) { %>
                                    <div class="mt-4 flex flex-wrap gap-2 border-t border-gray-100 pt-4">
                                        <form action="${pageContext.request.contextPath}/renter/booking/approve" method="post">
                                            <input type="hidden" name="bookingId" value="<%= booking.getBookingId() %>" />
                                            <button type="submit" class="rounded-lg bg-red-800 px-4 py-2 text-sm font-semibold text-white transition hover:bg-red-900">Approve</button>
                                        </form>
                                        <form action="${pageContext.request.contextPath}/renter/booking/reject" method="post">
                                            <input type="hidden" name="bookingId" value="<%= booking.getBookingId() %>" />
                                            <button type="submit" class="rounded-lg border border-red-200 bg-red-50 px-4 py-2 text-sm font-semibold text-red-800 transition hover:bg-red-100">Reject</button>
                                        </form>
                                    </div>
                                <% } %>
                            </article>
                            <% } } %>
                    </div>
                </div>
            </main>
        </div>
    </div>
</body>
</html>