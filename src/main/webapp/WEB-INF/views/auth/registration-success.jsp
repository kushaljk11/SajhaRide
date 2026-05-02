<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String role = (String) session.getAttribute("registeredRole");
    if (role == null) {
        role = "User"; // Fallback if somehow accessed directly without session attribute
    } else {
        // Clear the session attribute so it only shows once
        session.removeAttribute("registeredRole");
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registration Successful | SajhaRide</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-50 flex items-center justify-center min-h-screen p-4">
    <div class="max-w-md w-full bg-white rounded-3xl shadow-[0_8px_30px_rgb(0,0,0,0.12)] p-8 text-center border border-gray-100">
        <!-- Success Icon -->
        <div class="mx-auto flex items-center justify-center h-20 w-20 rounded-full bg-green-100 mb-6">
            <svg class="h-10 w-10 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path>
            </svg>
        </div>
        
        <h2 class="text-3xl font-bold text-gray-900 mb-4">Congratulations!</h2>
        
        <p class="text-gray-600 mb-8 leading-relaxed text-lg">
            You have successfully registered as a <span class="font-bold text-red-800"><%= role.toUpperCase() %></span> in the SajhaRide platform.
        </p>

        <a href="${pageContext.request.contextPath}/login" class="inline-block w-full bg-red-800 text-white font-semibold py-3 px-6 rounded-xl hover:bg-red-900 transition-colors duration-200 focus:outline-none focus:ring-2 focus:ring-red-800 focus:ring-offset-2 shadow-sm">
            Click here to login
        </a>
    </div>
</body>
</html>
