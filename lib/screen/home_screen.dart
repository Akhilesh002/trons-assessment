import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:trons_assesment/model/user_model.dart';
import 'package:trons_assesment/screen/edit_details_screen.dart';
import 'package:trons_assesment/util/constant.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<UserModel> data = [];
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    File file = File('$path/data.json');
    bool isFile = await file.exists();
    var jsonData;
    if (isFile) {
      jsonData = jsonDecode(jsonDecode(await file.readAsString())['data']);
      print(jsonData);
      jsonData.forEach((key, value) {
        if (value.isNotEmpty) {
          data.add(UserModel(value['firstName'], value['lastName'], value['mobile'], key));
        } else {
          data.add(UserModel('', '', '', key));
        }
      });
      setState(() {});
    } else {
      jsonData = jsonDecode(await rootBundle.loadString('assets/data.json'))['data'];
      jsonData.forEach((key, value) {
        if (value.isNotEmpty) {
          data.add(UserModel(value['firstName'], value['lastName'], value['mobile'], key));
        } else {
          data.add(UserModel('', '', '', key));
        }
      });
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Home'),
        ),
        body: SingleChildScrollView(
          child: Container(
            // margin: EdgeInsets.only(bottom: 20.0),
            height: MediaQuery.of(context).size.height - 85,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height - 200.0,
                  width: MediaQuery.of(context).size.width,
                  child: data.length == 0
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : ListView.builder(
                          itemCount: Constant.hourList.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.all(5.0),
                              child: Card(
                                elevation: 5.0,
                                color: Constant.hourList[index] == data[index].timeSlot && data[index].firstName.isNotEmpty
                                    ? Colors.red
                                    : Colors.white,
                                child: Constant.hourList[index] == data[index].timeSlot && data[index].firstName.isNotEmpty
                                    ? ListTile(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        tileColor: Colors.red,
                                        title: Text('${data[index].firstName} ${data[index].lastName}'),
                                        subtitle: Text('${data[index].mobile}'),
                                        trailing: Text(data[index].timeSlot),
                                        onTap: () {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => EditDetailsScreen(
                                                timeSlot: Constant.hourList[index],
                                                firstName: data[index].firstName,
                                                lastName: data[index].lastName,
                                                mobile: data[index].mobile,
                                              ),
                                            ),
                                          );
                                        },
                                      )
                                    : ListTile(
                                        title: Center(
                                          child: Text(Constant.hourList[index]),
                                        ),
                                        onTap: () {
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => EditDetailsScreen(timeSlot: Constant.hourList[index])));
                                        },
                                      ),
                              ),
                            );
                          },
                        ),
                ),
                Container(
                  height: 60.0,
                  width: 150.0,
                  child: ElevatedButton(
                    onPressed: () async {
                      final PickedFile? pickedFile = await picker.getImage(source: ImageSource.gallery);
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                      ),
                      padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0)),
                    ),
                    child: Text('Open Gallery'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
