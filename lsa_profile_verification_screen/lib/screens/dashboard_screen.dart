import 'package:flutter/material.dart';
import '../widgets/app_header.dart';
import '../widgets/recent_activity_table.dart';
import '../widgets/sidebar.dart';
import '../widgets/stat_card.dart';
import 'lsa_verification_screen.dart';

/// Main production dashboard screen integrating desktop sidebar, header, metrics, and LSA verification screen.
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedNavIndex = 1; // Default to Profile Verification view for easy workflow evaluation
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<String> _pageTitles = [
    'Dashboard',
    'LSA Profile Verification',
    'Projects',
    'Settings',
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 900;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF8FAFC),
      drawer: !isDesktop
          ? Drawer(
              child: Sidebar(
                selectedIndex: _selectedNavIndex,
                onItemSelected: (index) {
                  setState(() {
                    _selectedNavIndex = index;
                  });
                  Navigator.of(context).pop();
                },
              ),
            )
          : null,
      body: Row(
        children: [
          // Sidebar (Visible on Desktop)
          if (isDesktop)
            Sidebar(
              selectedIndex: _selectedNavIndex,
              onItemSelected: (index) {
                setState(() {
                  _selectedNavIndex = index;
                });
              },
            ),

          // Main Content Area
          Expanded(
            child: Column(
              children: [
                // Top Header Bar
                AppHeader(
                  title: _pageTitles[_selectedNavIndex],
                  onMenuPressed: () {
                    _scaffoldKey.currentState?.openDrawer();
                  },
                ),

                // Dynamic Body View
                Expanded(
                  child: IndexedStack(
                    index: _selectedNavIndex,
                    children: [
                      _buildDashboardOverview(),
                      const LsaVerificationScreen(),
                      _buildProjectsView(),
                      _buildSettingsView(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Dashboard Overview tab content.
  Widget _buildDashboardOverview() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stat Cards Grid
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 700;
              return GridView.count(
                crossAxisCount: isWide ? 4 : 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: isWide ? 1.6 : 1.3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: const [
                  StatCard(
                    title: 'Total Users',
                    value: '1,284',
                    trend: '+12%',
                    isTrendPositive: true,
                    icon: Icons.people_outline_rounded,
                  ),
                  StatCard(
                    title: 'Verifications',
                    value: '3,892',
                    trend: '+18%',
                    isTrendPositive: true,
                    icon: Icons.verified_outlined,
                  ),
                  StatCard(
                    title: 'Fail-Closed Events',
                    value: '42',
                    trend: '-5%',
                    isTrendPositive: true,
                    icon: Icons.shield_outlined,
                  ),
                  StatCard(
                    title: 'Active Sessions',
                    value: '156',
                    trend: '+8%',
                    isTrendPositive: true,
                    icon: Icons.flash_on_outlined,
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 24),

          // Quick Action Banner
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'LSA Profile Verification Tool',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Run fail-closed profile validation and cryptographic trace generation.',
                      style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedNavIndex = 1;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  ),
                  child: const Text('Open Tool', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Recent Activity Table
          const RecentActivityTable(),
        ],
      ),
    );
  }

  /// Projects tab view with simple empty state.
  Widget _buildProjectsView() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.folder_open_rounded, size: 48, color: Color(0xFF94A3B8)),
          const SizedBox(height: 12),
          const Text(
            'No projects yet.',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add_rounded, size: 18),
            label: const Text('Create Project'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            ),
          ),
        ],
      ),
    );
  }

  /// Settings view.
  Widget _buildSettingsView() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Environment Settings',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)),
                ),
                SizedBox(height: 8),
                Text('API Endpoint: https://reqres.in/api/users', style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                SizedBox(height: 4),
                Text('Fail-Closed Enforcement: Enabled', style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                SizedBox(height: 4),
                Text('Friction Detection Timeout: 5.0 Seconds', style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
