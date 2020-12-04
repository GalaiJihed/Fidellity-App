import 'package:app/utils/Theme.dart' as Theme;
import 'package:flutter/material.dart';

class BottomSheetWidget extends StatelessWidget {
  mainBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(
                  Icons.camera_alt,
                  color: Theme.mainColorAccent,
                ),
                title: Text('Take Photo'),
                onTap: () {
                  Navigator.pop(context, 0);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.photo_library,
                  color: Theme.mainColorAccent,
                ),
                title: Text('My Images'),
                onTap: () {
                  Navigator.pop(context, 1);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.clear,
                  color: Theme.mainColorAccent,
                ),
                title: Text('Cancel'),
                onTap: () {
                  Navigator.pop(context, 2);
                },
              ),
            ],
          );
        });
  }

  Future<int> _actionCancel() {
    return Future(() => 0);
  }

  Future<int> _actionCamera() {
    return Future(() => 1);
  }

  Future<int> _actionGallery() {
    return Future(() => 2);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }
}
