import 'dart:io';
// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:image_picker/image_picker.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:permission_handler/permission_handler.dart';


// ignore: camel_case_types
class insert extends StatefulWidget {
  const insert({Key? key}) : super(key: key);

  @override
  _insertState createState() => _insertState();
}

// ignore: camel_case_types
class _insertState extends State<insert> {
  // ignore: non_constant_identifier_names
  uploadImage() async {
    final _firebaseStorage = FirebaseStorage.instance;
    final _imagePicker = ImagePicker();
    PickedFile image;
    //Check Permissions
    await Permission.photos.request();

    var permissionStatus = await Permission.photos.status;

    if (permissionStatus.isGranted){
      //Select Image
      image = await _imagePicker.getImage(source: ImageSource.gallery);
      var file = File(image.path);

      // ignore: unnecessary_null_comparison
      if (image != null){
        //Upload to Firebase
        var snapshot = await _firebaseStorage.ref().child('images/imageName').putFile(file).onComplete;
        var downloadUrl = await snapshot.ref.getDownloadURL();
        setState(() {
          image = downloadUrl;
        });
      } else {
        print('No Image Path Received');
      }
    } else {
      print('Permission not granted. Try Again with permission access');
    }
  }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Insert image",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
        body: Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Container(
                  margin: EdgeInsets.all(15),
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                    border: Border.all(color: Colors.black),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                      ),
                    ],
                  ),
                  child: (uploadImage() != null) ? Image.network(uploadImage()) : Image.network('gs://image-9cfa7.appspot.com/smart.jpg')
              ),
              SizedBox(height: 20),
              RaisedButton(
                child: Text("Upload Image",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                    ),
                ),
                onPressed: (){},
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    side: BorderSide(color: Colors.blue)
                ),
                elevation: 5.0,
                color: Colors.blue,
                textColor: Colors.white,
                padding: EdgeInsets.all(20),
              ),
            ],
          ),
        ),
      );
    }
  }
