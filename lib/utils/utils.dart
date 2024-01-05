import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_route.dart';
import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';

import '../constant/constant.dart';

class Utils {
  static double averageRating(List<int> rating) {
    var avgRating = 0;
    for (int i = 0; i < rating.length; i++) {
      avgRating = avgRating + rating[i];
    }
    return double.parse((avgRating / rating.length).toStringAsFixed(1));
  }

  static void fieldFocusChange(
      BuildContext context, FocusNode current, FocusNode nextFocus) {
    current.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  // static toastMessage(String message) {
  //   Fluttertoast.showToast(
  //     msg: message,
  //     backgroundColor: Colors.black,
  //     textColor: Colors.white,
  //   );
  // }

  static void flushBarErrorMessage(String message, BuildContext context) {
    showFlushbar(
      context: context,
      flushbar: Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(10),
        backgroundColor: const Color.fromARGB(255, 207, 99, 87),
        boxShadows: const [
          BoxShadow(
            color: Colors.black45,
            offset: Offset(3, 3),
            blurRadius: 3,
          ),
        ],
        dismissDirection: FlushbarDismissDirection.VERTICAL,
        forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
        messageText: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            message,
            style: TextStyles.white16semibold,
          ),
        ),
        icon: const Padding(
          padding: EdgeInsets.only(left: 15.0),
          child: Icon(
            Icons.check_circle_outline_outlined,
            size: 30,
            color: Colors.white,
          ),
        ),
        // message: message,
        borderRadius: BorderRadius.circular(12),
        messageSize: MediaQuery.of(context).size.height * 0.03,
      )..show(context),
    );
  }

  static void flushBarSuccessMessage(String message, BuildContext context) {
    showFlushbar(
        context: context,
        flushbar: Flushbar(
          flushbarPosition: FlushbarPosition.TOP,
          duration: const Duration(seconds: 1),
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.all(10),
          backgroundColor: const Color.fromARGB(255, 114, 171, 115),
          boxShadows: const [
            BoxShadow(
              color: Colors.black45,
              offset: Offset(3, 3),
              blurRadius: 3,
            ),
          ],
          dismissDirection: FlushbarDismissDirection.VERTICAL,
          forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
          messageText: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              message,
              style: TextStyles.white16semibold,
            ),
          ),
          icon: const Padding(
            padding: EdgeInsets.only(left: 15.0),
            child: Icon(
              Icons.check_circle_outline_outlined,
              size: 30,
              color: Colors.white,
            ),
          ),
          // message: message,
          borderRadius: BorderRadius.circular(12),
          messageSize: MediaQuery.of(context).size.height * 0.03,
        )..show(context));
  }

  static snackBar(String message, BuildContext context) {
    return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: Colors.red, content: Text(message)));
  }
}
