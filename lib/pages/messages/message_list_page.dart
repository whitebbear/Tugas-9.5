// File: lib/pages/messages/message_list_page.dart

import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';
import '../../data/message_data.dart';

class MessageListPage extends StatefulWidget {
  const MessageListPage({super.key});

  @override
  State<MessageListPage> createState() => _MessageListPageState();
}

class _MessageListPageState extends State<MessageListPage> {
  @override
  Widget build(BuildContext context) {
    const Color appBarColor = Color(0xFF4B3B47);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // ... (AppBar tidak berubah) ...
        backgroundColor: appBarColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Messages List',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.profile);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Find food here...',
                hintStyle: TextStyle(color: Colors.grey.shade500),
                prefixIcon: Icon(Icons.search, color: Colors.grey.shade500),
                filled: true,
                fillColor: Colors.grey.shade200,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),

          // Message List
          Expanded(
            // --- MODIFIKASI: Tambahkan Empty State ---
            child: messageList.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.message_outlined,
                            size: 60, color: Colors.grey.shade300),
                        const SizedBox(height: 16),
                        const Text(
                          "Belum Ada Pesan",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black54),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "Riwayat obrolan Anda akan muncul di sini.",
                          style: TextStyle(color: Colors.black45),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    itemCount: messageList.length,
                    separatorBuilder: (context, index) => Divider(
                      height: 1,
                      indent: 80,
                      color: Colors.grey.shade200,
                    ),
                    itemBuilder: (context, index) {
                      final item = messageList[index];
                      return _buildMessageTile(
                        context: context,
                        name: item['name'],
                        message: item['message'],
                        time: item['time'],
                        avatar: item['avatar'],
                        userId: item['userId'], // <-- Kirim ID unik
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageTile({
    required BuildContext context,
    required String name,
    required String message,
    required String time,
    required String avatar,
    required String userId, // <-- Terima ID unik
  }) {
    return InkWell(
      onTap: () {
        // --- MODIFIKASI: Kirim 'userId' ---
        Navigator.pushNamed(
          context,
          AppRoutes.chatDetail,
          arguments: {
            'name': name,
            'avatar': avatar,
            'id': userId, // <-- Gunakan ID dari parameter
          },
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          // ... (sisa widget tile tidak berubah) ...
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundImage: AssetImage(avatar),
                ),
                Positioned(
                  bottom: 2,
                  right: 2,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Text(
              time,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}