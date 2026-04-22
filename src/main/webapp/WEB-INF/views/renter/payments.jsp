<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.riderental.myriderental.model.User" %>
<%
    User paymentUser = (User) session.getAttribute("loggedInUser");
    String firstName = "Rider";
    if (paymentUser != null && paymentUser.getFullName() != null && !paymentUser.getFullName().isBlank()) {
        String[] nameParts = paymentUser.getFullName().trim().split("\\s+");
        firstName = nameParts[0];
    }
%>
<html>
<head>
    <title>Payments | SajhaRide</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
</head>
<body class="h-screen overflow-hidden bg-[#f5f6fa] text-gray-900">
<div class="flex h-full">
    <%@ include file="/WEB-INF/views/renter/components/sidebar.jsp" %>

    <div class="flex min-w-0 flex-1 flex-col">
        <%@ include file="/WEB-INF/views/renter/components/topbar.jsp" %>

        <main class="flex-1 overflow-y-auto p-4 sm:p-6 lg:p-8">
            <section class="rounded-3xl border border-red-100 bg-white p-5 shadow-sm sm:p-7">
                <h1 class="text-2xl font-semibold text-gray-900 sm:text-4xl">Payment Center</h1>
                <p class="mt-2 max-w-3xl text-sm leading-6 text-gray-600 sm:text-base">Welcome back, <span class="font-semibold text-red-800"><%= firstName %></span>. Track your recent transactions, monitor pending charges, and manage payment details from one clean dashboard.</p>
                <div class="mt-5 grid gap-3 sm:grid-cols-2 xl:grid-cols-4">
                    <article class="rounded-2xl border border-red-100 bg-red-50 p-4">
                        <p class="text-xs font-semibold uppercase tracking-wide text-red-700">Total Spent</p>
                        <p class="mt-2 text-2xl font-bold text-red-900">Rs. 18,450</p>
                        <p class="mt-1 text-xs text-red-700/80">Across 7 bookings</p>
                    </article>
                    <article class="rounded-2xl border border-gray-200 bg-white p-4">
                        <p class="text-xs font-semibold uppercase tracking-wide text-gray-500">This Month</p>
                        <p class="mt-2 text-2xl font-bold text-gray-900">Rs. 6,700</p>
                        <p class="mt-1 text-xs text-gray-500">Apr 01 - Apr 20</p>
                    </article>
                    <article class="rounded-2xl border border-gray-200 bg-white p-4">
                        <p class="text-xs font-semibold uppercase tracking-wide text-gray-500">Pending</p>
                        <p class="mt-2 text-2xl font-bold text-gray-900">Rs. 1,200</p>
                        <p class="mt-1 text-xs text-gray-500">1 unsettled transaction</p>
                    </article>
                    <article class="rounded-2xl border border-gray-200 bg-white p-4">
                        <p class="text-xs font-semibold uppercase tracking-wide text-gray-500">Refunds</p>
                        <p class="mt-2 text-2xl font-bold text-gray-900">Rs. 900</p>
                        <p class="mt-1 text-xs text-gray-500">Last 30 days</p>
                    </article>
                </div>
            </section>

            <section class="mt-6 grid gap-4 xl:grid-cols-[1.65fr_1fr]">
                <article class="rounded-2xl border border-gray-200 bg-white shadow-sm">
                    <div class="flex flex-wrap items-center justify-between gap-2 border-b border-gray-100 px-5 py-4 sm:px-6">
                        <div>
                            <h2 class="text-lg font-semibold text-gray-900">Recent Transactions</h2>
                            <p class="text-xs text-gray-500 sm:text-sm">Complete timeline of your latest payment activities</p>
                        </div>
                        <button type="button" class="rounded-lg border border-red-200 bg-red-50 px-3 py-2 text-xs font-semibold text-red-800 transition hover:bg-red-100 sm:text-sm">Download Statement</button>
                    </div>

                    <div class="overflow-x-auto">
                        <table class="min-w-full text-left text-sm">
                            <thead class="bg-gray-50 text-xs uppercase tracking-wide text-gray-500">
                            <tr>
                                <th class="px-5 py-3 font-semibold sm:px-6">Txn ID</th>
                                <th class="px-5 py-3 font-semibold sm:px-6">Booking</th>
                                <th class="px-5 py-3 font-semibold sm:px-6">Method</th>
                                <th class="px-5 py-3 font-semibold sm:px-6">Date</th>
                                <th class="px-5 py-3 font-semibold sm:px-6">Amount</th>
                                <th class="px-5 py-3 font-semibold sm:px-6">Status</th>
                            </tr>
                            </thead>
                            <tbody class="divide-y divide-gray-100">
                            <tr class="hover:bg-red-50/30">
                                <td class="px-5 py-4 font-semibold text-gray-900 sm:px-6">TXN-40921</td>
                                <td class="px-5 py-4 sm:px-6">
                                    <p class="font-semibold text-gray-900">BK-10231</p>
                                    <p class="text-xs text-gray-500">Honda Activa 6G</p>
                                </td>
                                <td class="px-5 py-4 text-gray-700 sm:px-6">eSewa</td>
                                <td class="px-5 py-4 text-gray-700 sm:px-6">Apr 20, 2026</td>
                                <td class="px-5 py-4 font-semibold text-gray-900 sm:px-6">Rs. 1,200</td>
                                <td class="px-5 py-4 sm:px-6"><span class="inline-flex rounded-full bg-red-100 px-3 py-1 text-xs font-semibold text-red-800">Pending</span></td>
                            </tr>
                            <tr class="hover:bg-red-50/30">
                                <td class="px-5 py-4 font-semibold text-gray-900 sm:px-6">TXN-40784</td>
                                <td class="px-5 py-4 sm:px-6">
                                    <p class="font-semibold text-gray-900">BK-10082</p>
                                    <p class="text-xs text-gray-500">Suzuki Swift</p>
                                </td>
                                <td class="px-5 py-4 text-gray-700 sm:px-6">Khalti</td>
                                <td class="px-5 py-4 text-gray-700 sm:px-6">Apr 10, 2026</td>
                                <td class="px-5 py-4 font-semibold text-gray-900 sm:px-6">Rs. 4,500</td>
                                <td class="px-5 py-4 sm:px-6"><span class="inline-flex rounded-full bg-red-800 px-3 py-1 text-xs font-semibold text-white">Paid</span></td>
                            </tr>
                            <tr class="hover:bg-red-50/30">
                                <td class="px-5 py-4 font-semibold text-gray-900 sm:px-6">TXN-40652</td>
                                <td class="px-5 py-4 sm:px-6">
                                    <p class="font-semibold text-gray-900">BK-10030</p>
                                    <p class="text-xs text-gray-500">Mahindra Scorpio N</p>
                                </td>
                                <td class="px-5 py-4 text-gray-700 sm:px-6">Card</td>
                                <td class="px-5 py-4 text-gray-700 sm:px-6">Apr 04, 2026</td>
                                <td class="px-5 py-4 font-semibold text-gray-900 sm:px-6">Rs. 5,000</td>
                                <td class="px-5 py-4 sm:px-6"><span class="inline-flex rounded-full bg-red-800 px-3 py-1 text-xs font-semibold text-white">Paid</span></td>
                            </tr>
                            <tr class="hover:bg-red-50/30">
                                <td class="px-5 py-4 font-semibold text-gray-900 sm:px-6">TXN-40511</td>
                                <td class="px-5 py-4 sm:px-6">
                                    <p class="font-semibold text-gray-900">BK-09980</p>
                                    <p class="text-xs text-gray-500">Royal Enfield Classic</p>
                                </td>
                                <td class="px-5 py-4 text-gray-700 sm:px-6">Cash</td>
                                <td class="px-5 py-4 text-gray-700 sm:px-6">Mar 28, 2026</td>
                                <td class="px-5 py-4 font-semibold text-gray-900 sm:px-6">Rs. 2,500</td>
                                <td class="px-5 py-4 sm:px-6"><span class="inline-flex rounded-full bg-red-50 px-3 py-1 text-xs font-semibold text-red-700 ring-1 ring-red-100">Refunded</span></td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                </article>

                <div class="grid gap-4">
                    <article class="rounded-2xl border border-gray-200 bg-white p-5 shadow-sm">
                        <h3 class="text-lg font-semibold text-gray-900">Pay Pending Amount</h3>
                        <p class="mt-1 text-sm text-gray-600">Settle your unsettled transaction securely in a few taps.</p>
                        <div class="mt-4 rounded-xl border border-red-100 bg-red-50 p-4">
                            <p class="text-xs font-semibold uppercase tracking-wide text-red-700">Due Now</p>
                            <p class="mt-1 text-3xl font-bold text-red-900">Rs. 1,200</p>
                            <p class="text-xs text-red-700/80">For booking BK-10231</p>
                        </div>
                        <div class="mt-4 space-y-3">
                            <label class="block">
                                <span class="mb-1 block text-xs font-semibold uppercase tracking-wide text-gray-500">Payment Method</span>
                                <select class="w-full rounded-xl border border-gray-300 bg-white px-3 py-2.5 text-sm text-gray-800 focus:border-red-400 focus:outline-none focus:ring-2 focus:ring-red-100">
                                    <option>eSewa Wallet</option>
                                    <option>Khalti Wallet</option>
                                    <option>Card (Visa)</option>
                                </select>
                            </label>
                            <button type="button" class="w-full rounded-xl bg-red-800 px-4 py-2.5 text-sm font-semibold text-white transition hover:bg-red-900">Pay Rs. 1,200</button>
                        </div>
                    </article>

                    <article class="rounded-2xl border border-gray-200 bg-white p-5 shadow-sm">
                        <h3 class="text-lg font-semibold text-gray-900">Latest Invoice Details</h3>
                        <div class="mt-4 space-y-2 text-sm">
                            <div class="flex items-center justify-between"><span class="text-gray-500">Invoice No.</span><span class="font-semibold text-gray-900">INV-2026-391</span></div>
                            <div class="flex items-center justify-between"><span class="text-gray-500">Transaction</span><span class="font-semibold text-gray-900">TXN-40921</span></div>
                            <div class="flex items-center justify-between"><span class="text-gray-500">Vehicle</span><span class="font-semibold text-gray-900">Honda Activa 6G</span></div>
                            <div class="flex items-center justify-between"><span class="text-gray-500">Rental Charges</span><span class="font-semibold text-gray-900">Rs. 1,050</span></div>
                            <div class="flex items-center justify-between"><span class="text-gray-500">Service Fee</span><span class="font-semibold text-gray-900">Rs. 100</span></div>
                            <div class="flex items-center justify-between"><span class="text-gray-500">Tax</span><span class="font-semibold text-gray-900">Rs. 50</span></div>
                            <hr class="my-3 border-gray-200" />
                            <div class="flex items-center justify-between text-base"><span class="font-semibold text-gray-900">Total</span><span class="font-bold text-red-800">Rs. 1,200</span></div>
                        </div>
                        <div class="mt-4 flex gap-2">
                            <button type="button" class="flex-1 rounded-lg border border-gray-300 bg-gray-50 px-3 py-2 text-sm font-semibold text-gray-700 transition hover:bg-gray-100">View PDF</button>
                            <button type="button" class="flex-1 rounded-lg bg-red-800 px-3 py-2 text-sm font-semibold text-white transition hover:bg-red-900">Email Copy</button>
                        </div>
                    </article>
                </div>
            </section>
        </main>
    </div>
</div>
</body>
</html>
