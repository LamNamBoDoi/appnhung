import 'package:flutter/material.dart';
import 'package:hethong/controller/devices_controller.dart';
import 'package:hethong/controller/user_controller.dart';
import 'package:hethong/data/model/body/device.dart';
import 'package:hethong/data/model/body/user.dart';
import 'package:get/get.dart';

class UserDetailScreen extends StatefulWidget {
  User user;

  UserDetailScreen({Key? key, required this.user}) : super(key: key);

  @override
  _UserDetailScreenState createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _serialnumberController;
  String? _gender;
  String? _deviceDep;

  final List<String> _deviceDeps = ['All'];
  final List<String> _genders = ['None', 'Male', 'Female'];
  final UserController userController = Get.find<UserController>();
  final DevicesController devicesController = Get.find<DevicesController>();
  @override
  void initState() {
    super.initState();
    for (Device device in devicesController.devices) {
      if (device.device_dep != null && device.device_dep != 'None') {
        _deviceDeps.add(device.device_dep!);
      }
    }
    _initializeControllers();
  }

  void _initializeControllers() {
    _usernameController = TextEditingController(
        text: (widget.user.username == null || widget.user.username == 'None')
            ? 'None'
            : widget.user.username);
    _emailController = TextEditingController(
        text: (widget.user.email == null || widget.user.email == 'None')
            ? 'None'
            : widget.user.email);
    _serialnumberController = TextEditingController(
        text: (widget.user.serialnumber == null ||
                widget.user.serialnumber == '0')
            ? '0'
            : widget.user.serialnumber);
    _gender = (widget.user.gender == null || widget.user.gender == 'None')
        ? 'Male'
        : widget.user.gender;
    _deviceDep =
        (widget.user.device_dep == null || widget.user.device_dep == 'None')
            ? 'All'
            : widget.user.device_dep;
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _serialnumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chi tiết người dùng',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.teal[700],
        centerTitle: true,
        elevation: 4,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildUserDetailCard(),
            const SizedBox(height: 24),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildUserDetailCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // User avatar
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.teal[400]!, Colors.teal[700]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  widget.user.username?[0].toUpperCase() ?? 'U',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // User details
            Column(
              children: [
                _buildDetailItem('Tên người dùng', _usernameController.text),
                const Divider(height: 24, thickness: 0.5),
                _buildDetailItem('Email', _emailController.text),
                const Divider(height: 24, thickness: 0.5),
                _buildDetailItem('Số serial', _serialnumberController.text),
                const Divider(height: 24, thickness: 0.5),
                _buildDetailItem('Giới tính', _gender ?? 'N/A'),
                const Divider(height: 24, thickness: 0.5),
                _buildDetailItem('Phòng ban', _deviceDep ?? 'N/A'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          Text(
            value.isEmpty ? 'N/A' : value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.teal[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildButton(
          'Cập nhật',
          widget.user.add_card == "1" ? Colors.teal : Colors.grey,
          widget.user.add_card == "1" ? _updateUserInfo : null,
        ),
        _buildButton(
          'Thêm',
          widget.user.add_card == "0" ? Colors.orange : Colors.grey,
          widget.user.add_card == "0" ? _addUserInfo : null,
        ),
      ],
    );
  }

  Widget _buildButton(String text, Color color, VoidCallback? onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        elevation: 2,
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
    );
  }

  void _updateUserInfo() {
    _showEditDialog(true);
  }

  void _addUserInfo() {
    _showEditDialog(false);
  }

  void _showEditDialog(bool isUpdate) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
        contentPadding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
        actionsPadding: const EdgeInsets.all(16),
        title: Row(
          children: [
            Icon(
              isUpdate ? Icons.edit : Icons.person_add,
              color: Colors.teal,
            ),
            const SizedBox(width: 8),
            Text(
              isUpdate ? 'Cập nhật thông tin' : 'Thêm người dùng',
              style: const TextStyle(
                color: Colors.teal,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildEditField('Tên người dùng', _usernameController),
              const SizedBox(height: 12),
              _buildEditField('Email', _emailController),
              const SizedBox(height: 12),
              _buildEditField('Số serial', _serialnumberController),
              const SizedBox(height: 12),
              _buildDropdown('Giới tính', _gender, _genders, (value) {
                setState(() => _gender = value);
              }),
              const SizedBox(height: 12),
              _buildDropdown('Phòng ban', _deviceDep, _deviceDeps, (value) {
                setState(() => _deviceDep = value);
              }),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => {_initializeControllers(), Navigator.pop(context)},
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () async {
              if (userController.isSerialNumberExists(
                  _serialnumberController.text, widget.user.id!)) {
                Get.snackbar(
                  'Lỗi',
                  'Số serial đã tồn tại',
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                  snackPosition: SnackPosition.TOP,
                );
                return;
              } else if (_serialnumberController.text == "0") {
                Get.snackbar(
                  'Lỗi',
                  'Số serial không hợp lệ',
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                  snackPosition: SnackPosition.TOP,
                );
                return;
              }

              User updatedUser = User(
                id: widget.user.id,
                username: _usernameController.text,
                email: _emailController.text,
                serialnumber: _serialnumberController.text,
                gender: _gender,
                device_dep: _deviceDep,
                card_uid: widget.user.card_uid,
                card_select: widget.user.card_select,
                user_date: widget.user.user_date,
                device_uid: widget.user.device_uid,
                add_card: widget.user.add_card,
              );

              User addUser = User(
                id: widget.user.id,
                username: _usernameController.text,
                email: _emailController.text,
                serialnumber: _serialnumberController.text,
                gender: _gender,
                device_dep: _deviceDep,
                card_uid: widget.user.card_uid,
                card_select: widget.user.card_select,
                user_date: widget.user.user_date,
                device_uid: widget.user.device_uid,
                add_card: "1",
              );

              await userController.updateUser(isUpdate ? updatedUser : addUser);
              setState(() {
                widget.user = isUpdate ? updatedUser : addUser;
              });
              Navigator.pop(context);
            },
            child: const Text('Lưu', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildEditField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey[400]!),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    String? value,
    List<String> items,
    ValueChanged<String?> onChanged,
  ) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items.map((item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey[400]!),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}
