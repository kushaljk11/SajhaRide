<%--
  Created by IntelliJ IDEA.
  User: kusha
  Date: 3/28/2026
  Time: 9:14 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>SajhaRide</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 flex items-center justify-center min-h-screen">

<div class="w-full overflow-hidden flex flex-col md:flex-row min-h-screen">

    <!-- hero image -->
    <div class="hidden md:flex md:w-1/2 relative bg-cover bg-center h-1/2 md:h-auto"
         style="background-image: url('../../images/register.png');">

        <div class="absolute inset-0 bg-gradient-to-br from-red-800/70 via-black/50 to-black/30 flex flex-col justify-end p-10">
            <div>
                <span class="inline-block bg-white/15 backdrop-blur-sm text-white text-xs font-semibold tracking-widest uppercase px-3 py-1 rounded-full mb-4">
                    Nepal's Ride Network
                </span>

                <h2 class="text-4xl text-white font-semibold leading-tight mb-3">
                    Your journey<br>starts here.
                </h2>

                <p class="text-white/70 text-sm leading-relaxed max-w-xs">
                    Safe, reliable rides across the city — available 24/7.
                </p>

                <div class="flex gap-6 mt-8">
                    <div>
                        <p class="text-white text-2xl font-semibold">50K+</p>
                        <p class="text-white/60 text-xs">Active Riders</p>
                    </div>

                    <div class="w-px bg-white/20"></div>

                    <div>
                        <p class="text-white text-2xl font-semibold">4.9★</p>
                        <p class="text-white/60 text-xs">Average Rating</p>
                    </div>

                    <div class="w-px bg-white/20"></div>

                    <div>
                        <p class="text-white text-2xl font-semibold">24/7</p>
                        <p class="text-white/60 text-xs">Available</p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- login form -->
    <div class="w-full md:w-1/2 bg-white flex items-center justify-center px-8 py-12 md:px-12 h-1/2 md:h-screen">
        <div class="w-full max-w-sm ">

            <div class="flex items-center gap-2 mb-8">
                <span class="text-2xl font-semibold text-red-700">SajhaRide</span>
            </div>

            <div class="mb-8">
                <h1 class="text-3xl font-semibold text-gray-900">Welcome back</h1>
                <p class="text-gray-400 text-sm mt-1">
                    Enter your credentials
                </p>
            </div>

            <form action="LoginServlet" method="post" class="space-y-5">

                <!-- email ko label -->
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2">
                        Email
                    </label>
                    <input
                            type="email"
                            name="email"
                            required
                            placeholder="name@example.com"
                            class="w-full px-4 py-3 rounded-xl border border-gray-200 bg-gray-50 text-sm focus:outline-none focus:ring-2 focus:ring-red-700"
                    />
                </div>

                <!-- password ko label-->
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2">
                        Password
                    </label>
                    <input
                            type="password"
                            name="password"
                            required
                            placeholder="••••••••"
                            class="w-full px-4 py-3 rounded-xl border border-gray-200 bg-gray-50 text-sm focus:outline-none focus:ring-2 focus:ring-red-700"
                    />
                </div>

                <div class="flex items-center justify-between">
                    <label class="flex items-center gap-2 text-sm text-gray-600">
                        <input type="checkbox" name="remember">
                        Remember me
                    </label>

                    <a href="forgotPassword.jsp" class="text-sm text-red-700 font-medium">
                        Forgot password?
                    </a>
                </div>

                <%--button submit--%>
                <button
                        type="submit"
                        class="w-full py-3 rounded-xl bg-red-700 text-white font-semibold hover:bg-red-800 transition"
                >
                    Login
                </button>

                <p class="text-center text-sm text-gray-500">
                    Don't have an account?
                    <a href="register.jsp" class="text-red-700 font-semibold">
                        Sign up
                    </a>
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