<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chat | Renter Dashboard</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        .chat-container {
            display: flex;
            height: calc(100vh - 0px);
        }
        .conversations {
            width: 320px;
            background: #f7f8fa;
            border-right: 1px solid #ececec;
            display: flex;
            flex-direction: column;
            overflow: hidden;
        }
        .conversations .search {
            padding: 24px 16px 12px 16px;
        }
        .conversations .search input {
            width: 100%;
            padding: 8px 12px;
            border-radius: 6px;
            border: 1px solid #e0e0e0;
            font-size: 1em;
        }
        .conversations-list {
            flex: 1;
            overflow-y: auto;
        }
        .conversation {
            display: flex;
            align-items: center;
            padding: 14px 16px;
            cursor: pointer;
            border-bottom: 1px solid #ececec;
            background: #f7f8fa;
            transition: background 0.2s;
        }
        .conversation.active, .conversation:hover {
            background: #eaf0ff;
        }
        .conversation .avatar {
            width: 44px;
            height: 44px;
            border-radius: 50%;
            background: #dbeafe;
            margin-right: 14px;
            object-fit: cover;
        }
        .conversation .info {
            flex: 1;
        }
        .conversation .info .name {
            font-weight: 500;
            font-size: 1.08em;
        }
        .conversation .info .last-message {
            color: #888;
            font-size: 0.97em;
            margin-top: 2px;
        }
        .conversation .time {
            color: #bbb;
            font-size: 0.85em;
            margin-left: 8px;
        }
        .chat-section {
            flex: 1;
            display: flex;
            flex-direction: column;
            background: #fafbfc;
        }
        .chat-header {
            display: flex;
            align-items: center;
            padding: 24px 32px 16px 32px;
            border-bottom: 1px solid #ececec;
            background: #fff;
        }
        .chat-header .avatar {
            width: 48px;
            height: 48px;
            border-radius: 50%;
            background: #dbeafe;
            margin-right: 16px;
            object-fit: cover;
        }
        .chat-header .user-info {
            flex: 1;
        }
        .chat-header .user-info .name {
            font-weight: 600;
            font-size: 1.15em;
        }
        .chat-header .user-info .vehicle {
            color: #991b1b;
            font-size: 0.98em;
            margin-top: 2px;
        }
        .chat-header .view-vehicle {
            background: #991b1b;
            color: #fff;
            border: none;
            border-radius: 6px;
            padding: 8px 18px;
            font-size: 1em;
            cursor: pointer;
            transition: background 0.2s;
        }
        .chat-header .view-vehicle:hover {
            background: #7f1515;
        }
        .chat-body {
            flex: 1;
            padding: 32px 32px 16px 32px;
            overflow-y: auto;
            display: flex;
            flex-direction: column;
        }
        .message-row {
            display: flex;
            margin-bottom: 18px;
        }
        .message-row.self {
            justify-content: flex-end;
        }
        .message-bubble {
            max-width: 60%;
            padding: 14px 18px;
            border-radius: 16px;
            font-size: 1.05em;
            background: #fff;
            color: #222;
            box-shadow: 0 1px 2px rgba(0,0,0,0.03);
        }
        .message-row.self .message-bubble {
            background: #991b1b;
            color: #fff;
        }
        .chat-body .status {
            text-align: center;
            margin: 18px 0;
        }
        .chat-body .status span {
            background: #fecaca;
            color: #991b1b;
            padding: 6px 16px;
            border-radius: 12px;
            font-size: 0.98em;
            font-weight: 500;
        }
        .chat-footer {
            padding: 18px 32px;
            background: #fff;
            border-top: 1px solid #ececec;
            display: flex;
            align-items: center;
            gap: 12px;
        }
        .chat-footer input[type="text"] {
            flex: 1;
            padding: 12px 16px;
            border-radius: 8px;
            border: 1px solid #e0e0e0;
            font-size: 1.05em;
        }
        .chat-footer button {
            background: #991b1b;
            color: #fff;
            border: none;
            border-radius: 50%;
            width: 44px;
            height: 44px;
            font-size: 1.3em;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: background 0.2s;
        }
        .chat-footer button:hover {
            background: #7f1515;
        }
    </style>
</head>
<body class="bg-gray-50">
<div class="flex h-screen overflow-hidden">
    <!-- Sidebar -->
    <jsp:include page="components/sidebar.jsp" />

    <!-- Main Chat Area -->
    <div class="chat-container flex-1">
        <div class="conversations">
            <div class="search">
                <input type="text" placeholder="Search conversations...">
            </div>
            <div class="conversations-list">
                <div class="conversation active">
                    <img class="avatar" src="https://randomuser.me/api/portraits/men/32.jpg" alt="Birat Karki">
                    <div class="info">
                        <div class="name">Birat Karki</div>
                        <div class="last-message">The Scorpio is ready for tomorrow.</div>
                    </div>
                    <div class="time">2m ago</div>
                </div>
                <div class="conversation">
                    <img class="avatar" src="https://randomuser.me/api/portraits/women/44.jpg" alt="Sunita Rai">
                    <div class="info">
                        <div class="name">Sunita Rai</div>
                        <div class="last-message">Thank you for the booking!</div>
                    </div>
                    <div class="time">1h ago</div>
                </div>
                <div class="conversation">
                    <img class="avatar" src="https://randomuser.me/api/portraits/men/65.jpg" alt="Rajesh Thapa">
                    <div class="info">
                        <div class="name">Rajesh Thapa</div>
                        <div class="last-message">I've shared the location pin.</div>
                    </div>
                    <div class="time">4h ago</div>
                </div>
            </div>
        </div>

        <div class="chat-section">
            <div class="chat-header">
                <img class="avatar" src="https://randomuser.me/api/portraits/men/32.jpg" alt="Birat Karki">
                <div class="user-info">
                    <div class="name">Birat Karki</div>
                    <div class="vehicle">🚙 Mahindra Scorpio 4WD</div>
                </div>
                <button class="view-vehicle">View Vehicle</button>
            </div>
            <div class="chat-body">
                <div class="message-row">
                    <div class="message-bubble">Hello! Thanks for choosing my Scorpio for your trip to Pokhara.</div>
                </div>
                <div class="message-row self">
                    <div class="message-bubble">Hi Birat, excited for the trip! Is the 4WD fully functional? We might hit some muddy trails near the lake.</div>
                </div>
                <div class="message-row">
                    <div class="message-bubble">Absolutely. I just had it serviced yesterday. Tires are also brand new all-terrains. The Scorpio is ready for tomorrow morning!</div>
                </div>
                <div class="status"><span>BOOKING CONFIRMED • JUNE 12</span></div>
                <div class="message-row self">
                    <div class="message-bubble">Perfect. I will see you at the pickup point at 7 AM then.</div>
                </div>
            </div>
            <div class="chat-footer">
                <input type="text" placeholder="Type your message...">
                <button title="Send">&#9658;</button>
            </div>
        </div>
    </div>
</div>
</body>
</html>

