import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ass3_1/sign_in.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => SignIn(),
        transitionsBuilder: (_, animation, __, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
  final statusBarHeight = MediaQuery.of(context).padding.top;

  return Stack(
  children: [
  // 🌟 Glowing .gif background
  Positioned.fill(
  child: Image.asset(
  'assets/glow.gif',
  fit: BoxFit.cover,
  ),
  ),

  // 💡 Actual UI content
  Scaffold(
  backgroundColor: Colors.transparent, // <- important!
  floatingActionButton: FloatingActionButton(
  backgroundColor: Colors.redAccent,
  child: const Icon(Icons.logout, color: Colors.white),
  onPressed: () => _logout(context),
  ),
  body: NestedScrollView(
  headerSliverBuilder: (context, innerScrolled) => [
  SliverAppBar(
  expandedHeight: statusBarHeight + 350,
  pinned: true,
  elevation: innerScrolled ? 4 : 0,
  backgroundColor: Colors.teal.shade900.withOpacity(0.8), // translucent
  flexibleSpace: const FlexibleSpaceBar(
  collapseMode: CollapseMode.parallax,
  background: _ProfileHeader(),
  ),
  ),
  ],
  body: ListView(
  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
  children: const [
  _SectionCard(
  title: 'ABOUT ME',
  child: Text(
  'IoT and mobile developer with expertise in Flutter and embedded systems. '
  'Passionate about creating scalable, efficient technology that bridges '
  'hardware with modern user interfaces.',
  style: TextStyle(color: Colors.white70, height: 1.5),
  ),
  ),
  SizedBox(height: 16),
  _SectionCard(
  title: 'EDUCATION',
  child: _EducationItem(
  institution: 'KKTM Petaling Jaya',
  degree: 'Diploma in IoT Engineering',
  period: '2023 - 2025',
  ),
  ),
  SizedBox(height: 16),
  _SectionCard(
  title: 'SKILLS',
  child: Wrap(
  spacing: 8,
  runSpacing: 8,
  children: [
  _SkillChip('Flutter'),
  _SkillChip('Firebase'),
  _SkillChip('Dart'),
  _SkillChip('Python'),
  _SkillChip('MQTT'),
  _SkillChip('ESP32'),
  _SkillChip('GitHub'),
  ],
  ),
  ),
  ],
  ),
  ),
  ),
  ],
  );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    return Container(
      height: 350,
      padding: EdgeInsets.only(top: topPadding + 16, left: 16, right: 16, bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.teal.shade900.withOpacity(0.9),
            Colors.teal.shade800.withOpacity(0.7),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 58,
            backgroundColor: Colors.white24,
            child: const CircleAvatar(
              radius: 54,
              backgroundImage: AssetImage('assets/profile.png'),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Abqari Khair Bin Ruslan',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.tealAccent,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'IoT Engineer',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 16),
          // ← UPDATED: use Row for clarity
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                _HeaderInfoItem(icon: Icons.location_on, text: 'Kuantan'),
                _HeaderInfoItem(icon: Icons.school, text: 'KKTM PJ'),
                _HeaderInfoItem(icon: Icons.class_, text: '4A'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderInfoItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _HeaderInfoItem({Key? key, required this.icon, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.tealAccent),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SectionCard({Key? key, required this.title, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.tealAccent,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Divider(color: Colors.white10, height: 16),
            child,
          ],
        ),
      ),
    );
  }
}

class _EducationItem extends StatelessWidget {
  final String institution;
  final String degree;
  final String period;

  const _EducationItem(
      {Key? key,
        required this.institution,
        required this.degree,
        required this.period})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(institution,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(degree, style: const TextStyle(color: Colors.white70)),
        const SizedBox(height: 2),
        Text(period, style: const TextStyle(color: Colors.white54, fontSize: 12)),
      ],
    );
  }
}

class _SkillChip extends StatelessWidget {
  final String skill;

  const _SkillChip(this.skill, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(skill,
          style: const TextStyle(color: Colors.black87, fontSize: 12)),
      backgroundColor: Colors.tealAccent,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
    );
  }
}
