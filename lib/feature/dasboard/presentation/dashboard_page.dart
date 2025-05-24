import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram/r.dart';

@RoutePage()
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;

  static const List<String> _iconPaths = [
    AssetIcons.home,
    AssetIcons.search,
    AssetIcons.reel,
    AssetIcons.cart,
    AssetIcons.profile,
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_iconPaths.length, (index) {
              final isSelected = _selectedIndex == index;
              return GestureDetector(
                onTap: () => _onItemTapped(index),
                child: SvgPicture.asset(
                  _iconPaths[index],
                  colorFilter: ColorFilter.mode(
                    isSelected ? Colors.black : Colors.grey,
                    BlendMode.srcIn,
                  ),
                  width: 32,
                  height: 32,
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
