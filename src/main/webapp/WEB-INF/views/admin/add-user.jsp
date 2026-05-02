<%@ page contentType="text/html;charset=UTF-8" language="java" import="jakarta.servlet.http.HttpServletRequest" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>SajhaRide - Add User</title>
  <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="h-screen overflow-hidden bg-gray-50 text-gray-900">
<div class="flex h-full">
  <jsp:include page="components/sidebar.jsp" />

  <%
    String ctx = ((HttpServletRequest) request).getContextPath();
  %>

  <div class="flex min-w-0 flex-1 flex-col overflow-hidden">
    <jsp:include page="components/topbar.jsp" />

    <main class="flex-1 overflow-y-auto px-6 py-6 sm:px-8">
      <section class="mb-6 flex flex-col gap-4 lg:flex-row lg:items-center lg:justify-between">
        <div>
          <p class="text-xs font-semibold uppercase tracking-[0.18em] text-red-700">User Management</p>
          <h1 class="mt-2 text-4xl font-semibold tracking-tight text-gray-900">Add New User</h1>
          <p class="mt-2 text-sm text-gray-600">Create a new user account in the system.</p>
        </div>
      </section>

      <section class="max-w-2xl rounded-3xl border border-gray-200 bg-white p-6 shadow-sm">
        <form method="POST" action="<%= ctx %>/admin/users/create" class="space-y-6">
          <div class="grid grid-cols-1 gap-4 sm:grid-cols-2">
            <div>
              <label class="block text-sm font-semibold text-gray-700">Full Name</label>
              <input type="text" name="fullName" required class="mt-2 w-full rounded-xl border border-gray-200 bg-gray-50 px-4 py-3 text-sm outline-none transition focus:border-red-300 focus:bg-white focus:ring-2 focus:ring-red-100" placeholder="John Doe" />
            </div>
            <div>
              <label class="block text-sm font-semibold text-gray-700">Email</label>
              <input type="email" name="email" required class="mt-2 w-full rounded-xl border border-gray-200 bg-gray-50 px-4 py-3 text-sm outline-none transition focus:border-red-300 focus:bg-white focus:ring-2 focus:ring-red-100" placeholder="john@example.com" />
            </div>
          </div>

          <div class="grid grid-cols-1 gap-4 sm:grid-cols-2">
            <div>
              <label class="block text-sm font-semibold text-gray-700">Phone Number</label>
              <input type="tel" name="phoneNumber" required class="mt-2 w-full rounded-xl border border-gray-200 bg-gray-50 px-4 py-3 text-sm outline-none transition focus:border-red-300 focus:bg-white focus:ring-2 focus:ring-red-100" placeholder="+977 9800000000" />
            </div>
            <div>
              <label class="block text-sm font-semibold text-gray-700">Role</label>
              <select name="role" required class="mt-2 w-full rounded-xl border border-gray-200 bg-gray-50 px-4 py-3 text-sm outline-none transition focus:border-red-300 focus:bg-white focus:ring-2 focus:ring-red-100">
                <option value="">Select Role</option>
                <option value="OWNER">Owner</option>
                <option value="RENTER">Renter</option>
                <option value="ADMIN">Admin</option>
              </select>
            </div>
          </div>

          <div>
            <label class="block text-sm font-semibold text-gray-700">Password</label>
            <input type="password" name="password" required class="mt-2 w-full rounded-xl border border-gray-200 bg-gray-50 px-4 py-3 text-sm outline-none transition focus:border-red-300 focus:bg-white focus:ring-2 focus:ring-red-100" placeholder="••••••••" />
          </div>

          <div class="flex gap-3 pt-4">
            <button type="submit" class="flex-1 rounded-xl bg-red-800 px-5 py-3 text-sm font-semibold text-white shadow-sm transition hover:bg-red-900">Create User</button>
            <a href="<%= ctx %>/admin/users" class="flex-1 rounded-xl border border-gray-200 bg-white px-5 py-3 text-center text-sm font-semibold text-gray-700 shadow-sm transition hover:bg-gray-50">Cancel</a>
          </div>
        </form>
      </section>
    </main>
  </div>
</div>
</body>
</html>

