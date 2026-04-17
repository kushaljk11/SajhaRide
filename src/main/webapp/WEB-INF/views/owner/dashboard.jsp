<%--
  Created by IntelliJ IDEA.
  User: kusha
  Date: 4/11/2026
  Time: 3:17 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>SajhaRide</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="h-screen overflow-hidden bg-gray-50 text-gray-900">
  <div class="flex h-full">
    <jsp:include page="../owner/components/sidebar.jsp" />

    <div class="flex min-w-0 flex-1 flex-col overflow-hidden">
      <jsp:include page="../owner/components/topbar.jsp" />

      <main class="flex-1 overflow-y-auto">
      
        <!-- // dashboard overview section -->
        <div class="flex items-start justify-between gap-6 px-8 py-6">
          <div class="flex min-w-0 flex-1 flex-col">
            <h1 class="text-3xl font-semibold text-gray-900">Dashboard Overview</h1>
            <p class="mt-1 text-sm font-normal text-gray-500">Welcome back, Arjun. Here's what's happening today.</p>
          </div>
          <div>
            <button class="inline-flex items-center rounded-xl bg-red-700 px-6 py-3 text-sm font-semibold text-white shadow-md shadow-red-200 transition hover:bg-red-800 focus:outline-none focus:ring-2 focus:ring-red-300 focus:ring-offset-2">
              + Add New Vehicle
            </button>
          </div>
        </div>

        <div class="grid grid-cols-1 gap-4 px-8 pb-6 sm:grid-cols-2 xl:grid-cols-4">
          <article class="relative overflow-hidden rounded-3xl border border-emerald-100 bg-white p-4 shadow-sm">
            <div class="pointer-events-none absolute -right-8 -top-10 h-32 w-32 rounded-full bg-emerald-50"></div>
            <div class="relative mb-3 flex items-start justify-between gap-3">
              <h3 class="text-2xl font-semibold text-gray-900">Total Posts</h3>
              <span class="inline-flex h-14 w-14 items-center justify-center rounded-2xl bg-emerald-700 text-white">
                <svg class="h-6 w-6" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
                  <path d="M4 6h16"></path>
                  <path d="M4 12h16"></path>
                  <path d="M4 18h16"></path>
                </svg>
              </span>
            </div>
            <p class="text-2xl font-semibold leading-none text-gray-900">24</p>
            <p class="mt-2 text-sm text-gray-600">Total listings you have published.</p>
          </article>

          <article class="relative overflow-hidden rounded-3xl border border-amber-100 bg-white p-4 shadow-sm">
            <div class="pointer-events-none absolute -right-8 -top-10 h-32 w-32 rounded-full bg-amber-50"></div>
            <div class="relative mb-3 flex items-start justify-between gap-3">
              <h3 class="text-2xl font-semibold text-gray-900">Pending Posts</h3>
              <span class="inline-flex h-14 w-14 items-center justify-center rounded-2xl bg-amber-600 text-white">
                <svg class="h-6 w-6" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
                  <circle cx="12" cy="12" r="9"></circle>
                  <path d="M12 7v5"></path>
                  <path d="M12 16h.01"></path>
                </svg>
              </span>
            </div>
            <p class="text-2xl font-semibold leading-none text-gray-900">5</p>
            <p class="mt-2 text-sm text-gray-600">Posts waiting for approval or updates.</p>
          </article>

          <article class="relative overflow-hidden rounded-3xl border border-sky-100 bg-white p-4 shadow-sm">
            <div class="pointer-events-none absolute -right-8 -top-10 h-32 w-32 rounded-full bg-sky-50"></div>
            <div class="relative mb-3 flex items-start justify-between gap-3">
              <h3 class="text-2xl font-semibold text-gray-900">Bookings</h3>
              <span class="inline-flex h-14 w-14 items-center justify-center rounded-2xl bg-sky-700 text-white">
                <svg class="h-6 w-6" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
                  <rect x="3" y="4" width="18" height="18" rx="2"></rect>
                  <path d="M8 2v4"></path>
                  <path d="M16 2v4"></path>
                  <path d="M3 10h18"></path>
                </svg>
              </span>
            </div>
            <p class="text-2xl font-semibold leading-none text-gray-900">18</p>
            <p class="mt-2 text-sm text-gray-600">Confirmed bookings across all vehicles.</p>
          </article>

          <article class="relative overflow-hidden rounded-3xl border border-violet-100 bg-white p-4 shadow-sm">
            <div class="pointer-events-none absolute -right-8 -top-10 h-32 w-32 rounded-full bg-violet-50"></div>
            <div class="relative mb-3 flex items-start justify-between gap-3">
              <h3 class="text-xl font-semibold text-gray-900">Total Earning</h3>
              <span class="inline-flex h-14 w-14 items-center justify-center rounded-2xl bg-violet-700 text-white">
                <svg class="h-6 w-6" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
                  <path d="M12 1v22"></path>
                  <path d="M17 6.5a4.5 4.5 0 0 0-4.5-2.5h-1A4.5 4.5 0 0 0 7 8.5c0 2.5 2 3.5 5 4.5s5 2 5 4.5a4.5 4.5 0 0 1-4.5 4.5h-1A4.5 4.5 0 0 1 7 19.5"></path>
                </svg>
              </span>
            </div>
            <p class="text-2xl font-semibold leading-none text-gray-900">Rs. 84,500</p>
            <p class="mt-2 text-sm text-gray-600">Your total income</p>
          </article>
        </div>

        <div class="grid grid-cols-1 gap-6 px-8 pb-8 xl:grid-cols-3">
          <section class="xl:col-span-2">
            <div class="mb-4 flex items-center justify-between">
              <h2 class="text-2xl font-semibold text-gray-900">My Vehicle</h2>
              <button class="inline-flex items-center rounded-lg border border-gray-300 bg-white px-4 py-2 text-sm font-medium text-gray-700 transition hover:bg-gray-100">
                View All
              </button>
            </div>

            <div class="grid grid-cols-1 gap-4 md:grid-cols-2">
              <article class="overflow-hidden rounded-2xl border border-gray-200 bg-white shadow-sm">
                <img src="${pageContext.request.contextPath}/images/about.png" alt="Toyota Yaris" class="h-40 w-full object-cover">
                <div class="p-4">
                  <h3 class="text-lg font-semibold text-gray-900">Toyota Yaris 2021</h3>
                  <p class="mt-1 text-sm text-gray-600">Clean and fuel-efficient city ride.</p>
                  <div class="mt-3 flex items-center justify-between">
                    <span class="text-base font-semibold text-emerald-700">NPR 3,200 / day</span>
                    <span class="rounded-full bg-emerald-100 px-2.5 py-1 text-xs font-semibold text-emerald-700">Active</span>
                  </div>
                </div>
              </article>

              <article class="overflow-hidden rounded-2xl border border-gray-200 bg-white shadow-sm">
                <img src="${pageContext.request.contextPath}/images/register.png" alt="Hyundai Creta" class="h-40 w-full object-cover">
                <div class="p-4">
                  <h3 class="text-lg font-semibold text-gray-900">Hyundai Creta</h3>
                  <p class="mt-1 text-sm text-gray-600">Spacious SUV for family trips.</p>
                  <div class="mt-3 flex items-center justify-between">
                    <span class="text-base font-semibold text-emerald-700">NPR 5,000 / day</span>
                    <span class="rounded-full bg-amber-100 px-2.5 py-1 text-xs font-semibold text-amber-700">Pending</span>
                  </div>
                </div>
              </article>
              <hr>
            </div>
          </section>

          <section class="rounded-2xl border border-gray-200 bg-white p-5 shadow-sm">
            <h2 class="text-2xl font-semibold text-gray-900">Recent Booking</h2>
            <div class="mt-4 space-y-3">
              <article class="rounded-xl border border-gray-100 bg-gray-50 p-3">
                <p class="text-sm font-semibold text-gray-900">BK-3091 • Toyota Yaris</p>
                <p class="mt-1 text-sm text-gray-600">Rajan Shrestha • Apr 16, 2026</p>
                <p class="mt-1 text-sm font-semibold text-emerald-700">NPR 6,400</p>
              </article>

              <article class="rounded-xl border border-gray-100 bg-gray-50 p-3">
                <p class="text-sm font-semibold text-gray-900">BK-3084 • Hyundai Creta</p>
                <p class="mt-1 text-sm text-gray-600">Nisha Karki • Apr 15, 2026</p>
                <p class="mt-1 text-sm font-semibold text-emerald-700">NPR 10,000</p>
              </article>

              <article class="rounded-xl border border-gray-100 bg-gray-50 p-3">
                <p class="text-sm font-semibold text-gray-900">BK-3072 • Kia Sonet</p>
                <p class="mt-1 text-sm text-gray-600">Suman Lama • Apr 14, 2026</p>
                <p class="mt-1 text-sm font-semibold text-emerald-700">NPR 4,800</p>
              </article>
            </div>
          </section>
        </div>

        <div class="grid grid-cols-1 gap-6 px-8 pb-8 xl:grid-cols-2">
          <section class="rounded-2xl border border-red-900 bg-red-800 p-6 shadow-sm">
            <h2 class="text-2xl font-semibold text-white">Ready to Expand?</h2>
            <p class="mt-3 max-w-xl text-sm leading-6 text-white/90">
              Reach more renters by publishing a fresh vehicle post today. Add clear details, upload photos, and keep your listings active to boost bookings.
            </p>
            <button class="mt-5 inline-flex items-center rounded-xl border border-white/30 bg-white/10 px-5 py-2.5 text-sm font-semibold text-white transition hover:bg-white/20 focus:outline-none focus:ring-2 focus:ring-white/60 focus:ring-offset-2 focus:ring-offset-red-800">
              List New Post
            </button>
          </section>

          <section class="relative overflow-hidden rounded-2xl shadow-sm">
            <img src="${pageContext.request.contextPath}/images/about.png" alt="Community Spotlight" class="h-52 w-full object-cover">
            <div class="absolute inset-0 bg-gradient-to-t from-black/75 via-black/35 to-transparent"></div>
            <div class="absolute inset-x-0 bottom-0 p-5 text-white">
              <p class="text-xs font-semibold uppercase tracking-[0.16em] text-white/80">Community Spotlight</p>
              <h3 class="mt-1 text-3xl font-semibold leading-tight">New Rental Hubs in Pokhara</h3>
              <p class="mt-2 text-sm text-white/85">Expanding our network to the lake city. List your ride now.</p>
            </div>
          </section>
        </div>

      </main>
    </div>
  </div>
</body>
</html>
