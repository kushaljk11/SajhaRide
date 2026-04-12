<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.riderental.myriderental.model.User" %>
<%
    User user = (User) request.getAttribute("user");

    String successMsg = (String) session.getAttribute("profileSuccess");
    String errorMsg = (String) session.getAttribute("profileError");
    if (successMsg != null) session.removeAttribute("profileSuccess");
    if (errorMsg != null) session.removeAttribute("profileError");

    java.util.function.Function<String, String> esc = (s) ->
            s == null ? "" : s.replace("&", "&amp;")
                             .replace("<", "&lt;")
                             .replace(">", "&gt;")
                             .replace("\"", "&quot;")
                             .replace("'", "&#x27;");

    String fullName  = esc.apply(user != null ? user.getFullName() : "");
    String phone     = esc.apply(user != null ? user.getPhoneNumber() : "");
    String address   = esc.apply(user != null ? user.getAddress() : "");
    String email     = esc.apply(user != null ? user.getEmail() : "");
    String status    = esc.apply(user != null ? user.getAccountStatus() : "");
    String role      = esc.apply(user != null ? user.getRole() : "");

    String initial = (user != null && user.getFullName() != null && !user.getFullName().isEmpty())
            ? esc.apply(user.getFullName().substring(0,1).toUpperCase())
            : "U";

    String imagePath = (user != null &&
            user.getProfileImagePath() != null &&
            !user.getProfileImagePath().isBlank())
            ? user.getProfileImagePath()
            : null;

    if (errorMsg == null) {
        errorMsg = (String) request.getAttribute("errorMessage");
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>

<body class="bg-gray-50 min-h-screen">

<!-- Header -->
<header class="bg-red-800 text-white shadow-md">
    <div class="max-w-7xl mx-auto px-6 py-5 flex items-center justify-between">
        <div>
            <h1 class="text-3xl font-bold">My Profile</h1>
            <p class="text-red-100 text-sm mt-1">
                Update your account information and personal details
            </p>
        </div>

        <a href="${pageContext.request.contextPath}/logout"
           class="bg-white/10 border border-white/20 px-5 py-2 rounded-lg hover:bg-white/20 transition">
            Logout
        </a>
    </div>
</header>

<!-- Main Layout -->
<div class="max-w-7xl mx-auto px-6 py-8 grid grid-cols-1 lg:grid-cols-4 gap-6">

    <!-- Sidebar -->
    <aside class="space-y-6">

        <!-- Profile Card -->
        <div class="bg-white rounded-3xl shadow-sm border border-gray-100 p-6">
            <div class="flex flex-col items-center">
                <div class="w-24 h-24 rounded-full overflow-hidden bg-red-100 border-4 border-red-50 flex items-center justify-center text-3xl font-bold text-red-800">
                    <% if (imagePath != null) { %>
                    <img src="${pageContext.request.contextPath}/<%= imagePath %>"
                         class="w-full h-full object-cover"
                         alt="Profile photo">
                    <% } else { %>
                    <%= initial %>
                    <% } %>
                </div>

                <h2 class="mt-4 text-lg font-semibold text-gray-800">
                    <%= fullName.isEmpty() ? "User" : fullName %>
                </h2>

                <p class="text-sm text-gray-500 mt-1">
                    <%= role %>
                </p>
            </div>
        </div>

        <!-- Account Info -->
        <div class="bg-white rounded-3xl shadow-sm border border-gray-100 p-6">
            <h3 class="text-xs uppercase tracking-widest font-semibold text-red-800 mb-4">
                Account Information
            </h3>

            <div class="space-y-4 text-sm">
                <div>
                    <p class="text-gray-400 uppercase text-xs">Email</p>
                    <p class="font-medium text-gray-700 break-all"><%= email %></p>
                </div>

                <div>
                    <p class="text-gray-400 uppercase text-xs">Status</p>
                    <p class="font-medium text-green-600"><%= status %></p>
                </div>

                <div>
                    <p class="text-gray-400 uppercase text-xs">Role</p>
                    <p class="font-medium text-gray-700"><%= role %></p>
                </div>
            </div>
        </div>
    </aside>

    <!-- Main Form -->
    <main class="lg:col-span-3">
        <div class="bg-white rounded-3xl shadow-sm border border-gray-100 p-8">

            <div class="mb-6">
                <h2 class="text-2xl font-bold text-gray-800">Edit Profile</h2>
                <p class="text-sm text-gray-500 mt-1">
                    Keep your information up to date
                </p>
            </div>

            <!-- Success Message -->
            <% if (successMsg != null && !successMsg.isEmpty()) { %>
            <div class="mb-5 bg-green-50 border border-green-200 text-green-700 rounded-xl px-4 py-3">
                <%= esc.apply(successMsg) %>
            </div>
            <% } %>

            <!-- Error Message -->
            <% if (errorMsg != null && !errorMsg.isEmpty()) { %>
            <div class="mb-5 bg-red-50 border border-red-200 text-red-700 rounded-xl px-4 py-3">
                <%= esc.apply(errorMsg) %>
            </div>
            <% } %>

            <form action="${pageContext.request.contextPath}/profile"
                  method="post"
                  enctype="multipart/form-data"
                  class="space-y-6">

                <div class="grid md:grid-cols-2 gap-6">

                    <div>
                        <label class="block text-sm font-medium text-gray-600 mb-2">
                            Full Name
                        </label>
                        <input type="text"
                               name="fullName"
                               value="<%= fullName %>"
                               required
                               class="w-full px-4 py-3 rounded-xl border border-gray-200 bg-gray-50 focus:outline-none focus:ring-2 focus:ring-red-800">
                    </div>

                    <div>
                        <label class="block text-sm font-medium text-gray-600 mb-2">
                            Phone Number
                        </label>
                        <input type="text"
                               name="phoneNumber"
                               value="<%= phone %>"
                               required
                               class="w-full px-4 py-3 rounded-xl border border-gray-200 bg-gray-50 focus:outline-none focus:ring-2 focus:ring-red-800">
                    </div>
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-600 mb-2">
                        Address
                    </label>
                    <input type="text"
                           name="address"
                           value="<%= address %>"
                           required
                           class="w-full px-4 py-3 rounded-xl border border-gray-200 bg-gray-50 focus:outline-none focus:ring-2 focus:ring-red-800">
                </div>

                <!-- Current Image -->
                <% if (imagePath != null) { %>
                <div class="flex items-center gap-3">
                    <img src="${pageContext.request.contextPath}/<%= imagePath %>"
                         class="w-10 h-10 rounded-full object-cover border"
                         alt="Current image">
                    <span class="text-sm text-gray-500">
                        Current photo — upload new one to replace
                    </span>
                </div>
                <% } %>

                <!-- File Upload -->
                <div>
                    <label class="block text-sm font-medium text-gray-600 mb-2">
                        Profile Image
                    </label>

                    <label for="profileImage"
                           class="block border-2 border-dashed border-gray-300 rounded-xl p-5 bg-gray-50 hover:border-red-800 cursor-pointer transition">
                        <div class="text-center">
                            <p class="font-medium text-gray-700">
                                Click to upload a photo
                            </p>
                            <p class="text-sm text-gray-400">
                                PNG, JPG, WEBP — max 5 MB
                            </p>
                            <p id="fileNameDisplay" class="text-red-800 text-sm mt-2 hidden"></p>
                        </div>
                    </label>

                    <input type="file"
                           id="profileImage"
                           name="profileImage"
                           accept="image/*"
                           class="hidden"
                           onchange="showFileName(this)">
                </div>

                <button type="submit"
                        class="bg-red-800 hover:bg-red-900 text-white px-6 py-3 rounded-xl font-semibold shadow-sm transition">
                    Save Changes
                </button>

            </form>
        </div>
    </main>
</div>

<script>
    function showFileName(input) {
        const display = document.getElementById("fileNameDisplay");

        if (input.files && input.files[0]) {
            display.textContent = input.files[0].name;
            display.classList.remove("hidden");
        } else {
            display.classList.add("hidden");
        }
    }
</script>

</body>
</html>