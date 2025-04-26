import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hethong/controller/devices_controller.dart';
import 'package:hethong/controller/user_controller.dart';
import 'package:hethong/data/model/body/device.dart';
import 'package:hethong/data/model/body/user.dart';
import 'package:hethong/screen/user_screen/user_screen.dart';

class ClassScreen extends StatefulWidget {
  const ClassScreen({super.key});

  @override
  State<ClassScreen> createState() => _ClassScreenState();
}

class _ClassScreenState extends State<ClassScreen> {
  final TextEditingController _searchController = TextEditingController();
  final DevicesController devicesController = Get.find<DevicesController>();
  final UserController userController = Get.find<UserController>();
  List<Device> _filteredClass = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterClass);

    devicesController.getdevice().then((_) {
      setState(() {
        _filteredClass = devicesController.devices;
      });
    });
  }

  void _filterClass() {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) {
      setState(() {
        _filteredClass = devicesController.devices;
      });
      return;
    } else {
      setState(() {
        _filteredClass = devicesController.devices.where((device) {
          return (device.device_name != null &&
                  device.device_name!.toLowerCase().contains(query)) ||
              device.device_dep != null &&
                  device.device_dep!.toLowerCase().contains(query);
        }).toList();
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Danh sách lớp học',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.teal[700],
        centerTitle: true,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: GetBuilder<DevicesController>(
        builder: (controller) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Search bar
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search, color: Colors.teal),
                      hintText: 'Tìm kiếm lớp học...',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Class list
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await controller.getdevice();
                      setState(() {
                        _filterClass();
                      });
                    },
                    child: (_filteredClass.isEmpty)
                        ? const Center(
                            child: Text(
                              'Không có lớp học nào',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        : ListView.separated(
                            itemCount: _filteredClass.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final device = _filteredClass[index];
                              return _buildClassCard(device);
                            },
                          ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await userController.getUser();
          List<User> usersList = userController.getNewUsers();

          // Sử dụng `.then` để gọi lại getdevice() khi quay về
          Get.to(UserScreen(
            deviceDep: "",
            getUserInClass: false,
            usersList: usersList,
          ))?.then((_) async {
            // Gọi lại danh sách thiết bị/lớp học
            await devicesController.getdevice();
            setState(() {
              _filteredClass = devicesController.devices;
            });
          });
        },
        backgroundColor: Colors.teal[700],
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildClassCard(device) {
    List<User> usersList = Get.find<UserController>()
        .getStudentCountByClass(device.device_dep ?? '0');
    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Get.to(UserScreen(
            deviceDep: device.device_dep,
            getUserInClass: true,
            usersList: usersList,
          ))?.then((_) async {
            await userController.getUser();
            setState(() {
              _filteredClass = devicesController.devices;
            });
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Avatar lớp học
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.teal[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.school,
                  color: Colors.teal,
                  size: 30,
                ),
              ),
              const SizedBox(width: 16),
              // Thông tin lớp học
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      device.device_name ?? 'Tên lớp',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      device.device_dep ?? 'Phòng học',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.people, size: 16, color: Colors.grey[500]),
                        const SizedBox(width: 4),
                        Text(
                          usersList.length.toString() + ' sinh viên',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Icon(Icons.schedule, size: 16, color: Colors.grey[500]),
                        const SizedBox(width: 4),
                        Text(
                          '08:00 - 17:00',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
