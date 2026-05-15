<%-- Created by IntelliJ IDEA. User: kusha Date: 4/13/2026 Time: 1:24 PM To change this template use File | Settings |
  File Templates. --%>
  <%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="com.riderental.myriderental.model.User" %>
    <%@ page import="java.util.List" %>
    <%@ page import="com.riderental.myriderental.model.Vehicle" %>
      <% User loggedInUser=(User) session.getAttribute("loggedInUser"); String role=(String)
        request.getAttribute("viewRole"); if ((role==null || role.isBlank()) && loggedInUser !=null &&
        loggedInUser.getRole() !=null) { role=loggedInUser.getRole().toLowerCase(); } boolean ownerView="owner"
        .equalsIgnoreCase(role); boolean renterView="renter" .equalsIgnoreCase(role); if (!ownerView && !renterView) {
        response.sendRedirect(request.getContextPath() + "/login" ); return; }
        String selectedLocation = (String) request.getAttribute("location");
        String selectedType = (String) request.getAttribute("type");
        String selectedStartDate = (String) request.getAttribute("startDate");
        String selectedEndDate = (String) request.getAttribute("endDate");
        String selectedMaxPrice = (String) request.getAttribute("maxPrice");
        if (selectedLocation == null) selectedLocation = "";
        if (selectedType == null) selectedType = "";
        if (selectedStartDate == null) selectedStartDate = "";
        if (selectedEndDate == null) selectedEndDate = "";
        if (selectedMaxPrice == null) selectedMaxPrice = "";
      %>
        <html>

        <head>
          <title>SajhaRide</title>
          <meta name="viewport" content="width=device-width, initial-scale=1.0" />
          <script src="https://cdn.tailwindcss.com"></script>
        </head>

        <body class="<%= ownerView || renterView ? " min-h-screen bg-gray-100 text-gray-900 lg:h-screen lg:overflow-hidden"
          : "bg-gray-100 text-gray-900" %>">
          <div class="flex h-full">
            <% if (ownerView) { %>
              <jsp:include page="../owner/components/sidebar.jsp" />
              <% } else { %>
                <jsp:include page="../renter/components/sidebar.jsp" />
                <% } %>

                  <div class="flex min-w-0 flex-1 flex-col overflow-hidden">
                    <% if (ownerView) { %>
                      <jsp:include page="../owner/components/topbar.jsp" />
                      <% } else { %>
                        <jsp:include page="../renter/components/topbar.jsp" />
                        <% } %>

                          <main class="flex-1 overflow-y-auto px-4 py-6 sm:px-6 lg:px-8">
                            <form action="<%= request.getContextPath() %>/explore" method="get" class="rounded-2xl border border-red-100 bg-white p-4 shadow-sm">
                              <div class="grid grid-cols-1 gap-3 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-5">
                                <div>
                                  <label for="exploreLocation" class="mb-1 block text-[11px] font-semibold uppercase tracking-[0.12em] text-gray-500">
                                    Pick Up Location</label>
                                  <select id="exploreLocation" name="location"
                                    class="w-full rounded-xl border border-gray-200 bg-gray-50 px-3 py-2.5 text-sm focus:border-red-300 focus:outline-none focus:ring-2 focus:ring-red-100">
                                    <option value="">All Locations</option>
                                    <option value="Kathmandu" <%= "Kathmandu".equalsIgnoreCase(selectedLocation) ? "selected" : "" %>>Kathmandu</option>
                                    <option value="Pokhara" <%= "Pokhara".equalsIgnoreCase(selectedLocation) ? "selected" : "" %>>Pokhara</option>
                                    <option value="Bhaktapur" <%= "Bhaktapur".equalsIgnoreCase(selectedLocation) ? "selected" : "" %>>Bhaktapur</option>
                                    <option value="Lalitpur" <%= "Lalitpur".equalsIgnoreCase(selectedLocation) ? "selected" : "" %>>Lalitpur</option>
                                  </select>
                                </div>
                                <div>
                                  <label for="exploreType" class="mb-1 block text-[11px] font-semibold uppercase tracking-[0.12em] text-gray-500">
                                    Vehicle Category</label>
                                  <select id="exploreType" name="type"
                                    class="w-full rounded-xl border border-gray-200 bg-gray-50 px-3 py-2.5 text-sm focus:border-red-300 focus:outline-none focus:ring-2 focus:ring-red-100">
                                    <option value="">All Types</option>
                                    <option value="CAR" <%= "CAR".equalsIgnoreCase(selectedType) ? "selected" : "" %>>Car</option>
                                    <option value="BIKE" <%= "BIKE".equalsIgnoreCase(selectedType) ? "selected" : "" %>>Bike</option>
                                    <option value="SCOOTER" <%= "SCOOTER".equalsIgnoreCase(selectedType) ? "selected" : "" %>>Scooter</option>
                                    <option value="VAN" <%= "VAN".equalsIgnoreCase(selectedType) ? "selected" : "" %>>Van</option>
                                    <option value="TRUCK" <%= "TRUCK".equalsIgnoreCase(selectedType) ? "selected" : "" %>>Truck</option>
                                  </select>
                                </div>
                                <div>
                                  <label for="exploreStartDate" class="mb-1 block text-[11px] font-semibold uppercase tracking-[0.12em] text-gray-500">
                                    Start Date</label>
                                  <input id="exploreStartDate" name="startDate" type="date" value="<%= selectedStartDate %>"
                                    class="w-full rounded-xl border border-gray-200 bg-gray-50 px-3 py-2.5 text-sm text-gray-700 focus:border-red-300 focus:outline-none focus:ring-2 focus:ring-red-100" />
                                </div>
                                <div>
                                  <label for="exploreEndDate" class="mb-1 block text-[11px] font-semibold uppercase tracking-[0.12em] text-gray-500">
                                    End Date</label>
                                  <input id="exploreEndDate" name="endDate" type="date" value="<%= selectedEndDate %>"
                                    class="w-full rounded-xl border border-gray-200 bg-gray-50 px-3 py-2.5 text-sm text-gray-700 focus:border-red-300 focus:outline-none focus:ring-2 focus:ring-red-100" />
                                </div>
                                <div>
                                  <label for="exploreMaxPrice" class="mb-1 block text-[11px] font-semibold uppercase tracking-[0.12em] text-gray-500">
                                    Budget Per Day</label>
                                  <select id="exploreMaxPrice" name="maxPrice"
                                    class="w-full rounded-xl border border-gray-200 bg-gray-50 px-3 py-2.5 text-sm focus:border-red-300 focus:outline-none focus:ring-2 focus:ring-red-100">
                                    <option value="">Any Price</option>
                                    <option value="2000" <%= "2000".equals(selectedMaxPrice) ? "selected" : "" %>>Under NPR 2,000</option>
                                    <option value="5000" <%= "5000".equals(selectedMaxPrice) ? "selected" : "" %>>Under NPR 5,000</option>
                                    <option value="10000" <%= "10000".equals(selectedMaxPrice) ? "selected" : "" %>>Under NPR 10,000</option>
                                  </select>
                                </div>
                                <div class="flex items-end sm:col-span-2 lg:col-span-1">
                                  <button type="submit"
                                    class="w-full rounded-xl bg-red-800 px-4 py-2.5 text-sm font-semibold text-white transition hover:bg-red-900">Update
                                    Search</button>
                                </div>
                              </div>
                            </form>

                            <section class="mt-6">
                              <div class="mb-4 flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between">
                                <div>
                                  <h1 class="text-3xl font-semibold tracking-tight text-gray-900">Explore Vehicle</h1>
                                  <p class="mt-1 text-sm text-gray-600">Browse verified rides for your next
                                    adventure.</p>
                                </div>
                                <div class="flex items-center gap-2">
                                  <button
                                    class="w-full rounded-lg border border-red-300 bg-red-50 px-3 py-1.5 text-xs font-semibold text-red-800 sm:w-auto">Grid</button>
                                  <button
                                    class="w-full rounded-lg border border-gray-200 bg-white px-3 py-1.5 text-xs font-medium text-gray-600 sm:w-auto">List</button>
                                </div>
                              </div>

                              <div class="grid grid-cols-1 gap-4 md:grid-cols-2 xl:grid-cols-3">
                                <% 
                                List<Vehicle> exploreVehicles = (List<Vehicle>) request.getAttribute("vehicles");
                                if (exploreVehicles != null && !exploreVehicles.isEmpty()) {
                                    for (Vehicle v : exploreVehicles) {
                                        String imgPath = v.getImagePath();
                                        if (imgPath == null || imgPath.isBlank()) {
                                            imgPath = "images/about.png";
                                        } else {
                                            imgPath = imgPath.replace("\\", "/");
                                            if (imgPath.startsWith("/")) imgPath = imgPath.substring(1);
                                            if (!imgPath.startsWith("uploads/") && !imgPath.startsWith("images/")) {
                                                imgPath = "uploads/" + imgPath;
                                            }
                                        }
                                %>
                                <article class="overflow-hidden rounded-2xl border border-red-100 bg-white shadow-sm transition hover:shadow-md hover:-translate-y-1">
                                  <div class="relative">
                                    <img src="${pageContext.request.contextPath}/<%= imgPath %>"
                                      alt="<%= v.getVehicleName() %>" class="h-44 w-full object-cover" />
                                    <span
                                      class="absolute left-3 top-3 rounded-full bg-emerald-700 px-3 py-1 text-[10px] font-semibold uppercase tracking-wide text-white"><%= "AVAILABLE".equalsIgnoreCase(v.getAvailabilityStatus()) ? "Available Now" : v.getAvailabilityStatus() %></span>
                                  </div>
                                  <div class="p-4">
                                    <p class="text-[11px] font-semibold uppercase tracking-[0.12em] text-red-700"><%= v.getVehicleType() %>
                                    </p>
                                    <div class="mt-1 flex items-start justify-between gap-3">
                                      <h2 class="text-xl font-semibold leading-tight text-gray-900 line-clamp-1"><%= v.getVehicleName() %>
                                      </h2>
                                      <p class="text-right text-xs text-gray-500 whitespace-nowrap">Daily rate<br><span
                                          class="text-lg font-semibold text-red-800">Rs. <%= String.format(java.util.Locale.US, "%,.2f", v.getPricePerDay()) %></span></p>
                                    </div>
                                    <p class="mt-3 text-xs text-gray-600"><%= v.getLocation() %></p>
                                    <p class="mt-2 text-sm text-gray-700 line-clamp-2"><%= v.getDescription() %></p>
                                    <% if (renterView) { %>
                                    <a href="<%= request.getContextPath() %>/vehicle-details?id=<%= v.getVehicleId() %>"
                                      class="mt-4 block w-full rounded-xl bg-red-800 px-4 py-2.5 text-center text-sm font-semibold text-white hover:bg-red-900">View
                                      Details</a>
                                    <% } else { %>
                                    <a href="<%= request.getContextPath() %>/vehicle-details?id=<%= v.getVehicleId() %>"
                                      class="mt-4 block w-full rounded-xl bg-red-800 px-4 py-2.5 text-center text-sm font-semibold text-white hover:bg-red-900">Book
                                      Now</a>
                                    <% } %>
                                  </div>
                                </article>
                                <% 
                                    }
                                } else { 
                                %>
                                <div class="col-span-full py-12 text-center text-gray-500">
                                    No vehicles available to explore right now.
                                </div>
                                <% } %>
                              </div>

                              <div class="mt-8 flex justify-center">
                                <button
                                  class="rounded-xl border border-red-300 bg-white px-6 py-2.5 text-sm font-semibold text-red-800 transition hover:bg-red-50">Load
                                  More</button>
                              </div>
                            </section>
                          </main>
                  </div>
          </div>
        </body>

        </html>
