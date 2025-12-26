// File: lib/pages/messages/chat_detail_page.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/message_data.dart';
import 'dart:async';
import 'dart:math';

class ChatDetailPage extends StatefulWidget {
  final String userName;
  final String userAvatar;
  final String userId;

  const ChatDetailPage({
    super.key,
    required this.userName,
    required this.userAvatar,
    required this.userId,
  });

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late List<ChatMessage> _messages;
  
  bool _isTyping = false; // <-- TAMBAHKAN STATE INI

  final Random _random = Random();
  final List<String> _autoReplies = [
    "Baik Pak, pesanan Anda sedang saya antarkan.",
    "Siap, saya sudah di jalan. Mohon ditunggu.",
    "Saya sudah berada di coffee shop, mengambil pesanan Anda.",
    "OK, terima kasih atas konfirmasinya.",
    "5 menit lagi saya sampai di lokasi. Ditunggu ya!",
    "Pesanan Anda sudah siap, segera meluncur!"
  ];

  @override
  void initState() {
    super.initState();
    _messages = List.from(getChatHistory(widget.userName));
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;

    final newMessage = ChatMessage(
      text: _controller.text,
      timestamp: DateTime.now(),
      isSender: true,
    );

    setState(() {
      _messages.add(newMessage);
      _isTyping = true; // <-- TAMPILKAN INDIKATOR TYPING
    });

    _controller.clear();
    _scrollToBottom(); 

    // LOGIKA AUTO-REPLY
    Timer(Duration(milliseconds: 1500 + _random.nextInt(1000)), () {
      final replyText = _autoReplies[_random.nextInt(_autoReplies.length)];

      final replyMessage = ChatMessage(
        text: replyText,
        timestamp: DateTime.now(),
        isSender: false,
      );

      if (mounted) {
        setState(() {
          _isTyping = false; // <-- SEMBUNYIKAN INDIKATOR TYPING
          _messages.add(replyMessage);
        });
        _scrollToBottom();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          // Daftar Chat
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                // ... (Logika timestamp tidak berubah) ...
                final message = _messages[index];
                final isLast = index == _messages.length - 1;
                final isFirst = index == 0;

                bool showTimestamp = true;
                if (!isFirst) {
                  final prevMessage = _messages[index - 1];
                  final difference =
                      message.timestamp.difference(prevMessage.timestamp);
                  if (difference.inMinutes < 5 &&
                      message.isSender == prevMessage.isSender) {
                    showTimestamp = false;
                  }
                }

                String timeString =
                    DateFormat('HH:mm').format(message.timestamp);

                return _buildMessageBubble(
                  message: message,
                  showTimestamp: showTimestamp || isLast,
                  timeString: timeString,
                );
              },
            ),
          ),
          
          // --- TAMBAHKAN WIDGET INI ---
          _buildTypingIndicator(),
          // ---------------------------
          
          // Input Chat
          _buildChatInput(),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    // ... (Fungsi _buildAppBar tidak berubah)
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      shadowColor: Colors.grey.shade200,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
      title: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage(widget.userAvatar),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.userName,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                widget.userId,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.more_vert, color: Colors.black),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildMessageBubble(
      {required ChatMessage message,
      required bool showTimestamp,
      required String timeString}) {
    // ... (Fungsi _buildMessageBubble tidak berubah)
    final align =
        message.isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final color =
        message.isSender ? const Color(0xFF4B3B47) : const Color(0xFFFDEFE7);
    final textColor = message.isSender ? Colors.white : Colors.black87;
    final borderRadius = BorderRadius.circular(message.isSender ? 12 : 16);

    return Column(
      crossAxisAlignment: align,
      children: [
        Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          margin: const EdgeInsets.only(bottom: 4),
          decoration: BoxDecoration(
            color: color,
            borderRadius: borderRadius,
          ),
          child: Text(
            message.text,
            style: TextStyle(color: textColor, fontSize: 15, height: 1.3),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0, left: 8, right: 8, top: 2),
          child: Text(
            timeString,
            style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
          ),
        )
      ],
    );
  }
  
  // --- TAMBAHKAN FUNGSI BARU INI ---
  Widget _buildTypingIndicator() {
    // Gunakan AnimatedCrossFade untuk animasi muncul/hilang
    return AnimatedCrossFade(
      duration: const Duration(milliseconds: 300),
      // Tampilkan jika _isTyping true, jika false tampilkan container kosong
      crossFadeState:
          _isTyping ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      firstChild: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage: AssetImage(widget.userAvatar),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFFDEFE7), // Warna bubble penerima
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Text(
                "Typing...",
                style: TextStyle(
                  color: Colors.black54,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ),
      secondChild: const SizedBox.shrink(), // Widget kosong
    );
  }
  // --------------------------------

  Widget _buildChatInput() {
    // ... (Fungsi _buildChatInput tidak berubah)
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                onSubmitted: (_) => _sendMessage(),
                decoration: InputDecoration(
                  hintText: 'Type message...',
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                ),
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: _sendMessage,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: Color(0xFF4B3B47),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.send, color: Colors.white, size: 24),
              ),
            ),
          ],
        ),
      ),
    );
  }
}