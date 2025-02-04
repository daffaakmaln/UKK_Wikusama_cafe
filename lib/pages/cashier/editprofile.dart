import 'package:flutter/material.dart';

class EditProfile extends StatefulWidget {
  final int userID;

  const EditProfile({Key? key, required this.userID});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Fetch user data when the widget is initialized
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    // Contoh: Ambil data user dari API atau lokal berdasarkan userID
    // Set hasil nama dari database ke _nameController
    // setState(() {
    //   profilePicturePath = fetchedProfilePicturePath;
    // });
    _nameController.text = 'John Doe'; // Gantikan ini dengan nama dari database
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Picture
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage("assets/images/profile.png"),
              ),
            ),
            const SizedBox(height: 20),

            // TextField for Name
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 20),

            // Button to Change Password
            ElevatedButton(
              onPressed: () {
                // Navigate to Change Password Screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChangePasswordScreen(userID: widget.userID),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Change Password',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChangePasswordScreen extends StatelessWidget {
  final int userID;

  const ChangePasswordScreen({Key? key, required this.userID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
        backgroundColor: Colors.blue,
      ),
      body: const Center(
        child: Text('Change Password Screen'), // Tambahkan form untuk mengubah password sesuai kebutuhan
      ),
    );
  }
}
