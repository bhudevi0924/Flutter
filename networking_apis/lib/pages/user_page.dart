import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../model/user.dart';
import '../services/api_service.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});
  
  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  late Future<List<User>> users;

      late Box _box;

  @override
  void initState() {
    super.initState();
    users = ApiService.fetchRandomUsers(count: 10);
    _initBox();
    print(users);
  }

  void _initBox () async {
    _box = await Hive.openBox("todoBox");
  }

  @override
  Widget build(BuildContext context) {
    
    // Box todoBox=Hive.box("todoBox");
    return Scaffold(
      appBar: AppBar(title: const Text('Random Users')),
      body: FutureBuilder<List<User>>(
        future: users,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No users found'));
          } else {
            final usersData = snapshot.data!;
            return ListView.builder(
              itemCount: usersData.length,
              itemBuilder: (context, index) {
                final user = usersData[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(backgroundImage: NetworkImage(user.pictureUrl)),
                    title: Text(user.fullName),
                    subtitle: Text(user.email),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
