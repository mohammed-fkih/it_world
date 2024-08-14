import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class SendMessage extends StatefulWidget {
  final String recipientEmail;

  const SendMessage({Key? key, required this.recipientEmail}) : super(key: key);

  @override
  _SendMessageState createState() => _SendMessageState();
}

class _SendMessageState extends State<SendMessage> {
  final TextEditingController _messageController = TextEditingController();
  String _enteredMessage = "";
  XFile? _selectedImage;

  Future<void> _selectAndSendMessage() async {
    FocusScope.of(context).unfocus();
    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .get();

    if (_selectedImage != null) {
      // Check if the image file exists
      final File imageFile = File(_selectedImage!.path);
      if (!await imageFile.exists()) {
        print('Image file does not exist');
        return;
      }

      // Create a reference to the image in Firebase Storage
      final firebase_storage.Reference storageRef = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child('images')
          .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

      // Upload the image to Firebase Storage
      await storageRef.putFile(imageFile);

      // Retrieve the uploaded image URL
      final String downloadURL = await storageRef.getDownloadURL();

      // Add the URL to the sent message
      FirebaseFirestore.instance.collection('chat').add({
        'message': _enteredMessage,
        'recipientEmail': widget.recipientEmail,
        'createdAt': Timestamp.now(),
        'senderEmail': userData['email'],
        'imageURL': downloadURL,
      });
    } else {
      // Add the message without an image
      FirebaseFirestore.instance.collection('chat').add({
        'message': _enteredMessage,
        'recipientEmail': widget.recipientEmail,
        'createdAt': Timestamp.now(),
        'senderEmail': userData['email'],
        'imageURL': null,
      });
    }

    _messageController.clear();
    _selectedImage = null;
  }

  Future<void> _selectImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _selectedImage = pickedImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SingleChildScrollView(
        child: Column(children: [
          if (_selectedImage != null) ...[
            Container(
              margin: const EdgeInsets.all(40),
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10)),
              child: Image.file(File(_selectedImage!.path)),
            )
          ] else ...[
            Container()
          ],
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: "اكتب رسالة ...",
                    prefixIcon: IconButton(
                      onPressed: _selectImage,
                      icon: const Icon(
                        Icons.image,
                        color: Colors.blue,
                        weight: 1,
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _enteredMessage = value;
                    });
                  },
                ),
              ),
              IconButton(
                onPressed: _enteredMessage.trim().isEmpty
                    ? null
                    : _selectAndSendMessage,
                icon: const Icon(Icons.send),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
