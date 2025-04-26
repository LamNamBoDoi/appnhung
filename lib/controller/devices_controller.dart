import 'dart:convert';
import 'package:get/get.dart';
import 'package:hethong/data/model/body/device.dart';
import 'package:hethong/utils/app_constants.dart';
import 'package:http/http.dart' as http;

class DevicesController extends GetxController implements GetxService {
  bool _loading = false;
  List<Device> _devices = <Device>[];
  var message = ''.obs;
  bool get loading => _loading;
  List<Device> get devices => _devices;

  void onInit() async {
    super.onInit();
    await getdevice();
  }

  Future<void> getdevice() async {
    _loading = true;
    update();

    try {
      var url = Uri.parse(AppConstants.BASE_URL + AppConstants.GET_DEVICES);

      var response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> responseData = json.decode(response.body);

        _devices = responseData
            .map((deviceData) => Device.fromJson(deviceData))
            .toList();
      } else {
        throw Exception('Failed to load devices');
      }
    } catch (e) {
      print("Error fetching devices: $e");
    } finally {
      _loading = false;
      update();
    }
  }

  Future<bool> updateDevice(Device device) async {
    final url = AppConstants.BASE_URL +
        AppConstants.UPDATEDEVICE; // Địa chỉ API của bạn
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'id': device.id,
        'device_name': device.device_name,
        'device_dep': device.device_dep,
        'device_uid': device.device_uid,
        'device_date': device.device_date,
        'device_mode': device.device_mode,
      }),
    );

    if (response.statusCode == 200) {
      await getdevice();
      update();
      print('Device updated successfully');
      return true;
    } else {
      print('Failed to update device');
      return false;
    }
  }

  String getNameDevice(String deviceDep) {
    for (var device in devices) {
      if (device.device_dep == deviceDep) {
        return device.device_name ?? '';
      }
    }
    return '';
  }
}
