<%--
  Created by IntelliJ IDEA.
  User: kusha
  Date: 4/16/2026
  Time: 10:14 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>SajhaRide</title>
  <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="h-screen overflow-hidden bg-gray-100 text-gray-900">
<div class="flex h-full">
  <jsp:include page="../owner/components/sidebar.jsp" />

  <div class="flex min-w-0 flex-1 flex-col overflow-hidden">
    <jsp:include page="../owner/components/topbar.jsp" />

    <main class="flex-1 overflow-y-auto px-6 py-6 sm:px-8">
      <section class="mb-6 flex flex-col gap-4 lg:flex-row lg:items-start lg:justify-between">
        <div class="min-w-0 flex-1">
          <h1 class="text-3xl font-semibold tracking-tight text-gray-900">Manage Your Listed Fleet</h1>
          <p class="mt-2 max-w-2xl text-sm text-gray-600">
            Oversee your vehicle listings, update availability status, and track booking performance across Nepal.
          </p>
        </div>
        <div>
          <button class="inline-flex items-center gap-2 rounded-xl bg-red-800 px-5 py-3 text-sm font-semibold text-white shadow-lg shadow-red-200 transition hover:bg-red-900 focus:outline-none focus:ring-2 focus:ring-red-300 focus:ring-offset-2" type="button">
            <svg class="h-4 w-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
              <path d="M12 5v14"></path>
              <path d="M5 12h14"></path>
            </svg>
            Add New Vehicle
          </button>
        </div>
      </section>

      <section class="mb-6 grid grid-cols-1 gap-4 sm:grid-cols-2 xl:grid-cols-4">
        <article class="rounded-2xl border border-red-100 bg-white p-5 shadow-sm">
          <p class="text-xs font-semibold text-blue-700">Total Fleet</p>
          <p class="mt-3 text-3xl font-semibold text-gray-900">12 <span class="text-xl font-semibold text-gray-700">Units</span></p>
        </article>
        <article class="rounded-2xl border border-emerald-100 bg-white p-5 shadow-sm">
          <p class="text-xs font-semibold text-emerald-700">Active Now</p>
          <p class="mt-3 text-3xl font-semibold text-gray-900">8 <span class="text-xl font-semibold text-gray-700">Units</span></p>
        </article>
        <article class="rounded-2xl border border-amber-100 bg-white p-5 shadow-sm">
          <p class="text-xs font-semibold text-amber-700">In Service</p>
          <p class="mt-3 text-3xl font-semibold text-gray-900">4 <span class="text-xl font-semibold text-gray-700">Units</span></p>
        </article>
        <article class="rounded-2xl border border-red-100 bg-white p-5 shadow-sm">
          <p class="text-xs font-semibold text-red-700">Monthly Rev</p>
          <p class="mt-3 text-3xl font-semibold text-gray-900">NPR 142k</p>
        </article>
      </section>

      <section class="grid grid-cols-1 gap-5 md:grid-cols-2 2xl:grid-cols-3">
        <article class="overflow-hidden rounded-2xl border border-gray-200 bg-white shadow-sm transition hover:shadow-md">
          <div class="relative">
            <img src="${pageContext.request.contextPath}/images/about.png" alt="Mahindra Scorpio 4WD" class="h-52 w-full object-cover" />
            <span class="absolute left-3 top-3 inline-flex items-center rounded-full bg-emerald-700 px-3 py-1 text-[11px] font-bold uppercase tracking-wide text-white">
              Active
            </span>
          </div>
          <div class="p-4">
            <div class="flex items-start justify-between gap-4">
              <div>
                <h2 class="text-xl font-semibold leading-tight text-gray-900">Mahindra Scorpio 4WD</h2>
                <p class="mt-1 text-sm text-gray-600">Heavy-duty SUV • 7 Seats</p>
              </div>
              <p class="text-right text-xl font-semibold text-red-800">NPR 4,500<br /><span class="text-xs font-medium uppercase tracking-wide text-gray-500">per day</span></p>
            </div>
            <div class="mt-4 flex items-center gap-2 border-t border-gray-100 pt-4">
              <button class="flex-1 rounded-lg border border-gray-300 bg-gray-50 px-4 py-2 text-sm font-semibold text-gray-700 transition hover:bg-gray-100" type="button">Edit</button>
              <button class="flex-1 rounded-lg border border-blue-300 bg-blue-50 px-4 py-2 text-sm font-semibold text-blue-700 transition hover:bg-blue-100" type="button">View Bookings</button>
              <button class="rounded-lg border border-red-200 bg-red-50 px-3 py-2 text-sm font-semibold text-red-700 transition hover:bg-red-100" type="button" aria-label="Delete vehicle">
                <svg class="h-4 w-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
                  <path d="M3 6h18"></path>
                  <path d="M8 6V4h8v2"></path>
                  <path d="M10 11v6"></path>
                  <path d="M14 11v6"></path>
                  <path d="M5 6l1 14h12l1-14"></path>
                </svg>
              </button>
            </div>
          </div>
        </article>

        <article class="overflow-hidden rounded-2xl border border-gray-200 bg-white shadow-sm transition hover:shadow-md">
          <div class="relative">
            <img src="${pageContext.request.contextPath}/images/register.png" alt="RE Bullet 350 Classic" class="h-52 w-full object-cover" />
            <span class="absolute left-3 top-3 inline-flex items-center rounded-full bg-amber-600 px-3 py-1 text-[11px] font-bold uppercase tracking-wide text-white">
              Under Maintenance
            </span>
          </div>
          <div class="p-4">
            <div class="flex items-start justify-between gap-4">
              <div>
                <h2 class="text-xl font-semibold leading-tight text-gray-900">RE Bullet 350 Classic</h2>
                <p class="mt-1 text-sm text-gray-600">Adventure Cruiser • 350cc</p>
              </div>
              <p class="text-right text-xl font-semibold text-red-800">NPR 2,200<br /><span class="text-xs font-medium uppercase tracking-wide text-gray-500">per day</span></p>
            </div>
            <div class="mt-4 flex items-center gap-2 border-t border-gray-100 pt-4">
              <button class="flex-1 rounded-lg border border-gray-300 bg-gray-50 px-4 py-2 text-sm font-semibold text-gray-700 transition hover:bg-gray-100" type="button">Edit</button>
              <button class="flex-1 rounded-lg border border-blue-300 bg-blue-50 px-4 py-2 text-sm font-semibold text-blue-700 transition hover:bg-blue-100" type="button">View Bookings</button>
              <button class="rounded-lg border border-red-200 bg-red-50 px-3 py-2 text-sm font-semibold text-red-700 transition hover:bg-red-100" type="button" aria-label="Delete vehicle">
                <svg class="h-4 w-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
                  <path d="M3 6h18"></path>
                  <path d="M8 6V4h8v2"></path>
                  <path d="M10 11v6"></path>
                  <path d="M14 11v6"></path>
                  <path d="M5 6l1 14h12l1-14"></path>
                </svg>
              </button>
            </div>
          </div>
        </article>

        <article class="overflow-hidden rounded-2xl border border-gray-200 bg-white shadow-sm transition hover:shadow-md">
          <div class="relative">
            <img src="${pageContext.request.contextPath}/images/about.png" alt="Vespa VXL 150" class="h-52 w-full object-cover" />
            <span class="absolute left-3 top-3 inline-flex items-center rounded-full bg-emerald-700 px-3 py-1 text-[11px] font-bold uppercase tracking-wide text-white">
              Active
            </span>
          </div>
          <div class="p-4">
            <div class="flex items-start justify-between gap-4">
              <div>
                <h2 class="text-xl font-semibold leading-tight text-gray-900">Vespa VXL 150</h2>
                <p class="mt-1 text-sm text-gray-600">City Scooter • Automatic</p>
              </div>
              <p class="text-right text-xl font-semibold text-red-800">NPR 1,200<br /><span class="text-xs font-medium uppercase tracking-wide text-gray-500">per day</span></p>
            </div>
            <div class="mt-4 flex items-center gap-2 border-t border-gray-100 pt-4">
              <button class="flex-1 rounded-lg border border-gray-300 bg-gray-50 px-4 py-2 text-sm font-semibold text-gray-700 transition hover:bg-gray-100" type="button">Edit</button>
              <button class="flex-1 rounded-lg border border-blue-300 bg-blue-50 px-4 py-2 text-sm font-semibold text-blue-700 transition hover:bg-blue-100" type="button">View Bookings</button>
              <button class="rounded-lg border border-red-200 bg-red-50 px-3 py-2 text-sm font-semibold text-red-700 transition hover:bg-red-100" type="button" aria-label="Delete vehicle">
                <svg class="h-4 w-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
                  <path d="M3 6h18"></path>
                  <path d="M8 6V4h8v2"></path>
                  <path d="M10 11v6"></path>
                  <path d="M14 11v6"></path>
                  <path d="M5 6l1 14h12l1-14"></path>
                </svg>
              </button>
            </div>
          </div>
        </article>

        <article class="overflow-hidden rounded-2xl border border-gray-200 bg-white shadow-sm transition hover:shadow-md md:col-span-2 2xl:col-span-1">
          <div class="relative">
            <img src="${pageContext.request.contextPath}/images/register.png" alt="Toyota Hilux Rogue" class="h-52 w-full object-cover" />
            <span class="absolute left-3 top-3 inline-flex items-center rounded-full bg-emerald-700 px-3 py-1 text-[11px] font-bold uppercase tracking-wide text-white">
              Active
            </span>
          </div>
          <div class="p-4">
            <div class="flex items-start justify-between gap-4">
              <div>
                <h2 class="text-xl font-semibold leading-tight text-gray-900">Toyota Hilux Rogue</h2>
                <p class="mt-1 text-sm text-gray-600">4x4 Pickup • Double Cab</p>
              </div>
              <p class="text-right text-xl font-semibold text-red-800">NPR 6,800<br /><span class="text-xs font-medium uppercase tracking-wide text-gray-500">per day</span></p>
            </div>
            <div class="mt-4 flex items-center gap-2 border-t border-gray-100 pt-4">
              <button class="flex-1 rounded-lg border border-gray-300 bg-gray-50 px-4 py-2 text-sm font-semibold text-gray-700 transition hover:bg-gray-100" type="button">Edit</button>
              <button class="flex-1 rounded-lg border border-blue-300 bg-blue-50 px-4 py-2 text-sm font-semibold text-blue-700 transition hover:bg-blue-100" type="button">View Bookings</button>
              <button class="rounded-lg border border-red-200 bg-red-50 px-3 py-2 text-sm font-semibold text-red-700 transition hover:bg-red-100" type="button" aria-label="Delete vehicle">
                <svg class="h-4 w-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
                  <path d="M3 6h18"></path>
                  <path d="M8 6V4h8v2"></path>
                  <path d="M10 11v6"></path>
                  <path d="M14 11v6"></path>
                  <path d="M5 6l1 14h12l1-14"></path>
                </svg>
              </button>
            </div>
          </div>
        </article>
      </section>
    </main>
  </div>
</div>
</body>
</html>
