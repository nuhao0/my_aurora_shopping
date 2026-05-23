import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

import 'package:taqikrdnawa/backend/providers/auth_provider.dart';
import 'package:taqikrdnawa/backend/controllers/profile_controller.dart';
import 'package:taqikrdnawa/backend/services/storage_service.dart';
import 'auth_screen.dart';
import 'email_screen.dart';
import 'favorites_screen.dart';
import 'notifications_screen.dart';
import 'order_history_screen.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profile';
  final bool isStandalone;
  
  const ProfileScreen({super.key, this.isStandalone = true});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();
  final _picker = ImagePicker();
  
  // Demonstrating SetState for local UI state
  bool _isEditing = false; 

  final ProfileController controller = Get.find<ProfileController>();

  @override
  void initState() {
    super.initState();
    final auth = context.read<AuthProvider>();
    if (auth.user != null) {
      controller.fetchProfile(auth.user!.uid);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(String uid) async {
    final ImageSource? source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () => Navigator.of(context).pop(ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () => Navigator.of(context).pop(ImageSource.gallery),
            ),
          ],
        ),
      ),
    );

    if (source != null) {
      final file = await _picker.pickImage(source: source);
      if (file != null) {
        debugPrint('LOG: Image chosen! Path: ${file.path}');
        
        Get.snackbar('Uploading', 'Uploading profile photo...', showProgressIndicator: true, snackPosition: SnackPosition.BOTTOM);
        
        final storageService = StorageService();
        final downloadUrl = await storageService.uploadProfileImage(uid, File(file.path));
        
        if (downloadUrl != null) {
          await controller.updateProfile(uid, {'photoUrl': downloadUrl});
          Get.snackbar('Success', 'Profile photo updated successfully', snackPosition: SnackPosition.BOTTOM);
        } else {
          Get.snackbar('Error', 'Failed to upload photo. Ensure Firebase Storage rules are set.', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red[100]);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final email = auth.user?.email;
    final uid = auth.user?.uid;

    final bodyContent = Obx(() {
      final userData = controller.userData;
      final displayName = userData['displayName'] ?? (email != null ? email.split('@').first : 'Guest');
      final photoUrl = userData['photoUrl'];

      return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 46,
                  backgroundColor: Colors.grey.shade200,
                  backgroundImage: photoUrl != null ? NetworkImage(photoUrl) : null,
                  child: photoUrl == null ? const Icon(Icons.person, size: 44) : null,
                ),
                IconButton(
                  icon: const CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.black45,
                    child: Icon(Icons.camera_alt, size: 18, color: Colors.white),
                  ),
                  onPressed: uid == null ? null : () => _pickImage(uid),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              displayName,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 6),
          Center(
            child: Text(
              email ?? 'Login required',
              style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontSize: 13),
            ),
          ),
          const SizedBox(height: 16),

          if (uid == null)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Text('Please log in to edit your profile.'),
              ),
            )
          else
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextButton.icon(
                      icon: const Icon(Icons.edit),
                      label: Text(_isEditing ? 'Cancel' : 'Edit Profile'),
                      onPressed: () {
                        setState(() {
                          _isEditing = !_isEditing;
                          if (_isEditing) {
                            _nameController.text = userData['displayName'] ?? '';
                            _bioController.text = userData['bio'] ?? '';
                          }
                        });
                      },
                    ),
                    if (_isEditing) ...[
                      TextField(
                        controller: _nameController,
                        decoration: const InputDecoration(labelText: 'Display name'),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _bioController,
                        decoration: const InputDecoration(labelText: 'Bio'),
                        minLines: 2,
                        maxLines: 4,
                      ),
                      const SizedBox(height: 10),
                      if (controller.error.isNotEmpty)
                        Text(controller.error.value, style: TextStyle(color: Theme.of(context).colorScheme.error)),
                      const SizedBox(height: 6),
                      SizedBox(
                        width: double.infinity,
                        height: 44,
                        child: ElevatedButton(
                          onPressed: controller.isLoading.value
                              ? null
                              : () async {
                                  await controller.updateProfile(uid, {
                                    'displayName': _nameController.text.trim(),
                                    'bio': _bioController.text.trim(),
                                  });
                                  setState(() => _isEditing = false);
                                },
                          child: controller.isLoading.value
                              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                              : const Text('Save changes'),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

          const SizedBox(height: 18),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.history),
                  title: const Text('Order History'),
                  onTap: uid == null ? null : () => Navigator.of(context).pushNamed(OrderHistoryScreen.routeName),
                ),
                ListTile(
                  leading: const Icon(Icons.favorite_border),
                  title: const Text('Favorites'),
                  onTap: uid == null ? null : () => Navigator.of(context).pushNamed(FavoritesScreen.routeName),
                ),
                ListTile(
                  leading: const Icon(Icons.notifications),
                  title: const Text('Notifications'),
                  onTap: uid == null ? null : () => Navigator.of(context).pushNamed(NotificationsScreen.routeName),
                ),
                ListTile(
                  leading: const Icon(Icons.email),
                  title: const Text('Email'),
                  onTap: uid == null ? null : () => Navigator.of(context).pushNamed(EmailScreen.routeName),
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Log out'),
                  onTap: () async {
                    await context.read<AuthProvider>().signOut();
                    Get.offAllNamed(AuthScreen.routeName);
                  },
                ),
              ],
            ),
          ),
        ],
      );
    });

    if (!widget.isStandalone) {
      return bodyContent;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Me')),
      body: bodyContent,
    );
  }
}
