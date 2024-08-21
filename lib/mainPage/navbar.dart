import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo/Home.dart';
import 'package:todo/login.dart';

class NavBar extends StatefulWidget {
  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  String? _username;
  String? _email;
  //String? _Gusername;
  //String? _Gemail;

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  Future<void> _getUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String? uid = user.uid;
      try {
        DocumentSnapshot DocUser =
            await FirebaseFirestore.instance.collection('Users').doc(uid).get();
        if (DocUser.exists) {
          setState(() {
            _username = DocUser['userName'] as String?;
            _email = DocUser['email'] as String?;
            //_Gemail = DocUser['Gmail'] as String?;
            //_Gusername = DocUser['Gname'] as String?;

            //print('Gname : $_Gusername');
            //print("Gmal : $_Gemail");
            print("email : $_email");
            print("username : $_username");
          });
        } else {
          print("Doc user not exist");
        }
        print('Try block is excluded');
      } catch (e) {
        print('Unexpected error : $e');
      }
    } else {
      print('User is null');
    }
    print('Nothing is run');
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text('${_username?.toUpperCase() ?? 'GUEST'}'),
            accountEmail: Text('${_email}'),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.asset('images/NavBar.png'),
              ),
            ),
            decoration: BoxDecoration(color: Colors.indigo.shade200),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('HOME'),
            onTap: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => Home()));
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.local_activity),
            title: Text('PERSONAL TASKS'),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => personal()));
            },
          ),
          ListTile(
            leading: Icon(Icons.business_center),
            title: Text('WORK/PROFESSIONAL TASKS'),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => work()));
            },
          ),
          ListTile(
            leading: Icon(Icons.school_outlined),
            title: Text('ACADEMIC/STUDY TASKS'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => academeic()));
            },
          ),
          ListTile(
            leading: Icon(Icons.cleaning_services),
            title: Text('HOUSEHOLDER TASKS'),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => house()));
            },
          ),
          ListTile(
            leading: Icon(Icons.health_and_safety),
            title: Text('HEALTH & FITNESS'),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => health()));
            },
          ),
          ListTile(
            leading: Icon(Icons.group),
            title: Text('SOCIAL/EVENTS'),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => social()));
            },
          ),
          ListTile(
            leading: Icon(Icons.attach_money),
            title: Text('FINANCIAL TASKS'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => financial()));
            },
          ),
          ListTile(
            leading: Icon(Icons.stacked_bar_chart),
            title: Text('LONG-TEARM GOAL'),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => long()));
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('SETTINGS'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('LOGOUT'),
            onTap: () async {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => Login()));
              /*await GoogleSignIn().signOut();
              FirebaseAuth.instance.signOut();*/
            },
          ),
        ],
      ),
    );
  }
}

List<String> _doList = [
  'PERSONAL TASKS',
  'WORK & PROFESSIONAL TASKS',
  'ACADEMIC & STUDY TASKS',
  'HOUSEHOLDER TASKS',
  'HEALTH & FITNESS',
  'SOCIAL & VENTS',
  'FINANCIAL TASKS',
  'LONG-TEARM GOAL',
  'OTHERS',
];

class personal extends StatelessWidget {
  const personal({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    String uid = user!.uid;
    final screenSize = MediaQuery.of(context).size;
    final width = screenSize.width;
    final height = screenSize.height;
    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(right: 56.0),
          child: Center(
            child: Text(
              '${_doList[0]}',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic),
            ),
          ),
        ),
        backgroundColor: Colors.indigo,
      ),
      backgroundColor: Colors.indigo.shade300,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(uid) // Replace with the specific user ID
            .collection('Types')
            .doc(_doList[0])
            .collection("Categories")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No data available'));
          }

          // Extract data from snapshot
          final documents = snapshot.data!.docs;

          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final data = documents[index].data() as Map<String, dynamic>;

              return Container(
                margin: EdgeInsets.all(8.0),
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Category: ${data['Categories'] ?? 'No Category'}',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Description: ${data['Discription'] ?? 'No Description'}',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Date: ${data['Dou Date'] ?? 'No Date'}',
                      style: TextStyle(fontSize: 16),
                    ),
                    Row(
                      children: [
                        Text(
                          'Time: ${data['Dou Time'] ?? 'No Time'}',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(
                          width: width * 0.55,
                        ),
                        IconButton(
                          onPressed: () async {
                            try {
                              await FirebaseFirestore.instance
                                  .collection("Users")
                                ..doc(uid)
                                    .collection("Types")
                                    .doc(_doList[0])
                                    .collection("Categories")
                                    .doc(documents[index].id)
                                    .delete();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text('Deleted successfully')));
                            } catch (e) {
                              print("Error for delete : $e");
                            }
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Colors.deepOrangeAccent,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class work extends StatelessWidget {
  const work({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    String uid = user!.uid;
    final screenSize = MediaQuery.of(context).size;
    final width = screenSize.width;
    final height = screenSize.height;
    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(right: 56.0),
          child: Center(
            child: Text(
              '${_doList[1]}',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic),
            ),
          ),
        ),
        backgroundColor: Colors.indigo,
      ),
      backgroundColor: Colors.indigo.shade300,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(uid) // Replace with the specific user ID
            .collection('Types')
            .doc(_doList[1])
            .collection("Categories")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No data available'));
          }

          // Extract data from snapshot
          final documents = snapshot.data!.docs;

          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final data = documents[index].data() as Map<String, dynamic>;

              return Container(
                margin: EdgeInsets.all(8.0),
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Category: ${data['Categories'] ?? 'No Category'}',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Description: ${data['Discription'] ?? 'No Description'}',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Date: ${data['Dou Date'] ?? 'No Date'}',
                      style: TextStyle(fontSize: 16),
                    ),
                    Row(
                      children: [
                        Text(
                          'Time: ${data['Dou Time'] ?? 'No Time'}',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(
                          width: width * 0.55,
                        ),
                        IconButton(
                          onPressed: () async {
                            try {
                              await FirebaseFirestore.instance
                                  .collection("Users")
                                ..doc(uid)
                                    .collection("Types")
                                    .doc(_doList[1])
                                    .collection("Categories")
                                    .doc(documents[index].id)
                                    .delete();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text('Deleted successfully')));
                            } catch (e) {
                              print("Error for delete : $e");
                            }
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Colors.deepOrangeAccent,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class academeic extends StatelessWidget {
  const academeic({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    String uid = user!.uid;
    final screenSize = MediaQuery.of(context).size;
    final width = screenSize.width;
    final height = screenSize.height;
    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(right: 56.0),
          child: Center(
            child: Text(
              '${_doList[2]}',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic),
            ),
          ),
        ),
        backgroundColor: Colors.indigo,
      ),
      backgroundColor: Colors.indigo.shade300,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(uid) // Replace with the specific user ID
            .collection('Types')
            .doc(_doList[2])
            .collection("Categories")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No data available'));
          }

          // Extract data from snapshot
          final documents = snapshot.data!.docs;

          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final data = documents[index].data() as Map<String, dynamic>;

              return Container(
                margin: EdgeInsets.all(8.0),
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Category: ${data['Categories'] ?? 'No Category'}',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Description: ${data['Discription'] ?? 'No Description'}',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Date: ${data['Dou Date'] ?? 'No Date'}',
                      style: TextStyle(fontSize: 16),
                    ),
                    Row(
                      children: [
                        Text(
                          'Time: ${data['Dou Time'] ?? 'No Time'}',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(
                          width: width * 0.55,
                        ),
                        IconButton(
                          onPressed: () async {
                            try {
                              await FirebaseFirestore.instance
                                  .collection("Users")
                                ..doc(uid)
                                    .collection("Types")
                                    .doc(_doList[2])
                                    .collection("Categories")
                                    .doc(documents[index].id)
                                    .delete();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text('Deleted successfully')));
                            } catch (e) {
                              print("Error for delete : $e");
                            }
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Colors.deepOrangeAccent,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class house extends StatelessWidget {
  const house({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    String uid = user!.uid;
    final screenSize = MediaQuery.of(context).size;
    final width = screenSize.width;
    final height = screenSize.height;
    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(right: 56.0),
          child: Center(
            child: Text(
              '${_doList[3]}',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic),
            ),
          ),
        ),
        backgroundColor: Colors.indigo,
      ),
      backgroundColor: Colors.indigo.shade300,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(uid) // Replace with the specific user ID
            .collection('Types')
            .doc(_doList[3])
            .collection("Categories")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No data available'));
          }

          // Extract data from snapshot
          final documents = snapshot.data!.docs;

          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final data = documents[index].data() as Map<String, dynamic>;

              return Container(
                margin: EdgeInsets.all(8.0),
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Category: ${data['Categories'] ?? 'No Category'}',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Description: ${data['Discription'] ?? 'No Description'}',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Date: ${data['Dou Date'] ?? 'No Date'}',
                      style: TextStyle(fontSize: 16),
                    ),
                    Row(
                      children: [
                        Text(
                          'Time: ${data['Dou Time'] ?? 'No Time'}',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(
                          width: width * 0.55,
                        ),
                        IconButton(
                          onPressed: () async {
                            try {
                              await FirebaseFirestore.instance
                                  .collection("Users")
                                ..doc(uid)
                                    .collection("Types")
                                    .doc(_doList[3])
                                    .collection("Categories")
                                    .doc(documents[index].id)
                                    .delete();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text('Deleted successfully')));
                            } catch (e) {
                              print("Error for delete : $e");
                            }
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Colors.deepOrangeAccent,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class health extends StatelessWidget {
  const health({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    String uid = user!.uid;
    final screenSize = MediaQuery.of(context).size;
    final width = screenSize.width;
    final height = screenSize.height;
    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(right: 56.0),
          child: Center(
            child: Text(
              '${_doList[4]}',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic),
            ),
          ),
        ),
        backgroundColor: Colors.indigo,
      ),
      backgroundColor: Colors.indigo.shade300,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(uid) // Replace with the specific user ID
            .collection('Types')
            .doc(_doList[4])
            .collection("Categories")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No data available'));
          }

          // Extract data from snapshot
          final documents = snapshot.data!.docs;

          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final data = documents[index].data() as Map<String, dynamic>;

              return Container(
                margin: EdgeInsets.all(8.0),
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Category: ${data['Categories'] ?? 'No Category'}',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Description: ${data['Discription'] ?? 'No Description'}',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Date: ${data['Dou Date'] ?? 'No Date'}',
                      style: TextStyle(fontSize: 16),
                    ),
                    Row(
                      children: [
                        Text(
                          'Time: ${data['Dou Time'] ?? 'No Time'}',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(
                          width: width * 0.55,
                        ),
                        IconButton(
                          onPressed: () async {
                            try {
                              await FirebaseFirestore.instance
                                  .collection("Users")
                                ..doc(uid)
                                    .collection("Types")
                                    .doc(_doList[4])
                                    .collection("Categories")
                                    .doc(documents[index].id)
                                    .delete();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text('Deleted successfully')));
                            } catch (e) {
                              print("Error for delete : $e");
                            }
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Colors.deepOrangeAccent,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class social extends StatelessWidget {
  const social({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    String uid = user!.uid;
    final screenSize = MediaQuery.of(context).size;
    final width = screenSize.width;
    final height = screenSize.height;
    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(right: 56.0),
          child: Center(
            child: Text(
              '${_doList[5]}',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic),
            ),
          ),
        ),
        backgroundColor: Colors.indigo,
      ),
      backgroundColor: Colors.indigo.shade300,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(uid) // Replace with the specific user ID
            .collection('Types')
            .doc(_doList[5])
            .collection("Categories")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No data available'));
          }

          // Extract data from snapshot
          final documents = snapshot.data!.docs;

          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final data = documents[index].data() as Map<String, dynamic>;

              return Container(
                margin: EdgeInsets.all(8.0),
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Category: ${data['Categories'] ?? 'No Category'}',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Description: ${data['Discription'] ?? 'No Description'}',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Date: ${data['Dou Date'] ?? 'No Date'}',
                      style: TextStyle(fontSize: 16),
                    ),
                    Row(
                      children: [
                        Text(
                          'Time: ${data['Dou Time'] ?? 'No Time'}',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(
                          width: width * 0.55,
                        ),
                        IconButton(
                          onPressed: () async {
                            try {
                              await FirebaseFirestore.instance
                                  .collection("Users")
                                ..doc(uid)
                                    .collection("Types")
                                    .doc(_doList[5])
                                    .collection("Categories")
                                    .doc(documents[index].id)
                                    .delete();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text('Deleted successfully')));
                            } catch (e) {
                              print("Error for delete : $e");
                            }
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Colors.deepOrangeAccent,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class financial extends StatelessWidget {
  const financial({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    String uid = user!.uid;
    final screenSize = MediaQuery.of(context).size;
    final width = screenSize.width;
    final height = screenSize.height;
    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(right: 56.0),
          child: Center(
            child: Text(
              '${_doList[6]}',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic),
            ),
          ),
        ),
        backgroundColor: Colors.indigo,
      ),
      backgroundColor: Colors.indigo.shade300,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(uid) // Replace with the specific user ID
            .collection('Types')
            .doc(_doList[6])
            .collection("Categories")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No data available'));
          }

          // Extract data from snapshot
          final documents = snapshot.data!.docs;

          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final data = documents[index].data() as Map<String, dynamic>;

              return Container(
                margin: EdgeInsets.all(8.0),
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Category: ${data['Categories'] ?? 'No Category'}',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Description: ${data['Discription'] ?? 'No Description'}',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Date: ${data['Dou Date'] ?? 'No Date'}',
                      style: TextStyle(fontSize: 16),
                    ),
                    Row(
                      children: [
                        Text(
                          'Time: ${data['Dou Time'] ?? 'No Time'}',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(
                          width: width * 0.55,
                        ),
                        IconButton(
                          onPressed: () async {
                            try {
                              await FirebaseFirestore.instance
                                  .collection("Users")
                                ..doc(uid)
                                    .collection("Types")
                                    .doc(_doList[6])
                                    .collection("Categories")
                                    .doc(documents[index].id)
                                    .delete();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text('Deleted successfully')));
                            } catch (e) {
                              print("Error for delete : $e");
                            }
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Colors.deepOrangeAccent,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class long extends StatelessWidget {
  const long({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    String uid = user!.uid;
    final screenSize = MediaQuery.of(context).size;
    final width = screenSize.width;
    final height = screenSize.height;
    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(right: 56.0),
          child: Center(
            child: Text(
              '${_doList[7]}',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic),
            ),
          ),
        ),
        backgroundColor: Colors.indigo,
      ),
      backgroundColor: Colors.indigo.shade300,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(uid) // Replace with the specific user ID
            .collection('Types')
            .doc(_doList[7])
            .collection("Categories")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No data available'));
          }

          // Extract data from snapshot
          final documents = snapshot.data!.docs;

          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final data = documents[index].data() as Map<String, dynamic>;

              return Container(
                margin: EdgeInsets.all(8.0),
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Category: ${data['Categories'] ?? 'No Category'}',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Description: ${data['Discription'] ?? 'No Description'}',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Date: ${data['Dou Date'] ?? 'No Date'}',
                      style: TextStyle(fontSize: 16),
                    ),
                    Row(
                      children: [
                        Text(
                          'Time: ${data['Dou Time'] ?? 'No Time'}',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(
                          width: width * 0.55,
                        ),
                        IconButton(
                          onPressed: () async {
                            try {
                              await FirebaseFirestore.instance
                                  .collection("Users")
                                ..doc(uid)
                                    .collection("Types")
                                    .doc(_doList[7])
                                    .collection("Categories")
                                    .doc(documents[index].id)
                                    .delete();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text('Deleted successfully')));
                            } catch (e) {
                              print("Error for delete : $e");
                            }
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Colors.deepOrangeAccent,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
