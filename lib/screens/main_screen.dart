import 'package:flutter/material.dart';
import 'package:enerlink_mobile/widgets/bottom_navbar.dart';
import 'package:enerlink_mobile/screens/community_list.dart';
import 'package:enerlink_mobile/screens/venue_list.dart'; // From Venue branch
import 'package:enerlink_mobile/services/auth_service.dart';
import 'package:enerlink_mobile/models/user.dart';
import 'package:enerlink_mobile/screens/dashboard/user_dashboard_screen.dart'; // From Dev branch
import 'package:enerlink_mobile/models/venue.dart';
import 'package:enerlink_mobile/services/venue_service.dart';
import 'package:enerlink_mobile/screens/venue_detail.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:enerlink_mobile/screens/forum/forum_list_screen.dart';

class MainScreenMobile extends StatefulWidget {
  final int initialIndex;
  const MainScreenMobile({super.key, this.initialIndex = 0});

  @override
  State<MainScreenMobile> createState() => _MainScreenMobileState();
}

class _MainScreenMobileState extends State<MainScreenMobile> {
  late int _selectedIndex;

  // List of pages to switch between
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    _pages = [
      const HomeContent(), // Index 0: Home (The Dashboard)
      const CommunityListPage(), // Index 1: Community List
      const VenueListPage(), // Index 2: Venue List (From Venue Branch)
      const UserDashboardScreenMobile(), // Index 3: User Dashboard (From Dev Branch)
      const ForumTab(), // Index 4: Forum
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // No AppBar or Drawer anymore as requested for a cleaner, modern look
      // extendBodyBehindAppBar: _selectedIndex == 0, // No AppBar, so no need to extend body

      // This is the "Body" that changes based on bottom nav selection
      body: _pages[_selectedIndex],

      bottomNavigationBar: BottomNavbar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

// --- WIDGETS FOR PAGES ---

// 1. The Main Home Dashboard (Refactored from previous code)
class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  User? _currentUser;
  List<Venue> _featuredVenues = [];
  bool _isLoadingVenues = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
    _loadFeaturedVenues();
  }

  Future<void> _loadUser() async {
    final user = await AuthService.getCurrentUser();
    if (mounted) {
      setState(() {
        _currentUser = user;
      });
    }
  }

  Future<void> _loadFeaturedVenues() async {
    try {
      final response = await VenueService.getVenues();
      if (mounted && response.data != null) {
        setState(() {
          // Take top 5 venues for the carousel
          _featuredVenues = response.data!.take(5).toList();
          _isLoadingVenues = false;
        });
      } else {
        if (mounted) setState(() => _isLoadingVenues = false);
      }
    } catch (e) {
      // debugPrint("Error loading featured venues: $e");
      if (mounted) setState(() => _isLoadingVenues = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get display name or default
    final displayName = _currentUser?.firstName ?? _currentUser?.username ?? 'Guest';

    return Stack(
      children: [
        // 1. Background Gradient & Shapes
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF0D47A1), // Blue[900]
                Color(0xFF1565C0), // Blue[800]
                Color(0xFF1976D2), // Blue[700]
              ],
            ),
          ),
        ),
        // Decorative Circles
        Positioned(
          top: -100,
          right: -100,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withAlpha((255 * 0.1).round()),
            ),
          ),
        ),
        Positioned(
          bottom: 50,
          left: -50,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withAlpha((255 * 0.05).round()),
            ),
          ),
        ),

        // 2. Main Content
        SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // SizedBox to push content down a bit, compensating for removed AppBar
                const SizedBox(height: 30),
                
                // Welcome Text
                Text(
                  'Welcome $displayName,',
                  style: const TextStyle(color: Colors.white70, fontSize: 18),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Connect,\nPlay, Energize!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),

                const SizedBox(height: 30),

                // Search Bar
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Search feature coming soon!"),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha((255 * 0.15).round()),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withAlpha((255 * 0.2).round()),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.search, color: Colors.white70),
                          const SizedBox(width: 12),
                          Text(
                            'Find venues, communities...', 
                            style: TextStyle(
                              color: Colors.white.withAlpha(
                                (255 * 0.7).round(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Featured Venues Carousel
                if (!_isLoadingVenues && _featuredVenues.isNotEmpty) ...[
                  Text(
                    'Featured Venues',
                    style: TextStyle(
                      color: Colors.white.withAlpha((255 * 0.9).round()),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _featuredVenues.length,
                      itemBuilder: (context, index) {
                        final venue = _featuredVenues[index];
                        return _buildVenueCard(context, venue);
                      },
                    ),
                  ),
                  const SizedBox(height: 30),
                ],

                // Categories / Menu Grid
                Text(
                  'Explore',
                  style: TextStyle(
                    color: Colors.white.withAlpha((255 * 0.9).round()),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                GridView.count(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.1,
                  children: [
                    _buildFeatureCard(
                      context,
                      title: 'Communities',
                      icon: Icons.groups_rounded,
                      color1: const Color(0xFF42A5F5),
                      color2: const Color(0xFF1E88E5),
                      onTap: () {
                        // Switch to Communities Tab (Index 1)
                        final state = context
                            .findAncestorStateOfType<_MainScreenMobileState>();
                        state?._onItemTapped(1);
                      },
                    ),
                    _buildFeatureCard(
                      context,
                      title: 'Venues',
                      icon: Icons.stadium_rounded,
                      color1: const Color(0xFFFFEE58),
                      color2: const Color(0xFFFBC02D),
                      textColor: Colors.black87,
                      onTap: () {
                        // Switch to Venues Tab (Index 2)
                        final state = context
                            .findAncestorStateOfType<_MainScreenMobileState>();
                        state?._onItemTapped(2);
                      },
                    ),
                    _buildFeatureCard(
                      context,
                      title: 'Events',
                      icon: Icons.emoji_events_rounded,
                      color1: const Color(0xFFFFEE58),
                      color2: const Color(0xFFFBC02D),
                      textColor: Colors.black87,
                      onTap: () {
                        // Switch to User Dashboard Tab (Index 3) where Events are shown
                        final state = context
                            .findAncestorStateOfType<_MainScreenMobileState>();
                        state?._onItemTapped(3);
                      },
                    ),
                    _buildFeatureCard(
                      context,
                      title: 'Forum',
                      icon: Icons.forum_rounded,
                      color1: const Color(0xFF42A5F5),
                      color2: const Color(0xFF1E88E5),
                      onTap: () {
                        // Switch to Forum Tab (Index 4)
                        final state = context
                            .findAncestorStateOfType<_MainScreenMobileState>();
                        state?._onItemTapped(4);
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // Bottom Banner / Activity
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha((255 * 0.1).round()),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withAlpha((255 * 0.1).round()),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha((255 * 0.2).round()),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.notifications_active,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Don\'t miss out!',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Check upcoming events near you.',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVenueCard(BuildContext context, Venue venue) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 16),
      child: GestureDetector(
        onTap: () {
           Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VenueDetailPage(venueId: venue.idVenue),
            ),
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background Image
              venue.imageUrl.isNotEmpty &&
                      (venue.imageUrl.startsWith('http://') ||
                          venue.imageUrl.startsWith('https://'))
                  ? CachedNetworkImage(
                      imageUrl: venue.imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey[300],
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.stadium, size: 50, color: Colors.grey),
                      ),
                    )
                  : Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.stadium, size: 50, color: Colors.grey),
                    ),
              
              // Gradient Overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withAlpha(180),
                    ],
                    stops: const [0.6, 1.0],
                  ),
                ),
              ),

              // Content
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      venue.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          venue.rating.toStringAsFixed(1),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            venue.address,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Rp ${venue.sessionPrice.toStringAsFixed(0)}',
                      style: const TextStyle(
                        color: Colors.greenAccent,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context,    {
    required String title,
    required IconData icon,
    required Color color1,
    required Color color2,
    Color textColor = Colors.white,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [color1, color2],
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha((255 * 0.15).round()),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha((255 * 0.2).round()),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 32, color: textColor),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 2. Placeholder Page for other tabs
class PlaceholderPage extends StatelessWidget {
  final String title;
  final IconData icon;

  const PlaceholderPage({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.white, // Ensure other pages have a clear background
      appBar: AppBar(
        title: Text(
          title,
          style: TextStyle(
            color: Colors.blue[900],
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.blue[900]),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 100, color: Colors.grey[300]),
            const SizedBox(height: 20),
            Text(
              '$title Page',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue[900],
              ),
            ),
            const SizedBox(height: 8),
            const Text('Coming Soon', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}