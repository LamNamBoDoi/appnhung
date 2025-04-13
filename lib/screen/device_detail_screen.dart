import 'package:flutter/material.dart';
import 'package:hethong/data/model/body/device.dart';

class DeviceDetailScreen extends StatefulWidget {
  final Device device;

  DeviceDetailScreen({required this.device});

  @override
  _DeviceDetailScreenState createState() => _DeviceDetailScreenState();
}

class _DeviceDetailScreenState extends State<DeviceDetailScreen> {
  late TextEditingController _deviceNameController;
  late TextEditingController _deviceUidController;
  late TextEditingController _deviceDateController;
  String? _deviceMode;
  String? _deviceDep;

  final List<String> _deviceModes = ['Mode 1', 'Mode 2', 'Mode 3'];
  final List<String> _deviceDeps = ['All', 'DTVT', 'DTVT 20A'];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _deviceNameController =
        TextEditingController(text: widget.device.device_name);
    _deviceUidController =
        TextEditingController(text: widget.device.device_uid);
    _deviceDateController =
        TextEditingController(text: widget.device.device_date);

    // Đảm bảo giá trị mặc định hợp lệ
    _deviceMode = _deviceModes.contains(widget.device.device_mode)
        ? widget.device.device_mode
        : _deviceModes.first;
    _deviceDep = _deviceDeps.contains(widget.device.device_dep)
        ? widget.device.device_dep
        : _deviceDeps.first;
  }

  @override
  void dispose() {
    _deviceNameController.dispose();
    _deviceUidController.dispose();
    _deviceDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.device.device_name ?? 'Device Details'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildDeviceDetailCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(String label, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  Widget _buildDeviceDetailCard() {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailTile('Device Name', _deviceNameController.text),
            _buildDetailTile('Device UID', _deviceUidController.text),
            _buildDetailTile('Device Date', _deviceDateController.text),
            _buildDetailTile('Device Mode', _deviceMode ?? 'N/A'),
            _buildDetailTile('Device Department', _deviceDep ?? 'N/A'),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailTile(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Text(
            value.isEmpty ? 'N/A' : value,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        ),
      ),
    );
  }

  Widget _buildDropdownField(
      String label, String? currentValue, List<String> items) {
    // Đảm bảo giá trị hiện tại nằm trong danh sách
    if (currentValue != null && !items.contains(currentValue)) {
      currentValue = null;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: DropdownButtonFormField<String>(
        value: currentValue,
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            if (label == 'Device Mode') {
              _deviceMode = newValue;
            } else if (label == 'Device Department') {
              _deviceDep = newValue;
            }
          });
        },
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        ),
      ),
    );
  }
}
