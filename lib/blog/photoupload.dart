// import 'package:community_build/blog/blog_page.dart';

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';

// class UploadPhotoPage extends StatefulWidget {
//   const UploadPhotoPage({super.key});

//   @override
//   State<UploadPhotoPage> createState() => _UploadPhotoPageState();
// }

// class _UploadPhotoPageState extends State<UploadPhotoPage> {
//   File? sampleImage;
//   String? _title;
//   late String url;
//   String? _description;
//   final formKey = GlobalKey<FormState>();

//   Future getImage() async {
//     ImagePicker _picker = ImagePicker();
//     var tempImage = await _picker.pickImage(source: ImageSource.gallery);
//     if (tempImage != null) {
//       setState(() {
//         sampleImage = File(tempImage.path);
//       });
//     }
//   }

//   bool validateAndUpload() {
//     final form = formKey.currentState;
//     if (form!.validate()) {
//       form.save();
//       uploadImage();
//       return true;
//     } else {
//       return false;
//     }
//   }

//   Future<void> uploadImage() async {
//     if (sampleImage != null) {
//       try {
//         final storageReference = FirebaseStorage.instance
//             .ref()
//             .child('postimage/${DateTime.now().millisecondsSinceEpoch}.jpg');
//         final uploadTask = storageReference.putFile(sampleImage!);
//         await uploadTask;
//         final downloadUrl = await storageReference.getDownloadURL();
//         print(downloadUrl);
//         // url = downloadUrl.toString();
//         // print("Imagr url" + url);
//         // savetoDatabase(url);

//         // Save the post details to Firebase Database
//         final databaseReference =
//             FirebaseDatabase.instance.ref().child('postdata');
//         databaseReference.push().set({
//           'title': _title,
//           'description': _description,
//           'imageUrl': downloadUrl,
//           'date': DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
//           //'username': userMap['name'],
//         });

//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Post added successfully')),
//         );

//         setState(() {
//           sampleImage = null;
//           _title = null;
//           _description = null;
//           formKey.currentState!.reset();
//         });
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error uploading image: $e')),
//         );
//       }
//     }

//     Navigator.push(context, MaterialPageRoute(builder: (context) {
//       return BlogPage();
//     }));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Upload Image"),
//         centerTitle: true,
//       ),
//       body: Center(
//         child: sampleImage == null ? Text("Select an Image") : enableUpload(),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: getImage,
//         tooltip: "Add Image",
//         child: Icon(Icons.add_a_photo),
//       ),
//     );
//   }

//   Widget enableUpload() {
//     return Container(
//       padding: EdgeInsets.all(16),
//       child: SingleChildScrollView(
//         child: Form(
//           key: formKey,
//           child: Column(
//             children: <Widget>[
//               Image.file(
//                 sampleImage!,
//                 height: 330,
//                 width: 660,
//               ),
//               SizedBox(height: 20),
//               TextFormField(
//                 decoration: InputDecoration(labelText: 'Blog Title'),
//                 validator: (value) {
//                   return value!.isEmpty ? "Blog title is required" : null;
//                 },
//                 onSaved: (value) {
//                   _title = value;
//                 },
//               ),
//               SizedBox(height: 20),
//               TextFormField(
//                 decoration: InputDecoration(labelText: 'Description'),
//                 validator: (value) {
//                   return value!.isEmpty ? "Blog description is required" : null;
//                 },
//                 onSaved: (value) {
//                   _description = value;
//                 },
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: validateAndUpload,
//                 child: Text("Add the post"),
//                 style: ElevatedButton.styleFrom(
//                   textStyle: TextStyle(color: Colors.amber),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:community_build/blog/blog_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UploadPhotoPage extends StatefulWidget {
  const UploadPhotoPage({super.key});

  @override
  State<UploadPhotoPage> createState() => _UploadPhotoPageState();
}

class _UploadPhotoPageState extends State<UploadPhotoPage> {
  File? sampleImage;
  String? _title;
  late String url;
  String? _description;
  String? _username;
  final formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _fetchUsername();
  }

  Future<void> _fetchUsername() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      setState(() {
        _username = userDoc['name'];
      });
    }
  }

  Future getImage() async {
    ImagePicker _picker = ImagePicker();
    var tempImage = await _picker.pickImage(source: ImageSource.gallery);
    if (tempImage != null) {
      setState(() {
        sampleImage = File(tempImage.path);
      });
    }
  }

  bool validateAndUpload() {
    final form = formKey.currentState;
    if (form!.validate()) {
      form.save();
      uploadImage();
      return true;
    } else {
      return false;
    }
  }

  Future<void> uploadImage() async {
    if (sampleImage != null) {
      try {
        final storageReference = FirebaseStorage.instance
            .ref()
            .child('postimage/${DateTime.now().millisecondsSinceEpoch}.jpg');
        final uploadTask = storageReference.putFile(sampleImage!);
        await uploadTask;
        final downloadUrl = await storageReference.getDownloadURL();
        print(downloadUrl);

        // Save the post details to Firebase Database
        final databaseReference =
            FirebaseDatabase.instance.ref().child('postdata');
        databaseReference.push().set({
          'title': _title,
          'description': _description,
          'imageUrl': downloadUrl,
          'date': DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
          'username': _username,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Post added successfully')),
        );

        setState(() {
          sampleImage = null;
          _title = null;
          _description = null;
          formKey.currentState!.reset();
        });

        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return BlogPage();
        }));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error uploading image: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Image"),
        centerTitle: true,
      ),
      body: Center(
        child: sampleImage == null ? Text("Select an Image") : enableUpload(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: "Add Image",
        child: Icon(Icons.add_a_photo),
      ),
    );
  }

  Widget enableUpload() {
    return Container(
      padding: EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              Image.file(
                sampleImage!,
                height: 330,
                width: 660,
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(labelText: 'Blog Title'),
                validator: (value) {
                  return value!.isEmpty ? "Blog title is required" : null;
                },
                onSaved: (value) {
                  _title = value;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  return value!.isEmpty ? "Blog description is required" : null;
                },
                onSaved: (value) {
                  _description = value;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: validateAndUpload,
                child: Text("Add the post"),
                style: ElevatedButton.styleFrom(
                  textStyle: TextStyle(color: Colors.amber),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
