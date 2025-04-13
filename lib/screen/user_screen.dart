import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hethong/controller/user_controller.dart';
import 'package:hethong/data/model/body/user.dart';
import 'package:hethong/screen/user_detail_screen.dart';
import 'package:hethong/widget/custom_confirm_dialog.dart';

class UserScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  // Khởi tạo controller
  final UserController userController = Get.find<UserController>();
  final TextEditingController _searchController = TextEditingController();

  List<User> _filteredUsers = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterUsers);
    // Khởi tạo danh sách lọc ban đầu bằng toàn bộ người dùng
    userController.getUser().then((_) {
      setState(() {
        // Sau khi lấy dữ liệu, cập nhật filtered users
        _filteredUsers = userController.users;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterUsers() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredUsers = userController.users.where((user) {
        return user.username!.toLowerCase().contains(query) ||
            user.email!.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'User List',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          // Ô tìm kiếm
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search users...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          // Danh sách người dùng
          Expanded(
            child: GetBuilder<UserController>(
              builder: (_) {
                return RefreshIndicator(
                  onRefresh: () async {
                    await userController.getUser();
                    setState(() {
                      _filterUsers();
                    });
                  },
                  child: (_filteredUsers.isEmpty)
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          itemCount: _filteredUsers.length,
                          itemBuilder: (context, index) {
                            User user = _filteredUsers[index];
                            return _buildUserCard(user);
                          },
                        ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserCard(User user) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        leading: CircleAvatar(
          radius: 30,
          backgroundColor: Colors.teal,
          child: Text(
            user.username![0].toUpperCase(),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        title: Text(
          user.username!,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        subtitle: Text(
          user.email!,
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.orange),
          onPressed: () async {
            CustomConfirmDialog.show(
              context: context,
              text: 'Bạn muốn xóa user này không?',
              onConfirm: () async {
                await userController.deleteUser(user.id!).then((_) {
                  setState(() {
                    _filteredUsers.remove(user);
                  });
                  Navigator.pop(context);
                });
              },
            );
          },
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserDetailScreen(user: user),
            ),
          );
        },
      ),
    );
  }
}
