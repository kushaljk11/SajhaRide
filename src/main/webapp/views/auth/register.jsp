<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String fullNameValue = request.getParameter("fullName") == null ? "" : request.getParameter("fullName");
    String emailValue = request.getParameter("email") == null ? "" : request.getParameter("email");
    String phoneNumberValue = request.getParameter("phoneNumber") == null ? "" : request.getParameter("phoneNumber");
    String addressValue = request.getParameter("address") == null ? "" : request.getParameter("address");
%>
<html>
<head>
    <title>SajhaRide - Register</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 min-h-screen">

<div class="w-full flex flex-col md:flex-row min-h-screen">

    <div class="hidden md:flex md:w-1/2 relative bg-cover bg-center"
         style="background-image: url('../../images/register.png');">
        <div class="absolute inset-0 bg-gradient-to-br from-red-900/70 via-black/50 to-black/30 flex items-end p-10">
            <div>
                <span class="inline-block bg-white/15 backdrop-blur-sm text-white text-xs font-semibold tracking-widest uppercase px-3 py-1 rounded-full mb-4">
                    Nepal's Ride Network
                </span>
                <h2 class="text-4xl text-white font-semibold leading-tight mb-3">Create your account</h2>
                <p class="text-white/75 text-sm leading-relaxed max-w-sm">
                    Join SajhaRide and request trusted rides across the city in minutes.
                </p>
            </div>
        </div>
    </div>

    <div class="w-full md:w-1/2 bg-white flex items-center justify-center px-6 py-10 md:px-12">
        <div class="w-full max-w-2xl">
            <div class="mb-8">
                <h1 class="text-3xl font-semibold text-center text-gray-900">Register Asap!</h1>
                <p class="text-gray-500 text-center text-sm mt-1">Fill all details to create your account</p>
            </div>

            <form action="${pageContext.request.contextPath}/register" method="post" enctype="multipart/form-data" class="space-y-5">

                <div>
                    <label for="fullName" class="block text-sm font-medium text-gray-700 mb-2">Full Name</label>
                    <input
                            id="fullName"
                            type="text"
                            name="fullName"
                            value="<%= fullNameValue %>"
                            required
                            placeholder="Enter your full name"
                            class="w-full px-4 py-3 rounded-xl border border-gray-200 bg-gray-50 text-sm focus:outline-none focus:ring-2 focus:ring-red-700"
                    />
                </div>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div>
                        <label for="email" class="block text-sm font-medium text-gray-700 mb-2">Email</label>
                        <input
                                id="email"
                                type="email"
                                name="email"
                                value="<%= emailValue %>"
                                required
                                placeholder="name@example.com"
                                class="w-full px-4 py-3 rounded-xl border border-gray-200 bg-gray-50 text-sm focus:outline-none focus:ring-2 focus:ring-red-700"
                        />
                    </div>

                    <div>
                        <label for="phoneNumber" class="block text-sm font-medium text-gray-700 mb-2">Phone Number</label>
                        <input
                                id="phoneNumber"
                                type="tel"
                                name="phoneNumber"
                                value="<%= phoneNumberValue %>"
                                required
                                placeholder="98XXXXXXXX"
                                class="w-full px-4 py-3 rounded-xl border border-gray-200 bg-gray-50 text-sm focus:outline-none focus:ring-2 focus:ring-red-700"
                        />
                    </div>
                </div>

                <div>
                    <label for="password" class="block text-sm font-medium text-gray-700 mb-2">Password</label>
                    <input
                            id="password"
                            type="password"
                            name="password"
                            required
                            placeholder="Enter a secure password"
                            class="w-full px-4 py-3 rounded-xl border border-gray-200 bg-gray-50 text-sm focus:outline-none focus:ring-2 focus:ring-red-700"
                    />
                </div>

                <div>
                    <label for="address" class="block text-sm font-medium text-gray-700 mb-2">Address</label>
                    <input
                            id="address"
                            type="text"
                            name="address"
                            value="<%= addressValue %>"
                            required
                            placeholder="Enter your address"
                            class="w-full px-4 py-3 rounded-xl border border-gray-200 bg-gray-50 text-sm focus:outline-none focus:ring-2 focus:ring-red-700"
                    />
                </div>

                <input type="hidden" name="role" value="USER" />

                <div>
                    <label for="profileImage" class="block text-sm font-medium text-gray-700 mb-2">Profile Image</label>
                    <input
                            id="profileImage"
                            type="file"
                            name="profileImage"
                            accept="image/*"
                            class="w-full px-4 py-3 rounded-xl border border-gray-200 bg-gray-50 text-sm file:mr-4 file:border-0 file:bg-red-700 file:px-4 file:py-2 file:text-white file:rounded-lg hover:file:bg-red-800"
                    />
                </div>

                <button
                        type="submit"
                        class="w-full py-3 rounded-xl bg-red-700 text-white font-semibold hover:bg-red-800 transition"
                >
                    Create Account
                </button>

                <p class="text-center text-sm text-gray-500">
                    Already have an account?
                    <a href="${pageContext.request.contextPath}/login" class="text-red-700 font-semibold">Login</a>
                </p>
            </form>

            <%
                String error = (String) request.getAttribute("errorMessage");
                if (error != null && !error.isEmpty()) {
            %>
            <div class="mt-4 bg-red-50 border border-red-200 text-red-700 text-sm rounded-xl px-4 py-3">
                <%= error %>
            </div>
            <% } %>

        </div>
    </div>

</div>
</body>
</html>
