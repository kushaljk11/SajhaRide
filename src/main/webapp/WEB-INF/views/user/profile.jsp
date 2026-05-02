<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="com.riderental.myriderental.model.User" %>
        <% User user=(User) request.getAttribute("user"); String successMsg=(String)
            session.getAttribute("profileSuccess"); String errorMsg=(String) session.getAttribute("profileError"); if
            (successMsg !=null) session.removeAttribute("profileSuccess"); if (errorMsg !=null)
            session.removeAttribute("profileError"); java.util.function.Function<String, String> esc = (s) ->
            s == null ? "" : s.replace("&", "&amp;")
            .replace("<", "&lt;" ) .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#x27;");

                String fullName = esc.apply(user != null ? user.getFullName() : "");
                String phone = esc.apply(user != null ? user.getPhoneNumber() : "");
                String address = esc.apply(user != null ? user.getAddress() : "");
                String email = esc.apply(user != null ? user.getEmail() : "");
                String status = esc.apply(user != null ? user.getAccountStatus() : "");
                String role = esc.apply(user != null ? user.getRole() : "");
                boolean isRenter = user != null && user.getRole() != null && "RENTER".equalsIgnoreCase(user.getRole());
                boolean isOwner = user != null && user.getRole() != null && "OWNER".equalsIgnoreCase(user.getRole());

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

                    <% if (isRenter || isOwner) { %>
                        <div class="flex h-screen overflow-hidden">
                            <% if (isRenter) { %>
                                <%@ include file="/WEB-INF/views/renter/components/sidebar.jsp" %>
                            <% } else if (isOwner) { %>
                                <%@ include file="/WEB-INF/views/owner/components/sidebar.jsp" %>
                            <% } %>
                                <div class="flex min-w-0 flex-1 flex-col overflow-hidden">
                                    <% if (isRenter) { %>
                                        <%@ include file="/WEB-INF/views/renter/components/topbar.jsp" %>
                                    <% } else if (isOwner) { %>
                                        <%@ include file="/WEB-INF/views/owner/components/topbar.jsp" %>
                                    <% } %>
                                        <main class="flex-1 overflow-y-auto bg-gray-50">
                                            <% } %>

                                                <!-- Header -->
                                                <% if (!isRenter && !isOwner) { %>
                                                    <header class="bg-red-800 text-white shadow-md">
                                                        <div
                                                            class="max-w-7xl mx-auto px-6 py-5 flex items-center justify-between">
                                                            <div>
                                                                <h1 class="text-3xl font-bold">My Profile</h1>
                                                                <p class="text-red-100 text-sm mt-1">
                                                                    NOTE: Everything you change will be update....
                                                                </p>
                                                            </div>

                                                            <a href="${pageContext.request.contextPath}/logout"
                                                                class="bg-white/10 border border-white/20 px-5 py-2 rounded-lg hover:bg-white/20 transition">
                                                                Logout
                                                            </a>
                                                        </div>
                                                    </header>
                                                    <% } %>

                                                        <!-- Main Layout -->
                                                        <div
                                                            class="max-w-7xl mx-auto px-6 py-8 grid grid-cols-1 lg:grid-cols-4 gap-6">

                                                            <!-- Sidebar -->
                                                            <aside class="space-y-6">

                                                                <!-- Profile Card -->
                                                                <div
                                                                    class="bg-white rounded-3xl shadow-sm border border-gray-100 p-6">
                                                                    <div class="flex flex-col items-center">
                                                                        <div
                                                                            class="w-24 h-24 rounded-full overflow-hidden bg-red-100 border-4 border-red-50 flex items-center justify-center text-3xl font-bold text-red-800">
                                                                            <% if (imagePath !=null) { %>
                                                                                <img src="${pageContext.request.contextPath}/<%= imagePath %>"
                                                                                    class="w-full h-full object-cover"
                                                                                    alt="Profile photo">
                                                                                <% } else { %>
                                                                                    <%= initial %>
                                                                                        <% } %>
                                                                        </div>

                                                                        <h2
                                                                            class="mt-4 text-lg font-semibold text-gray-800 flex items-center justify-center">
                                                                            <%= fullName.isEmpty() ? "User" : fullName %>
                                                                            <% if (user != null && user.isVerified()) { %>
                                                                                <svg class="w-5 h-5 text-blue-500 inline-block ml-1" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"></path></svg>
                                                                            <% } %>
                                                                        </h2>

                                                                        <p class="text-sm text-gray-500 mt-1">
                                                                            <%= role %>
                                                                        </p>
                                                                    </div>
                                                                </div>

                                                                <!-- Account Info -->
                                                                <div
                                                                    class="bg-white rounded-3xl shadow-sm border border-gray-100 p-6">
                                                                    <h3 class="text-lg font-semibold text-red-800 mb-4">
                                                                        Account Information
                                                                    </h3>

                                                                    <div class="space-y-4 text-sm">
                                                                        <div>
                                                                            <p class="text-gray-400 uppercas text-sm">
                                                                                Email</p>
                                                                            <p
                                                                                class="font-medium text-gray-700 break-all">
                                                                                <%= email %>
                                                                            </p>
                                                                        </div>

                                                                        <div>
                                                                            <p class="text-gray-400 text-sm">Status</p>
                                                                            <p class="font-medium text-green-600">
                                                                                <%= status %>
                                                                            </p>
                                                                        </div>

                                                                        <div>
                                                                            <p class="text-gray-400 text-sm">Role</p>
                                                                            <p class="font-medium text-gray-700">
                                                                                <%= role %>
                                                                            </p>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </aside>

                                                            <!-- Main Form -->
                                                            <main class="lg:col-span-3">
                                                                <div
                                                                    class="bg-white rounded-3xl shadow-sm border border-gray-100 p-8">

                                                                    <div class="mb-6">
                                                                        <h2 class="text-2xl font-bold text-gray-800">
                                                                            Edit Profile</h2>
                                                                        <p class="text-sm text-gray-500 mt-1">
                                                                            Keep your information up to date
                                                                        </p>
                                                                    </div>

                                                                    <!-- Success Message -->
                                                                    <% if (successMsg !=null && !successMsg.isEmpty()) {
                                                                        %>
                                                                        <div
                                                                            class="mb-5 bg-green-50 border border-green-200 text-green-700 rounded-xl px-4 py-3">
                                                                            <%= esc.apply(successMsg) %>
                                                                        </div>
                                                                        <% } %>

                                                                            <!-- Error Message -->
                                                                            <% if (errorMsg !=null &&
                                                                                !errorMsg.isEmpty()) { %>
                                                                                <div
                                                                                    class="mb-5 bg-red-50 border border-red-200 text-red-700 rounded-xl px-4 py-3">
                                                                                    <%= esc.apply(errorMsg) %>
                                                                                </div>
                                                                                <% } %>

                                                                                    <form
                                                                                        action="${pageContext.request.contextPath}/profile"
                                                                                        method="post"
                                                                                        enctype="multipart/form-data"
                                                                                        class="space-y-6">

                                                                                        <div
                                                                                            class="grid md:grid-cols-2 gap-6">

                                                                                            <div>
                                                                                                <label
                                                                                                    class="block text-sm font-medium text-gray-600 mb-2">
                                                                                                    Full Name
                                                                                                </label>
                                                                                                <input type="text"
                                                                                                    name="fullName"
                                                                                                    value="<%= fullName %>"
                                                                                                    required
                                                                                                    class="w-full px-4 py-3 rounded-xl border border-gray-200 bg-gray-50 focus:outline-none focus:ring-2 focus:ring-red-800">
                                                                                            </div>

                                                                                            <div>
                                                                                                <label
                                                                                                    class="block text-sm font-medium text-gray-600 mb-2">
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
                                                                                            <label
                                                                                                class="block text-sm font-medium text-gray-600 mb-2">
                                                                                                Address
                                                                                            </label>
                                                                                            <input type="text"
                                                                                                name="address"
                                                                                                value="<%= address %>"
                                                                                                required
                                                                                                class="w-full px-4 py-3 rounded-xl border border-gray-200 bg-gray-50 focus:outline-none focus:ring-2 focus:ring-red-800">
                                                                                        </div>

                                                                                        <!-- Current Image -->
                                                                                        <% if (imagePath !=null) { %>
                                                                                            <div
                                                                                                class="flex items-center gap-3">
                                                                                                <img src="${pageContext.request.contextPath}/<%= imagePath %>"
                                                                                                    class="w-10 h-10 rounded-full object-cover border"
                                                                                                    alt="Current image">
                                                                                                <span
                                                                                                    class="text-sm text-gray-500">
                                                                                                    Current Photo ||
                                                                                                    Upload new one to
                                                                                                    replace
                                                                                                </span>
                                                                                            </div>
                                                                                            <% } %>

                                                                                                <!-- File Upload -->
                                                                                                <div>
                                                                                                    <label
                                                                                                        class="block text-sm font-medium text-gray-600 mb-2">
                                                                                                        Profile Image
                                                                                                    </label>

                                                                                                    <label
                                                                                                        for="profileImage"
                                                                                                        class="block border-2 border-dashed border-gray-300 rounded-xl p-5 bg-gray-50 hover:border-red-800 cursor-pointer transition">
                                                                                                        <div
                                                                                                            class="text-center">
                                                                                                            <p
                                                                                                                class="font-medium text-gray-700">
                                                                                                                Click to
                                                                                                                upload a
                                                                                                                photo
                                                                                                            </p>
                                                                                                            <p
                                                                                                                class="text-sm text-gray-400">
                                                                                                                PNG,
                                                                                                                JPG,
                                                                                                                WEBP —
                                                                                                                max 5 MB
                                                                                                            </p>
                                                                                                            <p id="fileNameDisplay"
                                                                                                                class="text-red-800 text-sm mt-2 hidden">
                                                                                                            </p>
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

                                                                <div class="bg-white rounded-3xl shadow-sm border border-gray-100 p-8 mt-6">
                                                                    <div class="mb-6 flex justify-between items-center">
                                                                        <div>
                                                                            <h2 class="text-2xl font-bold text-gray-800">Identity Verification</h2>
                                                                            <p class="text-sm text-gray-500 mt-1">Upload your <%= "OWNER".equalsIgnoreCase(role) ? "vehicle document" : "driving license" %> for verification</p>
                                                                        </div>
                                                                        <%
                                                                            com.riderental.myriderental.model.KycVerification kyc = (com.riderental.myriderental.model.KycVerification) request.getAttribute("kyc");
                                                                            if (kyc != null) {
                                                                                String badgeColor = "bg-yellow-100 text-yellow-800";
                                                                                if ("APPROVED".equals(kyc.getStatus())) badgeColor = "bg-green-100 text-green-800";
                                                                                if ("REJECTED".equals(kyc.getStatus())) badgeColor = "bg-red-100 text-red-800";
                                                                        %>
                                                                                <span class="px-3 py-1 text-xs font-semibold rounded-full <%= badgeColor %>">
                                                                                    <%= kyc.getStatus() %>
                                                                                </span>
                                                                        <% } else { %>
                                                                                <span class="px-3 py-1 text-xs font-semibold rounded-full bg-gray-100 text-gray-800">
                                                                                    NOT SUBMITTED
                                                                                </span>
                                                                        <% } %>
                                                                    </div>

                                                                    <% if (kyc != null && "REJECTED".equals(kyc.getStatus()) && kyc.getRejectionReason() != null) { %>
                                                                    <div class="mb-5 bg-red-50 border border-red-200 text-red-700 rounded-xl px-4 py-3 text-sm">
                                                                        <strong>Reason for rejection:</strong> <%= esc.apply(kyc.getRejectionReason()) %>
                                                                    </div>
                                                                    <% } %>

                                                                    <form action="${pageContext.request.contextPath}/user/kyc/upload" method="post" enctype="multipart/form-data" class="space-y-6">
                                                                        <div>
                                                                            <label class="block text-sm font-medium text-gray-600 mb-2">Document Type</label>
                                                                            <select name="documentType" required class="w-full px-4 py-3 rounded-xl border border-gray-200 bg-gray-50 focus:outline-none focus:ring-2 focus:ring-red-800">
                                                                                <% if ("OWNER".equalsIgnoreCase(role)) { %>
                                                                                    <option value="VEHICLE_DOCUMENT">Vehicle Document</option>
                                                                                <% } else { %>
                                                                                    <option value="LICENSE">Driving License</option>
                                                                                <% } %>
                                                                            </select>
                                                                        </div>
                                                                        <div>
                                                                            <label class="block text-sm font-medium text-gray-600 mb-2">Upload Document</label>
                                                                            <label for="kycDocument" class="block border-2 border-dashed border-gray-300 rounded-xl p-5 bg-gray-50 hover:border-red-800 cursor-pointer transition">
                                                                                <div class="text-center">
                                                                                    <p class="font-medium text-gray-700">Click to upload document</p>
                                                                                    <p class="text-sm text-gray-400">PDF, JPG, PNG — max 5 MB</p>
                                                                                    <p id="kycFileNameDisplay" class="text-red-800 text-sm mt-2 hidden"></p>
                                                                                </div>
                                                                            </label>
                                                                            <input type="file" id="kycDocument" name="kycDocument" accept=".pdf,image/*" required class="hidden" onchange="showKycFileName(this)">
                                                                        </div>
                                                                        <button type="submit" class="bg-red-800 hover:bg-red-900 text-white px-6 py-3 rounded-xl font-semibold shadow-sm transition">
                                                                            Submit for Verification
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

                                                            function showKycFileName(input) {
                                                                const display = document.getElementById("kycFileNameDisplay");

                                                                if (input.files && input.files[0]) {
                                                                    display.textContent = input.files[0].name;
                                                                    display.classList.remove("hidden");
                                                                } else {
                                                                    display.classList.add("hidden");
                                                                }
                                                            }
                                                        </script>

                                                        <% if (isRenter || isOwner) { %>
                                        </main>
                                </div>
                        </div>
                        <% } %>

                </body>

                </html>