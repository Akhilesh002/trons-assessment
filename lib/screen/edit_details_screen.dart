import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:trons_assesment/bloc/details_bloc.dart';
import 'package:trons_assesment/screen/home_screen.dart';

class EditDetailsScreen extends StatefulWidget {
  final String? timeSlot;
  final String? firstName;
  final String? lastName;
  final String? mobile;

  const EditDetailsScreen({@required this.timeSlot, this.firstName, this.lastName, this.mobile, Key? key}) : super(key: key);

  @override
  _EditDetailsScreenState createState() => _EditDetailsScreenState();
}

class _EditDetailsScreenState extends State<EditDetailsScreen> {
  final DetailsBloc bloc = DetailsBloc();
  String? timeSlot;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();

  @override
  void initState() {
    super.initState();
    timeSlot = widget.timeSlot;
    if (widget.firstName != null) {
      firstNameController.text = widget.firstName.toString();
      lastNameController.text = widget.lastName.toString();
      mobileController.text = widget.mobile.toString();
      bloc.observeFirstName.add(firstNameController.text);
      bloc.observeLastName.add(lastNameController.text);
      bloc.observeMobile.add(mobileController.text);
    }
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Details Screen'),
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
            height: MediaQuery.of(context).size.height - kToolbarHeight - 0.0,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5.0),
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.0),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: StreamBuilder(
                    stream: bloc.firstName,
                    builder: (context, snapshot) {
                      return TextFormField(
                        controller: firstNameController,
                        keyboardType: TextInputType.name,
                        onChanged: (value) {
                          bloc.observeFirstName.add(value);
                        },
                        decoration: InputDecoration(
                          hintText: 'First Name',
                          border: InputBorder.none,
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5.0),
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.0),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: StreamBuilder(
                    stream: bloc.lastName,
                    builder: (context, snapshot) {
                      return TextFormField(
                        controller: lastNameController,
                        keyboardType: TextInputType.name,
                        onChanged: (value) {
                          bloc.observeLastName.add(value);
                        },
                        decoration: InputDecoration(
                          hintText: 'Last Name',
                          border: InputBorder.none,
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5.0),
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.0),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: StreamBuilder<String>(
                    stream: bloc.mobile,
                    builder: (context, snapshot) {
                      return TextFormField(
                        controller: mobileController,
                        maxLength: 10,
                        keyboardType: TextInputType.phone,
                        onChanged: (value) {
                          bloc.observeMobile.add(value);
                        },
                        decoration: InputDecoration(
                          hintText: 'Phone Number',
                          border: InputBorder.none,
                        ),
                      );
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                      },
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                        ),
                        padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0)),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(fontSize: 17.0),
                      ),
                    ),
                    StreamBuilder(
                      stream: bloc.submit,
                      builder: (context, snapshot) {
                        return ElevatedButton(
                          onPressed: () async {
                            String? firstName = bloc.getFirstName();
                            String? lastName = bloc.getLastname();
                            String? mobile = bloc.getMobile();
                            if (firstName != null &&
                                firstName.trim().isNotEmpty &&
                                lastName != null &&
                                lastName.trim().isNotEmpty &&
                                mobile != null &&
                                mobile.trim().isNotEmpty) {
                              saveData(timeSlot: timeSlot, firstName: firstName, lastName: lastName, mobile: mobile);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('All fields are mandatory')));
                            }
                          },
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              ),
                            ),
                            padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0)),
                          ),
                          child: Text(
                            'Okay',
                            style: TextStyle(fontSize: 17.0),
                          ),
                        );
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<String> getJson() {
    return rootBundle.loadString('assets/data.json');
  }

  saveData({@required String? timeSlot, @required String? firstName, @required String? lastName, @required String? mobile}) async {
    File file = await localFile;
    bool isFile = await file.exists();
    String dataStr;
    var jsonData;
    if (isFile) {
      dataStr = await file.readAsString();
      print(dataStr);
      print(jsonDecode(jsonDecode(dataStr)['data']));
      jsonData = jsonDecode(jsonDecode(dataStr)['data']);
      print('before writing: ${jsonData.runtimeType}');
    } else {
      dataStr = await getJson();
      jsonData = jsonDecode(dataStr)['data'];
    }

    print('before writing: $jsonData');
    if (jsonData.containsKey(timeSlot)) {
      Map<String, dynamic> map = jsonData[timeSlot];
      map = {'firstName': firstName, 'lastName': lastName, 'mobile': mobile};
      jsonData[timeSlot] = map;
      print('after writing: $jsonData');
      Map<String, dynamic> data = {'data': jsonEncode(jsonData)};
      print('after writing: $data');
      writeData(data).then((value) => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen())));
    }
  }

  Future<String> get localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get localFile async {
    final path = await localPath;
    return File('$path/data.json');
  }

  Future<File> writeData(Map<String, dynamic> map) async {
    final file = await localFile;
    // Write the file
    return file.writeAsString(jsonEncode(map), mode: FileMode.write);
  }
}
