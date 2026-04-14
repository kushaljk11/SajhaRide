<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% String ctx = request.getContextPath(); %>
<html>
<head>
  <title>Contact SajhaRide</title>
  <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-neutral-100 text-slate-900">
<jsp:include page="components/topbar.jsp" />

<main class="mx-auto min-h-screen max-w-[1200px] px-4 pb-16 pt-10 sm:px-6 lg:px-8">
  <section class="relative overflow-hidden rounded-3xl bg-red-800 px-6 py-14 text-white sm:px-10">
    <div class="max-w-[760px]">
      <p class="text-lg text-red-100">Contact Us</p>
      <h1 class=" text-4xl font-semibold leading-tight sm:text-4xl">Namaste, Do you need help?.</h1>
    </div>
  </section>

  <section class="mt-10 grid grid-cols-1 gap-4 md:grid-cols-3">
    <article class="rounded-2xl border border-red-100 bg-white p-5 shadow-[0_10px_25px_-10px_rgba(0,0,0,0.12)]">
      <div class="flex h-10 w-10 items-center justify-center rounded-xl bg-red-100 text-red-800">
        <svg class="h-5 w-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
          <path stroke-linecap="round" stroke-linejoin="round" d="M4 4h16v16H4z"></path>
          <path stroke-linecap="round" stroke-linejoin="round" d="M4 7l8 6 8-6"></path>
        </svg>
      </div>
      <h2 class="mt-4 text-lg font-semibold text-slate-900">Email Support</h2>
      <p class="mt-2 text-sm text-slate-600">support@sajharide.com</p>
      <p class="mt-1 text-sm text-slate-600">We usually respond within 24 hours.</p>
    </article>

    <article class="rounded-2xl border border-red-100 bg-white p-5 shadow-[0_10px_25px_-10px_rgba(0,0,0,0.12)]">
      <div class="flex h-10 w-10 items-center justify-center rounded-xl bg-red-100 text-red-800">
        <svg class="h-5 w-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
          <path stroke-linecap="round" stroke-linejoin="round" d="M22 16.92v3a2 2 0 01-2.18 2 19.79 19.79 0 01-8.63-3.07 19.5 19.5 0 01-6-6A19.79 19.79 0 012.18 4.18 2 2 0 014.17 2h3a2 2 0 012 1.72c.12.89.33 1.76.63 2.6a2 2 0 01-.45 2.11L8.1 9.91a16 16 0 006 6l1.48-1.28a2 2 0 012.11-.45c.84.3 1.71.51 2.6.63A2 2 0 0122 16.92z"></path>
        </svg>
      </div>
      <h2 class="mt-4 text-lg font-semibold text-slate-900">Phone</h2>
      <p class="mt-2 text-sm text-slate-600">+977 9804060401</p>
      <p class="mt-1 text-sm text-slate-600">Sun - Fri, 9:00 AM to 6:00 PM</p>
    </article>

    <article class="rounded-2xl border border-red-100 bg-white p-5 shadow-[0_10px_25px_-10px_rgba(0,0,0,0.12)]">
      <div class="flex h-10 w-10 items-center justify-center rounded-xl bg-red-100 text-red-800">
        <svg class="h-5 w-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
          <path stroke-linecap="round" stroke-linejoin="round" d="M12 22s7-4.35 7-11a7 7 0 10-14 0c0 6.65 7 11 7 11z"></path>
          <circle cx="12" cy="11" r="2.5"></circle>
        </svg>
      </div>
      <h2 class="mt-4 text-lg font-semibold text-slate-900">Office</h2>
      <p class="mt-2 text-sm text-slate-600">Itahari, Nepal</p>
      <p class="mt-1 text-sm text-slate-600">Visit us for onboarding and support.</p>
    </article>
  </section>

  <section class="mt-12 grid grid-cols-1 gap-8 lg:grid-cols-2">
    <article class="rounded-3xl border border-red-100 bg-white p-6 shadow-[0_10px_25px_-10px_rgba(0,0,0,0.12)] sm:p-8">
      <p class="text-xs font-semibold uppercase tracking-[0.16em] text-red-800">Send Message</p>
      <h2 class="mt-3 text-3xl font-semibold text-slate-900">Let us know how we can help</h2>

      <form action="#" method="post" class="mt-6 space-y-4">
        <div class="grid grid-cols-1 gap-4 sm:grid-cols-2">
          <div>
            <label for="fullName" class="mb-2 block text-sm font-medium text-slate-700">Full Name</label>
            <input id="fullName" name="fullName" type="text" placeholder="Enter your name"
                 class="h-11 w-full rounded-xl border border-slate-200 bg-white px-3 text-sm text-slate-700 outline-none focus:border-red-800" />
          </div>
          <div>
            <label for="email" class="mb-2 block text-sm font-medium text-slate-700">Email</label>
            <input id="email" name="email" type="email" placeholder="name@example.com"
                 class="h-11 w-full rounded-xl border border-slate-200 bg-white px-3 text-sm text-slate-700 outline-none focus:border-red-800" />
          </div>
        </div>

        <div>
          <label for="subject" class="mb-2 block text-sm font-medium text-slate-700">Subject</label>
          <input id="subject" name="subject" type="text" placeholder="Booking, listing, payment..."
               class="h-11 w-full rounded-xl border border-slate-200 bg-white px-3 text-sm text-slate-700 outline-none focus:border-red-800" />
        </div>

        <div>
          <label for="message" class="mb-2 block text-sm font-medium text-slate-700">Message</label>
          <textarea id="message" name="message" rows="5" placeholder="Write your message"
                class="w-full rounded-xl border border-slate-200 bg-white px-3 py-3 text-sm text-slate-700 outline-none focus:border-red-800"></textarea>
        </div>

        <button type="submit"
            class="inline-flex items-center justify-center rounded-xl bg-red-800 px-7 py-3 text-sm font-semibold text-white transition hover:bg-red-900 focus:outline-none focus:ring-2 focus:ring-red-800 focus:ring-offset-2">
          Send Message
        </button>
      </form>
    </article>

    <article class="rounded-3xl border border-red-100 bg-white p-6 shadow-[0_10px_25px_-10px_rgba(0,0,0,0.12)] sm:p-8">
      <p class="text-xs font-semibold uppercase tracking-[0.16em] text-red-800">Quick Help</p>
      <h2 class="mt-3 text-3xl font-semibold text-slate-900">Frequently asked</h2>

      <div class="mt-6 space-y-4">
        <div class="rounded-2xl border border-red-100 bg-red-50/40 p-4">
          <h3 class="text-sm font-semibold text-slate-900">How do I list my vehicle?</h3>
          <p class="mt-2 text-sm text-slate-600">Create an owner account, upload vehicle details, set pricing, and publish your listing.</p>
        </div>
        <div class="rounded-2xl border border-red-100 bg-red-50/40 p-4">
          <h3 class="text-sm font-semibold text-slate-900">Are payments secure?</h3>
          <p class="mt-2 text-sm text-slate-600">Yes. We support secure digital payment options with transparent booking records.</p>
        </div>
        <div class="rounded-2xl border border-red-100 bg-red-50/40 p-4">
          <h3 class="text-sm font-semibold text-slate-900">Can I cancel a booking?</h3>
          <p class="mt-2 text-sm text-slate-600">Yes. Cancellation rules depend on the listing policy and timing of cancellation.</p>
        </div>
      </div>

      <a href="<%= ctx %>/vehicles/list"
         class="mt-6 inline-flex items-center justify-center rounded-xl border border-red-200 bg-white px-7 py-3 text-sm font-semibold text-red-800 transition hover:bg-red-50">
        Browse Available Vehicles
      </a>
    </article>
  </section>
</main>

<jsp:include page="components/footer.jsp" />

</body>
</html>
