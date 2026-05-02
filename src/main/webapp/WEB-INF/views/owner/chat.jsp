<%@ page contentType="text/html;charset=UTF-8" language="java" import="com.riderental.myriderental.model.Booking,java.util.List" %>
<%
    List<Booking> conversationBookings = (List<Booking>) request.getAttribute("conversationBookings");
    if (conversationBookings == null) conversationBookings = java.util.Collections.emptyList();
    Booking selectedBooking = (Booking) request.getAttribute("selectedBooking");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Chat | Owner Dashboard</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        .chat-container { display: flex; height: calc(100vh - 0px); }
        .conversations { width: 320px; background: #f7f8fa; border-right: 1px solid #ececec; display: flex; flex-direction: column; overflow: hidden; }
        .conversations .search { padding: 24px 16px 12px 16px; }
        .conversations .search input { width: 100%; padding: 8px 12px; border-radius: 6px; border: 1px solid #e0e0e0; }
        .conversations-list { flex: 1; overflow-y: auto; }
        .conversation { display: flex; align-items: center; padding: 14px 16px; cursor: pointer; border-bottom: 1px solid #ececec; background: #f7f8fa; transition: background 0.2s; }
        .conversation.active, .conversation:hover { background: #eaf0ff; }
        .conversation .avatar { width: 44px; height: 44px; border-radius: 50%; background: #dbeafe; margin-right: 14px; object-fit: cover; }
        .conversation .info { flex: 1; }
        .conversation .info .name { font-weight: 500; }
        .conversation .info .last-message { color: #888; font-size: 0.97em; }
        .conversation .time { color: #bbb; font-size: 0.85em; margin-left: 8px; }
        .chat-section { flex: 1; display: flex; flex-direction: column; background: #fafbfc; }
        .chat-header { display: flex; align-items: center; padding: 24px 32px 16px 32px; border-bottom: 1px solid #ececec; background: #fff; }
        .chat-header .avatar { width: 48px; height: 48px; border-radius: 50%; background: #dbeafe; margin-right: 16px; object-fit: cover; }
        .chat-header .user-info { flex: 1; }
        .chat-header .user-info .name { font-weight: 600; font-size: 1.15em; }
        .chat-header .user-info .vehicle { color: #991b1b; font-size: 0.98em; }
        .chat-header .view-vehicle { background: #991b1b; color: #fff; border: none; border-radius: 6px; padding: 8px 18px; cursor: pointer; }
        .chat-body { flex: 1; padding: 32px 32px 16px 32px; overflow-y: auto; display: flex; flex-direction: column; }
        .message-row { display: flex; margin-bottom: 18px; }
        .message-row.self { justify-content: flex-end; }
        .message-bubble { max-width: 60%; padding: 14px 18px; border-radius: 16px; background: #fff; color: #222; box-shadow: 0 1px 2px rgba(0,0,0,0.03); }
        .message-row.self .message-bubble { background: #991b1b; color: #fff; }
        .chat-body .status { text-align: center; margin: 18px 0; }
        .chat-body .status span { background: #fecaca; color: #991b1b; padding: 6px 16px; border-radius: 12px; font-weight: 500; }
        .chat-footer { padding: 18px 32px; background: #fff; border-top: 1px solid #ececec; display: flex; align-items: center; gap: 12px; }
        .chat-footer input[type="text"] { flex: 1; padding: 12px 16px; border-radius: 8px; border: 1px solid #e0e0e0; }
        .chat-footer button { background: #991b1b; color: #fff; border: none; border-radius: 50%; width: 44px; height: 44px; cursor: pointer; display: flex; align-items: center; justify-content: center; }
    </style>
</head>
<body class="bg-gray-50">
<div class="flex h-screen overflow-hidden">
    <jsp:include page="components/sidebar.jsp" />
    <div class="chat-container flex-1">
        <div class="conversations">
            <div class="search">
                <input type="text" placeholder="Search conversations..." />
            </div>
            <div class="conversations-list">
                <%
                    if (!conversationBookings.isEmpty()) {
                        for (Booking booking : conversationBookings) {
                            String renter = booking.getRenterName() == null ? "User #" + booking.getUserId() : booking.getRenterName();
                            String vehicle = booking.getVehicleName() == null ? "Vehicle #" + booking.getVehicleId() : booking.getVehicleName();
                            String status = booking.getStatus() == null ? "PENDING" : booking.getStatus();
                %>
                <div class="conversation <%= selectedBooking != null && selectedBooking.getBookingId() == booking.getBookingId() ? "active" : "" %>">
                    <img class="avatar" src="<%= request.getContextPath() %>/images/about.png" alt="<%= renter %>" />
                    <div class="info">
                        <div class="name"><%= renter %></div>
                        <div class="last-message"><%= vehicle %> • <%= status %></div>
                    </div>
                    <div class="time"><%= booking.getCreatedAt() == null ? "" : booking.getCreatedAt().toLocalDate() %></div>
                </div>
                <%
                        }
                    } else {
                %>
                <div class="p-4 text-sm text-gray-500">No recent booking conversations found.</div>
                <% } %>
            </div>
        </div>
        <div class="chat-section">
            <div class="chat-header">
                <img class="avatar" src="<%= request.getContextPath() %>/images/about.png" alt="Conversation" />
                <div class="user-info">
                    <div class="name"><%= selectedBooking != null && selectedBooking.getRenterName() != null ? selectedBooking.getRenterName() : "Select a booking conversation" %></div>
                    <div class="vehicle">🚙 <%= selectedBooking != null && selectedBooking.getVehicleName() != null ? selectedBooking.getVehicleName() : "Recent booking details" %></div>
                </div>
                <a class="view-vehicle" href="<%= request.getContextPath() %>/owner/bookings">View Bookings</a>
            </div>
            <div class="chat-body">
                <%
                    if (selectedBooking != null) {
                %>
                <div class="message-row">
                    <div class="message-bubble">Booking #<%= selectedBooking.getBookingId() %> is currently <strong><%= selectedBooking.getStatus() %></strong>.</div>
                </div>
                <div class="message-row self">
                    <div class="message-bubble">Vehicle: <%= selectedBooking.getVehicleName() == null ? "-" : selectedBooking.getVehicleName() %></div>
                </div>
                <div class="status"><span>DATABASE-DRIVEN CONVERSATION PREVIEW</span></div>
                <% } else { %>
                <div class="message-row"><div class="message-bubble">No recent bookings to display. When a booking arrives, it will show up here.</div></div>
                <% } %>
            </div>
            <div class="chat-footer">
                <input type="text" placeholder="Type your message..." disabled />
                <button title="Send" disabled>&#9658;</button>
            </div>
        </div>
    </div>
</div>
</body>
</html>

