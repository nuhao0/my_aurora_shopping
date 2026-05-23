import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:taqikrdnawa/backend/services/storage_service.dart';

class CameraSearchScreen extends StatefulWidget {
  static const routeName = '/camera-search';
  const CameraSearchScreen({super.key});

  @override
  State<CameraSearchScreen> createState() => _CameraSearchScreenState();
}

class _CameraSearchScreenState extends State<CameraSearchScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? _pickedFile;
  bool _isUploading = false;
  String? _status;

  Future<void> _pickFromCamera() async {
    final file = await _picker.pickImage(source: ImageSource.camera);
    if (file == null) return;
    setState(() => _pickedFile = file);
    _status = null;
  }

  Future<void> _uploadAndSearch() async {
    if (_pickedFile == null) return;
    setState(() {
      _isUploading = true;
      _status = 'Uploading image...';
    });

    try {
      final storageService = StorageService();
      final downloadUrl = await storageService.uploadSearchImage(File(_pickedFile!.path));

      if (downloadUrl != null) {
        setState(() {
          _status = 'Image uploaded successfully! (Ready for backend ML API)\nURL: $downloadUrl';
        });
      } else {
        setState(() {
          _status = 'Failed to upload. Ensure Firebase Storage rules are set.';
        });
      }
    } catch (e) {
      setState(() {
        _status = 'Error: $e';
      });
    } finally {
      setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera Search'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (_pickedFile != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.file(
                File(_pickedFile!.path),
                height: 260,
                fit: BoxFit.cover,
              ),
            )
          else
            Container(
              height: 260,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.grey.shade200,
              ),
              child: const Center(child: Text('Take a photo to search')),
            ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _isUploading ? null : _pickFromCamera,
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Open Camera'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: (_pickedFile == null || _isUploading) ? null : _uploadAndSearch,
              child: const Text('Search'),
            ),
          ),
          if (_status != null)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(_status!),
            ),
        ],
      ),
    );
  }
}

