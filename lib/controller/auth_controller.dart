import 'dart:convert';
import 'package:get/get.dart';
import 'package:hethong/data/model/body/admin.dart';
import 'package:http/http.dart' as http;
import 'package:hethong/utils/app_constants.dart';

class AuthController extends GetxController implements GetxService {
  var isLoading = false.obs;
  var message = ''.obs;
  Admin admin = Admin(); // Đối tượng Admin để lưu thông tin admin

  // Hàm login
  Future<void> login(String email, String password) async {
    isLoading(true);
    try {
      final response = await http.post(
        Uri.parse(AppConstants.BASE_URL + AppConstants.LOGIN),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "admin_email": email,
          "admin_pwd": password,
        }),
      );

      // In ra response để kiểm tra
      print(response.body);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print(responseData);

        if (responseData['status'] == 'success') {
          // Lưu thông tin admin vào biến admin
          admin = Admin.fromJson(responseData['admin']);
          print(admin);
          message.value = 'Chào mừng, ${admin.admin_name}!';
        } else {
          message.value = responseData['message'];
        }
      } else {
        message.value =
            "Lỗi kết nối. Vui lòng thử lại."; // Thông báo lỗi kết nối
      }
    } catch (e) {
      message.value =
          "Có lỗi xảy ra. Vui lòng thử lại."; // Thông báo lỗi khi gặp sự cố
      print("Error: $e");
    } finally {
      isLoading(false); // Kết thúc trạng thái loading
    }
  }

  // Cập nhật thông tin admin bao gồm mật khẩu
  Future<bool> updateAdminInfo(String name, String email,
      String currentPassword, String newPassword) async {
    final String apiUrl = AppConstants.BASE_URL + AppConstants.UPDATEADMIN;

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        // Thêm token nếu cần thiết
        // 'Authorization': 'Bearer your_token',
      },
      body: json.encode({
        'id': 1,
        'up_name': name,
        'up_email': email,
        'up_pwd': currentPassword, // Mật khẩu cũ
        'up_pwd_new': newPassword, // Mật khẩu mới
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData['status'] == 'success') {
        message.value = 'Cập nhật thông tin thành công!';
        return true;
      } else {
        message.value = responseData['message']; // Thông báo lỗi từ API
        return false;
      }
    } else {
      message.value = 'Lỗi kết nối. Vui lòng thử lại.';

      return false;
    }
  }

  Future<void> getAdmin() async {
    isLoading.value = true; // Bắt đầu trạng thái loading
    try {
      // Gửi yêu cầu GET đến API
      final url = Uri.parse(AppConstants.BASE_URL + AppConstants.GETADMIN);
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        // Thêm Authorization nếu API yêu cầu
        // 'Authorization': 'Bearer your_token',
      });

      // Kiểm tra mã trạng thái HTTP
      if (response.statusCode == 200) {
        print(response.body);

        final responseData = jsonDecode(response.body);
        print(responseData);
        // Kiểm tra nếu API trả về thành công
        if (responseData.isNotEmpty) {
          // Lấy phần tử đầu tiên của danh sách
          final adminData = responseData[0]; // Sử dụng chỉ mục 0 để truy cập
          admin = Admin.fromJson(adminData);
        } else {
          message.value = "Không có thông tin admin.";
        }
        message.value = "Tải thông tin admin thành công!";
      } else {
        // Thông báo lỗi nếu mã trạng thái không phải 200
        message.value = "Lỗi kết nối: ${response.statusCode}.";
      }
    } catch (e) {
      // Bắt các lỗi bất ngờ
      message.value = "Lỗi khi tải thông tin admin: $e";
      print("Error fetching admin: $e");
    } finally {
      isLoading.value = false; // Kết thúc trạng thái loading
    }
    update();
  }
}
