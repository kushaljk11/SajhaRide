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
  String topbarCtx = request.getContextPath();
  String displayName = (loggedInUser != null && loggedInUser.getFullName() != null && !loggedInUser.getFullName().isBlank())
      ? loggedInUser.getFullName()
      : "Profile";
%>

<header
  class="flex h-16 items-center justify-between gap-4 shadow-[2px_0_8px_rgba(153,27,27,0.18)] bg-white px-5"
>
  <div class="flex items-center gap-3">
    <button
      type="button"
      class="inline-flex h-10 w-10 items-center justify-center rounded-xl border border-gray-200 text-gray-700 transition hover:bg-gray-100 lg:hidden"
      aria-label="Toggle sidebar"
      aria-controls="ownerSidebar"
      aria-expanded="false"
      onclick="toggleOwnerSidebar()"
    >
      <svg class="h-5 w-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
        <path d="M3 6h18"></path>
        <path d="M3 12h18"></path>
        <path d="M3 18h18"></path>
      </svg>
    </button>
  </div>

  <div class="flex items-center gap-3">
    <div class="relative">
    <button
      class="inline-flex h-10 w-10 cursor-pointer items-center justify-center rounded-full border border-red-800 bg-gray-100 text-red-800 transition-colors duration-200 hover:border-gray-400 hover:bg-indigo-50"
      type="button"
      aria-label="Notifications"
      title="Notifications"
      onclick="toggleOwnerNotifications()"
    >
      <svg
        class="h-5 w-5"
        viewBox="0 0 24 24"
        fill="none"
        stroke="currentColor"
        stroke-width="2"
        stroke-linecap="round"
        stroke-linejoin="round"
        aria-hidden="true"
      >
        <path
          d="M15 17h5l-1.4-1.4a2 2 0 0 1-.6-1.4V11a6 6 0 1 0-12 0v3.2a2 2 0 0 1-.6 1.4L4 17h5"
        ></path>
        <path d="M9.5 17a2.5 2.5 0 0 0 5 0"></path>
      </svg>
      <% if (unreadCount > 0) { %>
      <span class="absolute top-0 right-0 inline-flex items-center justify-center px-2 py-1 text-xs font-bold leading-none text-white transform translate-x-1/4 -translate-y-1/4 bg-red-600 rounded-full"><%= unreadCount %></span>
      <% } %>
    </button>

    <div id="ownerNotificationDropdown" class="hidden absolute right-0 mt-2 w-80 bg-white rounded-md shadow-lg overflow-hidden z-50 border border-gray-200">
      <div class="py-2 px-4 bg-gray-50 border-b border-gray-200 flex justify-between items-center">
        <span class="font-bold text-gray-700">Notifications</span>
        <button onclick="markOwnerNotificationsRead()" class="text-xs text-blue-600 hover:text-blue-800">Mark all as read</button>
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

    <div class="group relative">
    <a
      href="<%= topbarCtx %>/profile"
      class="inline-flex h-10 w-10 cursor-pointer items-center justify-center rounded-full border border-gray-300 bg-red-800 text-white transition-colors duration-200 hover:border-red-800 hover:bg-red-900"
      aria-label="Open profile"
      title="Open profile"
    >
      <svg
        class="h-5 w-5"
        viewBox="0 0 24 24"
        fill="none"
        stroke="currentColor"
        stroke-width="2"
        stroke-linecap="round"
        stroke-linejoin="round"
        aria-hidden="true"
      >
        <circle cx="12" cy="8" r="4"></circle>
        <path d="M5 20c1.6-3.1 4-5 7-5s5.4 1.9 7 5"></path>
      </svg>
    </a>
    <div class="pointer-events-none absolute right-0 top-12 z-20 rounded-lg bg-red-800 px-3 py-1.5 text-xs font-semibold text-white opacity-0 shadow-lg transition-opacity duration-150 group-hover:opacity-100">
      <%= displayName %>
    </div>
  </div>
  </div>
</header>

<script>
  function toggleOwnerSidebar() {
    var sidebar = document.getElementById("ownerSidebar");
    var overlay = document.getElementById("ownerSidebarOverlay");
    var toggleButton = document.querySelector("[aria-controls='ownerSidebar']");
    if (!sidebar || !overlay) return;
    sidebar.classList.toggle("-translate-x-full");
    overlay.classList.toggle("hidden");
    if (toggleButton) {
      var expanded = !sidebar.classList.contains("-translate-x-full");
      toggleButton.setAttribute("aria-expanded", expanded ? "true" : "false");
    }
  }
  function toggleOwnerNotifications() {
    document.getElementById('ownerNotificationDropdown').classList.toggle('hidden');
  }
  function markOwnerNotificationsRead() {
    fetch('<%= request.getContextPath() %>/notifications/read', { method: 'POST' })
      .then(res => {
        if (res.ok) window.location.reload();
      });
  }
</script>
