import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfilePage extends StatefulWidget {
  final Map<String, dynamic> userData;

  ProfilePage(this.userData);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Request notification permission
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });

    // Populate text controllers with initial user data
    nameController.text = widget.userData['name'];
    emailController.text = widget.userData['email'];
    birthDateController.text = widget.userData['birth_date'];
    addressController.text = widget.userData['address'];
    phoneNumberController.text = widget.userData['phone_number'];

    super.initState();
  }

  Future<void> updateUser() async {
    // Get values from text controllers
    final String name = nameController.text;
    final String email = emailController.text;
    final String birthDate = birthDateController.text;
    final String address = addressController.text;
    final String phoneNumber = phoneNumberController.text;

    // Perform update logic here
    final url = 'http://192.168.20.34/app_kb/edit_user.php';

    final updateData = {
      "user_id": widget.userData['user_id'],
      "name": name,
      "email": email,
      "birth_date": birthDate,
      "address": address,
      "phone_number": phoneNumber,
    };

    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(updateData),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData != null &&
          responseData['status'] != null &&
          responseData['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data berhasil diperbarui')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memperbarui data. Mohon coba lagi')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Gagal memperbarui data. Terjadi kesalahan server')),
      );
    }
  }

  triggerNotification() {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: 10,
          channelKey: 'basic_channel',
          title: 'Keluarga Berencana',
          body: 'Cek kembali program keluarga berencana'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Nama'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: birthDateController,
              decoration: InputDecoration(labelText: 'Tanggal Lahir'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: addressController,
              decoration: InputDecoration(labelText: 'Alamat'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: phoneNumberController,
              decoration: InputDecoration(labelText: 'Nomor Telepon'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: updateUser,
              child: Text('Update'),
            ),
          ],
        ),
      ),
    );
  }
}
