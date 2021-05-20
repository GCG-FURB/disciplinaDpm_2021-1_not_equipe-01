// //https://livebook.manning.com/book/flutter-in-action/chapter-10/v-8/23
// // backend/lib/services/todos.dart -- line ~13
// import 'package:project_3e/models/user.dart';

// class HttpServices implements Services {
//   User user = new User();

//   Future<Map<String, User>> getUsers() async {
//     final response = await user
//         .get('https://crud-firebase-9c272-default-rtdb.firebaseio.com/users/');

//     if (response.statusCode == 200) {
//       // If the call to the server was successful, parse the JSON
//       var all = AllTodos.fromJson(json.decode(response.body));
//       return all.todos;
//     } else {
//       // If that call was not successful, throw an error.
//       throw Exception('Failed to load todos ');
//     }
//   }
// }
