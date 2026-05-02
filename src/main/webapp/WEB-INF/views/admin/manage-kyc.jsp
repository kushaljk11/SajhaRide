<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.riderental.myriderental.model.User" %>
<%@ page import="com.riderental.myriderental.model.KycVerification" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%
  User adminUser = (User) session.getAttribute("loggedInUser");
  List<KycVerification> pendingKycs = (List<KycVerification>) request.getAttribute("pendingKycs");
  String successMessage = (String) session.getAttribute("successMessage");
  String errorMessage = (String) session.getAttribute("errorMessage");
  if (successMessage != null) session.removeAttribute("successMessage");
  if (errorMessage != null) session.removeAttribute("errorMessage");

  DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MMM dd, yyyy HH:mm");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>KYC Management | SajhaRide Admin</title>
  <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="h-screen overflow-hidden bg-gray-50 font-sans text-gray-900">

<div class="flex h-full">
  <%@ include file="components/sidebar.jsp" %>

  <div class="flex flex-1 flex-col overflow-hidden">
    <!-- Topbar -->
    <header class="flex h-16 items-center justify-between border-b border-gray-200 bg-white px-8">
      <h1 class="text-xl font-semibold text-gray-800">KYC Verification</h1>
      <div class="flex items-center gap-4">
        <div class="flex h-10 w-10 items-center justify-center rounded-full bg-red-100 text-red-800 font-bold">
          A
        </div>
      </div>
    </header>

    <main class="flex-1 overflow-y-auto p-8">
      
      <% if (successMessage != null) { %>
      <div class="mb-4 rounded-xl border border-green-200 bg-green-50 p-4 text-sm text-green-800">
        <%= successMessage %>
      </div>
      <% } %>
      
      <% if (errorMessage != null) { %>
      <div class="mb-4 rounded-xl border border-red-200 bg-red-50 p-4 text-sm text-red-800">
        <%= errorMessage %>
      </div>
      <% } %>

      <div class="mb-6 flex items-center justify-between">
        <div>
          <h2 class="text-2xl font-bold text-gray-800">Pending Approvals</h2>
          <p class="text-sm text-gray-500 mt-1">Review renter identity documents to activate their accounts.</p>
        </div>
      </div>

      <div class="overflow-hidden rounded-2xl border border-gray-200 bg-white shadow-sm">
        <table class="min-w-full divide-y divide-gray-200">
          <thead class="bg-gray-50">
          <tr>
            <th scope="col" class="px-6 py-4 text-left text-xs font-semibold uppercase tracking-wider text-gray-500">ID</th>
            <th scope="col" class="px-6 py-4 text-left text-xs font-semibold uppercase tracking-wider text-gray-500">Renter Name</th>
            <th scope="col" class="px-6 py-4 text-left text-xs font-semibold uppercase tracking-wider text-gray-500">Document Type</th>
            <th scope="col" class="px-6 py-4 text-left text-xs font-semibold uppercase tracking-wider text-gray-500">Uploaded At</th>
            <th scope="col" class="px-6 py-4 text-right text-xs font-semibold uppercase tracking-wider text-gray-500">Actions</th>
          </tr>
          </thead>
          <tbody class="divide-y divide-gray-200 bg-white">
          <% if (pendingKycs != null && !pendingKycs.isEmpty()) { 
               for (KycVerification kyc : pendingKycs) {
          %>
          <tr class="hover:bg-gray-50 transition">
            <td class="whitespace-nowrap px-6 py-4 text-sm text-gray-900">#<%= kyc.getId() %></td>
            <td class="whitespace-nowrap px-6 py-4 text-sm font-medium text-gray-900">
              <%= kyc.getUserFullName() != null ? kyc.getUserFullName() : "User " + kyc.getUserId() %>
            </td>
            <td class="whitespace-nowrap px-6 py-4 text-sm text-gray-600">
              <span class="inline-flex rounded-full bg-blue-50 px-2 py-1 text-xs font-semibold text-blue-700">
                <%= kyc.getDocumentType() %>
              </span>
            </td>
            <td class="whitespace-nowrap px-6 py-4 text-sm text-gray-600">
              <%= kyc.getUploadedAt().format(formatter) %>
            </td>
            <td class="whitespace-nowrap px-6 py-4 text-right text-sm font-medium">
              <a href="${pageContext.request.contextPath}/document/kyc?id=<%= kyc.getId() %>" target="_blank" class="text-blue-600 hover:text-blue-900 mr-4">View Document</a>
              <button onclick="openRejectModal(<%= kyc.getId() %>)" class="text-red-600 hover:text-red-900 mr-4">Reject</button>
              <form action="${pageContext.request.contextPath}/admin/kyc" method="post" class="inline">
                <input type="hidden" name="action" value="approve">
                <input type="hidden" name="kycId" value="<%= kyc.getId() %>">
                <button type="submit" class="rounded bg-green-100 px-3 py-1 text-green-800 hover:bg-green-200 transition">Approve</button>
              </form>
            </td>
          </tr>
          <%     }
             } else { %>
          <tr>
            <td colspan="5" class="px-6 py-8 text-center text-sm text-gray-500">
              No pending KYC verifications found.
            </td>
          </tr>
          <% } %>
          </tbody>
        </table>
      </div>
    </main>
  </div>
</div>

<!-- Reject Modal -->
<div id="rejectModal" class="hidden fixed inset-0 z-50 overflow-y-auto" aria-labelledby="modal-title" role="dialog" aria-modal="true">
  <div class="flex items-end justify-center min-h-screen pt-4 px-4 pb-20 text-center sm:block sm:p-0">
    <div class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity" aria-hidden="true" onclick="closeRejectModal()"></div>
    <span class="hidden sm:inline-block sm:align-middle sm:h-screen" aria-hidden="true">&#8203;</span>
    <div class="inline-block align-bottom bg-white rounded-xl px-4 pt-5 pb-4 text-left overflow-hidden shadow-xl transform transition-all sm:my-8 sm:align-middle sm:max-w-lg sm:w-full sm:p-6">
      <form action="${pageContext.request.contextPath}/admin/kyc" method="post">
        <input type="hidden" name="action" value="reject">
        <input type="hidden" name="kycId" id="rejectKycId" value="">
        <div>
          <div class="mt-3 text-center sm:mt-0 sm:ml-4 sm:text-left">
            <h3 class="text-lg leading-6 font-medium text-gray-900" id="modal-title">
              Reject KYC Verification
            </h3>
            <div class="mt-4">
              <label for="reason" class="block text-sm font-medium text-gray-700">Reason for rejection</label>
              <textarea id="reason" name="reason" rows="3" required class="mt-1 block w-full rounded-md border border-gray-300 px-3 py-2 shadow-sm focus:border-red-800 focus:outline-none focus:ring-red-800 sm:text-sm" placeholder="E.g., Document is blurry"></textarea>
            </div>
          </div>
        </div>
        <div class="mt-5 sm:mt-4 sm:flex sm:flex-row-reverse">
          <button type="submit" class="w-full inline-flex justify-center rounded-md border border-transparent shadow-sm px-4 py-2 bg-red-600 text-base font-medium text-white hover:bg-red-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-red-500 sm:ml-3 sm:w-auto sm:text-sm">
            Reject Document
          </button>
          <button type="button" onclick="closeRejectModal()" class="mt-3 w-full inline-flex justify-center rounded-md border border-gray-300 shadow-sm px-4 py-2 bg-white text-base font-medium text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-red-500 sm:mt-0 sm:w-auto sm:text-sm">
            Cancel
          </button>
        </div>
      </form>
    </div>
  </div>
</div>

<script>
  function openRejectModal(kycId) {
    document.getElementById('rejectKycId').value = kycId;
    document.getElementById('rejectModal').classList.remove('hidden');
  }

  function closeRejectModal() {
    document.getElementById('rejectModal').classList.add('hidden');
    document.getElementById('rejectKycId').value = '';
    document.getElementById('reason').value = '';
  }
</script>

</body>
</html>
