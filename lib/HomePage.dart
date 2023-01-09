import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:external_path/external_path.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> listImagePath = [];
  var _permissionStatus;
  Future _futureGetPath;

  @override
  void initState() {
    super.initState();
    _getPermission();
    _futureGetPath = getImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Permission"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: FutureBuilder(
              future: _futureGetPath,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  var dir = Directory(snapshot.data);
                  print('permission status: $_permissionStatus');
                  if (_permissionStatus) _fetchFiles(dir);
                  return Text(snapshot.data);
                } else {
                  return Text("Loading");
                }
              },
            ),
          ),
          Expanded(
            flex: 19,
            child: GridView.count(
              primary: false,
              padding: const EdgeInsets.all(20),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 3,
              children: _getListImg(listImagePath),
            ),
          )
        ],
      ),
    );
  }

  void _getPermission() async {
    final status = await Permission.storage.status;
    if (status.isGranted) {
      await Permission.storage.request();
      setState(() => _permissionStatus = status);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Permission Is Granted")));
    }
    else if (status.isDenied) {
      await Permission.storage.request();
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Permission Is Not Granted")));
    }
  }


  Future<String> getImage() {
    return ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_PICTURES);
  }

  _fetchFiles(Directory dir) {
    List<dynamic> listImage = [];
    dir.list().forEach((element) {
      RegExp regExp = RegExp(
          "(gif|jpe?g|tiff?|png|webp|bmp)", caseSensitive: false);
      if (regExp.hasMatch('$element')) listImage.add(element);
        setState(() {
          listImagePath = listImage;
        });
    });
  }

  List<Widget> _getListImg(List<dynamic> listImagePath) {
    List<Widget> listImages = [];
    for (var imagePath in listImagePath) {
      listImages.add(
        Container(
          padding: const EdgeInsets.all(8),
          child: Image.file(imagePath, fit: BoxFit.cover),
        ),
      );
    }
    return listImages;
  }
}

