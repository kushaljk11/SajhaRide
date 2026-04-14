<%@ page contentType="text/html;charset=UTF-8" language="java" %> <% String ctx
= request.getContextPath(); %>

<html>
  <head>
    <title>SajhaRide</title>
    <script src="https://cdn.tailwindcss.com"></script>
  </head>

  <header class="w-full bg-white border-b border-neutral-300">
    <div
      class="relative mx-auto flex h-14 max-w-[1280px] items-center px-4 sm:px-6 lg:px-8"
    >
      <!-- Left: Logo -->
      <div class="flex items-center">
        <a
          href="<%= ctx %>/"
          class="flex items-center gap-2 transition"
        >
          <img
            src="<%= ctx %>/images/logo.svg"
            alt="SajhaRide"
            class="h-10 w-auto object-contain"
          />
          <span class="text-[20px] font-semibold text-red-800">Sajha<span class="text-[#154e75]">Ride</span></span>
          
        </a>
      </div>

      <!-- Center: Navbar -->
      <nav
        class="absolute left-1/2 hidden -translate-x-1/2 items-center gap-8 md:flex"
      >
        <a
          href="<%= ctx %>/"
          class="text-[13px] font-medium text-slate-700 hover:text-slate-900 transition"
        >
          Home
        </a>
        <a
          href="<%= ctx %>/rides"
          class="text-[13px] font-medium text-slate-700 hover:text-slate-900 transition"
        >
          Rent a Ride
        </a>
        <a
          href="<%= ctx %>/vehicles/list"
          class="text-[13px] font-medium text-slate-700 hover:text-slate-900 transition"
        >
          List a Vehicle
        </a>
        <a
                href="<%= ctx %>/vehicles/list"
                class="text-[13px] font-medium text-slate-700 hover:text-slate-900 transition"
        >
          About Us
        </a>
        <a
                href="<%= ctx %>/vehicles/list"
                class="text-[13px] font-medium text-slate-700 hover:text-slate-900 transition"
        >
          Contact
        </a>
      </nav>

      <!-- Right: Auth -->
      <div class="ml-auto flex items-center gap-4">
        <a
          href="<%= ctx %>/auth/login"
          class="rounded-xl border border-red-800 px-5 py-2 text-[12px] font-medium text-red-800 shadow-sm transition hover:bg-red-800 hover:text-white hover:shadow-md"
        >
          Login
        </a>

        <a
          href="<%= ctx %>/auth/register"
          class="rounded-xl bg-red-800 px-5 py-2 text-[12px] font-semibold text-white shadow-sm transition hover:bg-white hover:text-red-800 hover:border hover:border-red-800 hover:shadow-md"
        >
          Signup
        </a>
      </div>
    </div>
  </header>
</html>
