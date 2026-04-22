<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
  <head>
    <title>SajhaRide - Payments</title>
    <script src="https://cdn.tailwindcss.com"></script>
  </head>
  <body class="h-screen overflow-hidden bg-gray-100 text-gray-900">
    <div class="flex h-full">
      <jsp:include page="../owner/components/sidebar.jsp" />

      <div class="flex min-w-0 flex-1 flex-col overflow-hidden">
        <jsp:include page="../owner/components/topbar.jsp" />

        <main class="flex-1 overflow-y-auto px-6 py-6 sm:px-8">
          <section
            class="mb-6 flex flex-col gap-4 lg:flex-row lg:items-center lg:justify-between"
          >
            <div>
              <h1 class="text-4xl font-semibold tracking-tight text-gray-900">
                Payment Transactions
              </h1>
              <p class="mt-2 text-sm text-gray-600">
                Track completed payments from renters and monitor payout status.
              </p>
            </div>
            <button
              class="rounded-xl bg-red-800 px-5 py-3 text-sm font-semibold text-white hover:bg-red-900"
            >
              Export Statement
            </button>
          </section>

          <section class="mb-6 grid grid-cols-1 gap-4 md:grid-cols-4">
            <article
              class="rounded-2xl border border-red-100 bg-white p-4 shadow-sm"
            >
              <p class="text-xs uppercase tracking-[0.14em] text-red-800">
                Today Received
              </p>
              <p class="mt-2 text-3xl font-semibold text-gray-900">
                NPR 12,500
              </p>
            </article>
            <article
              class="rounded-2xl border border-red-100 bg-white p-4 shadow-sm"
            >
              <p class="text-xs uppercase tracking-[0.14em] text-red-800">
                This Week
              </p>
              <p class="mt-2 text-3xl font-semibold text-gray-900">
                NPR 84,300
              </p>
            </article>
            <article
              class="rounded-2xl border border-red-100 bg-white p-4 shadow-sm"
            >
              <p class="text-xs uppercase tracking-[0.14em] text-red-800">
                Pending Payout
              </p>
              <p class="mt-2 text-3xl font-semibold text-gray-900">NPR 9,000</p>
            </article>
            <article
              class="rounded-2xl border border-red-100 bg-red-800 p-4 shadow-sm"
            >
              <p class="text-xs uppercase tracking-[0.14em] text-red-100">
                Total Settled
              </p>
              <p class="mt-2 text-3xl font-semibold text-white">NPR 3.2L</p>
            </article>
          </section>

          <section
            class="rounded-2xl border border-red-100 bg-white p-5 shadow-sm"
          >
            <div class="mb-4 flex items-center justify-between">
              <h2 class="text-2xl font-semibold text-gray-900">
                Recent Transactions
              </h2>
              <div
                class="rounded-lg border border-red-100 bg-red-50 px-3 py-1.5 text-xs font-semibold text-red-800"
              >
                Latest 10
              </div>
            </div>

            <div class="overflow-x-auto">
              <table class="min-w-full text-left text-sm">
                <thead>
                  <tr
                    class="border-b border-gray-200 text-xs uppercase tracking-[0.12em] text-gray-500"
                  >
                    <th class="px-3 py-3 font-semibold">Txn ID</th>
                    <th class="px-3 py-3 font-semibold">Renter</th>
                    <th class="px-3 py-3 font-semibold">Vehicle</th>
                    <th class="px-3 py-3 font-semibold">Date</th>
                    <th class="px-3 py-3 font-semibold">Amount</th>
                    <th class="px-3 py-3 font-semibold">Method</th>
                    <th class="px-3 py-3 font-semibold">Status</th>
                  </tr>
                </thead>
                <tbody>
                  <tr class="border-b border-gray-100">
                    <td class="px-3 py-3 font-semibold text-gray-900">
                      TXN-9012
                    </td>
                    <td class="px-3 py-3">Aarav Karki</td>
                    <td class="px-3 py-3">Mahindra Scorpio 4WD</td>
                    <td class="px-3 py-3">Apr 17, 2026</td>
                    <td class="px-3 py-3 font-semibold text-gray-900">
                      NPR 12,000
                    </td>
                    <td class="px-3 py-3">eSewa</td>
                    <td class="px-3 py-3">
                      <span
                        class="rounded-full bg-red-100 px-2.5 py-1 text-xs font-semibold text-red-800"
                        >Paid</span
                      >
                    </td>
                  </tr>
                  <tr class="border-b border-gray-100">
                    <td class="px-3 py-3 font-semibold text-gray-900">
                      TXN-9011
                    </td>
                    <td class="px-3 py-3">Nisha Thapa</td>
                    <td class="px-3 py-3">Royal Enfield Classic 350</td>
                    <td class="px-3 py-3">Apr 16, 2026</td>
                    <td class="px-3 py-3 font-semibold text-gray-900">
                      NPR 8,400
                    </td>
                    <td class="px-3 py-3">Khalti</td>
                    <td class="px-3 py-3">
                      <span
                        class="rounded-full bg-red-100 px-2.5 py-1 text-xs font-semibold text-red-800"
                        >Paid</span
                      >
                    </td>
                  </tr>
                  <tr>
                    <td class="px-3 py-3 font-semibold text-gray-900">
                      TXN-9010
                    </td>
                    <td class="px-3 py-3">Sujan Rai</td>
                    <td class="px-3 py-3">Toyota Hilux Rogue</td>
                    <td class="px-3 py-3">Apr 15, 2026</td>
                    <td class="px-3 py-3 font-semibold text-gray-900">
                      NPR 20,000
                    </td>
                    <td class="px-3 py-3">Bank Transfer</td>
                    <td class="px-3 py-3">
                      <span
                        class="rounded-full bg-red-100 px-2.5 py-1 text-xs font-semibold text-red-800"
                        >Settled</span
                      >
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>
          </section>
        </main>
      </div>
    </div>
  </body>
</html>
