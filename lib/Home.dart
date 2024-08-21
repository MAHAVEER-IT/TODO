import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todo/mainPage/navbar.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  void _onTabChange(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final widh = screenSize.width;
    final height = screenSize.height;
    return Scaffold(
      drawer: NavBar(),
      bottomNavigationBar: GNav(
        onTabChange: _onTabChange,
        tabs: [
          GButton(
            gap: 8,
            icon: Icons.home,
            text: 'Home',
            iconSize: 30,
          ),
          GButton(
            gap: 8,
            icon: Icons.add_circle_outlined,
            text: 'ADD',
            iconSize: 30,
          ),
          GButton(
            gap: 8,
            icon: Icons.done_all,
            text: 'View All',
            iconSize: 30,
          ),
        ],
        activeColor: Colors.white,
        color: Colors.white70,
        backgroundColor: Colors.indigo,
      ),
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(right: 56.0),
          child: Center(
            child: Text(
              'TODO',
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
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          HomeIndex(),
          AddIndex(),
          ViewList(),
        ],
      ),
    );
  }
}

class HomeIndex extends StatefulWidget {
  @override
  State<HomeIndex> createState() => _HomeIndexState();
}

class _HomeIndexState extends State<HomeIndex> {
  DateTime today = DateTime.now();
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final width = screenSize.width;
    final height = screenSize.height;
    return Scaffold(
      backgroundColor: Colors.indigo.shade300,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            content(),
            SizedBox(
              height: 8,
            ),
            Container(
                width: width * 0.8,
                decoration: BoxDecoration(
                    color: Colors.indigo.shade200,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Center(
                    child: Text(
                  'TODAYS TASKS',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ))),
            SizedBox(
              height: 8,
            ),
            body(),
          ],
        ),
      ),
    );
  }

  Widget content() {
    final screenSize = MediaQuery.of(context).size;
    final width = screenSize.width;
    final height = screenSize.height;
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        height: height * 0.3,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(40)),
          color: Colors.indigo.shade100,
        ),
        child: TableCalendar(
          focusedDay: today,
          firstDay: DateTime.utc(1990, 1, 1),
          lastDay: DateTime.utc(2100, 1, 1),
          rowHeight: height * 0.038,
          headerStyle:
              HeaderStyle(formatButtonVisible: false, titleCentered: true),
          calendarStyle: CalendarStyle(
              defaultTextStyle: TextStyle(color: Colors.black),
              todayTextStyle: TextStyle(color: Colors.black),
              weekendTextStyle: TextStyle(color: Colors.redAccent.shade100),
              selectedTextStyle: TextStyle(color: Colors.indigo)),
        ),
      ),
    );
  }

  Widget body() {
    final screenSize = MediaQuery.of(context).size;
    final width = screenSize.width;
    final height = screenSize.height;
    User? user = FirebaseAuth.instance.currentUser;
    String? uid = user?.uid;
    DateTime? today = DateTime.now();
    Map<String, bool> isChekedState = {};

    void singletap() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.indigo.shade200,
            child: Container(
              height: 100,
              width: width,
              child: Center(
                child: Text(
                  'FINISH YOUR TASK DOUBLE TAP TO REMOVE',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 16),
                ),
              ),
            ),
          );
        },
      );
    }

    void doubleTap(var type, var uid, var docId) {
      Future.delayed(Duration(seconds: 1), () {
        FirebaseFirestore.instance
            .collection('Users')
            .doc(uid)
            .collection('Types')
            .doc(type)
            .collection('Categories')
            .doc(docId)
            .delete();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Your Task will be deleted'),
        ),
      );
    }

    return Column(
      children: _doList.map((type) {
        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Users')
              .doc(uid)
              .collection('Types')
              .doc(type)
              .collection("Categories")
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            // Extract data from snapshot
            final documents = snapshot.data!.docs;

            return ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: documents.length,
              itemBuilder: (context, index) {
                final data = documents[index].data() as Map<String, dynamic>;
                final docID = documents[index].id;

                String todayListhome = data['Dou Date'];

                if (todayListhome ==
                    '${today.day}-${today.month}-${today.year}') {
                  bool isCheked = isChekedState[docID] ?? false;
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
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Description: ${data['Discription'] ?? 'No Description'}',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    decoration: isCheked
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none),
                              ),
                            ),
                            SizedBox(
                              width: 70,
                            ),
                            GestureDetector(
                              onTap: () {
                                singletap();
                              },
                              onDoubleTap: () {
                                doubleTap(type, uid, docID);
                              },
                              child: Icon(
                                Icons.touch_app_outlined,
                                size: 40,
                              ),
                            )
                          ],
                        ),
                        Text(
                          'Category: ${data['Categories'] ?? 'No Category'}',
                          style: TextStyle(
                              fontSize: 16,
                              decoration: isCheked
                                  ? TextDecoration.underline
                                  : TextDecoration.none),
                        ),
                      ],
                    ),
                  );
                } else {
                  return SizedBox.shrink();
                }
              },
            );
          },
        );
      }).toList(),
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

class AddIndex extends StatefulWidget {
  @override
  State<AddIndex> createState() => _AddIndexState();
}

class _AddIndexState extends State<AddIndex> {
  TextEditingController _discribtion = TextEditingController();
  String? _selectedItem = 'Select any option';
  DateTime? _remindDay;
  TimeOfDay? _reminTime;
  String? _errormessage;

  void _showDate() async {
    DateTime? piked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2100));

    if (piked != null) {
      TimeOfDay? pikedTime =
          await showTimePicker(context: context, initialTime: TimeOfDay.now());
      setState(() {
        _remindDay = piked;
        if (pikedTime != null) {
          setState(() {
            _reminTime = pikedTime;
          });
        }
      });
    }
  }

  Future<void> toDo() async {
    User? user = FirebaseAuth.instance.currentUser;

    String? uid = user?.uid;
    try {
      if (_selectedItem != 'Select any option' &&
          _reminTime != null &&
          _remindDay != null) {
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(uid)
            .collection('Types')
            .doc(_selectedItem)
            .collection('Categories')
            .add({
          "Categories": _selectedItem,
          "Discription": _discribtion.text,
          "Dou Date":
              "${_remindDay?.day}-${_remindDay?.month}-${_remindDay?.year}",
          "Dou Time": "${_reminTime?.hour}:${_reminTime?.minute}"
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Your Work is Added.'),
          ),
        );
        print('Successfully insert');
      } else {
        print('Some is null');
      }
      print("try");
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Fail to added work : $e.'),
        ),
      );
      print("Can not insert data's ");
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final width = screenSize.width;
    final height = screenSize.height;
    return Scaffold(
      backgroundColor: Colors.indigo.shade300,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: height * 0.04,
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: height * 0.28,
                width: width * 0.95,
                decoration: BoxDecoration(
                  color: Colors.indigo.shade200,
                  borderRadius: BorderRadius.all(
                    Radius.circular(0),
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.note_alt_outlined,
                      size: 160,
                      color: Colors.white,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        'Write a note on top of your list that connects you to your vision or goals',
                        style: TextStyle(
                            color: Colors.white,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: height * 0.04,
            ),
            Padding(
              padding: EdgeInsets.zero,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                  color: Colors.indigo.shade200,
                ),
                width: 300,
                child: Center(
                  child: DropdownButton<String>(
                      hint: Text('${_selectedItem}'),
                      items: _doList.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newvalue) {
                        setState(() {
                          _selectedItem = newvalue;
                        });
                      }),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(33.0),
              child: Container(
                width: width * 0.85,
                child: Form(
                  child: TextField(
                    controller: _discribtion,
                    decoration: InputDecoration(
                      hintText: 'Enter your Tasks',
                      label: Text(
                        'Description',
                        style: TextStyle(color: Colors.black, fontSize: 15),
                      ),
                      border: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.white70, width: 10),
                      ),
                      focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 2)),
                      enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.white70, width: 1.5),
                      ),
                      errorText: _errormessage,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.zero,
              child: GestureDetector(
                onTap: () {
                  _showDate();
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  height: 50,
                  width: 230,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                    color: Colors.indigo.shade200,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_remindDay == null)
                        Text(
                          'Select Dou Date and Time',
                          style: TextStyle(fontSize: 15),
                        ),
                      if (_remindDay?.day != null && _remindDay?.month != null)
                        Text(
                          '${_remindDay?.day} - ${_remindDay?.month} - ${_remindDay?.year} ',
                          style: TextStyle(fontSize: 15),
                        ),
                      if (_remindDay?.day != null && _remindDay?.month != null)
                        Text(
                          ' & ',
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      if (_reminTime?.hour != null &&
                          _reminTime?.minute != null)
                        Text(
                          '${_reminTime?.hour} : ${_reminTime?.minute}' ??
                              'select Time',
                          style:
                              TextStyle(fontSize: 15, color: Colors.redAccent),
                        ),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(
                        Icons.watch_later,
                        color: Colors.black54,
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: height * 0.04,
            ),
            SizedBox(
              width: width * 0.35,
              height: height * 0.04,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                ),
                onPressed: () {
                  if (_selectedItem != 'Select any option' &&
                      _reminTime != null &&
                      _remindDay != null &&
                      _discribtion.text.length != 0) {
                    toDo();
                    _discribtion.clear();
                  }
                  if (_discribtion.text.length == 0) {
                    _errormessage = 'Please Enter Description';
                  }
                  if (_selectedItem == 'Select any option') {
                    Fluttertoast.showToast(
                        msg: 'Please Select Any Option',
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.SNACKBAR,
                        backgroundColor: Colors.black54,
                        textColor: Colors.white,
                        fontSize: 14);
                  }
                  if (_reminTime == null || _remindDay == null) {
                    Fluttertoast.showToast(
                        msg: 'Please Select Date and Time',
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.SNACKBAR,
                        backgroundColor: Colors.black54,
                        textColor: Colors.white,
                        fontSize: 14);
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Add',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: width * 0.05,
                    ),
                    Icon(Icons.add_circle_outline)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ViewList extends StatefulWidget {
  const ViewList({super.key});

  @override
  State<ViewList> createState() => _ViewListState();
}

class _ViewListState extends State<ViewList> {
  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    User? user = FirebaseAuth.instance.currentUser;
    String? uid = user?.uid;
    final screenSize = MediaQuery.of(context).size;
    final width = screenSize.width;
    final height = screenSize.height;
    return Scaffold(
      backgroundColor: Colors.indigo.shade300,
      body: uid == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                children: _doList.map((type) {
                  return StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('Users')
                        .doc(uid)
                        .collection('Types')
                        .doc(type)
                        .collection("Categories")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }

                      // Extract data from snapshot
                      final documents = snapshot.data!.docs;

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: documents.length,
                        itemBuilder: (context, index) {
                          final data =
                              documents[index].data() as Map<String, dynamic>;

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
                              children: [
                                Text(
                                  'Category: ${data['Categories'] ?? 'No Category'}',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
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
                                                .doc(type)
                                                .collection("Categories")
                                                .doc(documents[index].id)
                                                .delete();
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      'Deleted successfully')));
                                        } catch (e) {
                                          print("Error for delete : $e");
                                        }
                                      },
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.deepOrangeAccent,
                                        size: 30,
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
                  );
                }).toList(),
              ),
            ),
    );
  }
}
