import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({Key? key}) : super(key: key);

  // Warna yang digunakan untuk dark mode agar mirip screenshot
  static const Color _darkBackground =
      Color(0xFF3B2A33); // deep purple/burgundy
  static const Color _darkTextPrimary = Color(
      0xFF0B0B0B); // slightly dark for headings (screenshot shows strong heading)
  static const Color _darkTextSecondary =
      Color(0xFFB8AEB3); // muted gray for body text
  static const Color _dotTeal =
      Color(0xFF11BFAF); // teal dot for new notifications
  static const Color _dividerColor =
      Color(0xFFFFFFFF); // white thin divider like screenshot

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final bool isDark = brightness == Brightness.dark;

    final backgroundColor = isDark ? _darkBackground : Colors.white;
    final appBarBackground = Colors.white;
    final titleColor = isDark ? Colors.black : Colors.black;
    final timeColor = isDark ? const Color(0xFF9E9E9E) : Colors.grey;
    final descriptionColor = isDark ? _darkTextSecondary : Colors.grey;
    final headingColor = isDark ? _darkTextPrimary : Colors.black;
    final divider = Divider(
      color: isDark ? _dividerColor.withOpacity(0.9) : const Color(0xFFEAEAEA),
      thickness: 1,
      height: 28,
    );

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: appBarBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.person_outline, color: Colors.black),
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        children: [
          _buildNotificationItem(
            headingColor,
            descriptionColor,
            timeColor,
            title: "Apply Success",
            time: "10h ago",
            description:
                "You has apply an job in Queenify Group as UI Designer",
            isNew: true,
            divider: divider,
          ),
          _buildNotificationItem(
            headingColor,
            descriptionColor,
            timeColor,
            title: "Interview Calls",
            time: "9h ago",
            description: "Congratulations! You have interview calls",
            isNew: true,
            divider: divider,
          ),
          _buildNotificationItem(
            headingColor,
            descriptionColor,
            timeColor,
            title: "Apply Success",
            time: "8h ago",
            description:
                "You has apply an job in Queenify Group as UI Designer",
            isNew: false,
            divider: divider,
          ),
          _buildNotificationItem(
            headingColor,
            descriptionColor,
            timeColor,
            title: "Complete your profile",
            time: "4h ago",
            description:
                "Please verify your profile information to continue using this app",
            isNew: false,
            divider: divider,
          ),
          _buildNotificationItem(
            headingColor,
            descriptionColor,
            timeColor,
            title: "Apply Success",
            time: "10h ago",
            description:
                "You has apply an job in Queenify Group as UI Designer",
            isNew: false,
            divider: divider,
          ),
          _buildNotificationItem(
            headingColor,
            descriptionColor,
            timeColor,
            title: "Interview Calls",
            time: "9h ago",
            description: "Congratulations! You have interview calls",
            isNew: false,
            divider: divider,
          ),
          _buildNotificationItem(
            headingColor,
            descriptionColor,
            timeColor,
            title: "Apply Success",
            time: "8h ago",
            description:
                "You has apply an job in Queenify Group as UI Designer",
            isNew: false,
            divider: divider,
          ),
          _buildNotificationItem(
            headingColor,
            descriptionColor,
            timeColor,
            title: "Complete your profile",
            time: "4h ago",
            description:
                "Please verify your profile information to continue using this app",
            isNew: false,
            divider: divider,
          ),
          // Beri padding bawah agar footer tidak menempel
          const SizedBox(height: 18),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(
    Color headingColor,
    Color descriptionColor,
    Color timeColor, {
    required String title,
    required String time,
    required String description,
    required bool isNew,
    required Widget divider,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // dot / spacer
              if (isNew)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: _dotTeal,
                      shape: BoxShape.circle,
                    ),
                  ),
                )
              else
                const SizedBox(width: 10),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // title and time
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            title,
                            style: TextStyle(
                              color: headingColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Text(
                          time,
                          style: TextStyle(
                            color: timeColor,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: TextStyle(
                        color: descriptionColor,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Divider mirip screenshot (thin white line in dark)
        divider,
      ],
    );
  }
}
