import 'package:get/get.dart';
import '../services/user_service.dart';

class ProfileController extends GetxController {
  final UserService _userService;
  
  ProfileController({required UserService userService}) : _userService = userService;

  final RxMap userData = {}.obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  void fetchProfile(String uid) async {
    isLoading.value = true;
    error.value = '';
    try {
      final data = await _userService.getUserData(uid);
      if (data != null) {
        userData.addAll(data);
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfile(String uid, Map<String, dynamic> data) async {
    isLoading.value = true;
    try {
      await _userService.updateUserData(uid, data);
      userData.addAll(data);
      Get.snackbar('Success', 'Profile updated successfully!', 
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Error', 'Failed to update profile: $e', 
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Get.theme.colorScheme.errorContainer);
    } finally {
      isLoading.value = false;
    }
  }
}
