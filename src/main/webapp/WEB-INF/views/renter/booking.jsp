<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.riderental.myriderental.model.User" %>
<%
  User bookingUser = (User) session.getAttribute("loggedInUser");
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
</head>
<body class="h-screen overflow-hidden bg-gray-50 text-gray-900">
<div class="flex h-full">
  <%@ include file="/WEB-INF/views/renter/components/sidebar.jsp" %>

  <div class="flex min-w-0 flex-1 flex-col">
    <%@ include file="/WEB-INF/views/renter/components/topbar.jsp" %>

    <main class="flex-1 overflow-y-auto p-6 lg:p-8">
      <h1 class="text-3xl font-semibold text-gray-900">My Bookings</h1>
      <p class="text-sm mt-2 text-gray-500">Hey <span class="font-semibold text-red-800"><%= firstName %></span>, track your ride status and booking details here.</p>

      <section class=" mt-6">
        <div class="grid gap-4 md:grid-cols-3">
          <article class="rounded-2xl bg-gray-50 p-4 ring-1 ring-gray-200">
            <p class="text-sm font-semibold text-gray-500">Total Bookings</p>
            <p class="mt-2 text-3xl font-semibold text-gray-900">12</p>
          </article>
          <article class="rounded-2xl bg-red-800 p-4 text-white shadow-sm">
            <p class="text-sm font-semibold text-red-100">Active</p>
            <p class="mt-2 text-3xl font-semibold">2</p>
          </article>
          <article class="rounded-2xl bg-gray-50 p-4 ring-1 ring-gray-200">
            <p class="text-sm font-semibold text-gray-500">Completed</p>
            <p class="mt-2 text-3xl font-semibold text-gray-900">10</p>
          </article>
        </div>
      </section>

      <section class="mt-6">
        <div class="grid gap-4">
          <article class="rounded-2xl bg-white p-5 shadow-sm ring-1 ring-gray-200">
            <div class="flex flex-wrap items-start justify-between gap-3">
              <div>
                <h2 class="text-lg font-semibold text-gray-900">Honda Activa 6G</h2>
                <p class="text-sm text-gray-500">Pickup: Kalanki, Kathmandu</p>
              </div>
              <span class="inline-flex rounded-full bg-red-100 px-3 py-1 text-xs font-semibold text-red-800">Active</span>
            </div>
            <div class="mt-4 grid gap-3 text-sm text-gray-600 sm:grid-cols-3">
              <p><span class="font-semibold text-gray-900">Booking ID:</span> BK-10231</p>
              <p><span class="font-semibold text-gray-900">Date:</span> Apr 17, 2026</p>
              <p><span class="font-semibold text-gray-900">Total:</span> Rs. 1,200</p>
            </div>
            <div class="mt-4 flex flex-wrap gap-2">
              <button type="button" class="rounded-lg bg-red-800 px-3 py-2 text-xs font-semibold text-white transition hover:bg-red-900">View Details</button>
              <button type="button" class="rounded-lg border border-red-200 bg-red-50 px-3 py-2 text-xs font-semibold text-red-800 transition hover:bg-red-100">Cancel Booking</button>
            </div>
          </article>

          <article class="rounded-2xl bg-white p-5 shadow-sm ring-1 ring-gray-200">
            <div class="flex flex-wrap items-start justify-between gap-3">
              <div>
                <h2 class="text-lg font-semibold text-gray-900">Suzuki Swift</h2>
                <p class="text-sm text-gray-500">Pickup: Gwarko, Lalitpur</p>
              </div>
              <span class="inline-flex rounded-full bg-emerald-100 px-3 py-1 text-xs font-semibold text-emerald-800">Completed</span>
            </div>
            <div class="mt-4 grid gap-3 text-sm text-gray-600 sm:grid-cols-3">
              <p><span class="font-semibold text-gray-900">Booking ID:</span> BK-10082</p>
              <p><span class="font-semibold text-gray-900">Date:</span> Apr 10, 2026</p>
              <p><span class="font-semibold text-gray-900">Total:</span> Rs. 4,500</p>
            </div>
            <div class="mt-4 flex flex-wrap gap-2">
              <button type="button" class="rounded-lg bg-gray-100 px-3 py-2 text-xs font-semibold text-gray-700 transition hover:bg-gray-200">View Receipt</button>
              <button type="button" class="rounded-lg border border-red-200 bg-red-50 px-3 py-2 text-xs font-semibold text-red-800 transition hover:bg-red-100">Book Again</button>
            </div>
          </article>

          <article class="rounded-2xl bg-white p-5 shadow-sm ring-1 ring-gray-200">
            <div class="flex flex-wrap items-start justify-between gap-3">
              <div>
                <h2 class="text-lg font-semibold text-gray-900">Yamaha FZS</h2>
                <p class="text-sm text-gray-500">Pickup: Bhaktapur Durbar Area</p>
              </div>
              <span class="inline-flex rounded-full bg-blue-100 px-3 py-1 text-xs font-semibold text-blue-800">Pending</span>
            </div>
            <div class="mt-4 grid gap-3 text-sm text-gray-600 sm:grid-cols-3">
              <p><span class="font-semibold text-gray-900">Booking ID:</span> BK-10304</p>
              <p><span class="font-semibold text-gray-900">Date:</span> Apr 19, 2026</p>
              <p><span class="font-semibold text-gray-900">Total:</span> Rs. 2,250</p>
            </div>
            <div class="mt-4 flex flex-wrap gap-2">
              <button type="button" class="rounded-lg bg-red-800 px-3 py-2 text-xs font-semibold text-white transition hover:bg-red-900">Track Status</button>
              <button type="button" class="rounded-lg border border-gray-200 bg-white px-3 py-2 text-xs font-semibold text-gray-700 transition hover:bg-gray-50">Contact Owner</button>
            </div>
          </article>
        </div>
      </section>

      <section class="mt-6 grid gap-4 lg:grid-cols-2">
        <article class="rounded-xl border-l-4 border-red-800 bg-white p-5 shadow-sm ring-1 ring-gray-200">
          <h3 class="text-2xl font-semibold text-gray-900">Booking Policy</h3>
          <p class="mt-2 text-sm leading-6 text-gray-600">Cancellations made 24 hours before the trip are eligible for a full refund. Approved bookings require a digital signature upon vehicle handover.</p>
          <a href="#" class="mt-3 inline-flex items-center text-sm font-semibold text-red-800 hover:text-red-900">Read full terms -&gt;</a>
        </article>

        <article class="rounded-xl border-l-4 border-blue-700 bg-blue-50 p-5 shadow-sm ring-1 ring-blue-100">
          <h3 class="text-2xl font-semibold text-gray-900">Need Support?</h3>
          <p class="mt-2 text-sm leading-6 text-gray-600">Our premium support desk is available 24/7 for active bookings. Facing issues with your current ride? Contact our concierge service.</p>
          <button type="button" class="mt-3 rounded-lg bg-blue-700 px-4 py-2 text-sm font-semibold text-white transition hover:bg-blue-800">Launch Live Chat</button>
        </article>
      </section>
    </main>
  </div>
</div>
</body>
</html>
