<%@ page
        contentType="text/html;charset=UTF-8" language="java" %>
<%
  String uri = request.getRequestURI();
  String ctx = request.getContextPath();
  String currentPath = uri.startsWith(ctx) ? uri.substring(ctx.length()) : uri;
  String servletPath = request.getServletPath();
  if (servletPath != null && !servletPath.isEmpty()) {
    currentPath = servletPath;
  }
  if (currentPath != null && currentPath.length() > 1 && currentPath.endsWith("/")) {
    currentPath = currentPath.substring(0, currentPath.length() - 1);
  }

  boolean dashboardActive = currentPath.startsWith("/owner/dashboard");
  boolean myVehicleActive = currentPath.startsWith("/owner/myvehicle");
  boolean addVehicleActive = currentPath.startsWith("/owner/add-vehicle") || currentPath.startsWith("/owner/addnewpost");
  boolean bookingsActive = currentPath.startsWith("/owner/bookings");
  boolean paymentsActive = currentPath.startsWith("/owner/payments");
  boolean settingsActive = currentPath.startsWith("/owner/settings");
  boolean chatActive = currentPath.startsWith("/owner/chat");
%>
<aside
  class="flex h-screen w-64 shrink-0 flex-col bg-white px-4 py-3 shadow-[1px_0_4px_rgba(153,27,27,0.18)]"
>
  <a href="${pageContext.request.contextPath}/" class="mb-5 flex items-center gap-2 px-1 transition hover:opacity-90" aria-label="Go to landing page" title="Home">
    <img
      src="${pageContext.request.contextPath}/images/logo.svg"
      alt="SajhaRide"
      class="h-9 w-auto"
    />
    <p class="text-lg mt-4 font-semibold text-red-800">
      Sajha<span class="text-blue-800">Ride</span>
    </p>
  </a>

  <hr />

  <nav class="space-y-2 mt-4">
    <a
      href="${pageContext.request.contextPath}/owner/dashboard"
      data-owner-route="/owner/dashboard"
      class="flex items-center gap-3 rounded-xl px-3 py-2.5 text-sm transition <%= dashboardActive ? "bg-red-800 font-semibold text-white" : "font-medium text-gray-600 hover:bg-gray-200 hover:text-gray-900" %>"
      <%= dashboardActive ? "aria-current=\"page\"" : "" %>
    >
      <svg
        class="h-5 w-5"
        viewBox="0 0 24 24"
        fill="none"
        stroke="currentColor"
        stroke-width="2"
        aria-hidden="true"
      >
        <rect x="4" y="4" width="7" height="7" rx="1"></rect>
        <rect x="13" y="4" width="7" height="7" rx="1"></rect>
        <rect x="4" y="13" width="7" height="7" rx="1"></rect>
        <rect x="13" y="13" width="7" height="7" rx="1"></rect>
      </svg>
      Dashboard
    </a>

    <a
      href="${pageContext.request.contextPath}/owner/myvehicle"
      data-owner-route="/owner/myvehicle"
      class="flex items-center gap-3 rounded-xl px-3 py-2.5 text-sm transition <%= myVehicleActive ? "bg-red-800 font-semibold text-white" : "font-medium text-gray-600 hover:bg-gray-200 hover:text-gray-900" %>"
      <%= myVehicleActive ? "aria-current=\"page\"" : "" %>
    >
      <svg
        class="h-5 w-5"
        viewBox="0 0 24 24"
        fill="none"
        stroke="currentColor"
        stroke-width="2"
        aria-hidden="true"
      >
        <path d="M3 10l9-6 9 6"></path>
        <path d="M5 10v9h14v-9"></path>
        <circle cx="8" cy="15" r="1.5"></circle>
        <circle cx="16" cy="15" r="1.5"></circle>
      </svg>
      My Vehicle
    </a>

    <a
      href="${pageContext.request.contextPath}/owner/add-vehicle"
      data-owner-route="/owner/add-vehicle"
      class="flex items-center gap-3 rounded-xl px-3 py-2.5 text-sm transition <%= addVehicleActive ? "bg-red-800 font-semibold text-white" : "font-medium text-gray-600 hover:bg-gray-200 hover:text-gray-900" %>"
      <%= addVehicleActive ? "aria-current=\"page\"" : "" %>
    >
      <svg
        class="h-5 w-5"
        viewBox="0 0 24 24"
        fill="none"
        stroke="currentColor"
        stroke-width="2"
        aria-hidden="true"
      >
        <path d="M12 5v14"></path>
        <path d="M5 12h14"></path>
      </svg>
      Add New Post
    </a>

    <a
      href="${pageContext.request.contextPath}/owner/bookings"
      data-owner-route="/owner/bookings"
      class="flex items-center gap-3 rounded-xl px-3 py-2.5 text-sm transition <%= bookingsActive ? "bg-red-800 font-semibold text-white" : "font-medium text-gray-600 hover:bg-gray-200 hover:text-gray-900" %>"
      <%= bookingsActive ? "aria-current=\"page\"" : "" %>
    >
      <svg
        class="h-5 w-5"
        viewBox="0 0 24 24"
        fill="none"
        stroke="currentColor"
        stroke-width="2"
        aria-hidden="true"
      >
        <rect x="3" y="4" width="18" height="16" rx="2"></rect>
        <path d="M3 10h18"></path>
      </svg>
      Bookings
    </a>

    <a
      href="${pageContext.request.contextPath}/owner/payments"
      data-owner-route="/owner/payments"
      class="flex items-center gap-3 rounded-xl px-3 py-2.5 text-sm transition <%= paymentsActive ? "bg-red-800 font-semibold text-white" : "font-medium text-gray-600 hover:bg-gray-200 hover:text-gray-900" %>"
      <%= paymentsActive ? "aria-current=\"page\"" : "" %>
    >
      <svg
        class="h-5 w-5"
        viewBox="0 0 24 24"
        fill="none"
        stroke="currentColor"
        stroke-width="2"
        aria-hidden="true"
      >
        <rect x="3" y="6" width="18" height="12" rx="2"></rect>
        <path d="M3 10h18"></path>
      </svg>
      Payment
    </a>

    <a
      href="${pageContext.request.contextPath}/owner/settings"
      data-owner-route="/owner/settings"
      class="flex items-center gap-3 rounded-xl px-3 py-2.5 text-sm transition <%= settingsActive ? "bg-red-800 font-semibold text-white" : "font-medium text-gray-600 hover:bg-gray-200 hover:text-gray-900" %>"
      <%= settingsActive ? "aria-current=\"page\"" : "" %>
    >
      <svg
        class="h-5 w-5"
        viewBox="0 0 24 24"
        fill="none"
        stroke="currentColor"
        stroke-width="2"
        aria-hidden="true"
      >
        <path d="M4 7h16"></path>
        <path d="M4 12h10"></path>
        <path d="M4 17h7"></path>
      </svg>
      Settings
    </a>

    <a
      href="${pageContext.request.contextPath}/owner/chat"
      data-owner-route="/owner/chat"
      class="flex items-center gap-3 rounded-xl px-3 py-2.5 text-sm transition <%= chatActive ? "bg-red-800 font-semibold text-white" : "font-medium text-gray-600 hover:bg-gray-200 hover:text-gray-900" %>"
      <%= chatActive ? "aria-current=\"page\"" : "" %>
    >
      <svg
        class="h-5 w-5"
        viewBox="0 0 24 24"
        fill="none"
        stroke="currentColor"
        stroke-width="2"
        aria-hidden="true"
      >
        <path d="M7 10h10"></path>
        <path d="M7 14h6"></path>
        <rect x="3" y="5" width="18" height="14" rx="2"></rect>
      </svg>
      Chat
    </a>

  </nav>
</aside>

<script>
  (function () {
    var path = window.location.pathname.replace(/\/$/, "");
    var links = document.querySelectorAll("a[data-owner-route]");

    links.forEach(function (link) {
      var route = (link.getAttribute("data-owner-route") || "").replace(/\/$/, "");
      var isActive = path === route || path.indexOf(route + "/") === 0;

      if (route === "/owner/bookings" && path.indexOf("/owner/bookings") === 0) {
        isActive = true;
      }
      if (route === "/owner/payments" && path.indexOf("/owner/payments") === 0) {
        isActive = true;
      }
      if (route === "/owner/settings" && path.indexOf("/owner/settings") === 0) {
        isActive = true;
      }
      if (route === "/owner/chat" && path.indexOf("/owner/chat") === 0) {
        isActive = true;
      }

      link.classList.remove("bg-red-800", "font-semibold", "text-white");
      link.classList.remove("font-medium", "text-gray-600", "hover:bg-gray-200", "hover:text-gray-900");

      if (isActive) {
        link.classList.add("bg-red-800", "font-semibold", "text-white");
        link.setAttribute("aria-current", "page");
      } else {
        link.classList.add("font-medium", "text-gray-600", "hover:bg-gray-200", "hover:text-gray-900");
        link.removeAttribute("aria-current");
      }
    });
  })();
</script>
