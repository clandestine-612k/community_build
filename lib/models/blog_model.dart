// class Blog {
//   final String title;
//   final String description;
//   final String imageUrl;
//   final String date;

//   Blog({
//     required this.title,
//     required this.description,
//     required this.imageUrl,
//     required this.date,
//   });

//   factory Blog.fromMap(Map<String, dynamic> map) {
//     return Blog(
//       title: map['title'],
//       description: map['description'],
//       imageUrl: map['imageUrl'],
//       date: map['date'],
//     );
//   }
// }

class Blog {
  final String title;
  final String description;
  final String imageUrl;
  final String date;
  final String username; // New field for username

  Blog({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.date,
    required this.username, // Initialize the new field
  });

  factory Blog.fromMap(Map<String, dynamic> data) {
    return Blog(
      title: data['title'],
      description: data['description'],
      imageUrl: data['imageUrl'],
      date: data['date'],
      username: data['username'], // Parse the new field
    );
  }
}
