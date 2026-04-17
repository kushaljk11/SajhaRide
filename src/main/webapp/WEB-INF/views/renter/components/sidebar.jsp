<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  String uri = request.getRequestURI();
  String ctx = request.getContextPath();
  String currentPath = uri.startsWith(ctx) ? uri.substring(ctx.length()) : uri;
  if (currentPath != null && currentPath.length() > 1 && currentPath.endsWith("/")) {
    currentPath = currentPath.substring(0, currentPath.length() - 1);
  }

  boolean dashboardActive = currentPath.startsWith("/renter/dashboard");
  boolean exploreActive = currentPath.startsWith("/explore");
  boolean profileActive = currentPath.startsWith("/profile");
%>
<aside class="flex h-screen w-64 shrink-0 flex-col bg-white px-4 py-3 shadow-[1px_0_4px_rgba(153,27,27,0.18)]">
  <div class="mb-5 flex items-center gap-2 px-1">
    <img src="${pageContext.request.contextPath}/images/logo.svg" alt="SajhaRide" class="h-9 w-auto" />
    <p class="mt-4 text-lg font-semibold text-red-800">Sajha<span class="text-blue-800">Ride</span></p>
  </div>

  <hr />

  <nav class="mt-4 space-y-2">
    <a href="${pageContext.request.contextPath}/renter/dashboard" class="flex items-center gap-3 rounded-xl px-3 py-2.5 text-sm transition <%= dashboardActive ? "bg-red-800 font-semibold text-white" : "font-medium text-gray-600 hover:bg-gray-200 hover:text-gray-900" %>">
      Dashboard
    </a>

    <a href="${pageContext.request.contextPath}/explore" class="flex items-center gap-3 rounded-xl px-3 py-2.5 text-sm transition <%= exploreActive ? "bg-red-800 font-semibold text-white" : "font-medium text-gray-600 hover:bg-gray-200 hover:text-gray-900" %>">
      Explore
    </a>

    <a href="${pageContext.request.contextPath}/profile" class="flex items-center gap-3 rounded-xl px-3 py-2.5 text-sm transition <%= profileActive ? "bg-red-800 font-semibold text-white" : "font-medium text-gray-600 hover:bg-gray-200 hover:text-gray-900" %>">
      Profile
    </a>
  </nav>
</aside>
