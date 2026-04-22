<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.riderental.myriderental.model.User" %>
<%
    User dashboardUser = (User) session.getAttribute("loggedInUser");
    String firstName = "Rider";
    if (dashboardUser != null && dashboardUser.getFullName() != null && !dashboardUser.getFullName().isBlank()) {
        String[] nameParts = dashboardUser.getFullName().trim().split("\\s+");
        firstName = nameParts[0];
    }
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
            <p class="text-sm mt-1 text-gray-500">Welcome back, <span class="text-red-800 uppercase font-bold"><%= firstName %>.</span> Your latest trip updates are ready.</p>

            <section class="mt-4">
                <div class="grid gap-4 md:grid-cols-2 xl:grid-cols-4">
                    <article class="rounded-2xl bg-gray-50 p-4 ring-1 ring-gray-200">
                        <p class="text-sm font-semibold text-black">Total</p>
                        <p class="mt-3 text-3xl font-semibold text-gray-900">12</p>
                        <p class="text-sm text-gray-500">Completed Rides</p>
                    </article>

                    <article class="relative overflow-hidden rounded-2xl bg-red-800 p-4 text-white shadow-md">
                        <div class="absolute right-0 top-0 h-24 w-24 translate-x-6 -translate-y-6 rounded-full border border-white/25"></div>
                        <p class="text-sm font-semibold text-red-100">Saved</p>
                        <p class="mt-3 text-3xl font-semibold">1</p>
                        <p class="text-sm text-red-100">View Saved Post</p>
                    </article>

                    <article class="rounded-2xl bg-gray-50 p-4 ring-1 ring-gray-200">
                        <p class="text-sm font-semibold text-black">Total Bookings</p>
                        <p class="mt-3 text-3xl font-semibold text-gray-900">10</p>
                        <p class="text-sm text-gray-500">View Bookings</p>
                    </article>

                    <article class="rounded-2xl bg-gray-50 p-4 ring-1 ring-gray-200">
                        <p class="text-sm font-semibold text-black">Waiting</p>
                        <p class="mt-3 text-3xl font-semibold text-gray-900">1</p>
                        <p class="text-sm text-gray-500">Pending Request</p>
                    </article>
                </div>
            </section>

            <section class="mt-6">
                <div class="mb-4 flex flex-wrap items-center justify-between gap-3">
                    <div>
                        <h2 class="text-xl font-semibold text-gray-900">Explore Vehicles</h2>
                        <p class="text-sm text-gray-500">Find the perfect ride for your next plan.</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/explore" class="inline-flex items-center rounded-xl border border-red-200 bg-red-50 px-4 py-2 text-sm font-semibold text-red-800 transition hover:bg-red-100">
                        View More
                    </a>
                </div>

                <div class="grid gap-4 sm:grid-cols-2 xl:grid-cols-4">
                    <article class="group overflow-hidden rounded-2xl bg-gray-50 ring-1 ring-gray-200 transition hover:-translate-y-0.5 hover:shadow-sm">
                        <div class="h-32 overflow-hidden">
                            <img src="${pageContext.request.contextPath}/images/about.png" alt="Honda Dio 125" class="h-full w-full object-cover transition duration-300 group-hover:scale-105" />
                        </div>
                        <div class="p-4">
                            <h3 class="font-semibold text-gray-900">Honda Dio 125</h3>
                            <p class="mt-1 text-sm text-gray-500">Petrol • Kathmandu</p>
                            <p class="mt-3 text-sm font-semibold text-red-800">Rs. 1,450/day</p>
                        </div>
                    </article>

                    <article class="group overflow-hidden rounded-2xl bg-gray-50 ring-1 ring-gray-200 transition hover:-translate-y-0.5 hover:shadow-sm">
                        <div class="h-32 overflow-hidden">
                            <img src="${pageContext.request.contextPath}/images/register.png" alt="Suzuki Access" class="h-full w-full object-cover transition duration-300 group-hover:scale-105" />
                        </div>
                        <div class="p-4">
                            <h3 class="font-semibold text-gray-900">Suzuki Access</h3>
                            <p class="mt-1 text-sm text-gray-500">Petrol • Lalitpur</p>
                            <p class="mt-3 text-sm font-semibold text-red-800">Rs. 1,550/day</p>
                        </div>
                    </article>

                    <article class="group overflow-hidden rounded-2xl bg-gray-50 ring-1 ring-gray-200 transition hover:-translate-y-0.5 hover:shadow-sm">
                        <div class="h-32 overflow-hidden bg-gray-900">
                            <img src="${pageContext.request.contextPath}/images/logoho.png" alt="Yamaha FZS" class="h-full w-full object-cover transition duration-300 group-hover:scale-105" />
                        </div>
                        <div class="p-4">
                            <h3 class="font-semibold text-gray-900">Yamaha FZS</h3>
                            <p class="mt-1 text-sm text-gray-500">Bike • Bhaktapur</p>
                            <p class="mt-3 text-sm font-semibold text-red-800">Rs. 2,250/day</p>
                        </div>
                    </article>

                    <article class="group overflow-hidden rounded-2xl bg-gray-50 ring-1 ring-gray-200 transition hover:-translate-y-0.5 hover:shadow-sm">
                        <div class="h-32 overflow-hidden">
                            <img src="${pageContext.request.contextPath}/images/about.png" alt="Royal Enfield 350" class="h-full w-full object-cover transition duration-300 group-hover:scale-105" />
                        </div>
                        <div class="p-4">
                            <h3 class="font-semibold text-gray-900">Royal Enfield 350</h3>
                            <p class="mt-1 text-sm text-gray-500">Bike • Pokhara</p>
                            <p class="mt-3 text-sm font-semibold text-red-800">Rs. 3,800/day</p>
                        </div>
                    </article>
                </div>
            </section>

            <section class="mt-6 rounded-2xl bg-white shadow-sm ring-1 ring-gray-200">
                <div class="flex flex-wrap items-center justify-between gap-3 border-b border-gray-100 px-6 py-5">
                    <h2 class="text-xl font-semibold text-gray-900">Recent Booking History</h2>
                    <a href="${pageContext.request.contextPath}/renter/bookings" class="text-sm font-semibold text-red-800 hover:text-red-900">View All History</a>
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
                            <tr class="hover:bg-gray-50/80">
                                <td class="px-6 py-4">
                                    <p class="font-semibold text-gray-900">Honda Activa 6G</p>
                                    <p class="text-xs text-gray-500">Lic: BA-PA 4521</p>
                                </td>
                                <td class="px-6 py-4 text-gray-600">Oct 24, 2023</td>
                                <td class="px-6 py-4"><span class="inline-flex rounded-full bg-red-100 px-3 py-1 text-xs font-semibold text-red-800">Active</span></td>
                                <td class="px-6 py-4 font-semibold text-gray-900">Rs. 1,200</td>
                            </tr>
                            <tr class="hover:bg-gray-50/80">
                                <td class="px-6 py-4">
                                    <p class="font-semibold text-gray-900">Suzuki Swift</p>
                                    <p class="text-xs text-gray-500">Lic: BAG-MAT 9982</p>
                                </td>
                                <td class="px-6 py-4 text-gray-600">Oct 20, 2023</td>
                                <td class="px-6 py-4"><span class="inline-flex rounded-full bg-emerald-100 px-3 py-1 text-xs font-semibold text-emerald-800">Completed</span></td>
                                <td class="px-6 py-4 font-semibold text-gray-900">Rs. 4,500</td>
                            </tr>
                            <tr class="hover:bg-gray-50/80">
                                <td class="px-6 py-4">
                                    <p class="font-semibold text-gray-900">Vespa VXL 150</p>
                                    <p class="text-xs text-gray-500">Lic: BA-6-PA 1102</p>
                                </td>
                                <td class="px-6 py-4 text-gray-600">Oct 18, 2023</td>
                                <td class="px-6 py-4"><span class="inline-flex rounded-full bg-blue-100 px-3 py-1 text-xs font-semibold text-blue-800">Pending</span></td>
                                <td class="px-6 py-4 font-semibold text-gray-900">Rs. 1,800</td>
                            </tr>
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
                        <button type="button" class="rounded-xl bg-red-800 px-4 py-2.5 text-sm font-semibold text-white transition hover:bg-red-900">Contact Support</button>
                    </div>
                </article>
            </section>
        </main>
    </div>
</div>
</body>
</html>
