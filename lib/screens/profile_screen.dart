import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/api_client.dart';

class ProfileScreenMobile extends StatefulWidget {
  const ProfileScreenMobile({super.key});

  @override
  State<ProfileScreenMobile> createState() => _ProfileScreenMobileState();
}

class _ProfileScreenMobileState extends State<ProfileScreenMobile> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _username = TextEditingController();
  final _description = TextEditingController();

  XFile? _pickedFile;
  Uint8List? _pickedBytes;
  String? _pickedFileName;
  String? _avatarUrl;

  bool _loading = true;
  bool _saving = false;
  bool _loadFailed = false;
  bool _isPicking = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _username.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    if (!mounted) return;
    setState(() {
      _loading = true;
      _loadFailed = false;
    });
    
    final data = await ApiClient.getProfile();
    
    if (!mounted) return;
    
    if (data != null) {
      _username.text = (data['username'] ?? '').toString();
      _email.text = (data['email'] ?? '').toString();
      _name.text = '${data['first_name'] ?? ''} ${data['last_name'] ?? ''}'.trim();
      if (_name.text.isEmpty) {
        _name.text = data['username']?.toString() ?? '';
      }
      _description.text = (data['description'] ?? '').toString();
      
      final profilePic = data['profile_picture'];
      if (profilePic != null && profilePic.toString().isNotEmpty && profilePic.toString() != 'null') {
        _avatarUrl = profilePic.toString();
      } else {
        _avatarUrl = null;
      }
      
      setState(() => _loading = false);
    } else {
      setState(() {
        _loading = false;
        _loadFailed = true;
      });
    }
  }

  // 🔄 CHANGED: Simplified and robust _pickImage
  Future<void> _pickImage() async {
    if (_isPicking) return;
    
    print('');
    print('╔════════════════════════════════════╗');
    print('║       PICK IMAGE STARTED           ║');
    print('╚════════════════════════════════════╝');
    
    setState(() => _isPicking = true);
    
    try {
      final picker = ImagePicker();
      
      // Pick image
      final XFile? picked = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        imageQuality: 85,
      );
      
      if (picked == null) {
        print('📷 ❌ No image picked');
        return;
      }
      
      // Read bytes immediately
      print('📷 Reading bytes...');
      final bytes = await picked.readAsBytes();
      final fileName = picked.name;
      
      print('📷 ✅ Got ${bytes.length} bytes from $fileName');
      
      if (bytes.isEmpty) {
        print('📷 ❌ Bytes empty!');
        return;
      }
      
      // Store in instance variables first (always works)
      _pickedFile = picked;
      _pickedBytes = Uint8List.fromList(bytes);
      _pickedFileName = fileName;
      
      print('📷 ✅ Stored in instance variables');
      
      // Try to update UI
      if (mounted) {
        setState(() {});  // Trigger rebuild with stored values
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ Selected: $fileName (${(bytes.length/1024).toStringAsFixed(1)} KB)'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
      
      print('╔════════════════════════════════════╗');
      print('║       IMAGE PICKED SUCCESS         ║');
      print('╚════════════════════════════════════╝');
      print('📷 _pickedBytes: ${_pickedBytes?.length}');
      print('📷 _pickedFileName: $_pickedFileName');
      
    } catch (e) {
      print('❌ Pick error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      _isPicking = false;
      if (mounted) setState(() {});  // Always try to refresh UI
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    if (!mounted) return;
    
    setState(() => _saving = true);

    print('');
    print('╔════════════════════════════════════╗');
    print('║       SAVE PROFILE CLICKED         ║');
    print('╚════════════════════════════════════╝');
    print('📤 _pickedBytes: ${_pickedBytes?.length ?? "NULL"}');
    print('📤 _pickedFileName: $_pickedFileName');

    try {
      final success = await ApiClient.updateProfile(
        name: _name.text,
        email: _email.text,
        username: _username.text,
        description: _description.text,
        imageFile: _pickedFile,
        imageBytes: _pickedBytes,
      );

      if (!mounted) return;
      
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Profile updated!'), backgroundColor: Colors.green),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('❌ Failed'), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      print('❌ Save error: $e');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Check if we have picked bytes but UI hasn't updated
    final hasNewImage = _pickedBytes != null && _pickedBytes!.isNotEmpty;
    
    if (_loading) {
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1E3A8A), Color(0xFF2563EB), Color(0xFF0EA5E9)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: const Center(child: CircularProgressIndicator(color: Colors.white)),
        ),
      );
    }

    if (_loadFailed) {
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1E3A8A), Color(0xFF2563EB), Color(0xFF0EA5E9)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Center(
            child: Card(
              margin: const EdgeInsets.all(24),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    const Text('Failed to load profile'),
                    const SizedBox(height: 16),
                    ElevatedButton(onPressed: _loadProfile, child: const Text('Retry')),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1E3A8A), Color(0xFF2563EB), Color(0xFF0EA5E9)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Card(
                margin: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('Edit Profile', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 20),
                          
                          // Profile Picture with Key to force rebuild
                          Stack(
                            key: ValueKey('avatar_${_pickedBytes?.length ?? 0}'),  // ➕ Force rebuild when bytes change
                            children: [
                              Container(
                                width: 104,
                                height: 104,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: const Color(0xFF2563EB), width: 3),
                                ),
                                child: ClipOval(
                                  child: hasNewImage
                                      ? Image.memory(
                                          _pickedBytes!,
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
                                        )
                                      : (_avatarUrl != null && _avatarUrl!.isNotEmpty && _avatarUrl != 'null')
                                          ? Image.network(
                                              _avatarUrl!.startsWith('http') ? _avatarUrl! : '${ApiClient.baseUrl}$_avatarUrl',
                                              width: 100,
                                              height: 100,
                                              fit: BoxFit.cover,
                                              errorBuilder: (_, __, ___) => Image.asset(
                                                'lib/assets/images/noProfile.jpg',
                                                width: 100,
                                                height: 100,
                                                fit: BoxFit.cover,
                                              ),
                                            )
                                          : Image.asset(
                                              'lib/assets/images/noProfile.jpg',
                                              width: 100,
                                              height: 100,
                                              fit: BoxFit.cover,
                                            ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: _isPicking ? null : _pickImage,
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: _isPicking ? Colors.grey : const Color(0xFF2563EB),
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.white, width: 2),
                                    ),
                                    child: _isPicking
                                        ? const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                          )
                                        : const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          
                          // Status indicator
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: hasNewImage ? Colors.green[100] : Colors.grey[200],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  hasNewImage ? Icons.check_circle : Icons.info_outline,
                                  color: hasNewImage ? Colors.green : Colors.grey,
                                  size: 16,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  hasNewImage 
                                    ? '${_pickedFileName ?? "image"} (${(_pickedBytes!.length / 1024).toStringAsFixed(1)} KB)'
                                    : 'No new image selected',
                                  style: TextStyle(
                                    color: hasNewImage ? Colors.green[800] : Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          TextButton.icon(
                            onPressed: _isPicking ? null : _pickImage,
                            icon: const Icon(Icons.photo_library),
                            label: Text(_isPicking ? 'Selecting...' : 'Change Picture'),
                          ),
                          const SizedBox(height: 16),

                          TextFormField(
                            controller: _name,
                            decoration: const InputDecoration(
                              labelText: 'Display Name',
                              prefixIcon: Icon(Icons.person),
                              border: OutlineInputBorder(),
                            ),
                            validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _email,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              prefixIcon: Icon(Icons.email),
                              border: OutlineInputBorder(),
                            ),
                            validator: (v) => v == null || !v.contains('@') ? 'Invalid email' : null,
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _username,
                            decoration: const InputDecoration(
                              labelText: 'Username',
                              prefixIcon: Icon(Icons.alternate_email),
                              border: OutlineInputBorder(),
                            ),
                            validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _description,
                            decoration: const InputDecoration(
                              labelText: 'Description',
                              prefixIcon: Icon(Icons.info_outline),
                              border: OutlineInputBorder(),
                            ),
                            maxLines: 3,
                          ),
                          const SizedBox(height: 20),
                          
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton.icon(
                              onPressed: _saving ? null : _saveProfile,
                              icon: _saving 
                                ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                : const Icon(Icons.save),
                              label: Text(_saving ? 'Saving...' : 'Save Changes'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2563EB),
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextButton.icon(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.arrow_back),
                            label: const Text('Back'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}