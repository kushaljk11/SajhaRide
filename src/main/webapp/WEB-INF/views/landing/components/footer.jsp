<footer class="bg-red-800 text-white">
    <div class="mx-auto max-w-[1200px] px-6 py-12">

        <div class="grid grid-cols-1 gap-10 md:grid-cols-2 lg:grid-cols-4">

            <!-- Brand -->
            <div>
                <div class="flex items-center gap-3">
                    <div class="flex h-12 w-28 items-center justify-center overflow-hidden rounded-lg bg-white px-2">
                        <img src="<%= request.getContextPath() %>/images/logo.svg" alt="SajhaRide logo" class="h-9 w-auto object-contain" />
                    </div>
                    <h2 class="text-xl font-semibold text-white">SajhaRide</h2>
                </div>

                <p class="mt-4 text-sm leading-relaxed text-red-100">
                    Connecting vehicle owners and renters across Nepal with trusted, affordable, and flexible mobility.
                </p>

                <!-- Socials -->
                <div class="mt-5 flex gap-3">
                    <a href="#" aria-label="Facebook" class="flex h-10 w-10 items-center justify-center rounded-full bg-white/15 text-white transition hover:bg-white hover:text-red-800">
                        <svg class="h-4 w-4" viewBox="0 0 24 24" fill="currentColor" aria-hidden="true">
                            <path d="M13.5 22v-8h2.7l.4-3h-3.1V9.1c0-.9.3-1.6 1.6-1.6h1.7V4.8c-.3 0-1.3-.1-2.5-.1-2.5 0-4.1 1.5-4.1 4.4V11H7.5v3h2.7v8h3.3z"></path>
                        </svg>
                    </a>
                    <a href="#" aria-label="X" class="flex h-10 w-10 items-center justify-center rounded-full bg-white/15 text-white transition hover:bg-white hover:text-red-800">
                        <svg class="h-4 w-4" viewBox="0 0 24 24" fill="currentColor" aria-hidden="true">
                            <path d="M18.9 2H22l-6.8 7.8L23 22h-6.1l-4.8-6.3L6.5 22H3.4l7.3-8.3L1 2h6.3l4.3 5.8L18.9 2zm-1.1 18h1.7L6.4 3.9H4.6L17.8 20z"></path>
                        </svg>
                    </a>
                    <a href="#" aria-label="Instagram" class="flex h-10 w-10 items-center justify-center rounded-full bg-white/15 text-white transition hover:bg-white hover:text-red-800">
                        <svg class="h-4 w-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
                            <rect x="3" y="3" width="18" height="18" rx="5"></rect>
                            <circle cx="12" cy="12" r="4"></circle>
                            <circle cx="17.5" cy="6.5" r="1"></circle>
                        </svg>
                    </a>
                    <a href="#" aria-label="LinkedIn" class="flex h-10 w-10 items-center justify-center rounded-full bg-white/15 text-white transition hover:bg-white hover:text-red-800">
                        <svg class="h-4 w-4" viewBox="0 0 24 24" fill="currentColor" aria-hidden="true">
                            <path d="M6.9 8.6a1.9 1.9 0 110-3.8 1.9 1.9 0 010 3.8zM5.2 9.9h3.4V20H5.2V9.9zm5.3 0h3.2v1.4h.1c.4-.8 1.5-1.7
                             3.1-1.7 3.3 0 3.9 2.1 3.9 4.9V20h-3.4v-4.8c0-1.2 0-2.7-1.7-2.7s-1.9 1.3-1.9 2.6V20h-3.4V9.9z"></path>
                        </svg>
                    </a>
                </div>
            </div>

            <!-- Quick Links -->
            <div>
                <h3 class="text-lg font-semibold text-white">Quick Links</h3>
                <ul class="mt-4 space-y-2 text-sm text-red-100">
                    <li><a href="<%= request.getContextPath() %>/" class="transition hover:text-white">Home</a></li>
                    <li><a href="<%= request.getContextPath() %>/vehicles/list" class="transition hover:text-white">Find a Ride</a></li>
                    <li><a href="<%= request.getContextPath() %>/auth/register" class="transition hover:text-white">List Your Vehicle</a></li>
                    <li><a href="<%= request.getContextPath() %>/auth/login" class="transition hover:text-white">Login</a></li>
                    <li><a href="#" class="transition hover:text-white">Help Center</a></li>
                    <li><a href="#" class="transition hover:text-white">Contact</a></li>
                </ul>
            </div>

            <!-- Services -->
            <div>
                <h3 class="text-lg font-semibold text-white">Services</h3>
                <ul class="mt-4 space-y-2 text-sm text-red-100">
                    <li>Vehicle Listing for Owners</li>
                    <li>Smart Ride Discovery</li>
                    <li>Secure Digital Payments</li>
                    <li>Booking Request Management</li>
                    <li>Verified Profiles & Reviews</li>
                    <li>24/7 Ride Support</li>
                </ul>
            </div>

            <!-- Contact + Newsletter -->
            <div>
                <h3 class="text-lg font-semibold text-white">Contact Us</h3>

                <ul class="mt-4 space-y-3 text-sm text-red-100">
                    <li class="flex items-center gap-2">
                        <svg class="h-4 w-4 text-white" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
                            <path stroke-linecap="round" stroke-linejoin="round" d="M12 22s7-4.35 7-11a7 7 0 10-14 0c0 6.65 7 11 7 11z"></path>
                            <circle cx="12" cy="11" r="2.5"></circle>
                        </svg>
                        Kathmandu, Nepal
                    </li>
                    <li class="flex items-center gap-2">
                        <svg class="h-4 w-4 text-white" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
                            <path stroke-linecap="round" stroke-linejoin="round" d="M22 16.92v3a2 2 0 01-2.18 2 19.79 19.79 0 01-8.63-3.07 19.5 19.5 0 01-6-6A19.79 19.79 0 012.18 4.18 2 2 0 014.17 2h3a2 2 0 012 1.72c.12.89.33 1.76.63 2.6a2 2 0 01-.45 2.11L8.1 9.91a16 16 0 006 6l1.48-1.28a2 2 0 012.11-.45c.84.3 1.71.51 2.6.63A2 2 0 0122 16.92z"></path>
                        </svg>
                        +977 123-456-7890
                    </li>
                    <li class="flex items-center gap-2">
                        <svg class="h-4 w-4 text-white" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
                            <path stroke-linecap="round" stroke-linejoin="round" d="M4 4h16v16H4z"></path>
                            <path stroke-linecap="round" stroke-linejoin="round" d="M4 7l8 6 8-6"></path>
                        </svg>
                        support@sajharide.com
                    </li>
                </ul>

                <!-- Newsletter -->
                <div class="mt-6">
                    <h4 class="text-md font-semibold text-white">Newsletter</h4>
                    <div class="mt-3 flex">
                        <input
                                type="email"
                                placeholder="Your email"
                                class="w-full rounded-l-lg border border-white/40 bg-white/95 px-4 py-2 text-sm text-slate-800 placeholder:text-slate-500 focus:outline-none focus:ring-2 focus:ring-white/60"
                        />
                        <button class="rounded-r-lg bg-white px-4 py-2 text-sm font-semibold text-red-800 transition hover:bg-red-100">
                            Subscribe
                        </button>
                    </div>
                </div>
            </div>

        </div>
    </div>

    <!-- Bottom Bar -->
    <div class="border-t border-white/20 bg-red-800/70">
        <div class="mx-auto flex max-w-[1200px] flex-col items-center justify-between gap-3 px-6 py-4 text-sm text-red-100 md:flex-row">
            <p>&copy; 2026 SajhaRide. All rights reserved.</p>
            <div class="flex gap-4">
                <a href="#" class="transition hover:text-white">Help</a>
                <a href="#" class="transition hover:text-white">Support</a>
                <a href="#" class="transition hover:text-white">Safety Guide</a>
            </div>
        </div>
    </div>

</footer>
