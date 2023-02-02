import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DemoFormField extends StatefulWidget {
  const DemoFormField({Key? key}) : super(key: key);

  @override
  State<DemoFormField> createState() => _DemoFormFieldState();
}

class _DemoFormFieldState extends State<DemoFormField> {
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();



  // final CollectionReference collectionReference =
  //     FirebaseFirestore.instance.collection('users');

  // Stream<List<User>> readUser() => FirebaseFirestore.instance
  //     .collection('users')
  //     .snapshots()
  //     .map((snapshot) =>
  //         snapshot.docs.map((doc) => User.fromJson(doc.data())).toList());

  Future createUser(User user) async {
    // Check if collection exists or not

    final docUser = FirebaseFirestore.instance.collection('user1').doc();

    final temp = "hello";
    user.id = docUser.id;
    final json = user.toJson();
    await docUser.set(json);
  }

  var name2 = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Form Field"),
      ),
      body: Column(
        children: [
          Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                    hintText: "Enter name", border: OutlineInputBorder()),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: ageController,
                decoration: const InputDecoration(
                    hintText: "Enter age", border: OutlineInputBorder()),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  ElevatedButton(
                      onPressed: () {
                        final user = User(
                            name: nameController.text,
                            age: int.parse(ageController.text));
                        createUser(user);
                      },
                      child: const Text("Submit")),
                  const SizedBox(
                    width: 50,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        final docUser = FirebaseFirestore.instance
                            .collection('users')
                            .doc(name2);
                        docUser.update({
                          'name': nameController.text,
                          'age': ageController.text
                        }).then((value) {
                          nameController.clear();
                          ageController.clear();
                        },);
                      },
                      child: const Text("Update")),
                  const SizedBox(
                    width: 50,
                  ),
                  // ElevatedButton(
                  //     onPressed: () {
                  //       final docUser = FirebaseFirestore.instance
                  //           .collection('users')
                  //           .doc('n4UFfesPeux14xEm21yp');
                  //       docUser.delete();
                  //     },
                  //     child: Text("delete")),
                ],
              ),
            ],
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('users').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  // final users = snapshot.data!;
                  List<DocumentSnapshot> users = snapshot.data!.docs;
                  return Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            return Dismissible(
                                background: Container(
                                  color: Colors.blueAccent,
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: const Icon(Icons.delete),
                                ),
                                direction: DismissDirection.endToStart,
                                onDismissed: (direction) async {
                                  final docUser = FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(users[index].id);
                                  docUser.delete();
                                },
                                key: UniqueKey(),
                                child: Column(
                                  children: [
                                    ListTile(
                                      title: Text(users[index].get('name')),
                                      leading: CircleAvatar(
                                        child: Text(
                                            users[index].get('age').toString()),
                                      ),
                                      trailing: IconButton(
                                        icon: Icon(Icons.edit),
                                        onPressed: () {
                                          nameController.text =
                                              users[index].get('name');
                                          ageController.text =
                                              users[index].get('age');
                                          name2 = users[index].id;
                                          // final docUser = FirebaseFirestore.instance
                                          //     .collection('users')
                                          //     .doc(users[index].id);
                                          //
                                          // docUser.update({
                                          //   'name': nameController.text,
                                          //   'age': ageController.text
                                          // });
                                        },
                                      ),
                                    ),
                                    // ElevatedButton(
                                    //     onPressed: () {
                                    //       final docUser = FirebaseFirestore.instance
                                    //           .collection('users')
                                    //           .doc(users[index].id);
                                    //       docUser.update({'name': nameController.text,'age': ageController.text});
                                    //     },
                                    //     child: Text("Update")),
                                  ],
                                ));
                          },
                          scrollDirection: Axis.vertical,
                          itemCount: users.length,
                        ),
                      ),
                    ],
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
          )
        ],
      ),
    );
  }
}

class User {
  String? id;
  String name;
  int age;

  User({this.id, required this.name, required this.age});

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'age': age,
      };

  static User fromJson(Map<String, dynamic> json) =>
      User(id: json['id'], name: json['name'], age: json['age']);

  factory User.fromDocument(DocumentSnapshot doc) {
    return User(name: doc['name'], age: doc['age']);
  }
}
