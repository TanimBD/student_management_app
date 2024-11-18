import 'package:flutter/material.dart';
import 'db_helper.dart';

class StudentForm extends StatefulWidget {
  final Student? student;

  StudentForm({this.student});

  @override
  _StudentFormState createState() => _StudentFormState();
}

class _StudentFormState extends State<StudentForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _idController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.student != null) {
      _nameController.text = widget.student!.name;
      _idController.text = widget.student!.id!.toString();
      _emailController.text = widget.student!.email;
      _phoneController.text = widget.student!.phone;
      _locationController.text = widget.student!.location;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.student == null ? 'Add Student' : 'Update Student'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _idController,
                  decoration: InputDecoration(labelText: 'Student ID'),
                  enabled: widget.student == null,
                ),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Student Name'),
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(labelText: 'Phone'),
                ),
                TextFormField(
                  controller: _locationController,
                  decoration: InputDecoration(labelText: 'Location'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final student = Student(
                        id: widget.student?.id ?? int.parse(_idController.text),
                        name: _nameController.text,
                        email: _emailController.text,
                        phone: _phoneController.text,
                        location: _locationController.text,
                      );
                      if (widget.student == null) {
                        await DBHelper.instance.addStudent(student);
                      } else {
                        await DBHelper.instance.updateStudent(student);
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Student saved!')),
                      );
                      Navigator.pop(context);
                    }
                  },
                  child: Text('Save/Update'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
