import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xFF6F35A5);
const kPrimaryLightColor = Color(0xFFF1E6FF);

const double defaultPadding = 16.0;
  showLoading(BuildContext _) {
    return showDialog(
      context: _,
      builder: (context) {
        return const AlertDialog(
          title: Text('Please Wait'),
          content: SizedBox(
            height: 50,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
      },
    );
  }
List val = [
  {
    "note":
        "Mobile app development is the act or process by which a mobile app is developed for mobile devices, "
  },
  {
    "note":
        "Mobile app development is the act or process by which a mobile app is developed for mobile devices, "
  },
  {
    "note":
        "Mobile app development is the act or process by which a mobile app is developed for mobile devices, "
  },
  {
    "note":
        "Mobile app development is the act or process by which a mobile app is developed for mobile devices, "
  },
  {
    "note":
        "Mobile app development is the act or process by which a mobile app is developed for mobile devices, "
  },
  {
    "note":
        "Mobile app development is the act or process by which a mobile app is developed for mobile devices, "
  },
  {
    "note":
        "Mobile app development is the act or process by which a mobile app is developed for mobile devices, "
  },
];
