import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController statusController = TextEditingController();

  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _loadProfileData(); 
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _showImagePicker() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_camera, color: Color(0xFF075E54)),
                title: Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library, color: Color(0xFF075E54)),
                title: Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _updateProfile() async {
    if (nameController.text.isNotEmpty &&
        statusController.text.isNotEmpty &&
        _imageFile != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('name', nameController.text);
      await prefs.setString('status', statusController.text);
      await prefs.setString('imagePath', _imageFile!.path);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfilePage(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please complete all fields')),
      );
    }
  }

  Future<void> _loadProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedName = prefs.getString('name');
    String? savedStatus = prefs.getString('status');
    String? savedImagePath = prefs.getString('imagePath');

    if (savedName != null) {
      nameController.text = savedName;
    }
    if (savedStatus != null) {
      statusController.text = savedStatus;
    }
    if (savedImagePath != null) {
      setState(() {
        _imageFile = File(savedImagePath);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account Settings', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF075E54),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _showImagePicker,
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey.shade300,
                backgroundImage:
                    _imageFile != null ? FileImage(_imageFile!) : null,
                child: _imageFile == null
                    ? Icon(Icons.person, size: 80, color: Colors.grey.shade700)
                    : null,
              ),
            ),
            SizedBox(height: 24),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.person),
                hintText: 'Enter name',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF075E54)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF075E54)),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: statusController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.edit_note),
                hintText: 'Enter About',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF075E54)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF075E54)),
                ),
              ),
            ),
            SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _updateProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF075E54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text('Update',
                    style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? name;
  String? status;
  String? imagePath;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name');
      status = prefs.getString('status');
      imagePath = prefs.getString('imagePath');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile", style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF075E54),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (imagePath != null)
              CircleAvatar(
                radius: 80,
                backgroundImage: FileImage(File(imagePath!)),
              )
            else
              CircleAvatar(
                radius: 80,
                child: Icon(Icons.person, size: 80),
              ),
            SizedBox(height: 24),
            ListTile(
              leading: Icon(Icons.person, color: Color(0xFF075E54)),
              title: Text("Name"),
              subtitle: Text(name ?? 'Not set'),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.info_outline, color: Color(0xFF075E54)),
              title: Text("About"),
              subtitle: Text(status ?? 'Not set'),
            ),
          ],
        ),
      ),
    );
  }
}
