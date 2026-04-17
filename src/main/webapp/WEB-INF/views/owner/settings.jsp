<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.riderental.myriderental.model.User" %>
<%
    User loggedInUser = (User) session.getAttribute("loggedInUser");
    String fullName = loggedInUser != null && loggedInUser.getFullName() != null ? loggedInUser.getFullName() : "Owner User";
    String email = loggedInUser != null && loggedInUser.getEmail() != null ? loggedInUser.getEmail() : "owner@sajharide.com";
    String phone = loggedInUser != null && loggedInUser.getPhoneNumber() != null ? loggedInUser.getPhoneNumber() : "Not set";
    String address = loggedInUser != null && loggedInUser.getAddress() != null ? loggedInUser.getAddress() : "Not set";
%>
<html>
<head>
    <title>SajhaRide - Settings</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="h-screen overflow-hidden bg-gray-100 text-gray-900">
<div class="flex h-full">
    <jsp:include page="../owner/components/sidebar.jsp" />

    <div class="flex min-w-0 flex-1 flex-col overflow-hidden">
        <jsp:include page="../owner/components/topbar.jsp" />

        <main class="flex-1 overflow-y-auto px-6 py-6 sm:px-8">
            <section class="mb-6 flex flex-col gap-3 lg:flex-row lg:items-center lg:justify-between">
                <div>
                    <h1 class="text-4xl font-semibold tracking-tight text-gray-900">Owner Settings</h1>
                    <p class="mt-2 text-sm text-gray-600">Manage your account details and profile preferences.</p>
                </div>
                <a href="${pageContext.request.contextPath}/profile" class="rounded-xl bg-red-800 px-5 py-3 text-sm font-semibold text-white hover:bg-red-900">Open Full Profile</a>
            </section>

            <section class="grid grid-cols-1 gap-6 lg:grid-cols-3">
                <article class="rounded-2xl border border-red-100 bg-white p-5 shadow-sm">
                    <h2 class="text-xl font-semibold text-gray-900">Profile Snapshot</h2>
                    <div class="mt-4 flex items-center gap-3">
                        <div class="flex h-12 w-12 items-center justify-center rounded-full bg-red-100 text-lg font-semibold text-red-800">
                            <%= fullName.substring(0, 1).toUpperCase() %>
                        </div>
                        <div>
                            <p class="text-sm font-semibold text-gray-900"><%= fullName %></p>
                            <p class="text-xs text-gray-500">Vehicle Owner</p>
                        </div>
                    </div>
                    <a href="${pageContext.request.contextPath}/profile" class="mt-5 inline-block rounded-lg border border-red-300 px-4 py-2 text-sm font-semibold text-red-800 hover:bg-red-50">Edit Profile</a>
                </article>

                <article class="rounded-2xl border border-red-100 bg-white p-5 shadow-sm lg:col-span-2">
                    <h2 class="text-xl font-semibold text-gray-900">Account Details</h2>
                    <div class="mt-4 grid grid-cols-1 gap-4 sm:grid-cols-2">
                        <div class="rounded-xl border border-gray-200 bg-gray-50 p-4">
                            <p class="text-xs uppercase tracking-[0.12em] text-gray-500">Full Name</p>
                            <p class="mt-2 text-sm font-semibold text-gray-900"><%= fullName %></p>
                        </div>
                        <div class="rounded-xl border border-gray-200 bg-gray-50 p-4">
                            <p class="text-xs uppercase tracking-[0.12em] text-gray-500">Email</p>
                            <p class="mt-2 text-sm font-semibold text-gray-900"><%= email %></p>
                        </div>
                        <div class="rounded-xl border border-gray-200 bg-gray-50 p-4">
                            <p class="text-xs uppercase tracking-[0.12em] text-gray-500">Phone</p>
                            <p class="mt-2 text-sm font-semibold text-gray-900"><%= phone %></p>
                        </div>
                        <div class="rounded-xl border border-gray-200 bg-gray-50 p-4">
                            <p class="text-xs uppercase tracking-[0.12em] text-gray-500">Address</p>
                            <p class="mt-2 text-sm font-semibold text-gray-900"><%= address %></p>
                        </div>
                    </div>
                </article>
            </section>

            <section class="mt-6 grid grid-cols-1 gap-4 md:grid-cols-2">
                <article class="rounded-2xl border border-red-100 bg-white p-5 shadow-sm">
                    <h3 class="text-lg font-semibold text-gray-900">Notification Preferences</h3>
                    <div class="mt-4 space-y-3">
                        <label class="flex items-center justify-between rounded-xl border border-gray-200 bg-gray-50 px-4 py-3 text-sm">
                            Booking request alerts
                            <input type="checkbox" checked class="h-4 w-4 accent-red-800" />
                        </label>
                        <label class="flex items-center justify-between rounded-xl border border-gray-200 bg-gray-50 px-4 py-3 text-sm">
                            Payment confirmation alerts
                            <input type="checkbox" checked class="h-4 w-4 accent-red-800" />
                        </label>
                    </div>
                </article>
                <article class="rounded-2xl border border-red-100 bg-white p-5 shadow-sm">
                    <h3 class="text-lg font-semibold text-gray-900">Security</h3>
                    <p class="mt-2 text-sm text-gray-600">Keep your account secure by reviewing profile and password settings regularly.</p>
                    <a href="${pageContext.request.contextPath}/profile" class="mt-4 inline-block rounded-lg bg-red-800 px-4 py-2 text-sm font-semibold text-white hover:bg-red-900">Manage Security in Profile</a>
                </article>
            </section>
        </main>
    </div>
</div>
</body>
</html>
