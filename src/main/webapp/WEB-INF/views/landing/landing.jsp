<%@ page contentType="text/html;charset=UTF-8" language="java" %>
  <% String ctx=request.getContextPath(); %>
    <html>

    <head>
      <title>SajhaRide</title>
      <script src="https://cdn.tailwindcss.com"></script>
    </head>

    <body class="bg-neutral-100 text-slate-900">
      <jsp:include page="../landing/components/topbar.jsp" />

      <main class="mx-auto min-h-screen max-w-[1200px] px-4 pb-16 pt-12 sm:px-6 lg:px-8 lg:pt-16">
        <section class="mx-auto max-w-[880px] text-center">
          <!-- <p class="text-xs font-semibold uppercase tracking-[0.18em] text-red-800">Explore The Himalayas</p> -->

          <h1 class="mt-4 text-4xl font-semibold leading-tight text-slate-900 sm:text-5xl lg:text-6xl">
            Ride Smart,
            <span class="text-red-800">Share Local.</span>
          </h1>

          <p class="mx-auto mt-10 max-w-[640px] text-base leading-relaxed text-slate-600 sm:text-xl">
            Affordable and reliable vehicle sharing across Nepal. Connect with your community and hit the road with
            ease.
          </p>

          <div class="mt-8 flex flex-wrap items-center justify-center gap-3 sm:gap-4">
            <a href="<%= ctx %>/login"
              class="inline-flex min-w-[170px] items-center justify-center rounded-xl bg-red-800 px-7 py-3 text-sm font-semibold text-white shadow-sm transition hover:bg-red-900 focus:outline-none focus:ring-2 focus:ring-red-800 focus:ring-offset-2">
              Find a Ride
            </a>
            <a href="<%= ctx %>/login"
              class="inline-flex min-w-[170px] items-center justify-center rounded-xl border border-slate-300 bg-white px-7 py-3 text-sm font-semibold text-slate-700 shadow-sm transition hover:border-red-800 hover:text-red-800 focus:outline-none focus:ring-2 focus:ring-red-800 focus:ring-offset-2">
              List Your Vehicle
            </a>
          </div>
        </section>

        <section
          class="mx-auto mt-12 max-w-[980px] rounded-3xl bg-white p-4 shadow-[0_18px_40px_-22px_rgba(15,23,42,0.35)] sm:p-5">
          <form action="<%= ctx %>/vehicles/list" method="get" class="grid grid-cols-1 gap-3 md:grid-cols-12 md:gap-4">
            <div class="md:col-span-3">
              <label for="location"
                class="mb-1 block pl-1 text-[10px] font-semibold uppercase tracking-[0.12em] text-slate-500">
                Location
              </label>
              <div class="flex h-11 items-center gap-2 rounded-xl border border-slate-200 bg-slate-50 px-3">
                <svg class="h-4 w-4 text-slate-500" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                  stroke-width="2" aria-hidden="true">
                  <path stroke-linecap="round" stroke-linejoin="round"
                    d="M12 22s7-4.35 7-11a7 7 0 10-14 0c0 6.65 7 11 7 11z"></path>
                  <circle cx="12" cy="11" r="2.5"></circle>
                </svg>
                <select id="location" name="location"
                  class="w-full border-none bg-transparent text-sm font-medium text-slate-700 outline-none">
                  <option value="">All Locations</option>
                  <option value="Kathmandu">Kathmandu</option>
                  <option value="Lalitpur">Lalitpur</option>
                  <option value="Bhaktapur">Bhaktapur</option>
                  <option value="Pokhara">Pokhara</option>
                </select>
              </div>
            </div>

            <div class="md:col-span-2">
              <label for="type"
                class="mb-1 block pl-1 text-[10px] font-semibold uppercase tracking-[0.12em] text-slate-500">
                Vehicle Type
              </label>
              <div class="flex h-11 items-center gap-2 rounded-xl border border-slate-200 bg-slate-50 px-3">
                <svg class="h-4 w-4 text-slate-500" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                  stroke-width="2" aria-hidden="true">
                  <path stroke-linecap="round" stroke-linejoin="round"
                    d="M3 13l1.5-4.5A2 2 0 016.4 7h11.2a2 2 0 011.9 1.5L21 13"></path>
                  <rect x="3" y="13" width="18" height="6" rx="1.5"></rect>
                  <circle cx="7" cy="19" r="1"></circle>
                  <circle cx="17" cy="19" r="1"></circle>
                </svg>
                <select id="type" name="type"
                  class="w-full border-none bg-transparent text-sm font-medium text-slate-700 outline-none">
                  <option value="">All Types</option>
                  <option value="CAR">Car</option>
                  <option value="BIKE">Bike</option>
                  <option value="SCOOTER">Scooter</option>
                  <option value="VAN">Van</option>
                  <option value="TRUCK">Truck</option>
                </select>
              </div>
            </div>

            <div class="md:col-span-3">
              <label for="startDate"
                class="mb-1 block pl-1 text-[10px] font-semibold uppercase tracking-[0.12em] text-slate-500">
                Start Date
              </label>
              <input id="startDate" name="startDate" type="date"
                class="h-11 w-full rounded-xl border border-slate-200 bg-slate-50 px-3 text-sm font-medium text-slate-700 outline-none focus:border-red-800" />
            </div>

            <div class="md:col-span-3">
              <label for="endDate"
                class="mb-1 block pl-1 text-[10px] font-semibold uppercase tracking-[0.12em] text-slate-500">
                End Date
              </label>
              <input id="endDate" name="endDate" type="date"
                class="h-11 w-full rounded-xl border border-slate-200 bg-slate-50 px-3 text-sm font-medium text-slate-700 outline-none focus:border-red-800" />
            </div>

            <div class="md:col-span-1 md:flex md:items-end">
              <button type="submit"
                class="inline-flex h-11 w-full items-center justify-center gap-2 rounded-xl bg-red-800 px-4 text-sm font-semibold text-white shadow-sm transition hover:bg-red-900 focus:outline-none focus:ring-2 focus:ring-red-800 focus:ring-offset-2">
                <svg class="h-4 w-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
                  aria-hidden="true">
                  <circle cx="11" cy="11" r="7"></circle>
                  <path stroke-linecap="round" d="M20 20l-3.5-3.5"></path>
                </svg>
                Search
              </button>
            </div>
          </form>
        </section>

        <!-- why sajharide section -->  
        <section
          class="relative left-1/2 mt-14 w-screen -translate-x-1/2 border-y border-slate-200 bg-gradient-to-br from-red-50 via-white to-red-100/40 py-8 shadow-[0_8px_20px_-12px_rgba(0,0,0,0.1)] sm:py-10">
          <div class="mx-auto w-full max-w-[1200px] px-4 sm:px-6 lg:px-8">
            <div class="mx-auto max-w-[760px] text-center">
              <p class="text-lg font-semibold tracking-[0.16em] text-red-800">Why SajhaRide?</p>
              <h2 class="mt-3 text-3xl font-semibold leading-tight text-slate-900 sm:text-4xl">Built for Local Trust,
                Speed, and Comfort</h2>
              <p class="mx-auto mt-4 max-w-[680px] text-sm leading-relaxed text-slate-600 sm:text-base">
                SajhaRide is designed around Nepal's real travel needs, making vehicle sharing simpler for renters and
                more rewarding for owners.
              </p>
            </div>

            <div class="mt-8 grid grid-cols-1 gap-4 md:grid-cols-2 xl:grid-cols-4">
              <article
                class="group rounded-2xl border border-slate-200 bg-white/90 p-5 shadow-sm transition hover:-translate-y-1 hover:border-red-200 hover:shadow-md">
                <div class="flex h-10 w-10 items-center justify-center rounded-xl bg-red-100 text-red-800">
                  <svg class="h-5 w-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
                    aria-hidden="true">
                    <path stroke-linecap="round" stroke-linejoin="round"
                      d="M12 21s7-4.35 7-11a7 7 0 10-14 0c0 6.65 7 11 7 11z"></path>
                    <circle cx="12" cy="10" r="2.5"></circle>
                  </svg>
                </div>
                <h3 class="mt-4 text-base font-semibold text-slate-900">Hyperlocal Availability</h3>
                <p class="mt-2 text-sm leading-relaxed text-slate-600">
                  Discover vehicles in your own city and nearby areas with location-first search designed for local
                  travel.
                </p>
              </article>

              <article
                class="group rounded-2xl border border-slate-200 bg-white/90 p-5 shadow-sm transition hover:-translate-y-1 hover:border-red-200 hover:shadow-md">
                <div class="flex h-10 w-10 items-center justify-center rounded-xl bg-red-100 text-red-800">
                  <svg class="h-5 w-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
                    aria-hidden="true">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M12 6v6l4 2"></path>
                    <circle cx="12" cy="12" r="9"></circle>
                  </svg>
                </div>
                <h3 class="mt-4 text-base font-semibold text-slate-900">Fast Booking Flow</h3>
                <p class="mt-2 text-sm leading-relaxed text-slate-600">
                  Search, compare, and reserve in minutes with a clean booking journey that cuts friction from start to
                  finish.
                </p>
              </article>

              <article
                class="group rounded-2xl border border-slate-200 bg-white/90 p-5 shadow-sm transition hover:-translate-y-1 hover:border-red-200 hover:shadow-md">
                <div class="flex h-10 w-10 items-center justify-center rounded-xl bg-red-100 text-red-800">
                  <svg class="h-5 w-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
                    aria-hidden="true">
                    <path stroke-linecap="round" stroke-linejoin="round"
                      d="M20 7l-8-4-8 4v5c0 5 3.5 8.5 8 9 4.5-.5 8-4 8-9V7z"></path>
                    <path stroke-linecap="round" stroke-linejoin="round" d="M9 12l2 2 4-4"></path>
                  </svg>
                </div>
                <h3 class="mt-4 text-base font-semibold text-slate-900">Verified & Reliable</h3>
                <p class="mt-2 text-sm leading-relaxed text-slate-600">
                  Profiles, vehicle details, and role-based access create a safer, more dependable sharing environment.
                </p>
              </article>

              <article
                class="group rounded-2xl border border-slate-200 bg-white/90 p-5 shadow-sm transition hover:-translate-y-1 hover:border-red-200 hover:shadow-md">
                <div class="flex h-10 w-10 items-center justify-center rounded-xl bg-red-100 text-red-800">
                  <svg class="h-5 w-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
                    aria-hidden="true">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M12 3v18"></path>
                    <path stroke-linecap="round" stroke-linejoin="round"
                      d="M17 7.5c0-2-2.2-3.5-5-3.5s-5 1.5-5 3.5 2.2 3.5 5 3.5 5 1.5 5 3.5-2.2 3.5-5 3.5-5-1.5-5-3.5">
                    </path>
                  </svg>
                </div>
                <h3 class="mt-4 text-base font-semibold text-slate-900">Value for Everyone</h3>
                <p class="mt-2 text-sm leading-relaxed text-slate-600">
                  Renters save on flexible mobility while owners turn idle vehicles into consistent local income.
                </p>
              </article>
            </div>
          </div>
          </div>
        </section>

        <!-- feature vehicles section -->
        <section class="mx-auto mt-14 w-full max-w-[1200px]">
          <div class="mb-5 flex items-end justify-between gap-3">
            <div>
              <h2 class="text-3xl font-semibold tracking-tight text-slate-900">Featured Vehicles</h2>
              <p class="mt-1 text-sm text-slate-600">Handpicked rides with premium comfort, trusted owners, and
                transparent pricing.</p>
            </div>
            <a href="<%= ctx %>/vehicles/list"
              class="inline-flex items-center gap-2 text-sm font-semibold text-blue-700 transition hover:text-blue-900">
              View All
              <svg class="h-4 w-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
                aria-hidden="true">
                <path stroke-linecap="round" stroke-linejoin="round" d="M5 12h14"></path>
                <path stroke-linecap="round" stroke-linejoin="round" d="M13 6l6 6-6 6"></path>
              </svg>
            </a>
          </div>

          <div class="grid grid-cols-1 gap-5 sm:grid-cols-2 xl:grid-cols-4">
            <article
              class="overflow-hidden rounded-2xl border border-slate-200 bg-white shadow-sm transition duration-300 hover:-translate-y-1 hover:shadow-xl">
              <div class="relative">
                <img src="https://images.unsplash.com/photo-1616788494707-ec28f08d05a1?auto=format&fit=crop&w=1200&q=80"
                  alt="Mahindra Scorpio S11" class="h-48 w-full object-cover" />
                <span
                  class="absolute right-3 top-3 rounded-full bg-emerald-100 px-3 py-1 text-[10px] font-bold uppercase tracking-wide text-emerald-700">Available</span>
              </div>
              <div class="p-4">
                <h3 class="text-xl font-semibold text-slate-900">Mahindra Scorpio S11</h3>
                <p class="mt-1 text-sm text-slate-500">5 Seats • Diesel • Manual</p>
                <div class="mt-4 flex items-center justify-between border-t border-slate-100 pt-3">
                  <p class="text-xl font-semibold tracking-tight text-red-800">Rs. 6,500<span
                      class="ml-1 text-sm font-medium text-slate-500">/day</span></p>
                  <a href="<%= ctx %>/vehicles/list"
                    class="inline-flex h-9 w-9 items-center justify-center rounded-full bg-[#154e75] text-white transition hover:bg-blue-800">
                    <svg class="h-4 w-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
                      aria-hidden="true">
                      <path stroke-linecap="round" stroke-linejoin="round" d="M5 12h14"></path>
                      <path stroke-linecap="round" stroke-linejoin="round" d="M13 6l6 6-6 6"></path>
                    </svg>
                  </a>
                </div>
              </div>
            </article>

            <article
              class="overflow-hidden rounded-2xl border border-slate-200 bg-white shadow-sm transition duration-300 hover:-translate-y-1 hover:shadow-xl">
              <div class="relative">
                <img src="https://images.unsplash.com/photo-1563720223185-11003d516935?auto=format&fit=crop&w=1200&q=80"
                  alt="Hyundai Venue Turbo" class="h-48 w-full object-cover" />
                <span
                  class="absolute right-3 top-3 rounded-full bg-blue-100 px-3 py-1 text-[10px] font-bold uppercase tracking-wide text-blue-700">Popular</span>
              </div>
              <div class="p-4">
                <h3 class="text-xl font-semibold text-slate-900">Hyundai Venue Turbo</h3>
                <p class="mt-1 text-sm text-slate-500">5 Seats • Petrol • Automatic</p>
                <div class="mt-4 flex items-center justify-between border-t border-slate-100 pt-3">
                  <p class="text-xl font-semibold tracking-tight text-red-800">Rs. 4,200<span
                      class="ml-1 text-sm font-medium text-slate-500">/day</span></p>
                  <a href="<%= ctx %>/vehicles/list"
                    class="inline-flex h-9 w-9 items-center justify-center rounded-full bg-[#154e75] text-white transition hover:bg-blue-800">
                    <svg class="h-4 w-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
                      aria-hidden="true">
                      <path stroke-linecap="round" stroke-linejoin="round" d="M5 12h14"></path>
                      <path stroke-linecap="round" stroke-linejoin="round" d="M13 6l6 6-6 6"></path>
                    </svg>
                  </a>
                </div>
              </div>
            </article>

            <article
              class="overflow-hidden rounded-2xl border border-slate-200 bg-white shadow-sm transition duration-300 hover:-translate-y-1 hover:shadow-xl">
              <div class="relative">
                <img src="https://images.unsplash.com/photo-1558981806-ec527fa84c39?auto=format&fit=crop&w=1200&q=80"
                  alt="Royal Enfield Classic" class="h-48 w-full object-cover" />
                <span
                  class="absolute right-3 top-3 rounded-full bg-indigo-100 px-3 py-1 text-[10px] font-bold uppercase tracking-wide text-indigo-700">Verified</span>
              </div>
              <div class="p-4">
                <h3 class="text-xl font-semibold text-slate-900">Royal Enfield Classic</h3>
                <p class="mt-1 text-sm text-slate-500">2 Seats • 350cc • Petrol</p>
                <div class="mt-4 flex items-center justify-between border-t border-slate-100 pt-3">
                  <p class="text-xl font-semibold tracking-tight text-red-800">Rs. 2,500<span
                      class="ml-1 text-sm font-medium text-slate-500">/day</span></p>
                  <a href="<%= ctx %>/vehicles/list"
                    class="inline-flex h-9 w-9 items-center justify-center rounded-full bg-[#154e75] text-white transition hover:bg-blue-800">
                    <svg class="h-4 w-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
                      aria-hidden="true">
                      <path stroke-linecap="round" stroke-linejoin="round" d="M5 12h14"></path>
                      <path stroke-linecap="round" stroke-linejoin="round" d="M13 6l6 6-6 6"></path>
                    </svg>
                  </a>
                </div>
              </div>
            </article>

            <article
              class="overflow-hidden rounded-2xl border border-slate-200 bg-white shadow-sm transition duration-300 hover:-translate-y-1 hover:shadow-xl">
              <div class="relative">
                <img src="https://images.unsplash.com/photo-1511919884226-fd3cad34687c?auto=format&fit=crop&w=1200&q=80"
                  alt="Yamaha FZ-S V3" class="h-48 w-full object-cover" />
                <span
                  class="absolute right-3 top-3 rounded-full bg-amber-100 px-3 py-1 text-[10px] font-bold uppercase tracking-wide text-amber-700">Top
                  Rated</span>
              </div>
              <div class="p-4">
                <h3 class="text-xl font-semibold text-slate-900">Yamaha FZ-S V3</h3>
                <p class="mt-1 text-sm text-slate-500">2 Seats • 149cc • Petrol</p>
                <div class="mt-4 flex items-center justify-between border-t border-slate-100 pt-3">
                  <p class="text-xl font-semibold tracking-tight text-red-800">Rs. 1,800<span
                      class="ml-1 text-sm font-medium text-slate-500">/day</span></p>
                  <a href="<%= ctx %>/vehicles/list"
                    class="inline-flex h-9 w-9 items-center justify-center rounded-full bg-[#154e75] text-white transition hover:bg-blue-800">
                    <svg class="h-4 w-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
                      aria-hidden="true">
                      <path stroke-linecap="round" stroke-linejoin="round" d="M5 12h14"></path>
                      <path stroke-linecap="round" stroke-linejoin="round" d="M13 6l6 6-6 6"></path>
                    </svg>
                  </a>
                </div>
              </div>
            </article>
          </div>
        </section>


        <!-- Safety section -->
        <section
          class="relative left-1/2 mt-16 w-screen -translate-x-1/2 border-y border-red-100 bg-gradient-to-br from-red-50 via-white to-red-100/40 py-8 shadow-[0_8px_20px_-12px_rgba(0,0,0,0.1)] sm:py-10">
          <div class="mx-auto w-full max-w-[1200px] px-4 sm:px-6 lg:px-8">
            <div class="grid grid-cols-1 gap-8 lg:grid-cols-2 lg:gap-10">

              <!-- Cards -->
              <div class="grid grid-cols-1 gap-4 sm:grid-cols-2">

                <article class="rounded-2xl border border-red-100 bg-white p-5 shadow-sm">
                  <div class="flex h-11 w-11 items-center justify-center rounded-xl bg-red-100 text-red-800">
                    <!-- Verified Profiles Icon -->
                    <svg class="h-5 w-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                      <path stroke-linecap="round" stroke-linejoin="round"
                        d="M5.121 17.804A9 9 0 1118.364 4.56M15 11l-3 3-2-2"></path>
                    </svg>
                  </div>
                  <h3 class="mt-4 text-xl font-semibold text-slate-900">Verified Profiles</h3>
                  <p class="mt-2 text-sm leading-relaxed text-slate-600">
                    Every user is identity-verified to ensure a trusted and secure community.
                  </p>
                </article>

                <article class="rounded-2xl border border-red-100 bg-white p-5 shadow-sm">
                  <div class="flex h-11 w-11 items-center justify-center rounded-xl bg-red-100 text-red-800">
                    <!-- Ratings & Reviews Icon -->
                    <svg class="h-5 w-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                      <path stroke-linecap="round" stroke-linejoin="round"
                        d="M11.049 2.927c.3-.921 1.603-.921 1.902 0l2.1 6.462h6.79c.969 0 1.371 1.24.588 1.81l-5.49 3.99 2.1 6.462c.3.921-.755 1.688-1.54 1.118L12 18.347l-5.49 3.99c-.784.57-1.838-.197-1.539-1.118l2.1-6.462-5.49-3.99c-.783-.57-.38-1.81.588-1.81h6.79l2.1-6.462z">
                      </path>
                    </svg>
                  </div>
                  <h3 class="mt-4 text-xl font-semibold text-slate-900">Ratings & Reviews</h3>
                  <p class="mt-2 text-sm leading-relaxed text-slate-600">
                    Honest feedback from real users builds transparency and trust.
                  </p>
                </article>

                <article class="rounded-2xl border border-red-100 bg-white p-5 shadow-sm">
                  <div class="flex h-11 w-11 items-center justify-center rounded-xl bg-red-100 text-red-800">
                    <!-- Trip Protection Icon -->
                    <svg class="h-5 w-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                      <path stroke-linecap="round" stroke-linejoin="round"
                        d="M12 3l7 4v5c0 5-3.5 8-7 9-3.5-1-7-4-7-9V7l7-4z"></path>
                    </svg>
                  </div>
                  <h3 class="mt-4 text-xl font-semibold text-slate-900">Trip Protection</h3>
                  <p class="mt-2 text-sm leading-relaxed text-slate-600">
                    Every booking is backed by protection policies for peace of mind.
                  </p>
                </article>

                <article class="rounded-2xl border border-red-100 bg-white p-5 shadow-sm">
                  <div class="flex h-11 w-11 items-center justify-center rounded-xl bg-red-100 text-red-800">
                    <!-- 24/7 Support Icon -->
                    <svg class="h-5 w-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                      <path stroke-linecap="round" stroke-linejoin="round"
                        d="M18 10c0-4-3-7-6-7s-6 3-6 7v4a3 3 0 003 3h6a3 3 0 003-3v-4z"></path>
                      <path stroke-linecap="round" stroke-linejoin="round" d="M12 17v1"></path>
                    </svg>
                  </div>
                  <h3 class="mt-4 text-xl font-semibold text-slate-900">24/7 Assistance</h3>
                  <p class="mt-2 text-sm leading-relaxed text-slate-600">
                    Our support team is always available whenever you need help.
                  </p>
                </article>

              </div>

              <!-- Right Content -->
              <div class="flex flex-col justify-center rounded-2xl bg-white p-6 shadow-sm sm:p-8">
                <p class="text-sm uppercase font-semibold tracking-[0.16em] text-red-800">
                  Safety First
                </p>

                <h2 class="mt-3 text-3xl font-semibold leading-tight text-slate-900 sm:text-4xl">
                  Drive with confidence,
                  <span class="text-red-800">every single time.</span>
                </h2>

                <p class="mt-5 text-base leading-relaxed text-slate-600">
                  SajhaRide prioritizes your safety with verified users, transparent reviews, and reliable protection
                  systems built into every trip.
                </p>

                <ul class="mt-6 space-y-3">
                  <li class="flex items-start gap-3 text-sm font-medium text-slate-800 sm:text-base">
                    <span
                      class="mt-0.5 inline-flex h-5 w-5 items-center justify-center rounded-full bg-red-100 text-red-800">
                      <svg class="h-3.5 w-3.5" viewBox="0 0 20 20" fill="none" stroke="currentColor" stroke-width="2">
                        <path stroke-linecap="round" stroke-linejoin="round" d="M5 10l3 3 7-7"></path>
                      </svg>
                    </span>
                    Trusted renter-owner ecosystem
                  </li>

                  <li class="flex items-start gap-3 text-sm font-medium text-slate-800 sm:text-base">
                    <span
                      class="mt-0.5 inline-flex h-5 w-5 items-center justify-center rounded-full bg-red-100 text-red-800">
                      <svg class="h-3.5 w-3.5" viewBox="0 0 20 20" fill="none" stroke="currentColor" stroke-width="2">
                        <path stroke-linecap="round" stroke-linejoin="round" d="M5 10l3 3 7-7"></path>
                      </svg>
                    </span>
                    Real-time support system
                  </li>

                  <li class="flex items-start gap-3 text-sm font-medium text-slate-800 sm:text-base">
                    <span
                      class="mt-0.5 inline-flex h-5 w-5 items-center justify-center rounded-full bg-red-100 text-red-800">
                      <svg class="h-3.5 w-3.5" viewBox="0 0 20 20" fill="none" stroke="currentColor" stroke-width="2">
                        <path stroke-linecap="round" stroke-linejoin="round" d="M5 10l3 3 7-7"></path>
                      </svg>
                    </span>
                    Secure and transparent transactions
                  </li>
                </ul>

                <div class="mt-7">
                  <a href="<%= ctx %>/about"
                    class="inline-flex items-center justify-center rounded-xl bg-red-800 px-7 py-3 text-sm font-semibold text-white shadow-sm transition hover:bg-red-900 focus:outline-none focus:ring-2 focus:ring-red-800 focus:ring-offset-2">
                    Learn More About Safety
                  </a>
                </div>
              </div>

            </div>
          </div>
        </section>

        <!-- Testimonials Section -->
        <section class="mx-auto mt-16 w-full max-w-[1200px] px-0">
          <div class="mb-6 text-center">
            <p class="text-lg font-semibold tracking-[0.16em] text-red-800">Testimonials</p>
            <h2 class="mt-2 text-3xl font-semibold tracking-tight text-slate-900 sm:text-4xl">Loved by Riders Across Nepal</h2>
            <p class="mx-auto mt-3 max-w-[700px] text-sm leading-relaxed text-slate-600 sm:text-base">
              Real stories from our community of renters and owners who trust SajhaRide for daily mobility.
            </p>
          </div>

          <div class="grid grid-cols-1 gap-5 md:grid-cols-3">
            <article class="rounded-2xl border border-red-100 bg-white p-5 shadow-[0_10px_25px_-10px_rgba(0,0,0,0.12)]">
              <div class="flex items-center gap-1 text-red-800" aria-label="5 out of 5 stars">
                <svg class="h-4 w-4" viewBox="0 0 24 24" fill="currentColor" aria-hidden="true"><path d="M12 17.27L18.18 21 16.54 13.97 22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21z" /></svg>
                <svg class="h-4 w-4" viewBox="0 0 24 24" fill="currentColor" aria-hidden="true"><path d="M12 17.27L18.18 21 16.54 13.97 22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21z" /></svg>
                <svg class="h-4 w-4" viewBox="0 0 24 24" fill="currentColor" aria-hidden="true"><path d="M12 17.27L18.18 21 16.54 13.97 22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21z" /></svg>
                <svg class="h-4 w-4" viewBox="0 0 24 24" fill="currentColor" aria-hidden="true"><path d="M12 17.27L18.18 21 16.54 13.97 22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21z" /></svg>
                <svg class="h-4 w-4" viewBox="0 0 24 24" fill="currentColor" aria-hidden="true"><path d="M12 17.27L18.18 21 16.54 13.97 22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21z" /></svg>
              </div>
              <p class="mt-4 text-sm leading-relaxed text-slate-600">
                Booking in Kathmandu was super smooth. The owner was responsive, the car was clean, and pricing was exactly as shown.
              </p>
              <div class="mt-5 border-t border-red-100 pt-4">
                <h3 class="text-base font-semibold text-slate-900">Sushmita Shrestha</h3>
                <p class="text-sm text-slate-500">Kathmandu, Nepal</p>
              </div>
            </article>

            <article class="rounded-2xl border border-red-100 bg-white p-5 shadow-[0_10px_25px_-10px_rgba(0,0,0,0.12)]">
              <div class="flex items-center gap-1 text-red-800" aria-label="5 out of 5 stars">
                <svg class="h-4 w-4" viewBox="0 0 24 24" fill="currentColor" aria-hidden="true"><path d="M12 17.27L18.18 21 16.54 13.97 22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21z" /></svg>
                <svg class="h-4 w-4" viewBox="0 0 24 24" fill="currentColor" aria-hidden="true"><path d="M12 17.27L18.18 21 16.54 13.97 22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21z" /></svg>
                <svg class="h-4 w-4" viewBox="0 0 24 24" fill="currentColor" aria-hidden="true"><path d="M12 17.27L18.18 21 16.54 13.97 22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21z" /></svg>
                <svg class="h-4 w-4" viewBox="0 0 24 24" fill="currentColor" aria-hidden="true"><path d="M12 17.27L18.18 21 16.54 13.97 22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21z" /></svg>
                <svg class="h-4 w-4" viewBox="0 0 24 24" fill="currentColor" aria-hidden="true"><path d="M12 17.27L18.18 21 16.54 13.97 22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21z" /></svg>
              </div>
              <p class="mt-4 text-sm leading-relaxed text-slate-600">
                I listed my bike in Pokhara and got bookings from verified renters quickly. It feels safe and very easy to manage.
              </p>
              <div class="mt-5 border-t border-red-100 pt-4">
                <h3 class="text-base font-semibold text-slate-900">Prakash Gurung</h3>
                <p class="text-sm text-slate-500">Pokhara, Nepal</p>
              </div>
            </article>

            <article class="rounded-2xl border border-red-100 bg-white p-5 shadow-[0_10px_25px_-10px_rgba(0,0,0,0.12)]">
              <div class="flex items-center gap-1 text-red-800" aria-label="4 out of 5 stars">
                <svg class="h-4 w-4" viewBox="0 0 24 24" fill="currentColor" aria-hidden="true"><path d="M12 17.27L18.18 21 16.54 13.97 22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21z" /></svg>
                <svg class="h-4 w-4" viewBox="0 0 24 24" fill="currentColor" aria-hidden="true"><path d="M12 17.27L18.18 21 16.54 13.97 22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21z" /></svg>
                <svg class="h-4 w-4" viewBox="0 0 24 24" fill="currentColor" aria-hidden="true"><path d="M12 17.27L18.18 21 16.54 13.97 22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21z" /></svg>
                <svg class="h-4 w-4" viewBox="0 0 24 24" fill="currentColor" aria-hidden="true"><path d="M12 17.27L18.18 21 16.54 13.97 22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21z" /></svg>
                <svg class="h-4 w-4 text-red-200" viewBox="0 0 24 24" fill="currentColor" aria-hidden="true"><path d="M12 17.27L18.18 21 16.54 13.97 22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21z" /></svg>
              </div>
              <p class="mt-4 text-sm leading-relaxed text-slate-600">
                Great experience in Lalitpur for a weekend trip. No hidden charges and support replied fast when I needed help.
              </p>
              <div class="mt-5 border-t border-red-100 pt-4">
                <h3 class="text-base font-semibold text-slate-900">Anish Maharjan</h3>
                <p class="text-sm text-slate-500">Lalitpur, Nepal</p>
              </div>
            </article>
          </div>
        </section>

        <!-- Pricing Comparison Section -->
        <section class="relative left-1/2 mt-16 w-screen -translate-x-1/2 border-y border-red-100 bg-gradient-to-br from-red-50 via-white to-red-100/40 shadow-[0_8px_20px_-12px_rgba(0,0,0,0.1)]  bg-red-50/50 py-10">
          <div class="mx-auto w-full max-w-[1200px] px-4 sm:px-6 lg:px-8">
            <div class="mb-6 text-center">
              <p class="text-xs font-semibold uppercase tracking-[0.16em] text-red-800">Pricing Comparison</p>
              <h2 class="mt-2 text-3xl font-semibold tracking-tight text-slate-900 sm:text-4xl">SajhaRide vs Traditional Rentals</h2>
            </div>

            <div class="grid grid-cols-1 gap-5 lg:grid-cols-2">
              <article class="rounded-2xl border border-red-100 bg-white p-6 shadow-[0_10px_25px_-10px_rgba(0,0,0,0.12)]">
                <div class="mb-5 flex items-center justify-between gap-4">
                  <h3 class="text-2xl font-semibold text-slate-900">SajhaRide</h3>
                  <span class="rounded-full bg-red-100 px-3 py-1 text-xs font-semibold text-red-800">Recommended</span>
                </div>
                <ul class="space-y-3">
                  <li class="flex items-start gap-3 text-sm text-slate-700"><span class="mt-0.5 inline-flex h-5 w-5 items-center justify-center rounded-full bg-red-100 text-red-800"><svg class="h-3.5 w-3.5" viewBox="0 0 20 20" fill="none" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M5 10l3 3 7-7"></path></svg></span>No hidden booking fees</li>
                  <li class="flex items-start gap-3 text-sm text-slate-700"><span class="mt-0.5 inline-flex h-5 w-5 items-center justify-center rounded-full bg-red-100 text-red-800"><svg class="h-3.5 w-3.5" viewBox="0 0 20 20" fill="none" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M5 10l3 3 7-7"></path></svg></span>Flexible pricing by owner and season</li>
                  <li class="flex items-start gap-3 text-sm text-slate-700"><span class="mt-0.5 inline-flex h-5 w-5 items-center justify-center rounded-full bg-red-100 text-red-800"><svg class="h-3.5 w-3.5" viewBox="0 0 20 20" fill="none" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M5 10l3 3 7-7"></path></svg></span>Direct owner deals and transparent communication</li>
                  <li class="flex items-start gap-3 text-sm text-slate-700"><span class="mt-0.5 inline-flex h-5 w-5 items-center justify-center rounded-full bg-red-100 text-red-800"><svg class="h-3.5 w-3.5" viewBox="0 0 20 20" fill="none" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M5 10l3 3 7-7"></path></svg></span>Local support and verified community trust</li>
                </ul>
              </article>

              <article class="rounded-2xl border border-slate-200 bg-white p-6 shadow-[0_10px_25px_-10px_rgba(0,0,0,0.12)]">
                <h3 class="mb-5 text-2xl font-semibold text-slate-900">Traditional Rentals</h3>
                <ul class="space-y-3">
                  <li class="flex items-start gap-3 text-sm text-slate-700"><span class="mt-0.5 inline-flex h-5 w-5 items-center justify-center rounded-full bg-slate-100 text-slate-500"><svg class="h-3.5 w-3.5" viewBox="0 0 20 20" fill="none" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M6 6l8 8M14 6l-8 8"></path></svg></span>Extra surcharges often shown late</li>
                  <li class="flex items-start gap-3 text-sm text-slate-700"><span class="mt-0.5 inline-flex h-5 w-5 items-center justify-center rounded-full bg-slate-100 text-slate-500"><svg class="h-3.5 w-3.5" viewBox="0 0 20 20" fill="none" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M6 6l8 8M14 6l-8 8"></path></svg></span>Fixed rates with less flexibility</li>
                  <li class="flex items-start gap-3 text-sm text-slate-700"><span class="mt-0.5 inline-flex h-5 w-5 items-center justify-center rounded-full bg-slate-100 text-slate-500"><svg class="h-3.5 w-3.5" viewBox="0 0 20 20" fill="none" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M6 6l8 8M14 6l-8 8"></path></svg></span>Limited direct communication with owners</li>
                  <li class="flex items-start gap-3 text-sm text-slate-700"><span class="mt-0.5 inline-flex h-5 w-5 items-center justify-center rounded-full bg-slate-100 text-slate-500"><svg class="h-3.5 w-3.5" viewBox="0 0 20 20" fill="none" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M6 6l8 8M14 6l-8 8"></path></svg></span>Less localized booking experience</li>
                </ul>
              </article>
            </div>
          </div>
        </section>

        <!-- Vehicle Owners Section -->
        <section class="mx-auto mt-16 w-full max-w-[1200px]">
          <div class="grid grid-cols-1 gap-8 lg:grid-cols-2 lg:gap-10">
            <div class="grid grid-cols-1 gap-4 sm:grid-cols-2">
              <article class="rounded-2xl border border-red-100 bg-white p-5 shadow-[0_10px_25px_-10px_rgba(0,0,0,0.12)]">
                <div class="flex h-11 w-11 items-center justify-center rounded-xl bg-red-100 text-red-800">
                  <svg class="h-5 w-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true"><path stroke-linecap="round" stroke-linejoin="round" d="M12 3v18"></path><path stroke-linecap="round" stroke-linejoin="round" d="M17 7.5c0-2-2.2-3.5-5-3.5s-5 1.5-5 3.5 2.2 3.5 5 3.5 5 1.5 5 3.5-2.2 3.5-5 3.5-5-1.5-5-3.5"></path></svg>
                </div>
                <h3 class="mt-4 text-xl font-semibold text-slate-900">Earn Income</h3>
                <p class="mt-2 text-sm leading-relaxed text-slate-600">Turn idle vehicles into steady monthly earnings with flexible availability.</p>
              </article>

              <article class="rounded-2xl border border-red-100 bg-white p-5 shadow-[0_10px_25px_-10px_rgba(0,0,0,0.12)]">
                <div class="flex h-11 w-11 items-center justify-center rounded-xl bg-red-100 text-red-800">
                  <svg class="h-5 w-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true"><path stroke-linecap="round" stroke-linejoin="round" d="M12 8c2.21 0 4-1.79 4-4"></path><path stroke-linecap="round" stroke-linejoin="round" d="M8 4a4 4 0 104 4"></path><path stroke-linecap="round" stroke-linejoin="round" d="M4 14c2 0 3-1 4-2 1 1 2 2 4 2s3-1 4-2c1 1 2 2 4 2"></path><path stroke-linecap="round" stroke-linejoin="round" d="M6 14v6m12-6v6"></path></svg>
                </div>
                <h3 class="mt-4 text-xl font-semibold text-slate-900">Full Control</h3>
                <p class="mt-2 text-sm leading-relaxed text-slate-600">Set your own price, rules, and trip availability without middlemen constraints.</p>
              </article>

              <article class="rounded-2xl border border-red-100 bg-white p-5 shadow-[0_10px_25px_-10px_rgba(0,0,0,0.12)]">
                <div class="flex h-11 w-11 items-center justify-center rounded-xl bg-red-100 text-red-800">
                  <svg class="h-5 w-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true"><path stroke-linecap="round" stroke-linejoin="round" d="M16 11c1.66 0 3-1.34 3-3S17.66 5 16 5s-3 1.34-3 3 1.34 3 3 3z"></path><path stroke-linecap="round" stroke-linejoin="round" d="M8 11c1.66 0 3-1.34 3-3S9.66 5 8 5 5 6.34 5 8s1.34 3 3 3z"></path><path stroke-linecap="round" stroke-linejoin="round" d="M2 20v-1c0-2.2 1.8-4 4-4h4"></path><path stroke-linecap="round" stroke-linejoin="round" d="M14 18l2 2 4-4"></path></svg>
                </div>
                <h3 class="mt-4 text-xl font-semibold text-slate-900">Verified Renters</h3>
                <p class="mt-2 text-sm leading-relaxed text-slate-600">Accept bookings confidently from a trusted and identity-verified renter network.</p>
              </article>

              <article class="rounded-2xl border border-red-100 bg-white p-5 shadow-[0_10px_25px_-10px_rgba(0,0,0,0.12)]">
                <div class="flex h-11 w-11 items-center justify-center rounded-xl bg-red-100 text-red-800">
                  <svg class="h-5 w-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true"><path stroke-linecap="round" stroke-linejoin="round" d="M3 7h18"></path><path stroke-linecap="round" stroke-linejoin="round" d="M8 3v4"></path><path stroke-linecap="round" stroke-linejoin="round" d="M16 3v4"></path><rect x="3" y="7" width="18" height="14" rx="2"></rect><path stroke-linecap="round" stroke-linejoin="round" d="M8 12h8"></path><path stroke-linecap="round" stroke-linejoin="round" d="M8 16h5"></path></svg>
                </div>
                <h3 class="mt-4 text-xl font-semibold text-slate-900">Easy Management</h3>
                <p class="mt-2 text-sm leading-relaxed text-slate-600">Manage listings, requests, and schedules in one clean dashboard workflow.</p>
              </article>
            </div>

            <div class="flex flex-col justify-center rounded-2xl border border-red-100 bg-white p-6 shadow-[0_10px_25px_-10px_rgba(0,0,0,0.12)] sm:p-8">
              <p class="text-xs font-semibold uppercase tracking-[0.16em] text-red-800">For Vehicle Owners</p>
              <h2 class="mt-3 text-3xl font-semibold leading-tight text-slate-900 sm:text-4xl">
                List once,
                <span class="text-red-800">earn every month.</span>
              </h2>
              <p class="mt-5 text-base leading-relaxed text-slate-600">
                SajhaRide helps you grow passive income with trusted bookings, transparent pricing, and effortless day-to-day listing management.
              </p>
              <ul class="mt-6 space-y-3">
                <li class="flex items-start gap-3 text-sm font-medium text-slate-800 sm:text-base"><span class="mt-0.5 inline-flex h-5 w-5 items-center justify-center rounded-full bg-red-100 text-red-800"><svg class="h-3.5 w-3.5" viewBox="0 0 20 20" fill="none" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M5 10l3 3 7-7"></path></svg></span>Set your own rates and acceptance rules</li>
                <li class="flex items-start gap-3 text-sm font-medium text-slate-800 sm:text-base"><span class="mt-0.5 inline-flex h-5 w-5 items-center justify-center rounded-full bg-red-100 text-red-800"><svg class="h-3.5 w-3.5" viewBox="0 0 20 20" fill="none" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M5 10l3 3 7-7"></path></svg></span>Reach verified local renters faster</li>
                <li class="flex items-start gap-3 text-sm font-medium text-slate-800 sm:text-base"><span class="mt-0.5 inline-flex h-5 w-5 items-center justify-center rounded-full bg-red-100 text-red-800"><svg class="h-3.5 w-3.5" viewBox="0 0 20 20" fill="none" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M5 10l3 3 7-7"></path></svg></span>Track bookings and earnings with ease</li>
              </ul>
              <div class="mt-7">
                <a href="<%= ctx %>/auth/register" class="inline-flex items-center justify-center rounded-xl bg-red-800 px-7 py-3 text-sm font-semibold text-white shadow-sm transition hover:bg-red-900 focus:outline-none focus:ring-2 focus:ring-red-800 focus:ring-offset-2">
                  List Your Vehicle
                </a>
              </div>
            </div>
          </div>
        </section>

        <!-- Final CTA Section -->
        <section class="mx-auto mt-16 w-full max-w-[1200px]">
          <div class="rounded-3xl border border-red-100 bg-red-800 px-6 py-12 text-center shadow-[0_10px_25px_-10px_rgba(0,0,0,0.12)] sm:px-10">
            <p class="text-xs font-semibold uppercase tracking-[0.16em] text-white">Get Started</p>
            <h2 class="mt-3 text-3xl font-semibold leading-tight text-white sm:text-4xl">Start your journey today</h2>
            <p class="mx-auto mt-4 max-w-[700px] text-sm leading-relaxed text-white sm:text-base">
              Book a trusted ride for your next trip or list your own vehicle and start earning with SajhaRide.
            </p>

            <div class="mt-8 flex flex-wrap items-center justify-center gap-3 sm:gap-4">
              <a href="<%= ctx %>/login" class="inline-flex min-w-[170px] items-center justify-center rounded-xl bg-red-800 border border-white px-7 py-3 text-sm font-semibold text-white shadow-sm transition hover:bg-red-900 focus:outline-none focus:ring-2 focus:ring-red-800 focus:ring-offset-2">
                Book a Ride
              </a>
              <a href="<%= ctx %>/login" class="inline-flex min-w-[170px] items-center justify-center rounded-xl border border-red-200 bg-white px-7 py-3 text-sm font-semibold text-red-800 shadow-sm transition hover:bg-red-50 focus:outline-none focus:ring-2 focus:ring-red-800 focus:ring-offset-2">
                List Your Vehicle
              </a>
            </div>
          </div>
        </section>
      </main>
      <jsp:include page="../landing/components/footer.jsp" />
    </body>
    </html>

