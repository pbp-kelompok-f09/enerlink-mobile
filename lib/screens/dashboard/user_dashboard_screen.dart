import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../styles.dart';
import '../../services/api_client.dart';
import '../main_screen.dart'; // Import for MainScreenMobileState

class UserDashboardScreenMobile extends StatefulWidget {
  const UserDashboardScreenMobile({super.key});

  @override
  State<UserDashboardScreenMobile> createState() => _UserDashboardScreenMobileState();
}

class _UserDashboardScreenMobileState extends State<UserDashboardScreenMobile> {
  String userName = '';
  String joinDate = '';
  String? avatarUrl;
  double walletBalance = 0;
  String userRole = '';

  List<Map<String, dynamic>> recentActivities = [];
  List<Map<String, dynamic>> userEvents = [];
  List<Map<String, dynamic>> communities = [];
  List<Map<String, dynamic>> bookings = [];

  late List<Map<String, dynamic>> calendarDays;
  late String currentMonth;
  late int year;
  late int month;

  bool _loading = true;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    year = now.year;
    month = now.month;
    currentMonth = DateFormat('MMMM yyyy').format(now);
    calendarDays = [];
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    if (!mounted) return;
    setState(() => _loading = true);
    
    final data = await ApiClient.getDashboardData();
    
    if (!mounted) return;
    
    if (data != null) {
      setState(() {
        userName = '${data['first_name'] ?? ''} ${data['last_name'] ?? ''}'.trim();
        if (userName.isEmpty) userName = data['username'] ?? 'User';
        userRole = data['role'] ?? '';
        joinDate = data['date_joined'] ?? '';
        
        // 🔄 CHANGED: Better avatar URL handling
        final profilePic = data['profile_picture'];
        if (profilePic != null && profilePic.toString().isNotEmpty && profilePic.toString() != 'null') {
          avatarUrl = profilePic.toString();
          print('📷 Avatar URL: $avatarUrl');
        } else {
          avatarUrl = null;
          print('📷 No avatar, using default');
        }
        
        walletBalance = (data['wallet_balance'] as num?)?.toDouble() ?? 0;
        recentActivities = List<Map<String, dynamic>>.from(data['recent_activities'] ?? []);
        userEvents = List<Map<String, dynamic>>.from(data['user_events'] ?? []);
        communities = List<Map<String, dynamic>>.from(data['communities'] ?? []);
        bookings = List<Map<String, dynamic>>.from(data['bookings'] ?? []);
        calendarDays = _generateCalendar(year, month, DateTime.now());
        _loading = false;
      });
    } else {
      setState(() => _loading = false);
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }

  List<Map<String, dynamic>> _generateCalendar(int y, int m, DateTime today) {
    final first = DateTime(y, m, 1);
    final startWeekday = first.weekday % 7;
    final daysInMonth = DateTime(y, m + 1, 0).day;

    final list = <Map<String, dynamic>>[];
    for (int i = 0; i < startWeekday; i++) {
      list.add({'number': DateTime(y, m, 0).day - (startWeekday - i - 1), 'current_month': false, 'today': false, 'events': []});
    }
    for (int d = 1; d <= daysInMonth; d++) {
      final date = DateTime(y, m, d);
      final events = userEvents.where((e) {
        final ed = DateTime.tryParse(e['playing_date']?.toString() ?? '');
        return ed != null && ed.year == y && ed.month == m && ed.day == d;
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

  Future<void> _cancelEvent(String eventId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancel Event'),
        content: const Text('Are you sure you want to cancel this event?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('No')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Yes', style: TextStyle(color: Colors.red))),
        ],
      ),
    );
    if (confirm == true) {
      final success = await ApiClient.cancelEvent(eventId);
      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Event cancelled')));
          _loadDashboardData();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to cancel event')));
        }
      }
    }
  }

  Future<void> _leaveCommunity(String communityId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Leave Community'),
        content: const Text('Are you sure you want to leave this community?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('No')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Yes', style: TextStyle(color: Colors.red))),
        ],
      ),
    );
    if (confirm == true) {
      final success = await ApiClient.leaveCommunity(communityId);
      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Left community')));
          _loadDashboardData();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to leave community')));
        }
      }
    }
  }

  // ➕ ADDED: Top up wallet dialog
  Future<void> _showTopUpDialog() async {
    final amountController = TextEditingController();
    final amounts = [50000.0, 100000.0, 200000.0, 500000.0, 1000000.0];
    
    final result = await showDialog<double>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Top Up Wallet'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: amounts.map((a) => ActionChip(
                label: Text('Rp ${NumberFormat('#,###').format(a)}'),
                onPressed: () => Navigator.pop(ctx, a),
              )).toList(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Custom Amount',
                prefixText: 'Rp ',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final amount = double.tryParse(amountController.text) ?? 0;
              Navigator.pop(ctx, amount);
            },
            child: const Text('Top Up'),
          ),
        ],
      ),
    );
    
    if (result != null && result > 0) {
      final success = await ApiClient.topUpWallet(result);
      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Wallet topped up by Rp ${NumberFormat('#,###').format(result)}')),
          );
          _loadDashboardData();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to top up wallet')),
          );
        }
      }
    }
  }

  Future<void> _logout() async {
    await ApiClient.logout();
    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/account', (r) => false);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Logged out')));
    }
  }

  // 🔄 CHANGED: Helper widget for avatar with proper fallback
  Widget _buildAvatar({double radius = 24}) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.grey[300],
      backgroundImage: _getAvatarImage(),
      onBackgroundImageError: (_, __) {
        // 🔄 CHANGED: Handle image load error silently
        print('⚠️ Failed to load avatar image');
      },
      child: avatarUrl == null ? Icon(Icons.person, size: radius, color: Colors.grey[600]) : null,
    );
  }

  // 🔄 CHANGED: Get avatar image with proper null check
  ImageProvider? _getAvatarImage() {
    if (avatarUrl != null && avatarUrl!.isNotEmpty) {
      // 🔄 CHANGED: Prepend base URL if needed
      String imageUrl = avatarUrl!;
      if (!imageUrl.startsWith('http')) {
        imageUrl = '${ApiClient.baseUrl}$imageUrl';
      }
      print('📷 Loading image from: $imageUrl');
      return NetworkImage(imageUrl);
    }
    // 🔄 CHANGED: Return asset image as fallback
    return const AssetImage('lib/assets/images/noProfile.jpg');
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final itemW = (w - 16 * 2 - 6 * 6) / 7;

    if (_loading) {
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(gradient: EnerlinkStyles.bgGradient),
          child: const Center(child: CircularProgressIndicator(color: Colors.white)),
        ),
      );
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: EnerlinkStyles.bgGradient),
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: _loadDashboardData,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              children: [
                // Header
                Row(
                  children: [
                    // 🔄 CHANGED: Use helper method for avatar
                    _buildAvatar(radius: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Your Dashboard', style: EnerlinkStyles.sectionTitle),
                          const SizedBox(height: 4),
                          Text('Welcome $userName', style: const TextStyle(color: Colors.white70)),
                        ],
                      ),
                    ),
                    if (userRole == 'AC' || userRole == 'DEV')
                    IconButton(
                      tooltip: 'Admin Panel',
                      onPressed: () => Navigator.pushNamed(context, '/admin-dashboard'),
                      icon: const Icon(Icons.admin_panel_settings, color: Colors.amber),
                    ),
                    IconButton(
                      tooltip: 'Edit Profile',
                      onPressed: () async {
                        final changed = await Navigator.pushNamed(context, '/profile');
                        if (changed == true) _loadDashboardData();
                      },
                      icon: const Icon(Icons.edit, color: Colors.white),
                    ),
                    IconButton(
                      tooltip: 'Logout',
                      onPressed: _logout,
                      icon: const Icon(Icons.logout, color: Colors.redAccent),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // 🔄 CHANGED: Wallet with Top Up button
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
                        // ➕ ADDED: Top Up button
                        ElevatedButton.icon(
                          onPressed: _showTopUpDialog,
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text('Top Up'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF22C55E),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                                  onPressed: () {
                                    final state = context
                                        .findAncestorStateOfType<MainScreenMobileState>();
                                    state?.onItemTapped(1);
                                  },
                                  icon: const Icon(Icons.search),
                                  label: const Text('Explore Communities'),
                                ),
                              ),
                            ],
                          )
                        else
                          ...recentActivities.map((a) => ListTile(
                            leading: const Icon(Icons.event, color: Colors.blue),
                            title: Text(a['title']?.toString() ?? ''),
                            subtitle: Text(a['description']?.toString() ?? ''),
                          )),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Calendar
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

                // Scheduled Events
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Your Scheduled Events', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
                        const SizedBox(height: 8),
                        if (userEvents.isEmpty)
                          const Center(child: Padding(padding: EdgeInsets.all(12), child: Text('No scheduled events', style: TextStyle(color: Colors.black54))))
                        else
                          ...userEvents.map((e) {
                            final playingDate = DateTime.tryParse(e['playing_date']?.toString() ?? '');
                            final eventId = e['id']?.toString() ?? '';
                            return ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                              leading: const Icon(Icons.event_available, color: Colors.blue),
                              title: Text(e['title']?.toString() ?? '', style: const TextStyle(color: Color(0xFF111827))),
                              subtitle: Text(
                                '${e['venue_name'] ?? ''} • ${playingDate != null ? DateFormat('MMM d, yyyy').format(playingDate) : ''}',
                                style: const TextStyle(color: Colors.black54),
                              ),
                              trailing: IconButton(
                                onPressed: () => _cancelEvent(eventId),
                                icon: const Icon(Icons.close, color: Colors.redAccent),
                              ),
                            );
                          }),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Communities
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Communities Joined', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
                        const SizedBox(height: 12),
                        if (communities.isEmpty)
                          const Padding(padding: EdgeInsets.symmetric(vertical: 4), child: Text('You haven\'t joined any communities yet', style: TextStyle(color: Colors.black54)))
                        else
                          ...communities.map((c) {
                            final communityId = c['id']?.toString() ?? '';
                            return ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                              leading: const CircleAvatar(backgroundColor: Colors.blue, child: Icon(Icons.groups, color: Colors.white)),
                              title: Text(c['name']?.toString() ?? '', style: const TextStyle(color: Color(0xFF111827))),
                              subtitle: Text('${c['member_count'] ?? 0} members', style: const TextStyle(color: Colors.black54)),
                              trailing: IconButton(
                                onPressed: () => _leaveCommunity(communityId),
                                icon: const Icon(Icons.logout, color: Colors.redAccent),
                              ),
                            );
                          }),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              final state = context
                                  .findAncestorStateOfType<MainScreenMobileState>();
                              state?.onItemTapped(1);
                            },
                            icon: const Icon(Icons.search),
                            label: const Text('Find More Communities'),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text('Stats & Achievements', style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF111827))),
                        const SizedBox(height: 8),
                        _StatRow(label: 'Events Joined', value: '${userEvents.length}'),
                        const Divider(height: 12),
                        _StatRow(label: 'Communities', value: '${communities.length}'),
                        const Divider(height: 12),
                        const _StatRow(label: 'Venue Check-ins', value: '0'),
                        const SizedBox(height: 8),
                        const Row(
                          children: [
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
          children: headers.map((h) => Expanded(child: Center(child: Text(h, style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 12))))).toList(),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${d['number']}', style: TextStyle(color: isCurrent ? Colors.black87 : Colors.black38, fontWeight: FontWeight.w600, fontSize: 12)),
                    if (events.isNotEmpty)
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(color: Colors.blue.shade100, borderRadius: BorderRadius.circular(4)),
                          child: Text(events[0]['title']?.toString() ?? '', style: const TextStyle(fontSize: 8, color: Colors.blue), overflow: TextOverflow.ellipsis),
                        ),
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