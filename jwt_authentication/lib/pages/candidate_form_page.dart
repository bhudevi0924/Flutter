import 'package:flutter/material.dart';
import 'package:jwt_authentication/main.dart';
import 'package:jwt_authentication/model/candidate.dart';
import 'package:jwt_authentication/model/jwt_response.dart';
import 'package:jwt_authentication/services/api_service.dart';

class CandidateFormPage extends StatefulWidget {

  const CandidateFormPage({super.key});

  @override
  _CandidateFormPageState createState() => _CandidateFormPageState();
}

class _CandidateFormPageState extends State<CandidateFormPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _idNoController = TextEditingController();
  final _collegeController = TextEditingController();
  final _departmentController = TextEditingController();
  final _graduationYearController = TextEditingController();
  final _percentageController = TextEditingController();

  String? _selectedGender;
  String? _selectedIdType;
  String? _selectedDegree;

  final List<String> genders = ['Male', 'Female', 'Other'];
  final List<String> idTypes = ['Aadhar', 'PAN', 'Passport'];
  final List<String> degrees = ['B.Tech', 'M.Tech', 'B.Sc', 'M.Sc'];

  handleSubmit() async{
    if (_formKey.currentState!.validate()) {
      Candidate candidate = Candidate(
        name: _nameController.text,
        email: _emailController.text,
        phoneNo: _mobileController.text,
        degree: _selectedDegree!,
        collegeName: _collegeController.text,
        department: _departmentController.text,
        graduationYear: int.parse(_graduationYearController.text),
        percentage: double.parse(_percentageController.text),
        genderId: 9,
        govtUIDTypeId: 21,
        govtUID: _idNoController.text,
        testcodeId: 115,
        currentlyWorking: false
      );

      try {
        JwtResponse response = await ApiService.saveCandidate(candidate);
        print("response $response");
        print("token ${response.token}");
        await storage.write(key: "token", value: response.token);
        await storage.write(key: "refresh token", value: response.refreshToken);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Candidate saved. JWT: ${response.token} ******* ${response.candidateId}')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Candidate Form')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Wrap(
              runSpacing: 16,
              spacing: 20,
              children: [
                _buildTextField(_nameController, 'Full Name', hint: 'E.g. Bhudevi'),
                _buildDropdown('Gender', genders, _selectedGender,
                    (value) => setState(() => _selectedGender = value)),
                _buildTextField(_emailController, 'Email Id', hint: 'E.g. bhudevi@gmail.com'),
                _buildTextField(_mobileController, 'Mobile No', hint: 'E.g. 7894568794', keyboardType: TextInputType.phone),
                _buildDropdown('Id Type', idTypes, _selectedIdType,
                    (value) => setState(() => _selectedIdType = value)),
                _buildTextField(_idNoController, 'Id No', hint: 'E.g. 1234567890'),
                _buildDropdown('Degree', degrees, _selectedDegree,
                    (value) => setState(() => _selectedDegree = value)),
                _buildTextField(_collegeController, 'College Name', hint: 'E.g. ABC'),
                _buildTextField(_departmentController, 'Department', hint: 'E.g. EEE'),
                _buildTextField(_graduationYearController, 'Year of Graduation', hint: 'E.g. 2022', keyboardType: TextInputType.number),
                _buildTextField(_percentageController, 'Percentage/GPA', hint: 'E.g. 99.99', keyboardType: TextInputType.numberWithOptions(decimal: true)),

                SizedBox(height: 24),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // handle submission here
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Form Submitted')));
                        handleSubmit();
                      }
                    },
                    child: Text('Continue'),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {String? hint, TextInputType keyboardType = TextInputType.text}) {
    return SizedBox(
      width: 300,
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: '$label *',
          hintText: hint,
          border: OutlineInputBorder(),
        ),
        validator: (value) =>
            (value == null || value.isEmpty) ? 'Please enter $label' : null,
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> items, String? selectedValue,
      void Function(String?) onChanged) {
    return SizedBox(
      width: 300,
      child: DropdownButtonFormField<String>(
        value: selectedValue,
        decoration: InputDecoration(
          labelText: '$label *',
          border: OutlineInputBorder(),
        ),
        items: items
            .map((item) => DropdownMenuItem(value: item, child: Text(item)))
            .toList(),
        onChanged: onChanged,
        validator: (value) =>
            (value == null || value.isEmpty) ? 'Please select $label' : null,
      ),
    );
  }
}
