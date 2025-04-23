import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';

class HelpSupportPage extends StatelessWidget {
  final List<Map<String, String>> faqs = [
    {
      "question": "How do I reset my password?",
      "answer": "Go to Settings > Account > Reset Password and follow the instructions. You'll receive an email with a link to create a new password."
    },
    {
      "question": "How do I report a bug?",
      "answer": "You can report bugs directly through the app by going to Help > Report an Issue, or use the contact methods below. Please include details about your device and what you were doing when the issue occurred."
    },
    {
      "question": "Where can I learn how to use this app?",
      "answer": "We have comprehensive video tutorials available below. You can also visit our knowledge base at help.example.com for detailed guides."
    },
    {
      "question": "Is my data secure?",
      "answer": "Yes, we use industry-standard encryption to protect all your data. You can read more about our security practices in our Privacy Policy."
    },
  ];

  final String supportEmail = "support@example.com";
  final String supportPhone = "+60123456789";
  final String knowledgeBaseUrl = "https://help.example.com";

  // Single declaration of videoTutorials list
  final List<Map<String, dynamic>> videoTutorials = [
    {
      "title": "Flutter Setup Guide",
      "description": "Official tutorial for setting up Flutter development environment",
      "duration": "10:15",
      "url": "https://youtu.be/1ukSR1GRtMU?si=4PJ8L9XcM1W0zQ9J",
      "icon": Icons.video_library,
      "color": Colors.redAccent,
    },
    {
      "title": "Flutter Widgets Explained",
      "description": "Learn about basic Flutter widgets and how to use them",
      "duration": "15:30",
      "url": "https://youtu.be/b_sQ9bMltGU?si=5J6Z8Y7XcM1W0zQ9J",
      "icon": Icons.widgets,
      "color": Colors.blueAccent,
    },
    {
      "title": "State Management in Flutter",
      "description": "Introduction to state management solutions",
      "duration": "20:45",
      "url": "https://youtu.be/d_m5csmrf7I?si=6K7L9Y8XcM1W0zQ9J",
      "icon": Icons.stacked_line_chart,
      "color": Colors.purpleAccent,
    },
  ];

  void _launchUrl(String url) async {
    Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade900,
      appBar: AppBar(
        title: Text(
          "Help & Support",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.teal.shade900,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              // Implement search functionality
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Card
            _buildSearchCard(context),
            const SizedBox(height: 24),

            // FAQs Section
            _buildSectionHeader(
              context,
              "FAQs",
              Icons.help_outline,
              Colors.blueAccent,
            ),
            const SizedBox(height: 16),
            ...faqs.map((faq) => _buildFAQItem(faq)).toList(),
            const SizedBox(height: 24),

            // Contact Support Section
            _buildSectionHeader(
              context,
              "Contact Support",
              Icons.support_agent,
              Colors.greenAccent,
            ),
            const SizedBox(height: 16),
            _buildContactCard(context),
            const SizedBox(height: 24),

            // Video Tutorials Section
            _buildSectionHeader(
              context,
              "Learning Resources",
              Icons.school,
              Colors.purpleAccent,
            ),
            const SizedBox(height: 16),
            ...videoTutorials.map((video) => _buildVideoCard(video)).toList(),
            const SizedBox(height: 16),
            _buildKnowledgeBaseCard(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            const Icon(Icons.search, color: Colors.grey),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Search help articles...",
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildFAQItem(Map<String, String> faq) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        title: Text(
          faq["question"]!,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        iconColor: Colors.white,
        collapsedIconColor: Colors.white,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              faq["answer"]!,
              style: TextStyle(
                color: Colors.grey[400],
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blueAccent.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.email, color: Colors.blueAccent),
            ),
            title: const Text("Email Support", style: TextStyle(color: Colors.white)),
            subtitle: Text(supportEmail, style: TextStyle(color: Colors.grey[400])),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () => _launchUrl("mailto:$supportEmail"),
          ),
          Divider(height: 1, color: Colors.grey[800], indent: 72),
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.greenAccent.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.phone, color: Colors.greenAccent),
            ),
            title: const Text("Call Support", style: TextStyle(color: Colors.white)),
            subtitle: Text(supportPhone, style: TextStyle(color: Colors.grey[400])),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () => _launchUrl("tel:$supportPhone"),
          ),
          Divider(height: 1, color: Colors.grey[800], indent: 72),
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.orangeAccent.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.chat_bubble_outline, color: Colors.orangeAccent),
            ),
            title: const Text("Live Chat", style: TextStyle(color: Colors.white)),
            subtitle: Text(
              "Available 9AM-6PM (GMT+8)",
              style: TextStyle(color: Colors.grey[400]),
            ),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () {
              // Implement live chat
            },
          ),
        ],
      ),
    );
  }

  Widget _buildVideoCard(Map<String, dynamic> video) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _launchUrl(video["url"]),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: video["color"].withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(video["icon"], color: video["color"], size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      video["title"],
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      video["description"],
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      video["duration"],
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.play_arrow, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKnowledgeBaseCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _launchUrl("https://youtu.be/1ukSR1GRtMU?si=4PJ8L9XcM1W0zQ9J"),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.redAccent.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.video_library, color: Colors.redAccent, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      " Tutorial On Using App Features",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Official YouTube Guide How To Use Smart Farming App",
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "From Agritech Team",
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.play_arrow, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}