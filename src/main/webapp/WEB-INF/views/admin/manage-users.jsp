<%@ page contentType="text/html;charset=UTF-8" language="java" import="jakarta.servlet.http.HttpServletRequest" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>SajhaRide - User Management</title>
  <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="h-screen overflow-hidden bg-gray-50 text-gray-900">
<div class="flex h-full">
  <jsp:include page="components/sidebar.jsp" />

  <%-- convenience ctx variable to use in scriptlets (request is ServletRequest) --%>
  <%
    String ctx = ((HttpServletRequest) request).getContextPath();
  %>

  <div class="flex min-w-0 flex-1 flex-col overflow-hidden">
    <jsp:include page="components/topbar.jsp" />

    <main class="flex-1 overflow-y-auto px-6 py-6 sm:px-8">
      <section class="mb-6 flex flex-col gap-4 lg:flex-row lg:items-center lg:justify-between">
        <div>
          <p class="text-xs font-semibold uppercase tracking-[0.18em] text-red-700">Management</p>
          <h1 class="mt-2 text-4xl font-semibold tracking-tight text-gray-900">User Management</h1>
          <p class="mt-2 text-sm text-gray-600">Search, review, and manage riders, owners, and admin accounts.</p>
        </div>
        <div class="flex flex-wrap gap-3">
          <a href="<%= ctx + "/admin/users/export-csv" %>" class="rounded-xl border border-gray-200 bg-white px-5 py-3 text-sm font-semibold text-gray-700 shadow-sm transition hover:bg-gray-100">Export CSV</a>
          <a href="<%= ctx + "/admin/users/create" %>" class="rounded-xl bg-red-800 px-5 py-3 text-sm font-semibold text-white shadow-sm transition hover:bg-red-900">+ Add User</a>
        </div>
      </section>

      <section class="mb-6 grid grid-cols-1 gap-4 md:grid-cols-3">
        <article class="rounded-3xl bg-blue-50 p-5 ring-1 ring-blue-100">
          <p class="text-xs font-semibold uppercase tracking-[0.16em] text-blue-700">Total Users</p>
          <p class="mt-3 text-3xl font-semibold text-gray-900"><%= request.getAttribute("totalUsers") != null ? request.getAttribute("totalUsers") : "0" %></p>
          <p class="mt-1 text-sm text-gray-500">Registered accounts</p>
        </article>
        <article class="rounded-3xl bg-red-50 p-5 ring-1 ring-red-100">
          <p class="text-xs font-semibold uppercase tracking-[0.16em] text-red-700">Active Today</p>
          <p class="mt-3 text-3xl font-semibold text-gray-900"><%= request.getAttribute("activeToday") != null ? request.getAttribute("activeToday") : "0" %></p>
          <p class="mt-1 text-sm text-gray-500">Logged-in users</p>
        </article>
        <article class="rounded-3xl bg-emerald-50 p-5 ring-1 ring-emerald-100">
          <p class="text-xs font-semibold uppercase tracking-[0.16em] text-emerald-700">New Requests</p>
          <p class="mt-3 text-3xl font-semibold text-gray-900"><%= request.getAttribute("newRequests") != null ? request.getAttribute("newRequests") : "0" %></p>
          <p class="mt-1 text-sm text-gray-500">Pending approvals</p>
        </article>
      </section>

      <section class="rounded-3xl border border-gray-200 bg-white p-5 shadow-sm">
        <div class="mb-5 flex flex-col gap-4 lg:flex-row lg:items-center lg:justify-between">
          <div class="relative w-full lg:max-w-xl">
            <input type="text" placeholder="Search by name, email or ID..." class="w-full rounded-2xl border border-gray-200 bg-gray-50 px-4 py-3 pl-11 text-sm outline-none transition focus:border-red-300 focus:bg-white focus:ring-2 focus:ring-red-100" />
            <svg class="pointer-events-none absolute left-4 top-1/2 h-4 w-4 -translate-y-1/2 text-gray-400" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true"><circle cx="11" cy="11" r="7"></circle><path d="m20 20-3.5-3.5"></path></svg>
          </div>
          <div class="flex flex-wrap gap-3 text-sm">
            <select class="rounded-xl border border-gray-200 bg-white px-4 py-3 text-gray-700 outline-none focus:border-red-300 focus:ring-2 focus:ring-red-100">
              <option>All Roles</option>
              <option>Owner</option>
              <option>Renter</option>
              <option>Admin</option>
            </select>
            <select class="rounded-xl border border-gray-200 bg-white px-4 py-3 text-gray-700 outline-none focus:border-red-300 focus:ring-2 focus:ring-red-100">
              <option>All Status</option>
              <option>Active</option>
              <option>Inactive</option>
              <option>Suspended</option>
            </select>
          </div>
        </div>

        <div class="overflow-x-auto">
          <table class="min-w-full text-left text-sm">
            <thead>
            <tr class="border-b border-gray-200 text-xs uppercase tracking-[0.12em] text-gray-500">
              <th class="px-3 py-3 font-semibold">User Profile</th>
              <th class="px-3 py-3 font-semibold">Role</th>
              <th class="px-3 py-3 font-semibold">Status</th>
              <th class="px-3 py-3 font-semibold">Joined Date</th>
              <th class="px-3 py-3 font-semibold text-right">Actions</th>
            </tr>
            </thead>
            <tbody>
            <%
              java.util.List<com.riderental.myriderental.model.User> users = (java.util.List<com.riderental.myriderental.model.User>) request.getAttribute("users");
              if (users != null) {
                for (com.riderental.myriderental.model.User u : users) {
            %>
            <tr class="border-b border-gray-100">
              <td class="px-3 py-4">
                <div class="flex items-center gap-3">
                  <img src="<%= u.getProfileImagePath() == null || u.getProfileImagePath().isBlank() ? (ctx + "/images/about.png") : u.getProfileImagePath() %>" alt="<%= u.getFullName() %>" class="h-11 w-11 rounded-full object-cover" />
                  <div>
                    <p class="font-semibold text-gray-900"><%= u.getFullName() %></p>
                    <p class="text-xs text-gray-500"><%= u.getEmail() %></p>
                  </div>
                </div>
              </td>
              <td class="px-3 py-4"><span class="rounded-full bg-gray-100 px-3 py-1 text-xs font-semibold text-gray-700"><%= u.getRole() == null ? "-" : u.getRole() %></span></td>
              <td class="px-3 py-4"><span class="rounded-full bg-emerald-100 px-3 py-1 text-xs font-semibold text-emerald-700"><%= u.getAccountStatus() == null ? "Active" : u.getAccountStatus() %></span></td>
              <td class="px-3 py-4 text-gray-600"><%= u.getCreatedAt() == null ? "-" : u.getCreatedAt().toLocalDate().toString() %></td>
              <td class="px-3 py-4">
                <div class="flex justify-end gap-2 text-gray-400">
                  <form action="<%= ctx + "/admin/users/edit" %>" method="get" style="display:inline-block;">
                    <input type="hidden" name="id" value="<%= u.getUserId() %>" />
                    <button class="rounded-lg border border-gray-200 p-2 hover:bg-gray-50" aria-label="Edit user">Edit</button>
                  </form>
                  <form action="<%= ctx + "/admin/users/suspend" %>" method="post" style="display:inline-block;">
                    <input type="hidden" name="id" value="<%= u.getUserId() %>" />
                    <button class="rounded-lg border border-gray-200 p-2 hover:bg-gray-50" aria-label="Suspend user">Suspend</button>
                  </form>
                  <form action="<%= ctx + "/admin/users/delete" %>" method="post" style="display:inline-block;" onsubmit="return confirm('Delete user?');">
                    <input type="hidden" name="id" value="<%= u.getUserId() %>" />
                    <button class="rounded-lg border border-gray-200 p-2 hover:bg-gray-50" aria-label="Delete user">Delete</button>
                  </form>
                </div>
              </td>
            </tr>
            <%    }
              } else {
            %>
            <tr><td colspan="5" class="px-3 py-4 text-center text-gray-500">No users found.</td></tr>
            <% } %>
            </tbody>
          </table>
        </div>

        <div class="mt-4 flex flex-col gap-4 border-t border-gray-100 pt-4 text-sm text-gray-500 md:flex-row md:items-center md:justify-between">
          <p>Showing <span id="rowCount">1</span>-<span id="pageSize">10</span> of <%= request.getAttribute("totalUsers") != null ? request.getAttribute("totalUsers") : "0" %> users</p>
          <div class="flex items-center gap-2">
            <button class="rounded-lg border border-gray-200 bg-gray-50 px-3 py-2 text-gray-400">&lt;</button>
            <button class="rounded-lg bg-red-800 px-3 py-2 font-semibold text-white">1</button>
            <button class="rounded-lg border border-gray-200 px-3 py-2 text-gray-700 hover:bg-gray-50">2</button>
            <button class="rounded-lg border border-gray-200 px-3 py-2 text-gray-700 hover:bg-gray-50">3</button>
            <button class="rounded-lg border border-gray-200 px-3 py-2 text-gray-700 hover:bg-gray-50">...</button>
            <button class="rounded-lg border border-gray-200 px-3 py-2 text-gray-700 hover:bg-gray-50">45</button>
            <button class="rounded-lg border border-gray-200 bg-gray-50 px-3 py-2 text-gray-400">&gt;</button>
          </div>
        </div>
      </section>
    </main>
  </div>
</div>
</body>
</html>

