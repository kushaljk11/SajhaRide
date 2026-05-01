<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.riderental.myriderental.model.User" %>
<%
  User loggedInUser = (User) session.getAttribute("loggedInUser");
  String topbarCtx = request.getContextPath();
  String displayName = (loggedInUser != null && loggedInUser.getFullName() != null && !loggedInUser.getFullName().isBlank())
          ? loggedInUser.getFullName()
          : "Profile";
%>

<header
        class="flex h-16 items-center justify-end gap-2.5 shadow-[2px_0_8px_rgba(153,27,27,0.18)] bg-white px-5"
>
  <button
          class="inline-flex h-10 w-10 cursor-pointer items-center justify-center rounded-full border border-red-800 bg-gray-100 text-red-800 transition-colors duration-200 hover:border-gray-400 hover:bg-indigo-50"
          type="button"
          aria-label="Notifications"
          title="Notifications"
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
  </button>

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
</header>
