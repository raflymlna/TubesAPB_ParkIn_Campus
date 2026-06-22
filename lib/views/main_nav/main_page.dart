import 'package:flutter/material.dart';
import '../home/home_page.dart';
import '../../qr/scan_qr_page.dart';
import '../../parking/history_page.dart';
import '../profile/profile_page.dart';
import '../../l10n/app_localizations.dart';

class MainPage extends StatefulWidget {
  static int lastTab = 0;
  final int initialIndex;

  const MainPage({
    super.key,
    this.initialIndex = 0,
  });

  @override
  State<MainPage> createState() => _MainPageState();
  }

class _MainPageState extends State<MainPage> {
  late int index;
  int lastIndex = 0;

  @override
  void initState() {
    super.initState();
    index = widget.initialIndex;
  }

  List<Widget> get pages => [
    const HomePage(),
    QRPage(previousTab: lastIndex),
    const HistoryPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (i) {
          setState(() {
            if (i == 1) {
              MainPage.lastTab = index;
              print("lastTab = ${MainPage.lastTab}");
            }
            
            index = i;
          });
        },
        selectedItemColor: const Color(0xFF800000),
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        elevation: 10,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: AppLocalizations.of(context)!.home,),
          BottomNavigationBarItem(icon: Icon(Icons.qr_code), label: AppLocalizations.of(context)!.qr),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: AppLocalizations.of(context)!.history,),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: AppLocalizations.of(context)!.profile,),
        ],
      ),
    );
  }
}
