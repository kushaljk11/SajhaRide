<%@ page contentType="text/html;charset=UTF-8" language="java" %>
  <%@ page import="com.riderental.myriderental.model.User" %>
    <% User loggedInUser=(User) session.getAttribute("loggedInUser"); String topbarCtx=request.getContextPath(); String
      displayName=(loggedInUser !=null && loggedInUser.getFullName() !=null && !loggedInUser.getFullName().isBlank()) ?
      loggedInUser.getFullName() : "Profile" ; %>

      <header class="flex h-16 items-center justify-end gap-2.5 shadow-[2px_0_8px_rgba(153,27,27,0.18)] bg-white px-5">
        <div class="relative">
          <button id="notificationBtn"
            class="inline-flex h-10 w-10 cursor-pointer items-center justify-center rounded-full border border-red-800 bg-gray-100 text-red-800 transition-colors duration-200 hover:border-gray-400 hover:bg-indigo-50"
            type="button" aria-label="Notifications" title="Notifications">
            <svg class="h-5 w-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
              stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
              <path d="M15 17h5l-1.4-1.4a2 2 0 0 1-.6-1.4V11a6 6 0 1 0-12 0v3.2a2 2 0 0 1-.6 1.4L4 17h5"></path>
              <path d="M9.5 17a2.5 2.5 0 0 0 5 0"></path>
            </svg>
            <span class="absolute top-0 right-0 inline-flex items-center justify-center px-2 py-1 text-xs font-bold leading-none text-white transform translate-x-1/4 -translate-y-1/4 bg-red-600 rounded-full">3</span>
          </button>

          <!-- Notification Dropdown -->
          <div id="notificationDropdown" class="hidden absolute right-0 mt-2 w-80 bg-white rounded-xl shadow-lg border border-gray-100 z-50 overflow-hidden">
            <div class="px-4 py-3 border-b border-gray-100 bg-gray-50 flex justify-between items-center">
              <span class="font-bold text-gray-700">Notifications</span>
              <span class="text-xs text-red-800 font-semibold bg-red-100 px-2 py-1 rounded-full">3 New</span>
            </div>
            <div class="max-h-64 overflow-y-auto">
              <div class="px-4 py-3 border-b border-gray-50 hover:bg-gray-50 transition cursor-pointer">
                <p class="text-sm text-gray-800 font-semibold">Booking Approved</p>
                <p class="text-xs text-gray-500 mt-1">Your vehicle booking for tomorrow has been confirmed by the owner.</p>
                <p class="text-[10px] text-gray-400 mt-1">2 mins ago</p>
              </div>
              <div class="px-4 py-3 border-b border-gray-50 hover:bg-gray-50 transition cursor-pointer">
                <p class="text-sm text-gray-800 font-semibold">KYC Verification</p>
                <p class="text-xs text-gray-500 mt-1">Your driving license verification is currently pending review.</p>
                <p class="text-[10px] text-gray-400 mt-1">1 hour ago</p>
              </div>
              <div class="px-4 py-3 hover:bg-gray-50 transition cursor-pointer">
                <p class="text-sm text-gray-800 font-semibold">System Update</p>
                <p class="text-xs text-gray-500 mt-1">SajhaRide will be undergoing maintenance tonight at 12:00 AM.</p>
                <p class="text-[10px] text-gray-400 mt-1">3 hours ago</p>
              </div>
            </div>
            <div class="px-4 py-2 border-t border-gray-100 bg-gray-50 text-center">
              <a href="#" class="text-sm font-semibold text-red-800 hover:text-red-900 transition">Mark all as read</a>
            </div>
          </div>
        </div>

        <div class="group relative">
          <a href="<%= topbarCtx %>/profile"
            class="inline-flex h-10 w-10 cursor-pointer items-center justify-center rounded-full border border-gray-300 bg-red-800 text-white transition-colors duration-200 hover:border-red-800 hover:bg-red-900"
            aria-label="Open profile" title="Open profile">
            <svg class="h-5 w-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
              stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
              <circle cx="12" cy="8" r="4"></circle>
              <path d="M5 20c1.6-3.1 4-5 7-5s5.4 1.9 7 5"></path>
            </svg>
          </a>
          <div
            class="pointer-events-none absolute right-0 top-12 z-20 rounded-lg bg-red-800 px-3 py-1.5 text-xs font-semibold text-white opacity-0 shadow-lg transition-opacity duration-150 group-hover:opacity-100">
            <%= displayName %>
          </div>
        </div>
      </header>

      <script>
        document.addEventListener('DOMContentLoaded', function() {
          const notifBtn = document.getElementById('notificationBtn');
          const notifDropdown = document.getElementById('notificationDropdown');

          if (notifBtn && notifDropdown) {
            notifBtn.addEventListener('click', function(e) {
              e.stopPropagation();
              notifDropdown.classList.toggle('hidden');
            });

            document.addEventListener('click', function(e) {
              if (!notifDropdown.contains(e.target) && !notifBtn.contains(e.target)) {
                notifDropdown.classList.add('hidden');
              }
            });
          }
        });
      </script>