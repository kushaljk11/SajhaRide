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

  boolean dashboardActive = currentPath.startsWith("/renter/dashboard");
  boolean myBookingsActive = currentPath.startsWith("/renter/booking");
  boolean savedActive = currentPath.startsWith("/renter/saved");
  boolean paymentsActive = currentPath.startsWith("/renter/payments");
  boolean chatActive = currentPath.startsWith("/renter/chat");
  boolean exploreActive = currentPath.startsWith("/explore");
  boolean profileActive = currentPath.startsWith("/profile");
%>
<aside class="flex h-screen w-64 shrink-0 flex-col bg-white px-4 py-3 shadow-[1px_0_4px_rgba(153,27,27,0.18)]">
  <div class="mb-5 gap-2 flex items-center px-1">
    <img src="${pageContext.request.contextPath}/images/logo.svg" alt="SajhaRide" class="h-9 w-auto" />
    <p class="text-lg mt-4 font-semibold text-red-800">
      Sajha<span class="text-blue-800">Ride</span>
    </p>
  </div>

  <hr />

  <nav class="mt-4 flex-1 space-y-2 pb-4">
    <a href="${pageContext.request.contextPath}/renter/dashboard" data-renter-route="/renter/dashboard" class="flex items-center gap-3 rounded-xl px-3 py-2.5 text-sm transition <%= dashboardActive ? "bg-red-800 font-semibold text-white" : "font-medium text-gray-600 hover:bg-gray-200 hover:text-gray-900" %>" <%= dashboardActive ? "aria-current=\"page\"" : "" %>>
      <svg class="h-5 w-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
        <rect x="4" y="4" width="7" height="7" rx="1"></rect>
        <rect x="13" y="4" width="7" height="7" rx="1"></rect>
        <rect x="4" y="13" width="7" height="7" rx="1"></rect>
        <rect x="13" y="13" width="7" height="7" rx="1"></rect>
      </svg>
      Dashboard
    </a>

    <a href="${pageContext.request.contextPath}/renter/booking" data-renter-route="/renter/booking" class="flex items-center gap-3 rounded-xl px-3 py-2.5 text-sm transition <%= myBookingsActive ? "bg-red-800 font-semibold text-white" : "font-medium text-gray-600 hover:bg-gray-200 hover:text-gray-900" %>" <%= myBookingsActive ? "aria-current=\"page\"" : "" %>>
      <svg class="h-5 w-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
        <rect x="3" y="4" width="18" height="16" rx="2"></rect>
        <path d="M3 10h18"></path>
      </svg>
      My Booking
    </a>

    <a href="${pageContext.request.contextPath}/renter/saved" data-renter-route="/renter/saved" class="flex items-center gap-3 rounded-xl px-3 py-2.5 text-sm transition <%= savedActive ? "bg-red-800 font-semibold text-white" : "font-medium text-gray-600 hover:bg-gray-200 hover:text-gray-900" %>" <%= savedActive ? "aria-current=\"page\"" : "" %>>
      <svg class="h-5 w-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
        <path d="M6 4h12a1 1 0 0 1 1 1v15l-7-4-7 4V5a1 1 0 0 1 1-1z"></path>
      </svg>
      Saved
    </a>

    <a href="${pageContext.request.contextPath}/renter/payments" data-renter-route="/renter/payments" class="flex items-center gap-3 rounded-xl px-3 py-2.5 text-sm transition <%= paymentsActive ? "bg-red-800 font-semibold text-white" : "font-medium text-gray-600 hover:bg-gray-200 hover:text-gray-900" %>" <%= paymentsActive ? "aria-current=\"page\"" : "" %>>
      <svg class="h-5 w-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
        <rect x="3" y="6" width="18" height="12" rx="2"></rect>
        <path d="M3 10h18"></path>
      </svg>
      Payment
    </a>

    <a href="${pageContext.request.contextPath}/renter/chat" data-renter-route="/renter/chat" class="flex items-center gap-3 rounded-xl px-3 py-2.5 text-sm transition <%= chatActive ? "bg-red-800 font-semibold text-white" : "font-medium text-gray-600 hover:bg-gray-200 hover:text-gray-900" %>" <%= chatActive ? "aria-current=\"page\"" : "" %>>
      <svg class="h-5 w-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
        <path d="M7 10h10"></path>
        <path d="M7 14h6"></path>
        <rect x="3" y="5" width="18" height="14" rx="2"></rect>
      </svg>
      Chat
    </a>

    <a href="${pageContext.request.contextPath}/explore" data-renter-route="/explore" class="flex items-center gap-3 rounded-xl px-3 py-2.5 text-sm transition <%= exploreActive ? "bg-red-800 font-semibold text-white" : "font-medium text-gray-600 hover:bg-gray-200 hover:text-gray-900" %>" <%= exploreActive ? "aria-current=\"page\"" : "" %>>
      <svg class="h-5 w-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
        <circle cx="11" cy="11" r="7"></circle>
        <path d="m20 20-3.5-3.5"></path>
      </svg>
      Explore
    </a>

    <a href="${pageContext.request.contextPath}/profile" data-renter-route="/profile" class="flex items-center gap-3 rounded-xl px-3 py-2.5 text-sm transition <%= profileActive ? "bg-red-800 font-semibold text-white" : "font-medium text-gray-600 hover:bg-gray-200 hover:text-gray-900" %>" <%= profileActive ? "aria-current=\"page\"" : "" %>>
      <svg class="h-5 w-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
        <circle cx="12" cy="8" r="3"></circle>
        <path d="M5 19c0-3.5 3-6 7-6s7 2.5 7 6"></path>
      </svg>
      Profile
    </a>
  </nav>
</aside>

<script>
  (function () {
    var path = window.location.pathname.replace(/\/$/, "");
    var links = document.querySelectorAll("a[data-renter-route]");

    links.forEach(function (link) {
      var route = (link.getAttribute("data-renter-route") || "").replace(/\/$/, "");
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
