<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
  <head>
    <title>SajhaRide - Booking Requests</title>
    <script src="https://cdn.tailwindcss.com"></script>
  </head>
  <body class="h-screen overflow-hidden bg-gray-100 text-gray-900">
    <div class="flex h-full">
      <jsp:include page="../owner/components/sidebar.jsp" />

      <div class="flex min-w-0 flex-1 flex-col overflow-hidden">
        <jsp:include page="../owner/components/topbar.jsp" />

        <main class="flex-1 overflow-y-auto px-6 py-6 sm:px-8">
          <section class="mb-6">
            <h1 class="text-3xl font-semibold tracking-tight text-gray-900">
              Booking Requests
            </h1>
            <p class="mt-2 text-sm text-gray-600">
              Review and manage incoming rental requests for your vehicles.
            </p>
          </section>

          <section
            class="rounded-2xl border border-red-100 bg-white p-5 shadow-sm"
          >
            <div class="mb-4 flex items-center gap-5 text-sm">
              <button
                class="border-b-2 border-red-800 pb-2 font-semibold text-red-800"
              >
                Pending
              </button>
              <button class="pb-2 font-medium text-gray-500 hover:text-red-800">
                Approved
              </button>
              <button class="pb-2 font-medium text-gray-500 hover:text-red-800">
                Past
              </button>
            </div>

            <div class="grid grid-cols-1 gap-4 lg:grid-cols-2 xl:grid-cols-3">
              <article class="rounded-2xl border border-red-100 bg-gray-50 p-4">
                <div class="flex items-start justify-between gap-3">
                  <div>
                    <p
                      class="text-xs font-semibold uppercase tracking-[0.12em] text-gray-500"
                    >
                      Request #BR-4012
                    </p>
                    <h3 class="mt-1 text-lg font-semibold text-gray-900">
                      Royal Enfield Classic 350
                    </h3>
                    <p class="mt-1 text-sm text-gray-600">
                      Sunil Thapa booked this bike for a short city ride.
                    </p>
                  </div>
                  <span
                    class="rounded-full bg-red-100 px-2.5 py-1 text-xs font-semibold text-red-800"
                    >Pending</span
                  >
                </div>
                <div class="mt-4 grid grid-cols-2 gap-2 text-sm">
                  <div
                    class="rounded-lg border border-gray-200 bg-white px-3 py-2"
                  >
                    <p class="text-xs text-gray-500">Dates</p>
                    <p class="mt-1 font-semibold text-gray-800">
                      Oct 15 - Oct 18
                    </p>
                  </div>
                  <div
                    class="rounded-lg border border-gray-200 bg-white px-3 py-2"
                  >
                    <p class="text-xs text-gray-500">Price</p>
                    <p class="mt-1 font-semibold text-red-800">NPR 8,400</p>
                  </div>
                </div>
                <div class="mt-4 flex gap-2">
                  <button
                    class="flex-1 rounded-lg bg-red-800 px-3 py-2 text-xs font-semibold text-white hover:bg-red-900"
                  >
                    Approve
                  </button>
                  <button
                    class="flex-1 rounded-lg border border-red-300 px-3 py-2 text-xs font-semibold text-red-700 hover:bg-red-50"
                  >
                    Reject
                  </button>
                </div>
              </article>

              <article class="rounded-2xl border border-red-100 bg-gray-50 p-4">
                <div class="flex items-start justify-between gap-3">
                  <div>
                    <p
                      class="text-xs font-semibold uppercase tracking-[0.12em] text-gray-500"
                    >
                      Request #BR-4013
                    </p>
                    <h3 class="mt-1 text-lg font-semibold text-gray-900">
                      Mahindra Scorpio S11
                    </h3>
                    <p class="mt-1 text-sm text-gray-600">
                      Anjali Sharma requested this SUV for a family trip.
                    </p>
                  </div>
                  <span
                    class="rounded-full bg-red-100 px-2.5 py-1 text-xs font-semibold text-red-800"
                    >Pending</span
                  >
                </div>
                <div class="mt-4 grid grid-cols-2 gap-2 text-sm">
                  <div
                    class="rounded-lg border border-gray-200 bg-white px-3 py-2"
                  >
                    <p class="text-xs text-gray-500">Dates</p>
                    <p class="mt-1 font-semibold text-gray-800">
                      Oct 20 - Oct 25
                    </p>
                  </div>
                  <div
                    class="rounded-lg border border-gray-200 bg-white px-3 py-2"
                  >
                    <p class="text-xs text-gray-500">Price</p>
                    <p class="mt-1 font-semibold text-red-800">NPR 45,000</p>
                  </div>
                </div>
                <div class="mt-4 flex gap-2">
                  <button
                    class="flex-1 rounded-lg bg-red-800 px-3 py-2 text-xs font-semibold text-white hover:bg-red-900"
                  >
                    Approve
                  </button>
                  <button
                    class="flex-1 rounded-lg border border-red-300 px-3 py-2 text-xs font-semibold text-red-700 hover:bg-red-50"
                  >
                    Reject
                  </button>
                </div>
              </article>

              <article
                class="rounded-2xl border border-red-100 bg-gray-50 p-4 lg:col-span-2 xl:col-span-1"
              >
                <div class="flex items-start justify-between gap-3">
                  <div>
                    <p
                      class="text-xs font-semibold uppercase tracking-[0.12em] text-gray-500"
                    >
                      Request #BR-4014
                    </p>
                    <h3 class="mt-1 text-lg font-semibold text-gray-900">
                      Yamaha MT-15
                    </h3>
                    <p class="mt-1 text-sm text-gray-600">
                      Kiran Shrestha wants this bike for a weekend booking.
                    </p>
                  </div>
                  <span
                    class="rounded-full bg-red-100 px-2.5 py-1 text-xs font-semibold text-red-800"
                    >Pending</span
                  >
                </div>
                <div class="mt-4 grid grid-cols-2 gap-2 text-sm">
                  <div
                    class="rounded-lg border border-gray-200 bg-white px-3 py-2"
                  >
                    <p class="text-xs text-gray-500">Dates</p>
                    <p class="mt-1 font-semibold text-gray-800">
                      Oct 22 - Oct 23
                    </p>
                  </div>
                  <div
                    class="rounded-lg border border-gray-200 bg-white px-3 py-2"
                  >
                    <p class="text-xs text-gray-500">Price</p>
                    <p class="mt-1 font-semibold text-red-800">NPR 3,500</p>
                  </div>
                </div>
                <div class="mt-4 flex gap-2">
                  <button
                    class="flex-1 rounded-lg bg-red-800 px-3 py-2 text-xs font-semibold text-white hover:bg-red-900"
                  >
                    Approve
                  </button>
                  <button
                    class="flex-1 rounded-lg border border-red-300 px-3 py-2 text-xs font-semibold text-red-700 hover:bg-red-50"
                  >
                    Reject
                  </button>
                </div>
              </article>
            </div>

            <div class="mt-4 text-sm text-gray-500">
              Showing 3 of 12 pending requests
            </div>
          </section>

          <section class="mt-6 grid grid-cols-1 gap-4 md:grid-cols-3">
            <article
              class="rounded-2xl border border-red-100 bg-red-800 p-5 text-white shadow-sm"
            >
              <p class="text-sm text-red-100">Income Estimate</p>
              <p class="mt-3 text-4xl font-semibold">NPR 56,900</p>
              <p class="mt-1 text-xs text-red-100">
                Potential earnings from pending requests
              </p>
            </article>
            <article
              class="rounded-2xl border border-red-100 bg-white p-5 shadow-sm"
            >
              <p class="text-sm text-red-800">Response Rate</p>
              <p class="mt-3 text-4xl font-semibold text-gray-900">94%</p>
              <p class="mt-1 text-xs text-gray-500">
                Average response time: 14 mins
              </p>
            </article>
            <article
              class="rounded-2xl border border-red-100 bg-white p-5 shadow-sm"
            >
              <p class="text-sm text-red-800">Trusted Renters</p>
              <p class="mt-3 text-4xl font-semibold text-gray-900">8/10</p>
              <p class="mt-1 text-xs text-gray-500">
                Renters have 4.5+ star ratings
              </p>
            </article>
          </section>
        </main>
      </div>
    </div>
  </body>
</html>
