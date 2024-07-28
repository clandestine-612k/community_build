// import 'package:community_build/models/blog_model.dart';
// import 'package:firebase_database/firebase_database.dart';

// class BlogService {
//   final DatabaseReference databaseReference =
//       FirebaseDatabase.instance.ref().child('postdata');

//   Future<List<Blog>> getBlogs() async {
//     DataSnapshot snapshot = await databaseReference.get();
//     List<Blog> blogs = [];
//     if (snapshot.exists) {
//       Map<String, dynamic> values =
//           Map<String, dynamic>.from(snapshot.value as Map);
//       values.forEach((key, value) {
//         blogs.add(Blog.fromMap(Map<String, dynamic>.from(value)));
//       });
//     }
//     return blogs;
//   }
// }

import 'package:community_build/models/blog_model.dart';
import 'package:firebase_database/firebase_database.dart';

class BlogService {
  final DatabaseReference databaseReference =
      FirebaseDatabase.instance.ref().child('postdata');

  Future<List<Blog>> getBlogs() async {
    DataSnapshot snapshot = await databaseReference.get();
    List<Blog> blogs = [];
    if (snapshot.exists) {
      Map<String, dynamic> values =
          Map<String, dynamic>.from(snapshot.value as Map);
      values.forEach((key, value) {
        blogs.add(Blog.fromMap(Map<String, dynamic>.from(value)));
      });
    }
    return blogs;
  }
}
