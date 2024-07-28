// import 'package:community_build/models/blog_model.dart';
// import 'package:community_build/services/blog_service.dart';
// import 'package:flutter/material.dart';

// class BlogPage extends StatefulWidget {
//   @override
//   _BlogPageState createState() => _BlogPageState();
// }

// class _BlogPageState extends State<BlogPage> {
//   late Future<List<Blog>> _blogs;

//   @override
//   void initState() {
//     super.initState();
//     _blogs = BlogService().getBlogs();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Blogs'),
//       ),
//       body: FutureBuilder<List<Blog>>(
//         future: _blogs,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(child: Text('No blogs available'));
//           } else {
//             List<Blog> blogs = snapshot.data!;
//             return ListView.builder(
//               itemCount: blogs.length,
//               itemBuilder: (context, index) {
//                 Blog blog = blogs[index];
//                 return Card(
//                   margin: EdgeInsets.all(8),
//                   child: Padding(
//                     padding: EdgeInsets.all(16),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: <Widget>[
//                         Text(
//                           blog.title,
//                           style: TextStyle(
//                               fontSize: 24, fontWeight: FontWeight.bold),
//                         ),
//                         SizedBox(height: 10),
//                         Image.network(blog.imageUrl),
//                         SizedBox(height: 10),
//                         Text(
//                           blog.description,
//                           style: TextStyle(fontSize: 16),
//                         ),
//                         SizedBox(height: 10),
//                         Text(
//                           blog.date,
//                           style: TextStyle(fontSize: 12, color: Colors.grey),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
// }

import 'package:community_build/models/blog_model.dart';
import 'package:community_build/services/blog_service.dart';
import 'package:flutter/material.dart';

class BlogPage extends StatefulWidget {
  @override
  _BlogPageState createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  late Future<List<Blog>> _blogs;

  @override
  void initState() {
    super.initState();
    _blogs = BlogService().getBlogs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blogs'),
      ),
      body: FutureBuilder<List<Blog>>(
        future: _blogs,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No blogs available'));
          } else {
            List<Blog> blogs = snapshot.data!;
            return ListView.builder(
              itemCount: blogs.length,
              itemBuilder: (context, index) {
                Blog blog = blogs[index];
                return Card(
                  margin: EdgeInsets.all(8),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          blog.title,
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Image.network(blog.imageUrl),
                        SizedBox(height: 10),
                        Text(
                          blog.description,
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Posted by ${blog.username}', // Display the username
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 10),
                        Text(
                          blog.date,
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
