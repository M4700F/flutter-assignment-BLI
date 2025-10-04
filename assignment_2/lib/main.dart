import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student ID Card Generator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const StudentFormScreen(),
    );
  }
}

class StudentData {
  String studentId;
  String studentName;
  String program;
  String department;
  Uint8List? profileImageBytes;

  StudentData({
    required this.studentId,
    required this.studentName,
    required this.program,
    required this.department,
    this.profileImageBytes,
  });
}

class StudentFormScreen extends StatefulWidget {
  final StudentData? initialData;

  const StudentFormScreen({super.key, this.initialData});

  @override
  State<StudentFormScreen> createState() => _StudentFormScreenState();
}

class _StudentFormScreenState extends State<StudentFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _studentIdController = TextEditingController();
  final _studentNameController = TextEditingController();
  final _programController = TextEditingController();
  final _departmentController = TextEditingController();
  Uint8List? _profileImageBytes;

  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      _studentIdController.text = widget.initialData!.studentId;
      _studentNameController.text = widget.initialData!.studentName;
      _programController.text = widget.initialData!.program;
      _departmentController.text = widget.initialData!.department;
      _profileImageBytes = widget.initialData!.profileImageBytes;
    }
  }

  @override
  void dispose() {
    _studentIdController.dispose();
    _studentNameController.dispose();
    _programController.dispose();
    _departmentController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _profileImageBytes = bytes;
      });
    }
  }

  void _generateIDCard() {
    if (_formKey.currentState!.validate()) {
      final studentData = StudentData(
        studentId: _studentIdController.text,
        studentName: _studentNameController.text,
        program: _programController.text,
        department: _departmentController.text,
        profileImageBytes: _profileImageBytes,
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => StudentIDCardDisplay(studentData: studentData),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const Text('Student ID Card Generator'),
        backgroundColor: const Color(0xFF0D3B2E),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Profile Picture Selection
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: 150,
                    height: 180,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF0D3B2E),
                        width: 2,
                      ),
                    ),
                    child: _profileImageBytes != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.memory(
                              _profileImageBytes!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_a_photo,
                                size: 50,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Tap to add photo',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Student ID Field
              TextFormField(
                controller: _studentIdController,
                decoration: InputDecoration(
                  labelText: 'Student ID',
                  prefixIcon: const Icon(Icons.key),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter student ID';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Student Name Field
              TextFormField(
                controller: _studentNameController,
                decoration: InputDecoration(
                  labelText: 'Student Name',
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter student name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Program Field
              TextFormField(
                controller: _programController,
                decoration: InputDecoration(
                  labelText: 'Program',
                  hintText: 'e.g., B.Sc. in CSE',
                  prefixIcon: const Icon(Icons.school),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter program';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Department Field
              TextFormField(
                controller: _departmentController,
                decoration: InputDecoration(
                  labelText: 'Department',
                  hintText: 'e.g., CSE',
                  prefixIcon: const Icon(Icons.auto_stories),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter department';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),

              // Generate Button
              ElevatedButton(
                onPressed: _generateIDCard,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D3B2E),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Generate ID Card',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StudentIDCardDisplay extends StatelessWidget {
  final StudentData studentData;

  const StudentIDCardDisplay({super.key, required this.studentData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const Text('Student ID Card'),
        backgroundColor: const Color(0xFF0D3B2E),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      StudentFormScreen(initialData: studentData),
                ),
              );
            },
            tooltip: 'Edit',
          ),
        ],
      ),
      body: Center(
        child: Container(
          width: 350,
          height: 600,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Stack(
            children: [
              Column(
                children: [
                  // Top dark green header
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: const BoxDecoration(
                      color: Color(0xFF0D3B2E),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/IUT.png'),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            'ISLAMIC UNIVERSITY OF TECHNOLOGY',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.8,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 50),
                      ],
                    ),
                  ),

                  // Student information
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 100),
                          _buildInfoRow(
                            Icons.key,
                            'Student ID',
                            studentData.studentId,
                            isHighlighted: true,
                          ),
                          const SizedBox(height: 8),
                          _buildInfoRow(
                            Icons.person,
                            'Student Name',
                            studentData.studentName,
                            isName: true,
                          ),
                          const SizedBox(height: 8),
                          _buildInfoRowHorizontal(
                            Icons.school,
                            'Program',
                            studentData.program,
                          ),
                          const SizedBox(height: 8),
                          _buildInfoRowHorizontal(
                            Icons.auto_stories,
                            'Department',
                            studentData.department,
                          ),
                          const SizedBox(height: 8),
                          _buildInfoRow(
                            Icons.location_on,
                            'Bangladesh',
                            '',
                            isSingleLine: true,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Bottom footer
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: const BoxDecoration(
                      color: Color(0xFF0D3B2E),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'A subsidiary organ of OIC',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w300,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),

              // Profile image
              Positioned(
                top: 135,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    width: 130,
                    height: 160,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFF0D3B2E),
                        width: 3,
                      ),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: studentData.profileImageBytes != null
                        ? Image.memory(
                            studentData.profileImageBytes!,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            color: Colors.grey[300],
                            child: const Icon(
                              Icons.person,
                              size: 80,
                              color: Colors.grey,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value, {
    bool isHighlighted = false,
    bool isName = false,
    bool isSingleLine = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: isHighlighted ? const Color(0xFF0D3B2E) : Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 18,
            color: isHighlighted ? Colors.white : const Color(0xFF0D3B2E),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: isSingleLine
              ? Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[800],
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    isHighlighted
                        ? Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0D3B2E),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              value,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 0.8,
                              ),
                            ),
                          )
                        : Text(
                            value,
                            style: TextStyle(
                              fontSize: isName ? 15 : 14,
                              fontWeight: isName
                                  ? FontWeight.bold
                                  : FontWeight.w600,
                              color: Colors.black87,
                              letterSpacing: isName ? 0.3 : 0,
                            ),
                          ),
                  ],
                ),
        ),
      ],
    );
  }

  Widget _buildInfoRowHorizontal(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(3),
          decoration: const BoxDecoration(
            color: Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 18, color: const Color(0xFF0D3B2E)),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[800],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}
