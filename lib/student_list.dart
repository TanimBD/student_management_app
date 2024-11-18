import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'student_form.dart';
import 'package:url_launcher/url_launcher.dart';

class StudentList extends StatefulWidget {
  @override
  _StudentListState createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Students'),
      ),
      body: FutureBuilder<List<Student>>(
        future: DBHelper.instance.getStudents(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final student = snapshot.data![index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(student.name, style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 5),
                        Text('ID: ${student.id}', style: TextStyle(color: Colors.grey)),
                        Text('Phone: ${student.phone}', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => StudentForm(student: student),
                              ),
                            ).then((value) {
                              setState(() {});
                            });
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () async {
                            await DBHelper.instance.deleteStudent(student.id!);
                            setState(() {});
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.call),
                          onPressed: () async {
                            final url = 'tel:${student.phone}';
                            if (await canLaunch(url)) {
                              await launch(url);
                            } else {
                              throw 'Could not launch $url';
                            }
                          },
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
