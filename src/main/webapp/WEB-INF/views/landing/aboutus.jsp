<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% String ctx = request.getContextPath(); %>
<html>
<head>
  <title>About SajhaRide</title>
  <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-neutral-100 text-slate-900">
<jsp:include page="components/topbar.jsp" />

<main class="mx-auto min-h-screen max-w-[1200px] px-4 pb-16 pt-10 sm:px-6 lg:px-8">
  <section class="relative overflow-hidden rounded-3xl">
    <img src="<%= ctx %>/images/about.png"
       alt="Himalayan view"
       class="h-[320px] w-full object-cover sm:h-[360px]" />
    <div class="absolute inset-0 bg-gradient-to-br from-black/60 via-red-900/30 to-black/50"></div>
    <div class="absolute inset-0 flex items-center justify-center px-6 text-center">
      <div class="max-w-[760px]">
        <p class="text-xs font-semibold uppercase tracking-[0.16em] text-red-200">About SajhaRide</p>
        <h1 class="mt-3 text-4xl font-semibold leading-tight text-white sm:text-5xl">Built by the community, for the community.</h1>
        <p class="mx-auto mt-4 max-w-[640px] text-sm leading-relaxed text-white/90 sm:text-base">
          We connect local vehicle owners and renters across Nepal through transparent pricing, verified profiles, and safe digital booking.
        </p>
      </div>
    </div>
  </section>

  <section class="relative left-1/2 my-16 w-screen -translate-x-1/2 bg-white py-14">
    <div class="mx-auto grid w-full max-w-[1200px] grid-cols-1 items-center gap-8 px-4 sm:px-6 lg:grid-cols-2 lg:gap-10 lg:px-8">
      <article>
        <p class="text-xs font-semibold uppercase tracking-[0.16em] text-red-800">Our Mission</p>
        <h2 class="mt-3 text-3xl font-semibold leading-tight text-slate-900 sm:text-4xl">Connecting Nepal Through Shared Mobility</h2>
        <p class="mt-4 text-sm leading-relaxed text-slate-600 sm:text-base">
          SajhaRide exists to make transportation more accessible, affordable, and trusted for everyone. We help renters find reliable rides nearby while enabling owners to earn from underused vehicles.
        </p>
        <p class="mt-4 text-sm leading-relaxed text-slate-600 sm:text-base">
          Our platform is designed around real local needs, from secure booking flow to community reviews and role-based access. Every trip is built on trust and convenience.
        </p>
      </article>
      <div class="overflow-hidden rounded-2xl bg-white shadow-[0_12px_28px_-12px_rgba(15,23,42,0.35)]">
        <img src="https://images.unsplash.com/photo-1533473359331-0135ef1b58bf?auto=format&fit=crop&w=1200&q=80"
           alt="SajhaRide community"
           class="h-full min-h-[300px] w-full object-cover" />
      </div>
    </div>
  </section>

  <section class="mt-16">
    <div class="mx-auto max-w-[760px] text-center">
      <p class="text-xs font-semibold uppercase tracking-[0.16em] text-red-800">Why Choose SajhaRide</p>
      <h2 class="mt-3 text-3xl font-semibold text-slate-900 sm:text-4xl">Safe, local, and built for everyday rides</h2>
    </div>

    <div class="mt-8 grid grid-cols-1 gap-4 sm:grid-cols-2 xl:grid-cols-4">
      <article class="rounded-2xl border border-red-100 bg-white p-5 shadow-[0_10px_25px_-10px_rgba(0,0,0,0.12)]">
        <div class="flex h-10 w-10 items-center justify-center rounded-xl bg-red-100 text-red-800">
          <svg class="h-5 w-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
            <path stroke-linecap="round" stroke-linejoin="round" d="M12 3v18"></path>
            <path stroke-linecap="round" stroke-linejoin="round" d="M17 7.5c0-2-2.2-3.5-5-3.5s-5 1.5-5 3.5 2.2 3.5 5 3.5 5 1.5 5 3.5-2.2 3.5-5 3.5-5-1.5-5-3.5"></path>
          </svg>
        </div>
        <h3 class="mt-4 text-lg font-semibold text-slate-900">Affordable</h3>
        <p class="mt-2 text-sm leading-relaxed text-slate-600">Fair local pricing and no hidden fees for more transparent trips.</p>
      </article>

      <article class="rounded-2xl border border-red-100 bg-white p-5 shadow-[0_10px_25px_-10px_rgba(0,0,0,0.12)]">
        <div class="flex h-10 w-10 items-center justify-center rounded-xl bg-red-100 text-red-800">
          <svg class="h-5 w-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
            <path stroke-linecap="round" stroke-linejoin="round" d="M20 7l-8-4-8 4v5c0 5 3.5 8.5 8 9 4.5-.5 8-4 8-9V7z"></path>
            <path stroke-linecap="round" stroke-linejoin="round" d="M9 12l2 2 4-4"></path>
          </svg>
        </div>
        <h3 class="mt-4 text-lg font-semibold text-slate-900">Trusted Local Community</h3>
        <p class="mt-2 text-sm leading-relaxed text-slate-600">Verified users, reviews, and profile checks for safer bookings.</p>
      </article>

      <article class="rounded-2xl border border-red-100 bg-white p-5 shadow-[0_10px_25px_-10px_rgba(0,0,0,0.12)]">
        <div class="flex h-10 w-10 items-center justify-center rounded-xl bg-red-100 text-red-800">
          <svg class="h-5 w-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
            <path stroke-linecap="round" stroke-linejoin="round" d="M3 7h18"></path>
            <path stroke-linecap="round" stroke-linejoin="round" d="M8 3v4"></path>
            <path stroke-linecap="round" stroke-linejoin="round" d="M16 3v4"></path>
            <rect x="3" y="7" width="18" height="14" rx="2"></rect>
          </svg>
        </div>
        <h3 class="mt-4 text-lg font-semibold text-slate-900">Easy Booking</h3>
        <p class="mt-2 text-sm leading-relaxed text-slate-600">Quick search, clean booking flow, and convenient trip planning.</p>
      </article>

      <article class="rounded-2xl border border-red-100 bg-white p-5 shadow-[0_10px_25px_-10px_rgba(0,0,0,0.12)]">
        <div class="flex h-10 w-10 items-center justify-center rounded-xl bg-red-100 text-red-800">
          <svg class="h-5 w-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
            <path stroke-linecap="round" stroke-linejoin="round" d="M12 22s7-4.35 7-11a7 7 0 10-14 0c0 6.65 7 11 7 11z"></path>
            <circle cx="12" cy="11" r="2.5"></circle>
          </svg>
        </div>
        <h3 class="mt-4 text-lg font-semibold text-slate-900">Hyperlocal Access</h3>
        <p class="mt-2 text-sm leading-relaxed text-slate-600">Find vehicles near your area for smoother city-to-city travel.</p>
      </article>
    </div>
  </section>

  <section class="relative left-1/2 my-16 w-screen -translate-x-1/2 bg-white py-14">
    <div class="mx-auto w-full max-w-[1200px] px-4 sm:px-6 lg:px-8">
      <div class="mx-auto max-w-[760px] text-center">
        <p class="text-xs font-semibold uppercase tracking-[0.16em] text-red-800">Our Impact</p>
        <h2 class="mt-3 text-3xl font-semibold text-slate-900 sm:text-4xl">SajhaRide in numbers</h2>
      </div>

      <div class="mt-8 grid grid-cols-1 gap-5 md:grid-cols-3">
        <article class="rounded-2xl border border-red-100 bg-white p-6 shadow-[0_10px_25px_-10px_rgba(0,0,0,0.12)]">
          <p class="text-sm font-semibold tracking-[0.12em] text-red-800">Active Listings</p>
          <p class="mt-3 text-4xl font-semibold text-slate-900">500+</p>
          <p class="mt-2 text-sm text-slate-600">Vehicles across major cities and local neighborhoods.</p>
        </article>
        <article class="rounded-2xl border border-red-100 bg-white p-6 shadow-[0_10px_25px_-10px_rgba(0,0,0,0.12)]">
          <p class="text-sm font-semibold tracking-[0.12em] text-red-800">Verified Users</p>
          <p class="mt-3 text-4xl font-semibold text-slate-900">10K+</p>
          <p class="mt-2 text-sm text-slate-600">Community members with profile verification and reviews.</p>
        </article>
        <article class="rounded-2xl border border-red-100 bg-white p-6 shadow-[0_10px_25px_-10px_rgba(0,0,0,0.12)]">
          <p class="text-sm font-semibold tracking-[0.12em] text-red-800">Completed Trips</p>
          <p class="mt-3 text-4xl font-semibold text-slate-900">25K+</p>
          <p class="mt-2 text-sm text-slate-600">Successful rides completed with secure digital payments.</p>
        </article>
      </div>
    </div>
  </section>

  <section class="mt-16">
    <div class="rounded-3xl bg-gradient-to-r from-red-800 to-red-700 px-6 py-12 text-center shadow-[0_16px_40px_-18px_rgba(127,29,29,0.7)] sm:px-10">
      <h2 class="text-3xl font-semibold text-white sm:text-4xl">Ready to start sharing?</h2>
      <p class="mx-auto mt-3 max-w-[760px] text-sm leading-relaxed text-red-100 sm:text-base">
        Join thousands of renters and owners building a more connected transportation network in Nepal.
      </p>
      <div class="mt-7 flex flex-wrap items-center justify-center gap-3 sm:gap-4">
        <a href="<%= ctx %>/auth/register" class="inline-flex min-w-[170px] items-center justify-center rounded-xl bg-white px-7 py-3 text-sm font-semibold text-red-800 transition hover:bg-red-100">
          Become a Member
        </a>
        <a href="<%= ctx %>/vehicles/list" class="inline-flex min-w-[170px] items-center justify-center rounded-xl border border-white/60 px-7 py-3 text-sm font-semibold text-white transition hover:bg-white/10">
          Browse Vehicles
        </a>
      </div>
    </div>
  </section>
</main>

<jsp:include page="components/footer.jsp" />

</body>
</html>
