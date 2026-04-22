<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>SajhaRide - Vehicle Management</title>
  <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="h-screen overflow-hidden bg-gray-50 text-gray-900">
<div class="flex h-full">
  <jsp:include page="components/sidebar.jsp" />

  <div class="flex min-w-0 flex-1 flex-col overflow-hidden">
    <jsp:include page="components/topbar.jsp" />

    <main class="flex-1 overflow-y-auto px-6 py-6 sm:px-8">
      <section class="mb-6 flex flex-col gap-4 lg:flex-row lg:items-center lg:justify-between">
        <div>
          <p class="text-xs font-semibold uppercase tracking-[0.18em] text-red-700">Management</p>
          <h1 class="mt-2 text-4xl font-semibold tracking-tight text-gray-900">Vehicle Inventory</h1>
          <p class="mt-2 text-sm text-gray-600">Audit and regulate listings across the platform.</p>
        </div>
        <div class="flex flex-wrap gap-3">
          <button class="rounded-xl bg-red-800 px-5 py-3 text-sm font-semibold text-white shadow-sm transition hover:bg-red-900">+ New Listing</button>
          <button class="rounded-xl border border-gray-200 bg-white px-5 py-3 text-sm font-semibold text-gray-700 shadow-sm transition hover:bg-gray-100">Export CSV</button>
        </div>
      </section>

      <section class="grid grid-cols-1 gap-4 sm:grid-cols-2 xl:grid-cols-4">
        <article class="rounded-3xl bg-white p-4 shadow-sm ring-1 ring-gray-200">
          <p class="text-xs font-semibold uppercase tracking-[0.14em] text-emerald-700">Active Posts</p>
          <p class="mt-3 text-3xl font-semibold text-gray-900">1,284</p>
          <p class="mt-2 text-sm text-emerald-700">+12%</p>
        </article>
        <article class="rounded-3xl bg-white p-4 shadow-sm ring-1 ring-gray-200">
          <p class="text-xs font-semibold uppercase tracking-[0.14em] text-amber-700">Awaiting Approval</p>
          <p class="mt-3 text-3xl font-semibold text-gray-900">42</p>
          <p class="mt-2 text-sm text-amber-700">8 pending</p>
        </article>
        <article class="rounded-3xl bg-white p-4 shadow-sm ring-1 ring-gray-200">
          <p class="text-xs font-semibold uppercase tracking-[0.14em] text-rose-700">Blocked Listings</p>
          <p class="mt-3 text-3xl font-semibold text-gray-900">18</p>
          <p class="mt-2 text-sm text-rose-700">-2%</p>
        </article>
        <article class="rounded-3xl bg-white p-4 shadow-sm ring-1 ring-gray-200">
          <p class="text-xs font-semibold uppercase tracking-[0.14em] text-slate-700">Total Booking Value</p>
          <p class="mt-3 text-3xl font-semibold text-gray-900">Rs. 842k</p>
          <p class="mt-2 text-sm text-gray-500">Peak: 3PM</p>
        </article>
      </section>

      <section class="mt-6 rounded-3xl border border-gray-200 bg-white p-5 shadow-sm">
        <div class="mb-5 flex flex-col gap-4 lg:flex-row lg:items-center lg:justify-between">
          <div class="flex flex-wrap gap-2 text-sm">
            <button class="rounded-full bg-red-800 px-4 py-2 font-semibold text-white">All Posts</button>
            <button class="rounded-full bg-gray-100 px-4 py-2 font-medium text-gray-600">Active</button>
            <button class="rounded-full bg-gray-100 px-4 py-2 font-medium text-gray-600">Pending</button>
            <button class="rounded-full bg-gray-100 px-4 py-2 font-medium text-gray-600">Blocked</button>
            <button class="rounded-full bg-gray-100 px-4 py-2 font-medium text-gray-600">Deleted</button>
          </div>
          <div class="flex flex-wrap items-center gap-3">
            <select class="rounded-xl border border-gray-200 bg-white px-4 py-3 text-gray-700 outline-none focus:border-red-300 focus:ring-2 focus:ring-red-100">
              <option>All Vehicle Types</option>
              <option>Sedan</option>
              <option>SUV</option>
              <option>Motorbike</option>
              <option>Hatchback</option>
            </select>
            <button class="rounded-xl border border-gray-200 bg-white px-4 py-3 text-gray-700">Filter</button>
          </div>
        </div>

        <div class="overflow-x-auto">
          <table class="min-w-full text-left text-sm">
            <thead>
            <tr class="border-b border-gray-200 text-xs uppercase tracking-[0.12em] text-gray-500">
              <th class="px-3 py-3 font-semibold">Vehicle Details</th>
              <th class="px-3 py-3 font-semibold">Owner</th>
              <th class="px-3 py-3 font-semibold">Vehicle Type</th>
              <th class="px-3 py-3 font-semibold">Pricing</th>
              <th class="px-3 py-3 font-semibold">Status</th>
              <th class="px-3 py-3 font-semibold text-right">Actions</th>
            </tr>
            </thead>
            <tbody>
            <tr class="border-b border-gray-100">
              <td class="px-3 py-4">
                <div class="flex items-center gap-3">
                  <img src="${pageContext.request.contextPath}/images/about.png" alt="Toyota Corolla" class="h-12 w-16 rounded-lg object-cover" />
                  <div>
                    <p class="font-semibold text-gray-900">Toyota Corolla 2022</p>
                    <p class="text-xs text-gray-500">BA 3 PA 8921 • Blue</p>
                  </div>
                </div>
              </td>
              <td class="px-3 py-4">
                <p class="font-semibold text-gray-900">Anish Shrestha</p>
                <p class="text-xs text-gray-500">Koteshwor, KTM</p>
              </td>
              <td class="px-3 py-4"><span class="rounded-full bg-blue-100 px-3 py-1 text-xs font-semibold text-blue-700">Sedan</span></td>
              <td class="px-3 py-4 font-semibold text-gray-900">Rs. 3,500 <span class="text-xs font-normal text-gray-500">/day</span></td>
              <td class="px-3 py-4"><span class="rounded-full bg-emerald-100 px-3 py-1 text-xs font-semibold text-emerald-700">Active</span></td>
              <td class="px-3 py-4 text-right">
                <div class="inline-flex gap-2">
                  <button class="rounded-lg border border-gray-200 px-3 py-2 text-xs font-semibold text-gray-700 hover:bg-gray-50">View</button>
                  <button class="rounded-lg border border-gray-200 px-3 py-2 text-xs font-semibold text-gray-700 hover:bg-gray-50">Edit</button>
                </div>
              </td>
            </tr>

            <tr class="border-b border-gray-100">
              <td class="px-3 py-4">
                <div class="flex items-center gap-3">
                  <img src="${pageContext.request.contextPath}/images/register.png" alt="Hyundai Tucson" class="h-12 w-16 rounded-lg object-cover" />
                  <div>
                    <p class="font-semibold text-gray-900">Hyundai Tucson</p>
                    <p class="text-xs text-gray-500">Bag 2 KHA 7701 • Black</p>
                  </div>
                </div>
              </td>
              <td class="px-3 py-4">
                <p class="font-semibold text-gray-900">Maya Kapali</p>
                <p class="text-xs text-gray-500">Patan, Lalitpur</p>
              </td>
              <td class="px-3 py-4"><span class="rounded-full bg-sky-100 px-3 py-1 text-xs font-semibold text-sky-700">SUV</span></td>
              <td class="px-3 py-4 font-semibold text-gray-900">Rs. 6,200 <span class="text-xs font-normal text-gray-500">/day</span></td>
              <td class="px-3 py-4"><span class="rounded-full bg-amber-100 px-3 py-1 text-xs font-semibold text-amber-700">Pending</span></td>
              <td class="px-3 py-4 text-right">
                <div class="inline-flex gap-2">
                  <button class="rounded-lg border border-gray-200 px-3 py-2 text-xs font-semibold text-gray-700 hover:bg-gray-50">View</button>
                  <button class="rounded-lg border border-gray-200 px-3 py-2 text-xs font-semibold text-gray-700 hover:bg-gray-50">Approve</button>
                </div>
              </td>
            </tr>

            <tr class="border-b border-gray-100">
              <td class="px-3 py-4">
                <div class="flex items-center gap-3">
                  <img src="${pageContext.request.contextPath}/images/logoho.png" alt="Royal Enfield Classic" class="h-12 w-16 rounded-lg object-cover" />
                  <div>
                    <p class="font-semibold text-gray-900">Royal Enfield Classic</p>
                    <p class="text-xs text-gray-500">BA 9 PA 0921 • Silver</p>
                  </div>
                </div>
              </td>
              <td class="px-3 py-4">
                <p class="font-semibold text-gray-900">Rohan Basnet</p>
                <p class="text-xs text-gray-500">Banepa</p>
              </td>
              <td class="px-3 py-4"><span class="rounded-full bg-gray-100 px-3 py-1 text-xs font-semibold text-gray-700">Motorbike</span></td>
              <td class="px-3 py-4 font-semibold text-gray-900">Rs. 1,500 <span class="text-xs font-normal text-gray-500">/day</span></td>
              <td class="px-3 py-4"><span class="rounded-full bg-red-100 px-3 py-1 text-xs font-semibold text-red-700">Blocked</span></td>
              <td class="px-3 py-4 text-right">
                <div class="inline-flex gap-2">
                  <button class="rounded-lg border border-gray-200 px-3 py-2 text-xs font-semibold text-gray-700 hover:bg-gray-50">View</button>
                  <button class="rounded-lg border border-gray-200 px-3 py-2 text-xs font-semibold text-gray-700 hover:bg-gray-50">Unblock</button>
                </div>
              </td>
            </tr>

            <tr>
              <td class="px-3 py-4">
                <div class="flex items-center gap-3">
                  <img src="${pageContext.request.contextPath}/images/about.png" alt="Suzuki Swift" class="h-12 w-16 rounded-lg object-cover" />
                  <div>
                    <p class="font-semibold text-gray-900">Suzuki Swift 2021</p>
                    <p class="text-xs text-gray-500">BA 2 CHA 4523 • Red</p>
                  </div>
                </div>
              </td>
              <td class="px-3 py-4">
                <p class="font-semibold text-gray-900">Jenish Lama</p>
                <p class="text-xs text-gray-500">Dhobighat, Lalitpur</p>
              </td>
              <td class="px-3 py-4"><span class="rounded-full bg-yellow-100 px-3 py-1 text-xs font-semibold text-yellow-700">Hatchback</span></td>
              <td class="px-3 py-4 font-semibold text-gray-900">Rs. 2,800 <span class="text-xs font-normal text-gray-500">/day</span></td>
              <td class="px-3 py-4"><span class="rounded-full bg-emerald-100 px-3 py-1 text-xs font-semibold text-emerald-700">Active</span></td>
              <td class="px-3 py-4 text-right">
                <div class="inline-flex gap-2">
                  <button class="rounded-lg border border-gray-200 px-3 py-2 text-xs font-semibold text-gray-700 hover:bg-gray-50">View</button>
                  <button class="rounded-lg border border-gray-200 px-3 py-2 text-xs font-semibold text-gray-700 hover:bg-gray-50">Edit</button>
                </div>
              </td>
            </tr>
            </tbody>
          </table>
        </div>

        <div class="mt-4 flex flex-col gap-4 border-t border-gray-100 pt-4 text-sm text-gray-500 md:flex-row md:items-center md:justify-between">
          <p>Showing 1-10 of 1,344 results</p>
          <div class="flex items-center gap-2">
            <button class="rounded-lg border border-gray-200 bg-gray-50 px-3 py-2 text-gray-400">&lt;</button>
            <button class="rounded-lg bg-red-800 px-3 py-2 font-semibold text-white">1</button>
            <button class="rounded-lg border border-gray-200 px-3 py-2 text-gray-700 hover:bg-gray-50">2</button>
            <button class="rounded-lg border border-gray-200 px-3 py-2 text-gray-700 hover:bg-gray-50">3</button>
            <button class="rounded-lg border border-gray-200 px-3 py-2 text-gray-700 hover:bg-gray-50">...</button>
            <button class="rounded-lg border border-gray-200 px-3 py-2 text-gray-700 hover:bg-gray-50">135</button>
            <button class="rounded-lg border border-gray-200 bg-gray-50 px-3 py-2 text-gray-400">&gt;</button>
          </div>
        </div>
      </section>

      <section class="mt-6 grid grid-cols-1 gap-6 xl:grid-cols-[1.3fr_0.7fr]">
        <article class="rounded-3xl bg-red-800 p-6 text-white shadow-sm">
          <h2 class="text-3xl font-semibold">Automated Fraud Detection</h2>
          <p class="mt-3 max-w-2xl text-sm leading-6 text-red-50">Our new monitoring algorithm is currently tracking suspicious listings. Automated blocking will trigger if identity verification fails within 48 hours.</p>
          <button class="mt-6 rounded-xl bg-white px-5 py-3 text-sm font-semibold text-red-800 transition hover:bg-red-50">Review Flags</button>
        </article>

        <article class="rounded-3xl border border-gray-200 bg-white p-6 shadow-sm">
          <p class="text-xs font-semibold uppercase tracking-[0.2em] text-gray-400">Popular Demand</p>
          <h2 class="mt-2 text-2xl font-semibold text-gray-900">SUV Season is Here</h2>
          <ul class="mt-5 space-y-3 text-sm text-gray-600">
            <li class="flex gap-2"><span class="mt-1 h-2 w-2 rounded-full bg-red-500"></span> Search for 4WD up by 45%</li>
            <li class="flex gap-2"><span class="mt-1 h-2 w-2 rounded-full bg-red-500"></span> Kathmandu-Pokhara routes peak</li>
            <li class="flex gap-2"><span class="mt-1 h-2 w-2 rounded-full bg-red-500"></span> Avg. rental price: Rs. 5.5k</li>
          </ul>
        </article>
      </section>
    </main>
  </div>
</div>
</body>
</html>

