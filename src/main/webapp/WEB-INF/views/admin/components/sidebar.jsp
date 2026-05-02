<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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

  boolean dashboardActive = currentPath.startsWith("/admin/dashboard");
  boolean usersActive = currentPath.startsWith("/admin/users");
  boolean vehiclesActive = currentPath.startsWith("/admin/vehicles");
  boolean bookingsActive = currentPath.startsWith("/admin/bookings");
  boolean kycActive = currentPath.startsWith("/admin/kyc");
%>
<aside class="flex h-screen w-64 shrink-0 flex-col bg-white px-4 py-3 shadow-[1px_0_4px_rgba(153,27,27,0.18)]">
  <a href="${pageContext.request.contextPath}/" class="mb-5 flex items-center gap-2 px-1 transition hover:opacity-90" aria-label="Go to landing page" title="Home">
    <img
      src="${pageContext.request.contextPath}/images/logo.svg"
      alt="SajhaRide"
      class="h-9 w-auto"
    />
    <div>
      <p class="text-lg font-semibold text-red-800">
        Sajha<span class="text-blue-800">Ride</span>
      </p>
      <p class="text-[11px] font-semibold uppercase tracking-[0.2em] text-gray-400">
        Admin Console
      </p>
    </div>
  </a>

  <hr />

  <nav class="mt-4 space-y-2">
    <a
      href="${pageContext.request.contextPath}/admin/dashboard"
      data-admin-route="/admin/dashboard"
      class="flex items-center gap-3 rounded-xl px-3 py-2.5 text-sm transition <%= dashboardActive ? "bg-red-800 font-semibold text-white" : "font-medium text-gray-600 hover:bg-gray-200 hover:text-gray-900" %>"
      <%= dashboardActive ? "aria-current=\"page\"" : "" %>
    >
      <svg class="h-5 w-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
        <rect x="4" y="4" width="7" height="7" rx="1"></rect>
        <rect x="13" y="4" width="7" height="7" rx="1"></rect>
        <rect x="4" y="13" width="7" height="7" rx="1"></rect>
        <rect x="13" y="13" width="7" height="7" rx="1"></rect>
      </svg>
      Dashboard
    </a>

    <a
      href="${pageContext.request.contextPath}/admin/users"
      data-admin-route="/admin/users"
      class="flex items-center gap-3 rounded-xl px-3 py-2.5 text-sm transition <%= usersActive ? "bg-red-800 font-semibold text-white" : "font-medium text-gray-600 hover:bg-gray-200 hover:text-gray-900" %>"
      <%= usersActive ? "aria-current=\"page\"" : "" %>
    >
      <svg class="h-5 w-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
        <circle cx="12" cy="8" r="3"></circle>
        <path d="M5 20c1.6-3.1 4-5 7-5s5.4 1.9 7 5"></path>
      </svg>
      User Management
    </a>

    <a
      href="${pageContext.request.contextPath}/admin/vehicles"
      data-admin-route="/admin/vehicles"
      class="flex items-center gap-3 rounded-xl px-3 py-2.5 text-sm transition <%= vehiclesActive ? "bg-red-800 font-semibold text-white" : "font-medium text-gray-600 hover:bg-gray-200 hover:text-gray-900" %>"
      <%= vehiclesActive ? "aria-current=\"page\"" : "" %>
    >
      <svg class="h-5 w-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
        <path d="M3 10l2-4h14l2 4"></path>
        <path d="M5 10v9h14v-9"></path>
        <circle cx="8" cy="16" r="1.5"></circle>
        <circle cx="16" cy="16" r="1.5"></circle>
      </svg>
      Vehicle Management
    </a>

    <a
      href="${pageContext.request.contextPath}/admin/bookings"
      data-admin-route="/admin/bookings"
      class="flex items-center gap-3 rounded-xl px-3 py-2.5 text-sm transition <%= bookingsActive ? "bg-red-800 font-semibold text-white" : "font-medium text-gray-600 hover:bg-gray-200 hover:text-gray-900" %>"
      <%= bookingsActive ? "aria-current=\"page\"" : "" %>
    >
      <svg class="h-5 w-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
        <rect x="3" y="4" width="18" height="16" rx="2"></rect>
        <path d="M3 10h18"></path>
      </svg>
      Booking Management
    </a>

    <a
      href="${pageContext.request.contextPath}/admin/kyc"
      data-admin-route="/admin/kyc"
      class="flex items-center gap-3 rounded-xl px-3 py-2.5 text-sm transition <%= kycActive ? "bg-red-800 font-semibold text-white" : "font-medium text-gray-600 hover:bg-gray-200 hover:text-gray-900" %>"
      <%= kycActive ? "aria-current=\"page\"" : "" %>
    >
      <svg class="h-5 w-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
        <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path>
      </svg>
      KYC Management
    </a>
  </nav>

  <div class="mt-auto space-y-2 pt-6">
    <a
      href="${pageContext.request.contextPath}/logout"
      class="flex items-center gap-3 rounded-xl px-3 py-2.5 text-sm font-medium text-gray-600 transition hover:bg-gray-200 hover:text-gray-900"
    >
      <svg class="h-5 w-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
        <path d="M10 17l5-5-5-5"></path>
        <path d="M15 12H4"></path>
        <path d="M20 4v16"></path>
      </svg>
      Logout
    </a>
  </div>
</aside>

<script>
  (function () {
    var path = window.location.pathname.replace(/\/$/, "") || "/";
    var links = document.querySelectorAll("a[data-admin-route]");

    links.forEach(function (link) {
      var hrefPath;
      try {
        hrefPath = new URL(link.href, window.location.origin).pathname;
      } catch (e) {
        hrefPath = (link.getAttribute("href") || "");
      }
      var route = (hrefPath || "").replace(/\/$/, "") || "/";
      var isActive = path === route || path.indexOf(route + "/") === 0;

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

