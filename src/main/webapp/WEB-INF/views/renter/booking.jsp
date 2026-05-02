<%@ page contentType="text/html;charset=UTF-8" language="java" %>
  <%@ page import="com.riderental.myriderental.model.User" %>
    <%@ page import="com.riderental.myriderental.model.Booking" %>
      <%@ page import="java.util.List" %>
        <% User bookingUser=(User) session.getAttribute("loggedInUser"); List<Booking> allBookings = (List<Booking>)
            request.getAttribute("allBookings");
            List<Booking> pendingBookings = (List<Booking>) request.getAttribute("pendingBookings");
                List<Booking> activeBookings = (List<Booking>) request.getAttribute("activeBookings");
                    List<Booking> completedBookings = (List<Booking>) request.getAttribute("completedBookings");
                        Integer totalBookings = (Integer) request.getAttribute("totalBookings");
                        Integer pendingCount = (Integer) request.getAttribute("pendingCount");
                        Integer activeCount = (Integer) request.getAttribute("activeCount");
                        Integer completedCount = (Integer) request.getAttribute("completedCount");
                        String successMessage = (String) request.getAttribute("successMessage");
                        String errorMessage = (String) request.getAttribute("errorMessage");

                        if (allBookings == null) allBookings = java.util.Collections.emptyList();
                        if (pendingBookings == null) pendingBookings = java.util.Collections.emptyList();
                        if (activeBookings == null) activeBookings = java.util.Collections.emptyList();
                        if (completedBookings == null) completedBookings = java.util.Collections.emptyList();

                        int tb = totalBookings == null ? allBookings.size() : totalBookings;
                        int pc = pendingCount == null ? pendingBookings.size() : pendingCount;
                        int ac = activeCount == null ? activeBookings.size() : activeCount;
                        int cc = completedCount == null ? completedBookings.size() : completedCount;

                        String firstName = "Rider";
                        if (bookingUser != null && bookingUser.getFullName() != null &&
                        !bookingUser.getFullName().isBlank()) {
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
                                    <h1 class="text-3xl font-semibold text-gray-900">Booking Requests</h1>
                                    <p class="text-sm mt-2 text-gray-500">Hey <span class="font-semibold text-red-800">
                                        <%= firstName %>
                                      </span>, review incoming requests for your listed vehicles.</p>

                                    <% if (successMessage !=null && !successMessage.isBlank()) { %>
                                      <div
                                        class="mt-4 rounded-xl border border-green-200 bg-green-50 px-4 py-3 text-sm text-green-800">
                                        <%= successMessage %>
                                      </div>
                                      <% } %>
                                        <% if (errorMessage !=null && !errorMessage.isBlank()) { %>
                                          <div
                                            class="mt-4 rounded-xl border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-800">
                                            <%= errorMessage %>
                                          </div>
                                          <% } %>

                                            <section class=" mt-6">
                                              <div class="grid gap-4 md:grid-cols-4">
                                                <article class="rounded-2xl bg-gray-50 p-4 ring-1 ring-gray-200">
                                                  <p class="text-sm font-semibold text-gray-500">Total Bookings</p>
                                                  <p class="mt-2 text-3xl font-semibold text-gray-900">
                                                    <%= tb %>
                                                  </p>
                                                </article>
                                                <article class="rounded-2xl bg-red-800 p-4 text-white shadow-sm">
                                                  <p class="text-sm font-semibold text-red-100">Pending</p>
                                                  <p class="mt-2 text-3xl font-semibold">
                                                    <%= pc %>
                                                  </p>
                                                </article>
                                                <article class="rounded-2xl bg-gray-50 p-4 ring-1 ring-gray-200">
                                                  <p class="text-sm font-semibold text-gray-500">Approved</p>
                                                  <p class="mt-2 text-3xl font-semibold text-gray-900">
                                                    <%= ac %>
                                                  </p>
                                                </article>
                                                <article class="rounded-2xl bg-gray-50 p-4 ring-1 ring-gray-200">
                                                  <p class="text-sm font-semibold text-gray-500">Completed</p>
                                                  <p class="mt-2 text-3xl font-semibold text-gray-900">
                                                    <%= cc %>
                                                  </p>
                                                </article>
                                              </div>
                                            </section>

                                            <section class="mt-6">
                                              <div class="grid gap-4">
                                                <% if (allBookings.isEmpty()) { %>
                                                  <article
                                                    class="rounded-2xl bg-white p-5 shadow-sm ring-1 ring-gray-200">
                                                    <p class="text-sm text-gray-600">No booking requests are available
                                                      yet.</p>
                                                  </article>
                                                  <% } %>

                                                    <% for (Booking booking : allBookings) { String
                                                      status=booking.getStatus()==null ? "PENDING" :
                                                      booking.getStatus().toUpperCase(); String
                                                      badgeClass="bg-blue-100 text-blue-800" ; if
                                                      ("APPROVED".equals(status)) badgeClass="bg-red-100 text-red-800" ;
                                                      if ("COMPLETED".equals(status))
                                                      badgeClass="bg-emerald-100 text-emerald-800" ; if
                                                      ("REJECTED".equals(status)) badgeClass="bg-gray-200 text-gray-700"
                                                      ; %>
                                                      <article
                                                        class="rounded-2xl bg-white p-5 shadow-sm ring-1 ring-gray-200">
                                                        <div class="flex flex-wrap items-start justify-between gap-3">
                                                          <div>
                                                            <h2 class="text-lg font-semibold text-gray-900">
                                                              <%= booking.getVehicleName() %>
                                                            </h2>
                                                            <p class="text-sm text-gray-500">Renter: <%=
                                                                booking.getRenterName()==null ? "-" :
                                                                booking.getRenterName() %>
                                                            </p>
                                                          </div>
                                                          <span
                                                            class="inline-flex rounded-full px-3 py-1 text-xs font-semibold <%= badgeClass %>">
                                                            <%= status %>
                                                          </span>
                                                        </div>
                                                        <div
                                                          class="mt-4 grid gap-3 text-sm text-gray-600 sm:grid-cols-3">
                                                          <p><span class="font-semibold text-gray-900">Booking
                                                              ID:</span> BK-<%= booking.getBookingId() %>
                                                          </p>
                                                          <p><span class="font-semibold text-gray-900">Date:</span>
                                                            <%= booking.getStartDate() %> to <%= booking.getEndDate() %>
                                                          </p>
                                                          <p><span class="font-semibold text-gray-900">Total:</span> Rs.
                                                            <%= String.format(java.util.Locale.US, "%,.2f" ,
                                                              booking.getTotalPrice()) %>
                                                          </p>
                                                        </div>
                                                        <% if ("PENDING".equals(status)) { %>
                                                          <div class="mt-4 flex flex-wrap gap-2">
                                                            <form
                                                              action="${pageContext.request.contextPath}/renter/booking/approve"
                                                              method="post">
                                                              <input type="hidden" name="bookingId"
                                                                value="<%= booking.getBookingId() %>" />
                                                              <button type="submit"
                                                                class="rounded-lg bg-red-800 px-3 py-2 text-xs font-semibold text-white transition hover:bg-red-900">Approve</button>
                                                            </form>
                                                            <form
                                                              action="${pageContext.request.contextPath}/renter/booking/reject"
                                                              method="post">
                                                              <input type="hidden" name="bookingId"
                                                                value="<%= booking.getBookingId() %>" />
                                                              <button type="submit"
                                                                class="rounded-lg border border-red-200 bg-red-50 px-3 py-2 text-xs font-semibold text-red-800 transition hover:bg-red-100">Reject</button>
                                                            </form>
                                                          </div>
                                                          <% } %>
                                                      </article>
                                                      <% } %>
                                              </div>
                                            </section>

                                            <section class="mt-6 grid gap-4 lg:grid-cols-2">
                                              <article
                                                class="rounded-xl border-l-4 border-red-800 bg-white p-5 shadow-sm ring-1 ring-gray-200">
                                                <h3 class="text-2xl font-semibold text-gray-900">Booking Policy</h3>
                                                <p class="mt-2 text-sm leading-6 text-gray-600">Cancellations made 24
                                                  hours before the trip are eligible for a full refund. Approved
                                                  bookings require a digital signature upon vehicle handover.</p>
                                                <button type="button" onclick="document.getElementById('termsModal').classList.remove('hidden')"
                                                  class="mt-3 inline-flex items-center text-sm font-semibold text-red-800 hover:text-red-900">Read
                                                  full terms -&gt;</button>
                                              </article>

                                              <article
                                                class="rounded-xl border-l-4 border-blue-700 bg-blue-50 p-5 shadow-sm ring-1 ring-blue-100">
                                                <h3 class="text-2xl font-semibold text-gray-900">Need Support?</h3>
                                                <p class="mt-2 text-sm leading-6 text-gray-600">Our premium support desk
                                                  is available 24/7 for active bookings. Facing issues with your current
                                                  ride? Contact our concierge service.</p>
                                                <a href="${pageContext.request.contextPath}/renter/chat"
                                                  class="mt-3 inline-block rounded-lg bg-blue-700 px-4 py-2 text-sm font-semibold text-white transition hover:bg-blue-800">Launch
                                                  Live Chat</a>
                                              </article>
                                            </section>
                                    </main>

                                    <!-- Terms Modal -->
                                    <div id="termsModal" class="hidden fixed inset-0 z-50 overflow-y-auto" aria-labelledby="modal-title" role="dialog" aria-modal="true">
                                      <div class="flex items-end justify-center min-h-screen pt-4 px-4 pb-20 text-center sm:block sm:p-0">
                                        <div class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity" aria-hidden="true" onclick="document.getElementById('termsModal').classList.add('hidden')"></div>
                                        <span class="hidden sm:inline-block sm:align-middle sm:h-screen" aria-hidden="true">&#8203;</span>
                                        <div class="inline-block align-bottom bg-white rounded-xl px-4 pt-5 pb-4 text-left overflow-hidden shadow-xl transform transition-all sm:my-8 sm:align-middle sm:max-w-2xl sm:w-full sm:p-6">
                                          <div>
                                            <div class="mt-3 text-center sm:mt-0 sm:ml-4 sm:text-left">
                                              <h3 class="text-xl leading-6 font-bold text-gray-900" id="modal-title">
                                                Full Terms of Booking Policy
                                              </h3>
                                              <div class="mt-4 space-y-4 text-sm text-gray-600">
                                                <p><strong>1. Cancellations:</strong> Cancellations made 24 hours before the trip are eligible for a full refund. Cancellations made within 24 hours will be charged a 50% cancellation fee.</p>
                                                <p><strong>2. Signatures:</strong> Approved bookings require a digital signature upon vehicle handover. The renter must be present with a valid ID.</p>
                                                <p><strong>3. Vehicle Condition:</strong> The vehicle must be returned in the same condition it was rented. Any damages will be charged to the renter.</p>
                                                <p><strong>4. Late Returns:</strong> Late returns will be subject to an hourly charge of 10% of the daily rental rate.</p>
                                              </div>
                                            </div>
                                          </div>
                                          <div class="mt-5 sm:mt-4 sm:flex sm:flex-row-reverse">
                                            <button type="button" onclick="document.getElementById('termsModal').classList.add('hidden')" class="w-full inline-flex justify-center rounded-md border border-transparent shadow-sm px-4 py-2 bg-red-800 text-base font-medium text-white hover:bg-red-900 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-red-500 sm:ml-3 sm:w-auto sm:text-sm">
                                              I Understand
                                            </button>
                                          </div>
                                        </div>
                                      </div>
                                    </div>

                              </div>
                          </div>
                        </body>

                        </html>