<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.riderental.myriderental.model.User" %>
<%
	User savedUser = (User) session.getAttribute("loggedInUser");
	String firstName = "Rider";
	if (savedUser != null && savedUser.getFullName() != null && !savedUser.getFullName().isBlank()) {
		String[] nameParts = savedUser.getFullName().trim().split("\\s+");
		firstName = nameParts[0];
	}
%>
<html>
<head>
	<title>Saved Rides | SajhaRide</title>
	<script src="https://cdn.tailwindcss.com"></script>
	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
</head>
<body class="h-screen overflow-hidden bg-[#f2f4f8] text-gray-900">
<div class="flex h-full">
	<%@ include file="/WEB-INF/views/renter/components/sidebar.jsp" %>

	<div class="flex min-w-0 flex-1 flex-col">
		<%@ include file="/WEB-INF/views/renter/components/topbar.jsp" %>

		<main class="flex-1 overflow-y-auto p-4 sm:p-6 lg:p-8">
			<h1 class="max-w-2xl text-2xl font-semibold leading-tight text-gray-900 sm:text-4xl">Your favorite rides, ready for the road.</h1>
			<p class="mt-3 max-w-2xl text-sm leading-6 text-gray-600 sm:text-base">Review and manage your shortlisted vehicles, <span class="font-semibold text-red-800"><%= firstName %></span>. Book your next journey through the heart of our community-vetted sharing network.</p>

			<section class="mt-6 grid gap-4 sm:grid-cols-2 xl:grid-cols-3">
				<% 
					java.util.List<com.riderental.myriderental.model.Vehicle> savedVehicles = (java.util.List<com.riderental.myriderental.model.Vehicle>) request.getAttribute("savedVehicles");
					if (savedVehicles == null || savedVehicles.isEmpty()) {
				%>
					<article class="col-span-full rounded-2xl bg-white p-8 text-center shadow-sm ring-1 ring-gray-200">
                        <p class="text-gray-600">You haven't saved any rides yet.</p>
                        <a href="${pageContext.request.contextPath}/explore" class="mt-4 inline-block font-semibold text-red-800 hover:text-red-900">Start exploring</a>
                    </article>
				<% } else { 
					for (com.riderental.myriderental.model.Vehicle v : savedVehicles) {
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
				<article class="group overflow-hidden rounded-2xl border border-gray-200 bg-white shadow-sm transition hover:-translate-y-0.5 hover:shadow-md">
					<div class="relative h-44 overflow-hidden bg-gray-100">
						<img src="${pageContext.request.contextPath}/<%= imgPath %>" alt="<%= v.getVehicleName() %>" class="h-full w-full object-cover transition duration-300 group-hover:scale-105" />
						<span class="absolute right-3 top-3 rounded-full bg-blue-50 px-3 py-1 text-xs font-semibold uppercase tracking-wide text-blue-700"><%= v.getVehicleType() %></span>
					</div>
					<div class="p-4">
						<div class="flex items-start justify-between gap-4">
							<h2 class="text-xl font-semibold leading-tight text-gray-900 line-clamp-1"><%= v.getVehicleName() %></h2>
							<p class="text-right text-lg font-bold text-red-800 whitespace-nowrap">Rs. <%= String.format(java.util.Locale.US, "%,.0f", v.getPricePerDay()) %><span class="block text-xs font-semibold text-gray-400">/ day</span></p>
						</div>
						<p class="mt-2 text-sm text-gray-500"><%= v.getLocation() %></p>
						<div class="mt-4 flex items-center gap-2">
							<a href="<%= request.getContextPath() %>/vehicle-details?id=<%= v.getVehicleId() %>" class="flex-1 block text-center rounded-xl bg-red-800 px-4 py-2.5 text-sm font-semibold text-white transition hover:bg-red-900">View Details</a>
							<button type="button" class="inline-flex h-10 w-10 items-center justify-center rounded-xl border border-gray-200 text-gray-500 transition hover:bg-gray-100 hover:text-gray-800" aria-label="Remove from saved">
								<svg class="h-5 w-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
									<path d="M3 6h18"></path>
									<path d="M8 6V4h8v2"></path>
									<path d="M19 6l-1 14H6L5 6"></path>
									<path d="M10 11v6"></path>
									<path d="M14 11v6"></path>
								</svg>
							</button>
						</div>
					</div>
				</article>
				<% } } %>
			</section>

			<section class="mt-6 grid gap-4 lg:grid-cols-2">
				<article class="rounded-2xl border border-red-200 bg-red-50 p-5">
					<h3 class="text-lg font-semibold text-red-900">Price Drop Alerts</h3>
					<p class="mt-2 text-sm text-red-800/90">2 vehicles in your saved list dropped their daily rate in the last 48 hours.</p>
					<button type="button" class="mt-4 rounded-lg bg-red-800 px-4 py-2 text-sm font-semibold text-white transition hover:bg-red-900">View Deals</button>
				</article>

				<article class="rounded-2xl border border-gray-200 bg-white p-5">
					<h3 class="text-lg font-semibold text-gray-900">Smart Picks For You</h3>
					<p class="mt-2 text-sm text-gray-600">Based on your saved rides, SUVs and scooters in Kathmandu are trending this week.</p>
					<a href="${pageContext.request.contextPath}/explore" class="mt-4 inline-flex items-center rounded-lg border border-gray-300 bg-gray-50 px-4 py-2 text-sm font-semibold text-gray-700 transition hover:bg-gray-100">Explore Similar</a>
				</article>
			</section>
		</main>
	</div>
</div>
</body>
</html>
