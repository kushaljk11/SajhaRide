<%@ page contentType="text/html;charset=UTF-8" language="java" import="jakarta.servlet.http.HttpServletRequest" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>SajhaRide - Admin Dashboard</title>
  <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="h-screen overflow-hidden bg-gray-50 text-gray-900">
<div class="flex h-full">
  <jsp:include page="components/sidebar.jsp" />

  <%
    String ctx = ((HttpServletRequest) request).getContextPath();
  %>

  <div class="flex min-w-0 flex-1 flex-col overflow-hidden">
    <jsp:include page="components/topbar.jsp" />

    <main class="flex-1 overflow-y-auto px-6 py-6 sm:px-8">
      <section class="mb-6 flex flex-col gap-4 lg:flex-row lg:items-end lg:justify-between">
        <div>
          <p class="text-xs font-semibold uppercase tracking-[0.18em] text-red-700">Executive Overview</p>
          <h1 class="mt-2 text-4xl font-semibold tracking-tight text-gray-900">Dashboard Pulse</h1>
          <p class="mt-2 max-w-2xl text-sm text-gray-600">Monitor the platform health, pending reviews, and booking activity from a single place.</p>
        </div>
        <div class="flex flex-wrap gap-3">
          <button class="rounded-xl border border-gray-200 bg-white px-4 py-2.5 text-sm font-semibold text-gray-700 shadow-sm transition hover:bg-gray-100">Last 30 Days</button>
          <a href="<%= ctx %>/admin/dashboard/export-report" class="rounded-xl bg-red-800 px-4 py-2.5 text-sm font-semibold text-white shadow-sm transition hover:bg-red-900">Export Report</a>
        </div>
      </section>

      <section class="grid grid-cols-1 gap-4 sm:grid-cols-2 xl:grid-cols-4">
        <article class="rounded-3xl border border-blue-100 bg-white p-4 shadow-sm">
          <p class="text-xs font-semibold uppercase tracking-[0.14em] text-blue-700">Total Users</p>
          <p class="mt-3 text-3xl font-semibold text-gray-900">${totalUsers}</p>
          <p class="mt-2 text-sm text-gray-500">Riders, owners, and admins</p>
        </article>
        <article class="rounded-3xl border border-emerald-100 bg-white p-4 shadow-sm">
          <p class="text-xs font-semibold uppercase tracking-[0.14em] text-emerald-700">Total Listings</p>
          <p class="mt-3 text-3xl font-semibold text-gray-900">${totalVehicles}</p>
          <p class="mt-2 text-sm text-gray-500">Active and archived posts</p>
        </article>
        <article class="rounded-3xl border border-orange-100 bg-white p-4 shadow-sm">
          <p class="text-xs font-semibold uppercase tracking-[0.14em] text-orange-700">Total Bookings</p>
          <p class="mt-3 text-3xl font-semibold text-gray-900">${totalBookings}</p>
          <p class="mt-2 text-sm text-gray-500">Successful reservations</p>
        </article>
        <article class="rounded-3xl border border-red-100 bg-red-800 p-4 shadow-sm text-white">
          <p class="text-xs font-semibold uppercase tracking-[0.14em] text-red-100">Pending Approvals</p>
          <p class="mt-3 text-3xl font-semibold">${pendingBookings}</p>
          <p class="mt-2 text-sm text-red-100">Review new listings today</p>
        </article>
      </section>

      <section class="mt-6 grid grid-cols-1 gap-6 xl:grid-cols-[1.4fr_0.9fr]">
        <article class="rounded-3xl border border-gray-200 bg-white p-5 shadow-sm">
          <div class="mb-4 flex items-center justify-between gap-3">
            <div>
              <h2 class="text-2xl font-semibold text-gray-900">Recent Platform Activity</h2>
              <p class="mt-1 text-sm text-gray-500">Weekly breakdown of bookings and new posts</p>
            </div>
            <div class="flex items-center gap-4 text-xs font-semibold">
              <span class="inline-flex items-center gap-2 text-blue-700"><span class="h-2.5 w-2.5 rounded-full bg-blue-600"></span>Bookings</span>
              <span class="inline-flex items-center gap-2 text-red-700"><span class="h-2.5 w-2.5 rounded-full bg-red-600"></span>Posts</span>
            </div>
          </div>

          <div class="relative w-full h-72 mt-6 rounded-3xl bg-gray-50 p-4">
            <canvas id="activityChart"></canvas>
          </div>
          
          <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
          <script>
            document.addEventListener("DOMContentLoaded", function() {
              const ctx = document.getElementById('activityChart').getContext('2d');
              
              let blueGradient = ctx.createLinearGradient(0, 0, 0, 300);
              blueGradient.addColorStop(0, 'rgba(37, 99, 235, 0.25)'); 
              blueGradient.addColorStop(1, 'rgba(37, 99, 235, 0.0)');
              
              let redGradient = ctx.createLinearGradient(0, 0, 0, 300);
              redGradient.addColorStop(0, 'rgba(153, 27, 27, 0.25)'); 
              redGradient.addColorStop(1, 'rgba(153, 27, 27, 0.0)');
              
              const labels = [];
              for (let i = 6; i >= 0; i--) {
                  const d = new Date();
                  d.setDate(d.getDate() - i);
                  labels.push(d.toLocaleDateString('en-US', { weekday: 'short' }));
              }

              const weeklyBookings = ${not empty weeklyBookingsStr ? weeklyBookingsStr : '[0,0,0,0,0,0,0]'};
              const weeklyPosts = ${not empty weeklyPostsStr ? weeklyPostsStr : '[0,0,0,0,0,0,0]'};

              new Chart(ctx, {
                type: 'line',
                data: {
                  labels: labels,
                  datasets: [
                    {
                      label: 'Bookings',
                      data: weeklyBookings,
                      borderColor: '#2563eb',
                      backgroundColor: blueGradient,
                      borderWidth: 3,
                      tension: 0.4,
                      fill: true,
                      pointBackgroundColor: '#ffffff',
                      pointBorderColor: '#2563eb',
                      pointBorderWidth: 2,
                      pointRadius: 4,
                      pointHoverRadius: 6
                    },
                    {
                      label: 'New Posts',
                      data: weeklyPosts,
                      borderColor: '#991b1b',
                      backgroundColor: redGradient,
                      borderWidth: 3,
                      tension: 0.4,
                      fill: true,
                      pointBackgroundColor: '#ffffff',
                      pointBorderColor: '#991b1b',
                      pointBorderWidth: 2,
                      pointRadius: 4,
                      pointHoverRadius: 6
                    }
                  ]
                },
                options: {
                  responsive: true,
                  maintainAspectRatio: false,
                  plugins: {
                    legend: { display: false },
                    tooltip: {
                      backgroundColor: 'rgba(17, 24, 39, 0.9)',
                      titleFont: { size: 13 },
                      bodyFont: { size: 13 },
                      padding: 12,
                      cornerRadius: 8,
                      intersect: false,
                    }
                  },
                  scales: {
                    x: {
                      grid: { display: false, drawBorder: false },
                      ticks: { color: '#9ca3af', font: { size: 12, weight: '600' } }
                    },
                    y: {
                      grid: { color: '#f3f4f6', drawBorder: false, borderDash: [5, 5] },
                      ticks: { color: '#9ca3af', padding: 10, stepSize: 10 },
                      beginAtZero: true
                    }
                  },
                  interaction: { mode: 'index', intersect: false }
                }
              });
            });
          </script>
        </article>

        <aside class="space-y-6">
          <section class="rounded-3xl bg-slate-900 p-5 text-white shadow-sm">
            <div class="flex items-center justify-between gap-3">
              <div>
                <h2 class="text-2xl font-semibold">Recent Bookings</h2>
                <p class="mt-1 text-sm text-slate-300">Latest confirmed bookings on the platform</p>
              </div>
              <a href="${pageContext.request.contextPath}/admin/bookings" class="text-sm font-semibold text-red-300 hover:text-red-200">View All</a>
            </div>

            <div class="mt-4 space-y-4">
              <%
                java.util.List<com.riderental.myriderental.model.Booking> recentBookings = (java.util.List<com.riderental.myriderental.model.Booking>) request.getAttribute("recentBookings");
                if (recentBookings != null && !recentBookings.isEmpty()) {
                  int count = 0;
                  for (com.riderental.myriderental.model.Booking b : recentBookings) {
                    if (count >= 3) break;
              %>
              <article class="flex items-center gap-3 rounded-2xl bg-white/5 p-3">
                <img src="<%= ctx %>/images/about.png" alt="Booking preview" class="h-12 w-12 rounded-xl object-cover" />
                <div class="min-w-0 flex-1">
                  <p class="font-semibold"><%= b.getRenterName() != null ? b.getRenterName() : "Renter #" + b.getUserId() %></p>
                  <p class="text-sm text-slate-300"><%= b.getStartDate() %> • <%= b.getVehicleName() != null ? b.getVehicleName() : "Vehicle" %></p>
                </div>
                <span class="rounded-full bg-emerald-500/20 px-2.5 py-1 text-xs font-semibold text-emerald-200"><%= b.getStatus() %></span>
              </article>
              <%
                    count++;
                  }
                } else {
              %>
              <p class="text-slate-300">No recent bookings</p>
              <% } %>
            </div>

            <div class="mt-5 rounded-3xl bg-gradient-to-br from-red-800 to-red-950 p-4">
              <p class="text-xs font-semibold uppercase tracking-[0.2em] text-red-100">Success Metrics</p>
              <div class="mt-3 space-y-2 text-sm text-red-100">
                <div class="flex justify-between">
                  <span>Total Bookings:</span>
                  <span class="font-semibold">${totalBookings}</span>
                </div>
                <div class="flex justify-between">
                  <span>Total Revenue:</span>
                  <span class="font-semibold">NPR <%= String.format("%.0f", request.getAttribute("totalRevenue") != null ? (Double) request.getAttribute("totalRevenue") : 0) %></span>
                </div>
              </div>
            </div>
          </section>

          <section class="rounded-3xl border border-gray-200 bg-white p-5 shadow-sm">
            <h2 class="text-xl font-semibold text-gray-900">System Health</h2>
            <p class="mt-1 text-sm text-gray-500">All services are running normally across Nepal Central regions.</p>
            <div class="mt-5 flex items-center justify-between gap-4 rounded-2xl bg-emerald-50 px-4 py-4">
              <div>
                <p class="text-xs font-semibold uppercase tracking-[0.16em] text-emerald-700">Uptime</p>
                <p class="mt-1 text-2xl font-semibold text-gray-900">99.98%</p>
              </div>
              <button class="rounded-xl border border-emerald-200 bg-white px-4 py-2 text-sm font-semibold text-emerald-700">Details</button>
            </div>
          </section>
        </aside>
      </section>
    </main>
  </div>
</div>
</body>
</html>
