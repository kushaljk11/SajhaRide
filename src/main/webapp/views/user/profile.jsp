<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.riderental.myriderental.model.User" %>
<%
    User user = (User) request.getAttribute("user");
%>
<html>
<head>
    <title>My Profile</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-slate-100 min-h-screen py-10 px-4">
<div class="max-w-4xl mx-auto bg-white rounded-3xl shadow-lg overflow-hidden">
    <div class="bg-slate-900 text-white px-8 py-6 flex items-center justify-between">
        <div>
            <h1 class="text-3xl font-semibold">My Profile</h1>
            <p class="text-slate-300 text-sm mt-1">Update your account details and profile picture.</p>
        </div>
        <a href="${pageContext.request.contextPath}/logout" class="bg-red-600 px-4 py-2 rounded-xl text-sm font-semibold">Logout</a>
    </div>

    <div class="grid md:grid-cols-[240px_1fr] gap-8 p-8">
        <div class="space-y-4">
            <div class="rounded-3xl overflow-hidden border border-slate-200 bg-slate-50 aspect-square flex items-center justify-center">
                <% if (user != null && user.getProfileImagePath() != null && !user.getProfileImagePath().isBlank()) { %>
                <img src="${pageContext.request.contextPath}/<%= user.getProfileImagePath() %>" alt="Profile image" class="w-full h-full object-cover" />
                <% } else { %>
                <span class="text-slate-400 text-sm">No profile image</span>
                <% } %>
            </div>

            <div class="rounded-2xl bg-slate-50 border border-slate-200 p-4 text-sm text-slate-600">
                <p><span class="font-semibold text-slate-900">Email:</span> <%= user != null ? user.getEmail() : "" %></p>
                <p class="mt-2"><span class="font-semibold text-slate-900">Role:</span> <%= user != null ? user.getRole() : "" %></p>
                <p class="mt-2"><span class="font-semibold text-slate-900">Status:</span> <%= user != null ? user.getAccountStatus() : "" %></p>
            </div>
        </div>

        <div>
            <% if ("true".equals(request.getParameter("updated"))) { %>
            <div class="mb-4 bg-green-50 border border-green-200 text-green-700 text-sm rounded-xl px-4 py-3">
                Profile updated successfully.
            </div>
            <% } %>

            <%
                String error = (String) request.getAttribute("errorMessage");
                if (error != null && !error.isEmpty()) {
            %>
            <div class="mb-4 bg-red-50 border border-red-200 text-red-700 text-sm rounded-xl px-4 py-3">
                <%= error %>
            </div>
            <% } %>

            <form action="${pageContext.request.contextPath}/profile" method="post" enctype="multipart/form-data" class="space-y-5">
                <div>
                    <label for="fullName" class="block text-sm font-medium text-slate-700 mb-2">Full Name</label>
                    <input id="fullName" type="text" name="fullName" required value="<%= user != null ? user.getFullName() : "" %>"
                           class="w-full px-4 py-3 rounded-xl border border-slate-200 bg-slate-50 text-sm focus:outline-none focus:ring-2 focus:ring-slate-900" />
                </div>

                <div class="grid md:grid-cols-2 gap-4">
                    <div>
                        <label for="phoneNumber" class="block text-sm font-medium text-slate-700 mb-2">Phone Number</label>
                        <input id="phoneNumber" type="text" name="phoneNumber" required value="<%= user != null ? user.getPhoneNumber() : "" %>"
                               class="w-full px-4 py-3 rounded-xl border border-slate-200 bg-slate-50 text-sm focus:outline-none focus:ring-2 focus:ring-slate-900" />
                    </div>

                    <div>
                        <label for="address" class="block text-sm font-medium text-slate-700 mb-2">Address</label>
                        <input id="address" type="text" name="address" required value="<%= user != null ? user.getAddress() : "" %>"
                               class="w-full px-4 py-3 rounded-xl border border-slate-200 bg-slate-50 text-sm focus:outline-none focus:ring-2 focus:ring-slate-900" />
                    </div>
                </div>

                <div>
                    <label for="profileImage" class="block text-sm font-medium text-slate-700 mb-2">Profile Image</label>
                    <input id="profileImage" type="file" name="profileImage" accept="image/*"
                           class="w-full px-4 py-3 rounded-xl border border-slate-200 bg-slate-50 text-sm file:mr-4 file:border-0 file:bg-slate-900 file:px-4 file:py-2 file:text-white file:rounded-lg" />
                </div>

                <button type="submit" class="bg-slate-900 text-white px-6 py-3 rounded-xl font-semibold">Save Changes</button>
            </form>
        </div>
    </div>
</div>
</body>
</html>
