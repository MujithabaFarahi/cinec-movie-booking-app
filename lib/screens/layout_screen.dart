import 'package:cinec_movies/screens/bookings_screen.dart';
import 'package:cinec_movies/screens/home_screen.dart';
import 'package:cinec_movies/screens/profile_screen.dart';
import 'package:cinec_movies/theme/app_colors.dart';
import 'package:cinec_movies/widgets/image_icon_builder.dart';
import 'package:flutter/material.dart';

class LayoutScreen extends StatefulWidget {
  final int pageIndex;
  const LayoutScreen({super.key, required this.pageIndex});

  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen> {
  int _selectedIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.pageIndex;
    _pageController = PageController(initialPage: _selectedIndex);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(), // Disable swipe gesture
        children: const [HomeScreen(), BookingsScreen(), ProfileScreen()],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          items: [
            BottomNavigationBarItem(
              icon: _selectedIndex == 0
                  ? const ImageIconBuilder(
                      image: 'assets/icons/home.png',
                      isSelected: true,
                    )
                  : const ImageIconBuilder(
                      image: 'assets/icons/home-outline.png',
                    ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: _selectedIndex == 1
                  ? const ImageIconBuilder(
                      image: 'assets/icons/booking_fill.png',
                      isSelected: true,
                    )
                  : const ImageIconBuilder(image: 'assets/icons/booking.png'),
              label: 'Bookings',
            ),

            BottomNavigationBarItem(
              icon: _selectedIndex == 2
                  ? const ImageIconBuilder(
                      image: 'assets/icons/user_fill.png',
                      isSelected: true,
                    )
                  : const ImageIconBuilder(image: 'assets/icons/user.png'),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: AppColors.primary,
          selectedLabelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          unselectedItemColor: Colors.black,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
