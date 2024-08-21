// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class ProfilePage extends StatefulWidget {
//   final String uid;
//   ProfilePage({required this.uid});

//   @override
//   State<ProfilePage> createState() => _ProfilePageState();
// }

// class _ProfilePageState extends State<ProfilePage> {
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();
//   final TextEditingController _passingYearController = TextEditingController();
//   String? _selectedJob;

//   bool _isEditing = false;

//   final List<String> _jobOptions = [
//     'Software Engineer',
//     'Data Scientist',
//     'Product Manager',
//     'Designer',
//     'Other',
//   ];

//   Future<String?> getUserName(String wanted) async {
//     try {
//       DocumentSnapshot userDoc = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(widget.uid)
//           .get();
//       return userDoc[wanted];
//     } catch (e) {
//       print(e); // Handle errors appropriately
//       return null;
//     }
//   }

//   Future<void> getUserData() async {
//     try {
//       DocumentSnapshot userDoc = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(widget.uid)
//           .get();

//       if (userDoc.exists) {
//         _nameController.text = userDoc['name'] ?? '';
//         _emailController.text = userDoc['email'] ?? '';
//         _phoneController.text = userDoc['phone'] ?? '';
//         _passingYearController.text = userDoc['passingYear'] ?? '';
//         _selectedJob = userDoc['currentJob'] ?? _jobOptions.first;
//       }
//     } catch (e) {
//       print(e); // Handle errors appropriately
//     }
//   }

//   Future<void> saveUserData() async {
//     try {
//       await FirebaseFirestore.instance.collection('users').doc(widget.uid).set({
//         'name': _nameController.text,
//         'email': _emailController.text,
//         'phone': _phoneController.text,
//         'passingYear': _passingYearController.text,
//         'currentJob': _selectedJob,
//       }, SetOptions(merge: true));

//       setState(() {
//         _isEditing = false;
//       });
//     } catch (e) {
//       print(e); // Handle errors appropriately
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     getUserData();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: FutureBuilder<String?>(
//           future: getUserName('name'),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return CircularProgressIndicator(
//                 color: Colors.white,
//               );
//             } else if (snapshot.hasError) {
//               return Text('Error');
//             } else if (!snapshot.hasData || snapshot.data == null) {
//               return Text('No user data found');
//             } else {
//               return Text('Hello, ${snapshot.data}');
//             }
//           },
//         ),
//         actions: [
//           IconButton(
//             icon: Icon(_isEditing ? Icons.save : Icons.edit),
//             onPressed: () {
//               if (_isEditing) {
//                 saveUserData();
//               } else {
//                 setState(() {
//                   _isEditing = true;
//                 });
//               }
//             },
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _nameController,
//               decoration: InputDecoration(labelText: 'Name'),
//               readOnly: !_isEditing,
//             ),
//             TextField(
//               controller: _emailController,
//               decoration: InputDecoration(labelText: 'Email'),
//               readOnly: !_isEditing,
//             ),
//             TextField(
//               controller: _phoneController,
//               decoration: InputDecoration(labelText: 'Phone Number'),
//               keyboardType: TextInputType.phone,
//               readOnly: !_isEditing,
//             ),
//             TextField(
//               controller: _passingYearController,
//               decoration: InputDecoration(labelText: 'Passing Year'),
//               keyboardType: TextInputType.number,
//               readOnly: !_isEditing,
//             ),
//             DropdownButtonFormField<String>(
//               value: _selectedJob,
//               items: _jobOptions.map((job) {
//                 return DropdownMenuItem<String>(
//                   value: job,
//                   child: Text(job),
//                 );
//               }).toList(),
//               decoration: InputDecoration(labelText: 'Current Job'),
//               onChanged: _isEditing
//                   ? (newValue) {
//                       setState(() {
//                         _selectedJob = newValue;
//                       });
//                     }
//                   : null,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final String uid;
  ProfilePage({required this.uid});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passingYearController = TextEditingController();
  final TextEditingController _currentJobController = TextEditingController();
  final TextEditingController _courseController = TextEditingController();

  bool _isEditing = false;

  Future<void> getUserData() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      if (userDoc.exists) {
        _nameController.text = userDoc['name'] ?? '';
        _emailController.text = userDoc['email'] ?? '';
        _phoneController.text = userDoc['phone'] ?? '';
        _passingYearController.text = userDoc['passingYear'] ?? '';
        _currentJobController.text = userDoc['currentJob'] ?? '';
        _courseController.text = userDoc['course'] ?? '';
      }
    } catch (e) {
      print(e); // Handle errors appropriately
    }
  }

  Future<String?> getUserName(String wanted) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();
      return userDoc[wanted];
    } catch (e) {
      print(e); // Handle errors appropriately
      return null;
    }
  }

  Future<void> saveUserData() async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(widget.uid).set({
        'name': _nameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
        'passingYear': _passingYearController.text,
        'currentJob': _currentJobController.text,
        'course': _courseController.text,
      }, SetOptions(merge: true));

      setState(() {
        _isEditing = false;
      });
    } catch (e) {
      print(e); // Handle errors appropriately
    }
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<String?>(
          future: getUserName('name'),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(
                color: Colors.white,
              );
            } else if (snapshot.hasError) {
              return Text('Error');
            } else if (!snapshot.hasData || snapshot.data == null) {
              return Text('No user data found');
            } else {
              return Text('Hello, ${snapshot.data}');
            }
          },
        ),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.save : Icons.edit),
            onPressed: () {
              if (_isEditing) {
                saveUserData();
              } else {
                setState(() {
                  _isEditing = true;
                });
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                readOnly: !_isEditing,
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                readOnly: !_isEditing,
              ),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
                readOnly: !_isEditing,
              ),
              TextField(
                controller: _passingYearController,
                decoration: InputDecoration(labelText: 'Passing Year'),
                keyboardType: TextInputType.number,
                readOnly: !_isEditing,
              ),
              TextField(
                controller: _currentJobController,
                decoration: InputDecoration(labelText: 'Current Job'),
                readOnly: !_isEditing,
              ),
              TextField(
                controller: _courseController,
                decoration: InputDecoration(labelText: 'Course'),
                readOnly: !_isEditing,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
