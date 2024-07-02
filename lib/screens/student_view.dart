import 'package:fire_base/screens/model/student_model.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class StudentView extends StatefulWidget {
  const StudentView({super.key});

  @override
  State<StudentView> createState() => _StudentViewState();
}

class _StudentViewState extends State<StudentView> {

  DatabaseReference dbRef = FirebaseDatabase.instance.ref();

  final TextEditingController _nameController =TextEditingController();
  final TextEditingController _ageController =TextEditingController();
  final TextEditingController _subjectController =TextEditingController();

  List<Student> studentList = List.empty(growable: true);

  bool updateStudent = false;

  @override
  void initState() {
    initBackgroundData();
    super.initState();
  }

  

  Future<void> initBackgroundData() async {
     dbRef.child("Student").onChildAdded.listen((data) {
        StudentData studentData = StudentData.fromJson(data.snapshot.value as Map);
        Student student = Student(key: data.snapshot.key, studentData: studentData);
        studentList.add(student);
        setState(() {
          
        });
     });
  }

  @override
  void dispose() {
    dbRef.onDisconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Student"),
      ),
      body: Container(
        child: ListView.builder(
          itemCount: studentList.length,
          itemBuilder: (context, index) {
            return studentView(studentList[index]); 
        },),
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        _nameController.text = "";
        _ageController.text = "";
        _subjectController.text = "";
        updateStudent = false;
        studentDialog();
      }, child: const Icon(Icons.save)),
    );
  }
  
  void studentDialog({String key = ""}) {
    showDialog(context: context, builder: (context) {
      return Dialog(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child:  Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  helperText: "Name"
                ),
              ),
               TextField(
                controller: _ageController,
                decoration: const InputDecoration(
                  helperText: "Age"
                ),
              ),
               TextField(
                controller: _subjectController,
                decoration: const InputDecoration(
                  helperText: "Subject"
                ),
              ),
              const SizedBox(height: 5.0),
              ElevatedButton(
                onPressed: () async {
                  pushDataToDBRT(key: key);
                },
                child: Text( updateStudent ? "Update data" : "Save data"),
              )
            ],
          ),
        ),
      );
    });
  }
  void pushDataToDBRT({String key = ""}) {
    Map<String, dynamic> data = {
      "name": _nameController.text.toString(),
      "age": _ageController.text.toString(),
      "subject": _subjectController.text.toString()
    };

    if (updateStudent) {
      dbRef.child("Student").child(key).update(data).then((value) {
        int index = studentList.indexWhere((element) => element.key == key);
        if (index > -1) {
          studentList.removeAt(index);
          studentList.insert(index, Student(key: key, studentData: StudentData.fromJson(data)));
          setState(() {
            
          });
        }
        Navigator.of(context).pop();
      });
    } else {
      dbRef.child("Student").push().set(data).then((value) {
        Navigator.of(context).pop();
      });
    }

  }
  
  Widget studentView(Student student) {
    return InkWell(
      onTap:(){
        _nameController.text = student.studentData!.name ?? "";
        _ageController.text = student.studentData!.age ?? "";
        _subjectController.text = student.studentData!.subject ?? "";
        updateStudent = true;
        studentDialog(key: student.key ?? "");
      },
      child: Container(
        width: MediaQuery.sizeOf(context).width,
        padding: const EdgeInsets.all(5.0),
        margin: const EdgeInsets.only(top: 5.0, left: 5.0, right: 5.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(width: 1, color: Colors.black)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(student.studentData?.name ?? ""),
                Text(student.studentData?.age ?? ""),
                Text(student.studentData?.subject ?? ""),
              ],
            ),
            IconButton(
              onPressed: () {
                dbRef.child("Student").child(student.key ?? "").remove().then((value) {
                  studentList.removeWhere((element) => element.key == student.key);
                  setState(() {
                    
                  });
                });
              },
              icon: const Icon(Icons.delete, size: 23, color: Colors.black)
            ),
          ],
        )
      ),
    );
  }
}
