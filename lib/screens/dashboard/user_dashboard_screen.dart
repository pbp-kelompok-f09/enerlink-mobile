import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../widgets/bottom_bar.dart';
import '../../styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDashboardScreenMobile extends StatefulWidget {
  const UserDashboardScreenMobile({super.key});

  @override
  State<UserDashboardScreenMobile> createState() => _UserDashboardScreenMobileState();
}

class _UserDashboardScreenMobileState extends State<UserDashboardScreenMobile> {
  final String userName = 'Hanif Mahendra';
  final String joinDate = 'November 2025';
  final double walletBalance = 10000000.00;

  final List<Map<String, dynamic>> recentActivities = [];
  final List<Map<String, dynamic>> userEvents = [
    {'title': 'Charity Run', 'location': 'GBK', 'playingDate': DateTime(2025, 12, 15)},
  ];
  final List<Map<String, dynamic>> communities = [];

  late List<Map<String, dynamic>> calendarDays;
  late String currentMonth;
  late int year;
  late int month;

  int bottomIndex = 3; // Account tab aktif untuk dashboard

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    year = now.year;
    month = now.month;
    currentMonth = DateFormat('MMMM yyyy').format(now);
    calendarDays = _generateCalendar(year, month, now);
  }

  List<Map<String, dynamic>> _generateCalendar(int y, int m, DateTime today) {
    final first = DateTime(y, m, 1);
    final startWeekday = first.weekday % 7; // Sunday=0
    final daysInMonth = DateTime(y, m + 1, 0).day;

    final list = <Map<String, dynamic>>[];
    for (int i = 0; i < startWeekday; i++) {
      list.add({'number': DateTime(y, m, 0).day - (startWeekday - i - 1), 'current_month': false, 'today': false, 'events': []});
    }
    for (int d = 1; d <= daysInMonth; d++) {
      final date = DateTime(y, m, d);
      final events = userEvents.where((e) {
        final ed = e['playingDate'] as DateTime;
        return ed.year == y && ed.month == m && ed.day == d;
      }).toList();
      list.add({'number': d, 'current_month': true, 'today': _sameDay(date, today), 'events': events});
    }
    while (list.length % 7 != 0) {
      list.add({'number': list.length % 7, 'current_month': false, 'today': false, 'events': []});
    }
    return list;
  }

  bool _sameDay(DateTime a, DateTime b) => a.year == b.year && a.month == b.month && a.day == b.day;

  void _prevMonth() {
    setState(() {
      final d = DateTime(year, month - 1);
      year = d.year;
      month = d.month;
      currentMonth = DateFormat('MMMM yyyy').format(d);
      calendarDays = _generateCalendar(year, month, DateTime.now());
    });
  }

  void _nextMonth() {
    setState(() {
      final d = DateTime(year, month + 1);
      year = d.year;
      month = d.month;
      currentMonth = DateFormat('MMMM yyyy').format(d);
      calendarDays = _generateCalendar(year, month, DateTime.now());
    });
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final itemW = (w - 16 * 2 - 6 * 6) / 7;

    return Scaffold(
      // Tanpa AppBar
      bottomNavigationBar: MobileBottomNav(
        currentIndex: bottomIndex,
        onTap: (i) {
          setState(() => bottomIndex = i);
          if (i == 0) {
            Navigator.pushReplacementNamed(context, '/'); // Home (landing)
          } else if (i == 1) {
            Navigator.pushNamed(context, '/community'); // placeholder (bisa kembali)
          } else if (i == 2) {
            Navigator.pushNamed(context, '/venues'); // placeholder (bisa kembali)
          } else if (i == 3) {
            // sudah di dashboard (Account)
          }
        },
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: EnerlinkStyles.bgGradient),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            children: [
              // Header singkat dashboard + Edit Profile
              Row(
                children: [
                  const CircleAvatar(
                    radius: 22,
                    backgroundImage: AssetImage('lib/assets/images/noProfile.jpg'), // ensure pubspec asset
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Your Dashboard', style: EnerlinkStyles.sectionTitle),
                        const SizedBox(height: 4),
                        Text('Welcome $userName • Joined $joinDate', style: const TextStyle(color: Colors.white70)),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: 'Edit Profile',
                    onPressed: () => Navigator.pushNamed(context, '/profile'),
                    icon: const Icon(Icons.edit, color: Colors.white),
                  ),
                  // Tombol logout merah (opsional di dashboard)
                  IconButton(
                    tooltip: 'Logout',
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.remove('isLoggedIn');
                      if (!mounted) return;
                      Navigator.pushNamedAndRemoveUntil(context, '/account', (r) => false);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Logged out')));
                    },
                    icon: const Icon(Icons.logout, color: Colors.redAccent),
                  ),
                ],
              ),

              const SizedBox(height: 18),
              // Wallet card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(color: Color(0xFF22C55E), shape: BoxShape.circle),
                        child: const Icon(Icons.account_balance_wallet, color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Rp ${NumberFormat('#,###.00').format(walletBalance)}',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF111827)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),
              // Recent Activity
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Recent Activity', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
                      const SizedBox(height: 8),
                      if (recentActivities.isEmpty)
                        Column(
                          children: [
                            Icon(Icons.inbox, size: 48, color: Colors.grey[400]),
                            const SizedBox(height: 6),
                            const Text('No Recent Activity', style: TextStyle(color: Colors.black54)),
                            const SizedBox(height: 10),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () {/* TODO: Explore communities */},
                                icon: const Icon(Icons.search),
                                label: const Text('Explore Communities'),
                              ),
                            ),
                          ],
                        )
                      else
                        Column(
                          children: recentActivities
                              .map((a) => ListTile(
                                    leading: const Icon(Icons.event, color: Colors.blue),
                                    title: Text(a['title'] ?? ''),
                                    subtitle: Text(a['location'] ?? ''),
                                  ))
                              .toList(),
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),
              // Scheduled Activities + Calendar
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Scheduled Activities', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(onPressed: _prevMonth, icon: const Icon(Icons.chevron_left)),
                          Text(currentMonth, style: const TextStyle(fontWeight: FontWeight.w600)),
                          IconButton(onPressed: _nextMonth, icon: const Icon(Icons.chevron_right)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      _CalendarGridMobile(calendarDays: calendarDays, itemWidth: itemW),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),
              // Your Scheduled Events
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Your Scheduled Events', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
                      const SizedBox(height: 8),
                      if (userEvents.isEmpty)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(12),
                            child: Text('No scheduled events', style: TextStyle(color: Colors.black54)),
                          ),
                        )
                      else
                        Column(
                          children: userEvents
                              .map((e) => ListTile(
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                                    leading: const Icon(Icons.event_available, color: Colors.blue),
                                    title: Text(e['title'], style: const TextStyle(color: Color(0xFF111827))),
                                    subtitle: Text(
                                      '${e['location']} • ${DateFormat('MMM d, yyyy').format(e['playingDate'])}',
                                      style: const TextStyle(color: Colors.black54),
                                    ),
                                    trailing: IconButton(onPressed: () {/* TODO: cancel */}, icon: const Icon(Icons.close, color: Colors.redAccent)),
                                  ))
                              .toList(),
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),
              // Communities + Stats
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Communities Joined', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
                      const SizedBox(height: 12),
                      if (communities.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 4),
                          child: Text('You haven\'t joined any communities yet', style: TextStyle(color: Colors.black54)),
                        )
                      else
                        ...communities.map(
                          (c) => ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                            leading: const CircleAvatar(backgroundColor: Colors.blue, child: Icon(Icons.groups, color: Colors.white)),
                            title: Text(c['name'], style: const TextStyle(color: Color(0xFF111827))),
                            subtitle: Text('${c['members']} members', style: const TextStyle(color: Colors.black54)),
                            trailing: IconButton(onPressed: () {/* TODO: leave */}, icon: const Icon(Icons.logout, color: Colors.redAccent)),
                          ),
                        ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {/* TODO: find communities */},
                          icon: const Icon(Icons.search),
                          label: const Text('Find More Communities'),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text('Stats & Achievements', style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF111827))),
                      const SizedBox(height: 8),
                      const _StatRow(label: 'Events Joined', value: '12'),
                      const Divider(height: 12),
                      const _StatRow(label: 'Communities', value: '3'),
                      const Divider(height: 12),
                      const _StatRow(label: 'Venue Check-ins', value: '10'),
                      const SizedBox(height: 8),
                      Row(
                        children: const [
                          _Badge(emoji: '🥇', bg: Color(0xFFFEF3C7)),
                          SizedBox(width: 8),
                          _Badge(emoji: '👥', bg: Color(0xFFDBEAFE)),
                          SizedBox(width: 8),
                          _Badge(emoji: '🏃', bg: Color(0xFFD1FAE5)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CalendarGridMobile extends StatelessWidget {
  final List<Map<String, dynamic>> calendarDays;
  final double itemWidth;
  const _CalendarGridMobile({required this.calendarDays, required this.itemWidth});

  @override
  Widget build(BuildContext context) {
    const headers = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

    return Column(
      children: [
        Row(
          children: headers
              .map((h) => Expanded(child: Center(child: Text(h, style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 12)))))
              .toList(),
        ),
        const SizedBox(height: 8),
        Wrap(
          runSpacing: 6,
          spacing: 6,
          children: List.generate(calendarDays.length, (i) {
            final d = calendarDays[i];
            final isCurrent = d['current_month'] == true;
            final isToday = d['today'] == true;
            final events = d['events'] as List;

            return SizedBox(
              width: itemWidth,
              height: 48,
              child: Container(
                decoration: BoxDecoration(
                  color: isToday ? Colors.blue.shade50 : Colors.white,
                  border: Border.all(color: Colors.black12),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${d['number']}', style: TextStyle(color: isCurrent ? Colors.black87 : Colors.black38, fontWeight: FontWeight.w600, fontSize: 12)),
                    if (events.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: Colors.blue.shade100, borderRadius: BorderRadius.circular(6)),
                        child: Text(events[0]['title'], style: const TextStyle(fontSize: 9, color: Colors.blue)),
                      ),
                  ],
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;
  const _StatRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label, style: const TextStyle(color: Color(0xFF111827))),
      Text(value, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2563EB))),
    ]);
  }
}

class _Badge extends StatelessWidget {
  final String emoji;
  final Color bg;
  const _Badge({required this.emoji, required this.bg});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
      child: Center(child: Text(emoji)),
    );
  }
}