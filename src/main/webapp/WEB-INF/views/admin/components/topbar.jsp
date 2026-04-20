<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.riderental.myriderental.model.User" %>
<%
  User loggedInUser = (User) session.getAttribute("loggedInUser");
  String displayName = (loggedInUser != null && loggedInUser.getFullName() != null && !loggedInUser.getFullName().isBlank())
      ? loggedInUser.getFullName()
      : "Administrator";
  String roleLabel = (loggedInUser != null && loggedInUser.getRole() != null && !loggedInUser.getRole().isBlank())
      ? loggedInUser.getRole().toUpperCase()
      : "ADMIN";
%>

<header class="flex h-16 items-center justify-between gap-4 border-b border-red-100 bg-white px-5 shadow-[2px_0_8px_rgba(153,27,27,0.12)]">
  <div>
    <p class="text-xs font-semibold uppercase tracking-[0.18em] text-red-700">Admin Panel</p>
    <p class="mt-1 text-sm text-gray-500">Manage users, listings, and bookings from one place.</p>
  </div>

  <div class="flex items-center gap-3">
    <button
      class="inline-flex h-10 w-10 items-center justify-center rounded-full border border-red-800 bg-gray-100 text-red-800 transition hover:border-gray-400 hover:bg-indigo-50"
      type="button"
      aria-label="Notifications"
      title="Notifications"
    >
      <svg class="h-5 w-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
        <path d="M15 17h5l-1.4-1.4a2 2 0 0 1-.6-1.4V11a6 6 0 1 0-12 0v3.2a2 2 0 0 1-.6 1.4L4 17h5"></path>
        <path d="M9.5 17a2.5 2.5 0 0 0 5 0"></path>
      </svg>
    </button>

    <div class="flex items-center gap-3 rounded-full border border-gray-200 bg-gray-50 px-3 py-2">
      <div class="inline-flex h-9 w-9 items-center justify-center rounded-full bg-red-800 text-sm font-semibold text-white">
        <%= displayName.isEmpty() ? "A" : displayName.substring(0, 1).toUpperCase() %>
      </div>
      <div class="leading-tight">
        <p class="text-sm font-semibold text-gray-900"><%= displayName %></p>
        <p class="text-xs font-medium text-gray-500"><%= roleLabel %></p>
      </div>
    </div>
  </div>
</header>

