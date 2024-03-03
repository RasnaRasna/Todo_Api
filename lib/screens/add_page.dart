import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({super.key});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController titileController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Todo"),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                TextField(
                  controller: titileController,
                  decoration: InputDecoration(hintText: "Title"),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(hintText: "Description "),
                  maxLength: 8,
                ),
                ElevatedButton(onPressed: submitData, child: Text("Submit"))
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> submitData() async {
    //Get the data from the form
    final title = titileController.text;
    final description = descriptionController.text;

    final body = {
      "title": title,
      "description": description,
      "is_completed": false
    };
    //Submit data to the surver

    final url = 'https://api.nstack.in/v1/todos';
    final uri = Uri.parse(url);
    final response = await http.post(uri,
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});
    print(response.statusCode);
    print(response.body);

    //Shoe ot fail message
    if (response.statusCode == 201) {
      titileController.text = '';
      descriptionController.text = '';
      showSucessMessage(" Creation sucess");
    } else {
      showerrorMessage(" Creation failed");
    }
  }

  void showSucessMessage(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showerrorMessage(String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
