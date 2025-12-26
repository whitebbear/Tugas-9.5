// File: lib/data/message_data.dart

class ChatMessage {
  final String text;
  final DateTime timestamp;
  final bool isSender;

  ChatMessage({
    required this.text,
    required this.timestamp,
    required this.isSender,
  });
}

// --- MODIFIKASI: TAMBAHKAN 'userId' ---
final List<Map<String, dynamic>> messageList = [
  {
    "name": "Sam Verdinand",
    "message": "Baik Pak, pesanan Anda sedang disiapkan.",
    "time": "2M AGO",
    "avatar": "assets/images/profile1.jpg",
    "userId": "ID 123456" // ID Unik
  },
  {
    "name": "Freddie Ronan",
    "message": "Saya sudah di depan, Pak.",
    "time": "2:00 PM",
    "avatar": "assets/images/profile1.jpg",
    "userId": "ID 789012" // ID Unik
  },
  {
    "name": "Ethan Jacoby",
    "message": "Terima kasih atas ordernya!",
    "time": "5:00 PM",
    "avatar": "assets/images/profile1.jpg",
    "userId": "ID 345678" // ID Unik
  },
  {
    "name": "Alfie Mason",
    "message": "Siap, mohon ditunggu ya.",
    "time": "3:00 AM",
    "avatar": "assets/images/profile1.jpg",
    "userId": "ID 901234" // ID Unik
  },
  {
    "name": "Archie Parker",
    "message": "OK, akan segera saya antar.",
    "time": "TODAY",
    "avatar": "assets/images/profile1.jpg",
    "userId": "ID 567890" // ID Unik
  },
  {
    "name": "Roy Leebauf",
    "message": "Your order is on my way sir.",
    "time": "YESTERDAY",
    "avatar": "assets/images/profile1.jpg",
    "userId": "ID 2445556" // ID dari screenshot
  },
];
// ------------------------------------

// Chat untuk Sam Verdinand
final List<ChatMessage> chatMessages_Sam = [
  ChatMessage(
    text: "Baik Pak, pesanan Anda sedang disiapkan.",
    timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
    isSender: false,
  ),
  ChatMessage(
    text: "Tolong pastikan tidak pakai bawang ya.",
    timestamp: DateTime.now().subtract(const Duration(minutes: 1)),
    isSender: true,
  ),
];

// ... (sisa data chat tidak berubah) ...
final List<ChatMessage> chatMessages_Freddie = [
  ChatMessage(
    text: "Saya sudah di depan, Pak. Di lobby ya.",
    timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
    isSender: false,
  ),
];

final List<ChatMessage> chatMessages_Roy = [
  ChatMessage(
    text: "Your order is on my way sir. Please wait in a minutes",
    timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
    isSender: false,
  ),
  ChatMessage(
    text: "OK Bro!",
    timestamp: DateTime.now().subtract(const Duration(minutes: 1)),
    isSender: true,
  ),
  ChatMessage(
    text: "Please call me if you already at my house",
    timestamp: DateTime.now(),
    isSender: true,
  ),
];

Map<String, List<ChatMessage>> mockChatHistories = {
  "Sam Verdinand": chatMessages_Sam,
  "Freddie Ronan": chatMessages_Freddie,
  "Ethan Jacoby": [
    ChatMessage(
        text: "Terima kasih atas ordernya!",
        timestamp: DateTime.now(),
        isSender: false)
  ],
  "Alfie Mason": [
    ChatMessage(
        text: "Siap, mohon ditunggu ya.",
        timestamp: DateTime.now(),
        isSender: false)
  ],
  "Archie Parker": [
    ChatMessage(
        text: "OK, akan segera saya antar.",
        timestamp: DateTime.now(),
        isSender: false)
  ],
  "Roy Leebauf": chatMessages_Roy,
};

List<ChatMessage> getChatHistory(String contactName) {
  return mockChatHistories[contactName] ??
      [
        ChatMessage(
            text: "Halo! Ada yang bisa saya bantu?",
            timestamp: DateTime.now(),
            isSender: false)
      ];
}