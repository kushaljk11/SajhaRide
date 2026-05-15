<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.riderental.myriderental.model.User" %>
<%@ page import="java.util.List" %>
<%@ page import="com.riderental.myriderental.model.Notification" %>
<%@ page import="com.riderental.myriderental.dao.NotificationDAO" %>
<%
  User loggedInUser = (User) session.getAttribute("loggedInUser");
  NotificationDAO notifDAO = new NotificationDAO();
  List<Notification> notifications = loggedInUser != null ? notifDAO.findByUserId(loggedInUser.getUserId()) : java.util.Collections.emptyList();
  int unreadCount = loggedInUser != null ? notifDAO.getUnreadCount(loggedInUser.getUserId()) : 0;
  String displayName = (loggedInUser != null && loggedInUser.getFullName() != null && !loggedInUser.getFullName().isBlank())
      ? loggedInUser.getFullName()
      : "Administrator";
  String roleLabel = (loggedInUser != null && loggedInUser.getRole() != null && !loggedInUser.getRole().isBlank())
      ? loggedInUser.getRole().toUpperCase()
      : "ADMIN";
%>

<header class="flex h-16 items-center justify-between gap-4 border-b border-red-100 bg-white px-5 shadow-[2px_0_8px_rgba(153,27,27,0.12)]">
  <div class="flex items-center gap-3">
    <button
      type="button"
      class="inline-flex h-10 w-10 items-center justify-center rounded-xl border border-gray-200 text-gray-700 transition hover:bg-gray-100 lg:hidden"
      aria-label="Toggle sidebar"
      aria-controls="adminSidebar"
      aria-expanded="false"
      onclick="toggleAdminSidebar()"
    >
      <svg class="h-5 w-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
        <path d="M3 6h18"></path>
        <path d="M3 12h18"></path>
        <path d="M3 18h18"></path>
      </svg>
    </button>
<%--    <div>--%>
<%--      <p class="text-xs font-semibold uppercase tracking-[0.18em] text-red-700">Admin Panel</p>--%>
<%--      <p class="mt-1 text-sm text-gray-500">Manage users, listings, and bookings from one place.</p>--%>
<%--    </div>--%>
  </div>

  <div class="flex items-center gap-3">
    <div class="relative">
      <button
        class="inline-flex h-10 w-10 items-center justify-center rounded-full border border-red-800 bg-gray-100 text-red-800 transition hover:border-gray-400 hover:bg-indigo-50"
        type="button"
        aria-label="Notifications"
        title="Notifications"
        onclick="toggleAdminNotifications()"
      >
        <svg class="h-5 w-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
          <path d="M15 17h5l-1.4-1.4a2 2 0 0 1-.6-1.4V11a6 6 0 1 0-12 0v3.2a2 2 0 0 1-.6 1.4L4 17h5"></path>
          <path d="M9.5 17a2.5 2.5 0 0 0 5 0"></path>
        </svg>
        <% if (unreadCount > 0) { %>
        <span class="absolute top-0 right-0 inline-flex items-center justify-center px-2 py-1 text-xs font-bold leading-none text-white transform translate-x-1/4 -translate-y-1/4 bg-red-600 rounded-full"><%= unreadCount %></span>
        <% } %>
      </button>

      <div id="adminNotificationDropdown" class="hidden absolute right-0 mt-2 w-80 bg-white rounded-md shadow-lg overflow-hidden z-50 border border-gray-200">
        <div class="py-2 px-4 bg-gray-50 border-b border-gray-200 flex justify-between items-center">
          <span class="font-bold text-gray-700">Notifications</span>
          <button onclick="markAdminNotificationsRead()" class="text-xs text-blue-600 hover:text-blue-800">Mark all as read</button>
        </div>
        <div class="max-h-64 overflow-y-auto">
          <% if (notifications.isEmpty()) { %>
            <div class="px-4 py-3 text-sm text-gray-500">No new notifications.</div>
          <% } else {
               for (Notification n : notifications) { %>
            <div class="px-4 py-3 border-b border-gray-100 <%= n.isRead() ? "bg-white" : "bg-blue-50" %>">
              <p class="text-sm text-gray-800"><%= n.getMessage() %></p>
              <span class="text-xs text-gray-400"><%= n.getCreatedAt() != null ? n.getCreatedAt().toLocalDate() + " " + n.getCreatedAt().toLocalTime().withNano(0) : "" %></span>
            </div>
          <%   }
             } %>
        </div>
      </div>
    </div>

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

<script>
  function toggleAdminSidebar() {
    var sidebar = document.getElementById("adminSidebar");
    var overlay = document.getElementById("adminSidebarOverlay");
    var toggleButton = document.querySelector("[aria-controls='adminSidebar']");
    if (!sidebar || !overlay) return;
    sidebar.classList.toggle("-translate-x-full");
    overlay.classList.toggle("hidden");
    if (toggleButton) {
      var expanded = !sidebar.classList.contains("-translate-x-full");
      toggleButton.setAttribute("aria-expanded", expanded ? "true" : "false");
    }
  }
  function toggleAdminNotifications() {
    document.getElementById('adminNotificationDropdown').classList.toggle('hidden');
  }
  function markAdminNotificationsRead() {
    fetch('<%= request.getContextPath() %>/notifications/read', { method: 'POST' })
      .then(res => {
        if (res.ok) window.location.reload();
      });
  }
</script>

