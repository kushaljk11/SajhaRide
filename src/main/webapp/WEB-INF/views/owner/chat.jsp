<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.riderental.myriderental.model.User" %>
<%@ page import="java.util.List" %>
<% 
    User loggedInUser = (User) session.getAttribute("loggedInUser");
    List<User> contacts = (List<User>) request.getAttribute("contacts");
    Integer activeUserIdParam = (Integer) request.getAttribute("activeUserId");
    int activeUserId = activeUserIdParam != null ? activeUserIdParam : (contacts != null && !contacts.isEmpty() ? contacts.get(0).getUserId() : -1);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chat | Owner Dashboard</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        .chat-container { display: flex; height: calc(100vh - 0px); }
        .conversations { width: 320px; background: #f7f8fa; border-right: 1px solid #ececec; display: flex; flex-direction: column; overflow: hidden; }
        .conversations .search { padding: 24px 16px 12px 16px; }
        .conversations .search input { width: 100%; padding: 8px 12px; border-radius: 6px; border: 1px solid #e0e0e0; font-size: 1em; }
        .conversations-list { flex: 1; overflow-y: auto; }
        .conversation { display: flex; align-items: center; padding: 14px 16px; cursor: pointer; border-bottom: 1px solid #ececec; background: #f7f8fa; transition: background 0.2s; text-decoration: none; color: inherit; }
        .conversation.active, .conversation:hover { background: #eaf0ff; }
        .conversation .avatar { width: 44px; height: 44px; border-radius: 50%; background: #dbeafe; margin-right: 14px; object-fit: cover; }
        .conversation .info { flex: 1; }
        .conversation .info .name { font-weight: 500; font-size: 1.08em; }
        .chat-section { flex: 1; display: flex; flex-direction: column; background: #fafbfc; }
        .chat-header { display: flex; align-items: center; padding: 24px 32px 16px 32px; border-bottom: 1px solid #ececec; background: #fff; }
        .chat-header .user-info { flex: 1; }
        .chat-header .user-info .name { font-weight: 600; font-size: 1.15em; }
        .chat-body { flex: 1; padding: 32px 32px 16px 32px; overflow-y: auto; display: flex; flex-direction: column; }
        .message-row { display: flex; margin-bottom: 18px; }
        .message-row.self { justify-content: flex-end; }
        .message-bubble { max-width: 60%; padding: 14px 18px; border-radius: 16px; font-size: 1.05em; background: #fff; color: #222; box-shadow: 0 1px 2px rgba(0, 0, 0, 0.03); }
        .message-row.self .message-bubble { background: #991b1b; color: #fff; }
        .chat-footer { padding: 18px 32px; background: #fff; border-top: 1px solid #ececec; display: flex; align-items: center; gap: 12px; }
        .chat-footer input[type="text"] { flex: 1; padding: 12px 16px; border-radius: 8px; border: 1px solid #e0e0e0; font-size: 1.05em; }
        .chat-footer button { background: #991b1b; color: #fff; border: none; border-radius: 50%; width: 44px; height: 44px; font-size: 1.3em; cursor: pointer; display: flex; align-items: center; justify-content: center; transition: background 0.2s; }
        .chat-footer button:hover { background: #7f1515; }
    </style>
</head>
<body class="bg-gray-50">
    <div class="flex h-screen overflow-hidden">
        <jsp:include page="components/sidebar.jsp" />

        <div class="chat-container flex-1">
            <div class="conversations">
                <div class="search">
                    <input type="text" placeholder="Search conversations...">
                </div>
                <div class="conversations-list">
                    <% if (contacts == null || contacts.isEmpty()) { %>
                        <div class="p-4 text-gray-500 text-sm text-center">No active conversations. Book a vehicle to start chatting!</div>
                    <% } else {
                        User activeContact = null;
                        for (User contact : contacts) { 
                            boolean isActive = contact.getUserId() == activeUserId;
                            if (isActive) activeContact = contact;
                            String imgPath = contact.getProfileImagePath() != null ? contact.getProfileImagePath() : "images/default-avatar.png";
                            if (!imgPath.startsWith("http")) imgPath = request.getContextPath() + "/" + imgPath.replace("\\", "/");
                    %>
                    <a href="?userId=<%= contact.getUserId() %>" class="conversation <%= isActive ? "active" : "" %>">
                        <img class="avatar" src="<%= imgPath %>" alt="<%= contact.getFullName() %>">
                        <div class="info">
                            <div class="name"><%= contact.getFullName() %></div>
                        </div>
                    </a>
                    <% } %>
                </div>
            </div>

            <div class="chat-section">
                <% if (activeContact != null) { %>
                <div class="chat-header">
                    <div class="user-info">
                        <div class="name"><%= activeContact.getFullName() %></div>
                    </div>
                </div>
                <div class="chat-body" id="chatBody">
                    <!-- Messages loaded via AJAX -->
                </div>
                <div class="chat-footer">
                    <input type="hidden" id="receiverId" value="<%= activeContact.getUserId() %>">
                    <input type="text" id="chatInput" placeholder="Type your message...">
                    <button id="chatSendBtn" title="Send">&#9658;</button>
                </div>
                <% } else { %>
                <div class="flex-1 flex items-center justify-center flex-col text-gray-500">
                    <svg class="w-16 h-16 mb-4 text-gray-300" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 12h.01M12 12h.01M16 12h.01M21 12c0 4.418-4.03 8-9 8a9.863 9.863 0 01-4.255-.949L3 20l1.395-3.72C3.512 15.042 3 13.574 3 12c0-4.418 4.03-8 9-8s9 3.582 9 8z"></path></svg>
                    <p class="text-lg">Select a conversation to start chatting</p>
                </div>
                <% } } %>
            </div>
        </div>
    </div>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const input = document.getElementById('chatInput');
            const btn = document.getElementById('chatSendBtn');
            const chatBody = document.getElementById('chatBody');
            const receiverIdInput = document.getElementById('receiverId');
            
            if (!receiverIdInput) return; // No active chat
            const receiverId = receiverIdInput.value;
            let lastMessageCount = 0;

            function loadMessages() {
                fetch('<%= request.getContextPath() %>/api/chat/messages/' + receiverId)
                    .then(response => response.json())
                    .then(data => {
                        if (data.length > lastMessageCount) {
                            chatBody.innerHTML = '';
                            data.forEach(msg => {
                                const isSelf = msg.senderId === <%= loggedInUser.getUserId() %>;
                                const row = document.createElement('div');
                                row.className = 'message-row ' + (isSelf ? 'self' : '');
                                row.innerHTML = '<div class="message-bubble">' + msg.content + '</div>';
                                chatBody.appendChild(row);
                            });
                            chatBody.scrollTop = chatBody.scrollHeight;
                            lastMessageCount = data.length;
                        }
                    })
                    .catch(error => console.error("Error loading messages:", error));
            }

            function sendMessage() {
                const text = input.value.trim();
                if(text) {
                    input.value = '';
                    fetch('<%= request.getContextPath() %>/api/chat/send', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify({
                            receiverId: parseInt(receiverId),
                            content: text
                        })
                    }).then(() => loadMessages());
                }
            }

            btn.addEventListener('click', sendMessage);
            input.addEventListener('keypress', function(e) {
                if(e.key === 'Enter') sendMessage();
            });

            // Initial load and poll every 3 seconds
            loadMessages();
            setInterval(loadMessages, 3000);
        });
    </script>
</body>
</html>
