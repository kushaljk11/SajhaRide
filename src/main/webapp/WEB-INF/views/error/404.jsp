<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Page Not Found | SajhaRide</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="min-h-screen bg-gray-50 text-gray-900">
    <div class="min-h-screen flex items-center justify-center px-6 py-12">
        <div class="w-full max-w-2xl rounded-3xl border border-red-100 bg-white p-8 shadow-[0_10px_40px_rgba(153,27,27,0.12)] sm:p-12">
            <div class="flex flex-col gap-6 sm:flex-row sm:items-center sm:justify-between">
                <div>
                    <p class="text-xs font-semibold uppercase tracking-[0.2em] text-red-700">SajhaRide</p>
                    <h1 class="mt-3 text-4xl font-semibold text-gray-900 sm:text-5xl">404</h1>
                    <p class="mt-3 text-lg font-semibold text-red-800">Page not found</p>
                    <p class="mt-2 text-sm text-gray-600">
                        The page you are looking for does not exist or has been moved.
                    </p>
                </div>
                <div class="rounded-2xl bg-red-50 px-6 py-5 text-center">
                    <p class="text-sm font-semibold text-red-700">Need help?</p>
                    <p class="mt-1 text-xs text-red-600">Try heading back to the dashboard.</p>
                </div>
            </div>

            <div class="mt-8 flex flex-col gap-3 sm:flex-row">
                <a
                    href="${pageContext.request.contextPath}/"
                    class="inline-flex w-full items-center justify-center rounded-xl bg-red-800 px-5 py-3 text-sm font-semibold text-white transition hover:bg-red-900 sm:w-auto"
                >
                    Go to Home
                </a>
                <a
                    href="${pageContext.request.contextPath}/login"
                    class="inline-flex w-full items-center justify-center rounded-xl border border-red-200 bg-white px-5 py-3 text-sm font-semibold text-red-800 transition hover:bg-red-50 sm:w-auto"
                >
                    Login
                </a>
            </div>
        </div>
    </div>
</body>
</html>
