import 'package:flutter/material.dart';
import 'package:hethong/controller/user_controller.dart';
import 'package:hethong/data/model/body/user.dart';
import 'package:get/get.dart';
import 'package:hethong/screen/home_screen.dart';

class UserDetailScreen extends StatefulWidget {
  User user;

  UserDetailScreen({required this.user});

  @override
  _UserDetailScreenState createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _serialnumberController;
  String? _gender;
  String? _deviceDep;

  final List<String> _deviceDeps = ['All', 'DTVT', 'DTVT 20A'];
  final List<String> _genders = ['None', 'Male', 'Female'];
  UserController userController = Get.find<UserController>();

  @override
  void initState() {
    super.initState();
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
        ? 'Male' // Giá trị mặc định
        : widget.user.gender;
    _deviceDep =
        (widget.user.device_dep == null || widget.user.device_dep == 'None')
            ? 'All' // Giá trị mặc định
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
          'User Detail',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () async {
            await userController.getUser(); // Gọi hàm cập nhật
            Get.offAll(HomeScreen());
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildUserDetailCard(),
            const SizedBox(height: 20),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildUserDetailCard() {
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
            _buildDetailTile('Username', _usernameController.text),
            _buildDetailTile('Email', _emailController.text),
            _buildDetailTile('Serial Number', _serialnumberController.text),
            _buildDetailTile('Gender', _gender ?? 'N/A'),
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

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        widget.user.add_card == "1"
            ? _buildActionButton('Update', Colors.teal, _updateUserInfo)
            : _buildActionButton('Update', Colors.grey, () {}),
        widget.user.add_card == "0"
            ? _buildActionButton('Add', Colors.orange, _addUserInfo)
            : _buildActionButton('Add', Colors.grey, () {}),
      ],
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

  void _updateUserInfo() {
    // Nếu không có lỗi, tiếp tục với việc cập nhật thông tin
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: _buildDialogTitle(true),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField('Username', _usernameController),
                _buildTextField('Email', _emailController),
                _buildTextField('Serial Number', _serialnumberController),
                _buildDropdownField('Gender', _gender, _genders),
                _buildDropdownField(
                    'Device Department', _deviceDep, _deviceDeps),
              ],
            ),
          ),
          actions: _buildDialogActions(true),
        );
      },
    );
  }

  void _addUserInfo() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: _buildDialogTitle(false),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField('Username', _usernameController),
                _buildTextField('Email', _emailController),
                _buildTextField('Serial Number', _serialnumberController),
                _buildDropdownField('Gender', _gender, _genders),
                _buildDropdownField(
                    'Device Department', _deviceDep, _deviceDeps),
              ],
            ),
          ),
          actions: _buildDialogActions(false),
        );
      },
    );
  }

  Widget _buildDialogTitle(bool update) {
    return Row(
      children: [
        const Icon(Icons.edit, color: Colors.teal),
        const SizedBox(width: 8),
        Text(update ? 'Update User Info' : 'Add User Info',
            style: const TextStyle(color: Colors.teal)),
      ],
    );
  }

  List<Widget> _buildDialogActions(bool update) {
    return [
      ElevatedButton(
        onPressed: () async {
          if (userController.isSerialNumberExists(
              _serialnumberController.text, widget.user.id!)) {
            Get.snackbar(
              'Error',
              'Serial Number Exists',
              backgroundColor: Colors.red,
              colorText: Colors.white,
              duration: Duration(seconds: 1),
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
          update
              ? await userController.updateUser(updatedUser)
              : await userController.updateUser(addUser);
          setState(() {
            update ? widget.user = updatedUser : widget.user = addUser;
          });
          Navigator.pop(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.teal,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),
        child: const Text('Save', style: TextStyle(color: Colors.white)),
      ),
      ElevatedButton(
        onPressed: () {
          Navigator.pop(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),
        child: const Text('Cancel', style: TextStyle(color: Colors.white)),
      ),
    ];
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        ),
      ),
    );
  }

  Widget _buildDropdownField(
      String label, String? currentValue, List<String> items) {
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
            if (label == 'Gender') {
              _gender = newValue;
            } else {
              _deviceDep = newValue;
            }
          });
        },
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        ),
      ),
    );
  }
}
