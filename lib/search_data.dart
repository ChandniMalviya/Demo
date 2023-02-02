import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'form_field.dart';

class SearchDetail extends StatefulWidget {
  const SearchDetail({Key? key}) : super(key: key);

  @override
  State<SearchDetail> createState() => _SearchDetailState();
}

class _SearchDetailState extends State<SearchDetail> {
  final searchController = TextEditingController();
  List users = [];

  Future<void> searchFirebase(String query) async {
    final result = await FirebaseFirestore.instance
        .collection('users')
        .where('name',
            isGreaterThanOrEqualTo: query,
            isLessThan: query.substring(0, query.length - 1) +
                String.fromCharCode(query.codeUnitAt(query.length - 1) + 1))
        .get();
    setState(() {
      users = result.docs.map((e) => e.data()).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Search in Firebase")),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              onChanged: (query) {
                searchFirebase(query);
              },
              controller: searchController,
              decoration: const InputDecoration(
                  hintText: "Search", border: OutlineInputBorder()),
            ),
            // ElevatedButton(onPressed: () {
            //    searchFirebase(query);
            // }, child: Text("Search")),
            Expanded(
                child: ListView.builder(
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(users[index]['name']),
                  trailing: CircleAvatar(
                    child: Text(users[index]['age'].toString()),
                  ),
                );
              },
              itemCount: users.length,
            ))
          ],
        ),
      ),
    );
  }
}
