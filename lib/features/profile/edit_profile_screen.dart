import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../common/constants/app_styles.dart';
import '../../common/widgets/custom_widgets.dart';
import '../../services/firestore_service.dart';
import 'profile_service.dart';
import '../../models/user_model.dart';
import '../auth/auth_service.dart';
import 'change_password_screen.dart';

class EditProfileScreen extends StatefulWidget {
  final UserModel user;

  const EditProfileScreen({super.key, required this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  final FireStoreService _firestoreService = FireStoreService();
  final ProfileService _profileService = ProfileService();
  bool _isLoading = false;
  File? _imageFile;
  String? _profileImageUrl;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _profileImageUrl = widget.user.profileImageUrl;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  /// Pick an image from gallery or camera
  Future<void> _pickAndUploadImage(ImageSource source) async {
    try {
      // 1. Pick image using image_picker
      final XFile? pickedFile = await _profileService.pickImage(source);
      if (pickedFile == null) return;

      setState(() {
        _imageFile = File(pickedFile.path);
        _isLoading = true; // Show loader while uploading
      });

      // 2. Upload to Firebase Storage and update Firestore
      // The service handles both storage upload and firestore field update
      final String downloadUrl = await _profileService.uploadProfileImage(widget.user.id, _imageFile!);
      
      setState(() {
        _profileImageUrl = downloadUrl;
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile picture updated!')),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  /// Show a bottom sheet to let the user choose between Gallery and Camera
  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  _pickAndUploadImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  _pickAndUploadImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await _firestoreService.updateUserField(widget.user.id, 'username', _nameController.text.trim());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating profile: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _isLoading ? null : () => _showPicker(context),
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: AppColors.surface,
                      backgroundImage: _imageFile != null 
                        ? FileImage(_imageFile!) 
                        : (_profileImageUrl != null ? NetworkImage(_profileImageUrl!) : null) as ImageProvider?,
                      child: _imageFile == null && _profileImageUrl == null
                          ? const Icon(Icons.person, size: 60, color: AppColors.primary)
                          : null,
                    ),
                    if (_isLoading)
                      const Positioned.fill(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.primary,
                        ),
                      ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: AppColors.primary,
                        child: Icon(
                          _isLoading ? Icons.hourglass_empty : Icons.camera_alt,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(widget.user.email, style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 32),
              CustomTextField(
                label: 'Full Name',
                icon: Icons.person_outline,
                controller: _nameController,
                validator: (value) => value!.isEmpty ? 'Name cannot be empty' : null,
              ),
              const SizedBox(height: 24),
              if (AuthService().currentUser?.providerData.first.providerId == 'password')
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ChangePasswordScreen()),
                    );
                  },
                  child: AbsorbPointer(
                    child: TextFormField(
                      initialValue: '********',
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock_outline, color: Colors.grey),
                        suffixIcon: Icon(Icons.chevron_right, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 40),
              PrimaryButton(
                text: 'SAVE CHANGES',
                isLoading: _isLoading,
                onPressed: _saveProfile,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
