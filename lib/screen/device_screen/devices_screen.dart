import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hethong/controller/devices_controller.dart';
import 'package:hethong/data/model/body/device.dart';
import 'package:hethong/screen/device_screen/widget/device_detail_screen.dart';

class DeviceScreen extends StatefulWidget {
  @override
  _DeviceScreenState createState() => _DeviceScreenState();
}

class _DeviceScreenState extends State<DeviceScreen> {
  // Khởi tạo controller
  final DevicesController deviceController = Get.find<DevicesController>();
  final TextEditingController _searchController = TextEditingController();

  List<Device> _filteredDevices = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterDevices);
    // Khởi tạo danh sách ban đầu bằng toàn bộ thiết bị
    deviceController.getdevice().then((_) {
      setState(() {
        // Sau khi lấy dữ liệu, cập nhật filtered users
        _filteredDevices = deviceController.devices;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterDevices() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredDevices = deviceController.devices.where((device) {
        return device.device_name!.toLowerCase().contains(query) ||
            device.device_dep!.toLowerCase().contains(query) ||
            device.device_uid!.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Danh sách thiết bị',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.teal[700],
        centerTitle: true,
        elevation: 4,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
        ),
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
                hintText: 'Search devices...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          // Danh sách thiết bị
          Expanded(
            child: GetBuilder<DevicesController>(
              builder: (_) {
                return RefreshIndicator(
                  onRefresh: () async {
                    await deviceController.getdevice();
                    _filterDevices(); // Cập nhật danh sách sau khi tải lại
                  },
                  child: (_filteredDevices.isEmpty)
                      ? const Center(
                          child: Text(
                            'Không có thiết bị nào',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: _filteredDevices.length,
                          itemBuilder: (context, index) {
                            Device device = _filteredDevices[index];
                            return _buildDeviceCard(device);
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

  Widget _buildDeviceCard(Device device) {
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
            device.device_name![0].toUpperCase(),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        title: Text(
          device.device_name!,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              device.device_dep!,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              device.device_mode == '1'
                  ? 'Mode: Attendance'
                  : 'Mode: Enrollment',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.teal,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          icon: const Icon(Icons.settings, color: Colors.orange),
          onSelected: (value) async {
            bool success = false;
            if (value == 'attendance' && device.device_mode != '1') {
              success = await deviceController.updateDevice(Device(
                id: device.id,
                device_uid: device.device_uid,
                device_date: device.device_date,
                device_dep: device.device_dep,
                device_mode: '1',
                device_name: device.device_name,
              ));
            } else if (value == 'enrollment' && device.device_mode != '0') {
              success = await deviceController.updateDevice(Device(
                id: device.id,
                device_uid: device.device_uid,
                device_date: device.device_date,
                device_dep: device.device_dep,
                device_mode: '0',
                device_name: device.device_name,
              ));
            }
            if (success) {
              _filterDevices();
              Get.snackbar(
                'Đổi chế độ thiết bị thành công',
                deviceController.message.value,
                backgroundColor: Colors.green,
                colorText: Colors.white,
                duration: const Duration(seconds: 1),
              );
            } else {
              Get.snackbar(
                'Đổi chế độ thiết bị thất bại',
                deviceController.message.value,
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 1),
                colorText: Colors.white,
              );
            }
          },
          itemBuilder: (BuildContext context) {
            return [
              const PopupMenuItem<String>(
                value: 'attendance',
                child: Text('Attendance'),
              ),
              const PopupMenuItem<String>(
                value: 'enrollment',
                child: Text('Enrollment'),
              ),
            ];
          },
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DeviceDetailScreen(device: device),
            ),
          );
        },
      ),
    );
  }
}
