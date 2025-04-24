import 'package:flutter/material.dart';
import '../pages/provider_page.dart';
import '../pages/future_provider_page.dart';
import '../pages/stream_provider_page.dart';
import '../pages/proxy_provider_page.dart';
import '../pages/multiprovider_page.dart';

class NavigationDrawerWidget extends StatelessWidget {
  const NavigationDrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(child: Text('Providers')),
          _navItem(context, 'Basic Provider', const ProviderPage()),
          _navItem(context, 'FutureProvider', const FutureProviderPage()),
          _navItem(context, 'StreamProvider', const StreamProviderPage()),
          _navItem(context, 'ProxyProvider', const ProxyProviderPage()),
          _navItem(context, 'MultiProvider', const MultiProviderPage()),
        ],
      ),
    );
  }

  ListTile _navItem(BuildContext ctx, String title, Widget page) => ListTile(
        title: Text(title),
        onTap: () {
          Navigator.push(
            ctx,
            MaterialPageRoute(builder: (_) => page),
          );
        },
      );
}
