<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>SajhaRide - Add New Post</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="h-screen overflow-hidden bg-gray-100 text-gray-900">
<div class="flex h-full">
    <jsp:include page="../owner/components/sidebar.jsp" />

    <div class="flex min-w-0 flex-1 flex-col overflow-hidden">
        <jsp:include page="../owner/components/topbar.jsp" />

        <main class="flex-1 overflow-y-auto px-6 py-6 sm:px-8">
            <section class="mb-6">
                <h1 class="text-3xl font-semibold tracking-tight text-gray-900">List Your Vehicle</h1>
                <p class="mt-2 max-w-2xl text-sm leading-6 text-gray-600">
                    Join the SajhaRide community and turn your idle vehicle into a source of income. It takes less than 5 minutes to get started.
                </p>
            </section>

            <section class="grid grid-cols-1 gap-6 xl:grid-cols-5">
                <div class="space-y-6 xl:col-span-3">
                    <article class="rounded-2xl border border-red-100 bg-white p-5 shadow-sm">
                        <div class="mb-4 flex items-center gap-2">
                            <span class="inline-flex h-5 w-5 items-center justify-center rounded-full border border-red-200 bg-red-50 text-red-800">
                                <svg class="h-3.5 w-3.5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
                                    <circle cx="12" cy="12" r="9"></circle>
                                    <path d="M12 8v5"></path>
                                    <path d="M12 16h.01"></path>
                                </svg>
                            </span>
                            <h2 class="text-2xl font-semibold text-gray-900">Vehicle Information</h2>
                        </div>

                        <form class="space-y-4" action="#" method="post" enctype="multipart/form-data">
                            <div>
                                <label for="vehicleName" class="mb-1.5 block text-sm font-semibold text-gray-700">Vehicle Name</label>
                                <input id="vehicleName" name="vehicleName" type="text" placeholder="e.g., Mahindra Scorpio 4WD" class="w-full rounded-xl border border-gray-200 bg-gray-50 px-4 py-3 text-sm text-gray-700 placeholder:text-gray-400 focus:border-red-300 focus:outline-none focus:ring-2 focus:ring-red-100" />
                            </div>

                            <div class="grid grid-cols-1 gap-4 md:grid-cols-2">
                                <div>
                                    <label for="vehicleType" class="mb-1.5 block text-sm font-semibold text-gray-700">Vehicle Type</label>
                                    <select id="vehicleType" name="vehicleType" class="w-full rounded-xl border border-gray-200 bg-gray-50 px-4 py-3 text-sm text-gray-700 focus:border-red-300 focus:outline-none focus:ring-2 focus:ring-red-100">
                                        <option>SUV</option>
                                        <option>Sedan</option>
                                        <option>Bike</option>
                                        <option>Scooter</option>
                                        <option>Pickup</option>
                                    </select>
                                </div>

                                <div>
                                    <label for="pricePerDay" class="mb-1.5 block text-sm font-semibold text-gray-700">Price Per Day</label>
                                    <div class="flex items-center rounded-xl border border-gray-200 bg-gray-50 px-4 py-3">
                                        <span class="text-sm font-semibold text-red-800">NPR</span>
                                        <input id="pricePerDay" name="pricePerDay" type="number" min="0" step="100" value="2500" class="ml-2 w-full bg-transparent text-sm text-gray-700 focus:outline-none" />
                                    </div>
                                </div>
                            </div>

                            <div>
                                <label for="location" class="mb-1.5 block text-sm font-semibold text-gray-700">Location</label>
                                <select id="location" name="location" class="w-full rounded-xl border border-gray-200 bg-gray-50 px-4 py-3 text-sm text-gray-700 focus:border-red-300 focus:outline-none focus:ring-2 focus:ring-red-100">
                                    <option>Kathmandu</option>
                                    <option>Lalitpur</option>
                                    <option>Bhaktapur</option>
                                    <option>Pokhara</option>
                                    <option>Chitwan</option>
                                </select>
                            </div>

                            <div>
                                <label for="description" class="mb-1.5 block text-sm font-semibold text-gray-700">Description</label>
                                <textarea id="description" name="description" rows="5" placeholder="Tell potential renters about the features, maintenance history, and specific rules..." class="w-full resize-none rounded-xl border border-gray-200 bg-gray-50 px-4 py-3 text-sm text-gray-700 placeholder:text-gray-400 focus:border-red-300 focus:outline-none focus:ring-2 focus:ring-red-100"></textarea>
                            </div>
                        </form>
                    </article>

                    <article class="rounded-2xl border border-red-100 bg-white p-5 shadow-sm">
                        <div class="mb-4 flex items-center gap-2">
                            <span class="inline-flex h-5 w-5 items-center justify-center rounded-md border border-red-200 bg-red-50 text-red-800">
                                <svg class="h-3.5 w-3.5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
                                    <rect x="4" y="4" width="16" height="16" rx="2"></rect>
                                    <path d="M8 12h8"></path>
                                </svg>
                            </span>
                            <h2 class="text-2xl font-semibold text-gray-900">Availability &amp; Status</h2>
                        </div>

                        <div class="flex items-center justify-between rounded-xl border border-gray-200 bg-gray-50 px-4 py-4">
                            <div>
                                <p class="text-sm font-semibold text-gray-800">Listed Status</p>
                                <p class="mt-1 text-xs text-gray-600">Make your vehicle visible immediately.</p>
                            </div>
                            <label class="relative inline-flex cursor-pointer items-center">
                                <input type="checkbox" class="peer sr-only" checked />
                                <span class="h-7 w-12 rounded-full bg-red-800 transition peer-checked:bg-red-800 peer-focus:outline-none"></span>
                                <span class="absolute left-1 top-1 h-5 w-5 rounded-full bg-white transition peer-checked:translate-x-5"></span>
                            </label>
                        </div>
                    </article>
                </div>

                <div class="space-y-6 xl:col-span-2">
                    <article class="rounded-2xl border border-red-100 bg-white p-5 shadow-sm">
                        <div class="mb-4 flex items-center gap-2">
                            <span class="inline-flex h-5 w-5 items-center justify-center rounded-md border border-red-200 bg-red-50 text-red-800">
                                <svg class="h-3.5 w-3.5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
                                    <rect x="3" y="4" width="18" height="16" rx="2"></rect>
                                    <path d="m8 13 2.5-2.5L14 14l2-2"></path>
                                </svg>
                            </span>
                            <h2 class="text-2xl font-semibold text-gray-900">Vehicle Photos</h2>
                        </div>

                        <div class="rounded-xl border border-dashed border-red-200 bg-red-50/30 p-6 text-center">
                            <span class="mx-auto inline-flex h-12 w-12 items-center justify-center rounded-full bg-red-100 text-red-800">
                                <svg class="h-6 w-6" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
                                    <path d="M12 16V8"></path>
                                    <path d="m8.5 11.5 3.5-3.5 3.5 3.5"></path>
                                    <path d="M20 16.5a3.5 3.5 0 0 0-2.1-3.2"></path>
                                    <path d="M4 16.5a3.5 3.5 0 0 1 2.1-3.2"></path>
                                    <path d="M8 18h8"></path>
                                </svg>
                            </span>
                            <p class="mt-3 text-sm font-semibold text-gray-800">Drag and drop your photos</p>
                            <p class="mt-1 text-xs text-gray-600">PNG, JPG up to 10MB each</p>
                            <button type="button" class="mt-4 rounded-lg bg-red-800 px-4 py-2 text-sm font-semibold text-white transition hover:bg-red-900">Upload Photos</button>
                        </div>

                        <div class="mt-3 grid grid-cols-2 gap-3">
                            <div class="h-14 rounded-lg border border-gray-200 bg-gray-100"></div>
                            <div class="h-14 rounded-lg border border-gray-200 bg-gray-100"></div>
                        </div>
                    </article>

                    <article class="rounded-2xl border border-red-100 bg-white p-5 shadow-sm">
                        <h3 class="text-lg font-semibold text-gray-900">Pro Tip</h3>
                        <p class="mt-2 text-sm leading-6 text-gray-600">
                            Add clear front, side, and interior photos to improve trust and increase booking chances.
                        </p>
                    </article>

                    <article class="rounded-2xl border border-red-100 bg-white p-5 shadow-sm">
                        <h3 class="text-lg font-semibold text-gray-900">Listing Checklist</h3>
                        <ul class="mt-3 space-y-2 text-sm text-gray-700">
                            <li class="flex items-center gap-2">
                                <span class="inline-block h-2 w-2 rounded-full bg-red-800"></span>
                                Vehicle name and type added
                            </li>
                            <li class="flex items-center gap-2">
                                <span class="inline-block h-2 w-2 rounded-full bg-red-800"></span>
                                Daily price and location set
                            </li>
                            <li class="flex items-center gap-2">
                                <span class="inline-block h-2 w-2 rounded-full bg-red-800"></span>
                                At least 3 photos uploaded
                            </li>
                        </ul>
                    </article>

                    <div>
                        <button type="button" class="w-full rounded-xl bg-red-800 px-6 py-3 text-base font-semibold text-white shadow-lg shadow-red-200 transition hover:bg-red-900">List My Vehicle</button>
                        <p class="mt-2 text-center text-xs text-gray-500">
                            By listing, you agree to SajhaRide's Owner Terms &amp; Conditions.
                        </p>
                    </div>
                </div>
            </section>
        </main>
    </div>
</div>
</body>
</html>
