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
        response.sendRedirect(request.getContextPath() + "/login" ); return; } %>
        <html>

        <head>
          <title>SajhaRide</title>
          <script src="https://cdn.tailwindcss.com"></script>
        </head>

        <body class="<%= ownerView || renterView ? " h-screen overflow-hidden bg-gray-100 text-gray-900"
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
                            <section class="rounded-2xl border border-red-100 bg-white p-4 shadow-sm">
                              <div class="grid grid-cols-1 gap-3 md:grid-cols-2 xl:grid-cols-5">
                                <div>
                                  <p class="mb-1 text-[11px] font-semibold uppercase tracking-[0.12em] text-gray-500">
                                    Pick Up Location</p>
                                  <select
                                    class="w-full rounded-xl border border-gray-200 bg-gray-50 px-3 py-2.5 text-sm focus:border-red-300 focus:outline-none focus:ring-2 focus:ring-red-100">
                                    <option>Kathmandu</option>
                                    <option>Pokhara</option>
                                    <option>Bhaktapur</option>
                                    <option>Lalitpur</option>
                                  </select>
                                </div>
                                <div>
                                  <p class="mb-1 text-[11px] font-semibold uppercase tracking-[0.12em] text-gray-500">
                                    Vehicle Category</p>
                                  <select
                                    class="w-full rounded-xl border border-gray-200 bg-gray-50 px-3 py-2.5 text-sm focus:border-red-300 focus:outline-none focus:ring-2 focus:ring-red-100">
                                    <option>All Types</option>
                                    <option>SUV</option>
                                    <option>Bike</option>
                                    <option>Scooter</option>
                                  </select>
                                </div>
                                <div>
                                  <p class="mb-1 text-[11px] font-semibold uppercase tracking-[0.12em] text-gray-500">
                                    Rental Period</p>
                                  <input type="text" value="Select dates"
                                    class="w-full rounded-xl border border-gray-200 bg-gray-50 px-3 py-2.5 text-sm text-gray-500 focus:border-red-300 focus:outline-none focus:ring-2 focus:ring-red-100" />
                                </div>
                                <div>
                                  <p class="mb-1 text-[11px] font-semibold uppercase tracking-[0.12em] text-gray-500">
                                    Budget Per Day</p>
                                  <select
                                    class="w-full rounded-xl border border-gray-200 bg-gray-50 px-3 py-2.5 text-sm focus:border-red-300 focus:outline-none focus:ring-2 focus:ring-red-100">
                                    <option>Any Price</option>
                                    <option>Under NPR 2,000</option>
                                    <option>Under NPR 5,000</option>
                                    <option>Under NPR 10,000</option>
                                  </select>
                                </div>
                                <div class="flex items-end">
                                  <button
                                    class="w-full rounded-xl bg-red-800 px-4 py-2.5 text-sm font-semibold text-white transition hover:bg-red-900">Update
                                    Search</button>
                                </div>
                              </div>
                            </section>

                            <section class="mt-6">
                              <div class="mb-4 flex items-center justify-between gap-3">
                                <div>
                                  <h1 class="text-3xl font-semibold tracking-tight text-gray-900">Explore Vehicle</h1>
                                  <p class="mt-1 text-sm text-gray-600">Browse 128 verified rides for your next
                                    Himalayan adventure.</p>
                                </div>
                                <div class="hidden items-center gap-2 sm:flex">
                                  <button
                                    class="rounded-lg border border-red-300 bg-red-50 px-3 py-1.5 text-xs font-semibold text-red-800">Grid</button>
                                  <button
                                    class="rounded-lg border border-gray-200 bg-white px-3 py-1.5 text-xs font-medium text-gray-600">List</button>
                                </div>
                              </div>

                              <div class="grid grid-cols-1 gap-4 md:grid-cols-2 xl:grid-cols-3">
                                <article class="overflow-hidden rounded-2xl border border-red-100 bg-white shadow-sm">
                                  <div class="relative">
                                    <img src="${pageContext.request.contextPath}/images/about.png"
                                      alt="Mahindra Scorpio N" class="h-44 w-full object-cover" />
                                    <span
                                      class="absolute left-3 top-3 rounded-full bg-emerald-700 px-3 py-1 text-[10px] font-semibold uppercase tracking-wide text-white">Available
                                      Now</span>
                                  </div>
                                  <div class="p-4">
                                    <p class="text-[11px] font-semibold uppercase tracking-[0.12em] text-red-700">SUV
                                    </p>
                                    <div class="mt-1 flex items-start justify-between gap-3">
                                      <h2 class="text-xl font-semibold leading-tight text-gray-900">Mahindra Scorpio N
                                      </h2>
                                      <p class="text-right text-xs text-gray-500">Daily rate<br><span
                                          class="text-lg font-semibold text-red-800">Rs. 6,500</span></p>
                                    </div>
                                    <p class="mt-3 text-xs text-gray-600">Kathmandu • Manual • 7 Seats</p>
                                    <p class="mt-2 text-sm text-gray-700">Comfortable and reliable SUV suitable for family trips and mountain roads.</p>
                                    <% if (renterView) { %>
                                    <a href="<%= request.getContextPath() %>/vehicle-details?id=1"
                                      class="mt-4 block w-full rounded-xl bg-red-800 px-4 py-2.5 text-center text-sm font-semibold text-white hover:bg-red-900">View
                                      Details</a>
                                    <% } else { %>
                                    <button
                                      class="mt-4 w-full rounded-xl bg-red-800 px-4 py-2.5 text-sm font-semibold text-white hover:bg-red-900">Book
                                      Now</button>
                                    <% } %>
                                  </div>
                                </article>

                                <article class="overflow-hidden rounded-2xl border border-red-100 bg-white shadow-sm">
                                  <div class="relative">
                                    <img src="${pageContext.request.contextPath}/images/register.png"
                                      alt="Royal Enfield Classic" class="h-44 w-full object-cover" />
                                    <span
                                      class="absolute left-3 top-3 rounded-full bg-emerald-700 px-3 py-1 text-[10px] font-semibold uppercase tracking-wide text-white">Available
                                      Now</span>
                                  </div>
                                  <div class="p-4">
                                    <p class="text-[11px] font-semibold uppercase tracking-[0.12em] text-red-700">
                                      Cruiser</p>
                                    <div class="mt-1 flex items-start justify-between gap-3">
                                      <h2 class="text-xl font-semibold leading-tight text-gray-900">Royal Enfield
                                        Classic</h2>
                                      <p class="text-right text-xs text-gray-500">Daily rate<br><span
                                          class="text-lg font-semibold text-red-800">Rs. 2,500</span></p>
                                    </div>
                                    <p class="mt-3 text-xs text-gray-600">Lalitpur • 350cc • Petrol</p>
                                      <p class="mt-2 text-sm text-gray-700">Classic cruiser with a comfortable ride and strong mid-range torque — great for weekend rides.</p>
                                      <% if (renterView) { %>
                                      <a href="<%= request.getContextPath() %>/vehicle-details?id=2"
                                        class="mt-4 block w-full rounded-xl bg-red-800 px-4 py-2.5 text-center text-sm font-semibold text-white hover:bg-red-900">View
                                        Details</a>
                                      <% } else { %>
                                      <button
                                        class="mt-4 w-full rounded-xl bg-red-800 px-4 py-2.5 text-sm font-semibold text-white hover:bg-red-900">Book
                                        Now</button>
                                      <% } %>
                                  </div>
                                </article>

                                <article class="overflow-hidden rounded-2xl border border-red-100 bg-white shadow-sm">
                                  <div class="relative">
                                    <img src="${pageContext.request.contextPath}/images/about.png"
                                      alt="Hyundai Grand i10" class="h-44 w-full object-cover" />
                                    <span
                                      class="absolute left-3 top-3 rounded-full bg-gray-800 px-3 py-1 text-[10px] font-semibold uppercase tracking-wide text-white">Booked
                                      Today</span>
                                  </div>
                                  <div class="p-4">
                                    <p class="text-[11px] font-semibold uppercase tracking-[0.12em] text-red-700">
                                      Hatchback</p>
                                    <div class="mt-1 flex items-start justify-between gap-3">
                                      <h2 class="text-xl font-semibold leading-tight text-gray-900">Hyundai Grand i10
                                      </h2>
                                      <p class="text-right text-xs text-gray-500">Daily rate<br><span
                                          class="text-lg font-semibold text-red-800">Rs. 4,000</span></p>
                                    </div>
                                    <p class="mt-3 text-xs text-gray-600">Kathmandu • Automatic • 5 Seats</p>
                                      <p class="mt-2 text-sm text-gray-700">Compact and fuel-efficient hatchback perfect for city commuting and short trips.</p>
                                      <% if (renterView) { %>
                                      <a href="<%= request.getContextPath() %>/vehicle-details?id=3"
                                        class="mt-4 block w-full rounded-xl bg-red-800 px-4 py-2.5 text-center text-sm font-semibold text-white hover:bg-red-900">View
                                        Details</a>
                                      <% } else { %>
                                      <button
                                        class="mt-4 w-full rounded-xl bg-red-800 px-4 py-2.5 text-sm font-semibold text-white hover:bg-red-900">Book
                                        Now</button>
                                      <% } %>
                                  </div>
                                </article>

                                <article class="overflow-hidden rounded-2xl border border-red-100 bg-white shadow-sm">
                                  <div class="relative">
                                    <img src="${pageContext.request.contextPath}/images/register.png"
                                      alt="Toyota Fortuner Legender" class="h-44 w-full object-cover" />
                                    <span
                                      class="absolute left-3 top-3 rounded-full bg-emerald-700 px-3 py-1 text-[10px] font-semibold uppercase tracking-wide text-white">Available
                                      Now</span>
                                  </div>
                                  <div class="p-4">
                                    <p class="text-[11px] font-semibold uppercase tracking-[0.12em] text-red-700">
                                      Premium SUV</p>
                                    <div class="mt-1 flex items-start justify-between gap-3">
                                      <h2 class="text-xl font-semibold leading-tight text-gray-900">Toyota Fortuner
                                        Legender</h2>
                                      <p class="text-right text-xs text-gray-500">Daily rate<br><span
                                          class="text-lg font-semibold text-red-800">Rs. 12,000</span></p>
                                    </div>
                                    <p class="mt-3 text-xs text-gray-600">Kathmandu • Auto • 4x4</p>
                                      <p class="mt-2 text-sm text-gray-700">Powerful premium SUV with off-road capability and spacious interiors for long journeys.</p>
                                      <% if (renterView) { %>
                                      <a href="<%= request.getContextPath() %>/vehicle-details?id=4"
                                        class="mt-4 block w-full rounded-xl bg-red-800 px-4 py-2.5 text-center text-sm font-semibold text-white hover:bg-red-900">View
                                        Details</a>
                                      <% } else { %>
                                      <button
                                        class="mt-4 w-full rounded-xl bg-red-800 px-4 py-2.5 text-sm font-semibold text-white hover:bg-red-900">Book
                                        Now</button>
                                      <% } %>
                                  </div>
                                </article>

                                <article class="overflow-hidden rounded-2xl border border-red-100 bg-white shadow-sm">
                                  <div class="relative">
                                    <img src="${pageContext.request.contextPath}/images/about.png"
                                      alt="Honda Grazia 125" class="h-44 w-full object-cover" />
                                    <span
                                      class="absolute left-3 top-3 rounded-full bg-emerald-700 px-3 py-1 text-[10px] font-semibold uppercase tracking-wide text-white">Available
                                      Now</span>
                                  </div>
                                  <div class="p-4">
                                    <p class="text-[11px] font-semibold uppercase tracking-[0.12em] text-red-700">
                                      Scooter</p>
                                    <div class="mt-1 flex items-start justify-between gap-3">
                                      <h2 class="text-xl font-semibold leading-tight text-gray-900">Honda Grazia 125
                                      </h2>
                                      <p class="text-right text-xs text-gray-500">Daily rate<br><span
                                          class="text-lg font-semibold text-red-800">Rs. 1,500</span></p>
                                    </div>
                                    <p class="mt-3 text-xs text-gray-600">Bhaktapur • 125cc • Storage</p>
                                      <p class="mt-2 text-sm text-gray-700">Lightweight scooter ideal for quick errands and easy parking in crowded streets.</p>
                                      <% if (renterView) { %>
                                      <a href="<%= request.getContextPath() %>/vehicle-details?id=5"
                                        class="mt-4 block w-full rounded-xl bg-red-800 px-4 py-2.5 text-center text-sm font-semibold text-white hover:bg-red-900">View
                                        Details</a>
                                      <% } else { %>
                                      <button
                                        class="mt-4 w-full rounded-xl bg-red-800 px-4 py-2.5 text-sm font-semibold text-white hover:bg-red-900">Book
                                        Now</button>
                                      <% } %>
                                  </div>
                                </article>

                                <article class="overflow-hidden rounded-2xl border border-red-100 bg-white shadow-sm">
                                  <div class="relative">
                                    <img src="${pageContext.request.contextPath}/images/register.png"
                                      alt="KTM Adventure 390" class="h-44 w-full object-cover" />
                                    <span
                                      class="absolute left-3 top-3 rounded-full bg-emerald-700 px-3 py-1 text-[10px] font-semibold uppercase tracking-wide text-white">Available
                                      Now</span>
                                  </div>
                                  <div class="p-4">
                                    <p class="text-[11px] font-semibold uppercase tracking-[0.12em] text-red-700">
                                      Adventure</p>
                                    <div class="mt-1 flex items-start justify-between gap-3">
                                      <h2 class="text-xl font-semibold leading-tight text-gray-900">KTM Adventure 390
                                      </h2>
                                      <p class="text-right text-xs text-gray-500">Daily rate<br><span
                                          class="text-lg font-semibold text-red-800">Rs. 4,500</span></p>
                                    </div>
                                    <p class="mt-3 text-xs text-gray-600">Pokhara • Off-road • ABS</p>
                                      <p class="mt-2 text-sm text-gray-700">Adventure motorcycle built for rough terrain with good suspension and handling off-road.</p>
                                      <% if (renterView) { %>
                                      <a href="<%= request.getContextPath() %>/vehicle-details?id=6"
                                        class="mt-4 block w-full rounded-xl bg-red-800 px-4 py-2.5 text-center text-sm font-semibold text-white hover:bg-red-900">View
                                        Details</a>
                                      <% } else { %>
                                      <button
                                        class="mt-4 w-full rounded-xl bg-red-800 px-4 py-2.5 text-sm font-semibold text-white hover:bg-red-900">Book
                                        Now</button>
                                      <% } %>
                                  </div>
                                </article>
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