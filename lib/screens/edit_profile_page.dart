import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditProfilePage extends StatefulWidget {
  final String currentUsername;
  final String currentBio;
  final List<String> currentInterests;
  final String profileImage;

  const EditProfilePage({
    super.key,
    required this.currentUsername,
    required this.currentBio,
    required this.currentInterests,
    required this.profileImage,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _usernameController;
  late TextEditingController _bioController;
  late List<String> _interests;
  File? _newImage;
  bool _isSaving = false;

  final List<String> _allInterests = [
    "Live Music",
    "Hiking",
    "Food Festivals",
    "Tech Meetups",
    "Sports Events",
    "Gaming",
    "Art",
    "Dance",
    "Stand-up Comedy"
  ];

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.currentUsername);
    _bioController = TextEditingController(text: widget.currentBio);
    _interests = List.from(widget.currentInterests);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _newImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      print('Error picking image: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error selecting image: $e')),
        );
      }
    }
  }

  void _toggleInterest(String interest) {
    setState(() {
      if (_interests.contains(interest)) {
        _interests.remove(interest);
      } else {
        _interests.add(interest);
      }
    });
  }

  Future<String?> _uploadProfileImage(File imageFile) async {
    try {
      // Get current user
      final User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      final userId = user.uid;

      // Create a unique filename to avoid collisions
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'profile_${userId}_$timestamp.jpg';

      // Create a direct reference to the root of Firebase Storage
      final storageInstance = FirebaseStorage.instance;

      // Create a reference directly to the file we want to create
      final fileRef = storageInstance.ref().child(fileName);

      print('Attempting to upload to: ${fileRef.fullPath}');

      // Upload the file directly to the root without assuming any directory structure
      final uploadTask = fileRef.putFile(
        imageFile,
        SettableMetadata(contentType: 'image/jpeg'),
      );

      // Handle upload events
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        print(
            'Upload progress: ${snapshot.bytesTransferred}/${snapshot.totalBytes}');
      }, onError: (e) {
        print('Upload error event: $e');
      });

      // Wait for upload to complete
      final snapshot =
          await uploadTask.whenComplete(() => print('Upload completed'));

      // Get download URL
      final downloadUrl = await snapshot.ref.getDownloadURL();
      print('Upload successful, URL: $downloadUrl');
      return downloadUrl;
    } catch (e) {
      print('Error in _uploadProfileImage: $e');

      // More detailed error information
      if (e is FirebaseException) {
        print('Firebase error code: ${e.code}');
        print('Firebase error message: ${e.message}');

        if (e.code == 'object-not-found') {
          print(
              'This typically means the bucket or path does not exist or you lack permissions.');

          // Try creating with alternative approach (directly to root)
          try {
            final user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              final timestamp = DateTime.now().millisecondsSinceEpoch;
              final rootRef = FirebaseStorage.instance.ref();
              final uploadTask = rootRef
                  .child('user_${user.uid}_$timestamp.jpg')
                  .putFile(imageFile);
              final snapshot = await uploadTask;
              final url = await snapshot.ref.getDownloadURL();
              print('Alternative upload method successful: $url');
              return url;
            }
          } catch (fallbackError) {
            print('Alternative upload method failed: $fallbackError');
          }
        }
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to upload image: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return null;
    }
  }

  void _saveChanges() async {
    if (_isSaving) return;

    setState(() {
      _isSaving = true;
    });

    try {
      // Check if user is authenticated
      final User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      final userId = user.uid;
      String imageUrl = widget.profileImage;

      // Upload new image if selected
      if (_newImage != null) {
        final uploadedImageUrl = await _uploadProfileImage(_newImage!);
        if (uploadedImageUrl != null) {
          imageUrl = uploadedImageUrl;
        } else {
          print('Image upload failed, using original image URL');

          // If the image upload fails but we still want to update other profile data
          if (mounted) {
            final continueWithout = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Image Upload Failed'),
                    content: const Text(
                        'Do you want to continue saving other profile changes without updating your profile picture?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text('Continue'),
                      ),
                    ],
                  ),
                ) ??
                false;

            if (!continueWithout) {
              setState(() {
                _isSaving = false;
              });
              return;
            }
          }
        }
      }

      // Prepare user data update
      final userData = {
        'username': _usernameController.text,
        'bio': _bioController.text,
        'interests': _interests,
        'profileImage': imageUrl,
        'lastUpdated': FieldValue.serverTimestamp(),
      };

      // Update or create user document
      final docRef = FirebaseFirestore.instance.collection('users').doc(userId);
      final doc = await docRef.get();

      if (doc.exists) {
        // Update existing document
        await docRef.update(userData);
      } else {
        // Create new document
        await docRef.set(userData);
      }

      // Show success message
      if (mounted) {
        Navigator.pop(context, {
          'username': _usernameController.text,
          'bio': _bioController.text,
          'interests': _interests,
          'image': imageUrl,
        });
      }
    } catch (e) {
      print('Error saving profile: $e');

      if (e is FirebaseException) {
        print('Firebase error code: ${e.code}');
        print('Firebase error message: ${e.message}');
      }

      if (mounted) {
        setState(() {
          _isSaving = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save profile: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        actions: [
          _isSaving
              ? const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  ),
                )
              : IconButton(
                  icon: const Icon(Icons.check),
                  onPressed: _saveChanges,
                  tooltip: 'Save changes',
                )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 55,
                  backgroundImage: _newImage != null
                      ? FileImage(_newImage!)
                      : (widget.profileImage.isNotEmpty
                              ? NetworkImage(widget.profileImage)
                              : const AssetImage('assets/default_profile.png'))
                          as ImageProvider,
                ),
                Positioned(
                  bottom: 0,
                  right: 4,
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      child:
                          const Icon(Icons.edit, size: 20, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _usernameController,
            decoration: const InputDecoration(labelText: 'Username'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _bioController,
            maxLines: 2,
            decoration: const InputDecoration(labelText: 'Bio'),
          ),
          const SizedBox(height: 24),
          const Text("Select Interests",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _allInterests.map((interest) {
              final isSelected = _interests.contains(interest);
              return FilterChip(
                label: Text(interest),
                selected: isSelected,
                onSelected: (_) => _toggleInterest(interest),
                selectedColor: Colors.orange.shade200,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
