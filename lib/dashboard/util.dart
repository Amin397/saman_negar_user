import 'package:flutter/material.dart';
import 'package:samannegarusers/dashboard/plugins/rich_alert.dart';

class CustomColors {
  static const Color GreyBackground = Color.fromRGBO(249, 252, 255, 1);
  static const Color GreyBorder = Color.fromRGBO(207, 207, 207, 1);
  
  static const Color GreenLight = Color.fromRGBO(93, 230, 26, 1);
  static const Color GreenDark = Color.fromRGBO(57, 170, 2, 1);
  static const Color GreenIcon = Color.fromRGBO(30, 209, 2, 1);
  static const Color GreenAccent = Color.fromRGBO(30, 209, 2, 1);
  static const Color GreenShadow = Color.fromRGBO(30, 209, 2, 0.24); // 24%
  static const Color GreenBackground = Color.fromRGBO(181, 255, 155, 0.36); // 36%

  static const Color OrangeIcon = Color.fromRGBO(236, 108, 11, 1);
  static const Color OrangeBackground = Color.fromRGBO(255, 208, 155, 0.36); // 36%

  static const Color PurpleLight = Color.fromRGBO(248, 87, 195, 1);
  static const Color PurpleDark = Color.fromRGBO(224, 19, 156, 1);
  static const Color PurpleIcon = Color.fromRGBO(209, 2, 99, 1);
  static const Color PurpleAccent = Color.fromRGBO(209, 2, 99, 1);
  static const Color PurpleShadow = Color.fromRGBO(209, 2, 99, 0.27); // 27%
  static const Color PurpleBackground = Color.fromRGBO(255, 155, 205, 0.36); // 36%

  static const Color DeeppurlpleIcon = Color.fromRGBO(191, 0, 128, 1);
  static const Color DeeppurlpleBackground = Color.fromRGBO(245, 155, 255, 0.36); // 36%

  static const Color BlueLight = Color.fromRGBO(11, 182, 255, 1);
  static const Color BlueDark = Color(0xffe46b10);
  static const Color BlueIcon = Color.fromRGBO(9, 172, 206, 1);
  static const Color BlueBackground = Color.fromRGBO(155, 255, 248, 0.36); // 36%
  static const Color BlueShadow = Color.fromRGBO(104, 148, 238, 0.1);

  static const Color HeaderYellowLight = Color(0xfffbb448);
  static const Color HeaderOrange = Color(0xffe46b10);
  static const Color HeaderGreyLight = Color.fromRGBO(225, 255, 255, 0.31); // 31%

  static const Color YellowIcon = Color.fromRGBO(249, 194, 41, 1);
  static const Color YellowBell = Color.fromRGBO(225, 220, 0, 1);
  static const Color YellowAccent = Color.fromRGBO(255, 213, 6, 1);
  static const Color YellowShadow = Color.fromRGBO(243, 230, 37, 0.27); // 27%
  static const Color YellowBackground = Color.fromRGBO(255, 238, 155, 0.36); // 36%

  static const Color BellGrey = Color.fromRGBO(217, 217, 217, 1);
  static const Color BellYellow = Color.fromRGBO(255, 220, 0, 1);

  static const Color TrashRed = Color.fromRGBO(251, 54, 54, 1);
  static const Color TrashRedBackground = Color.fromRGBO(255, 207, 207, 1);
  
  static const Color TextHeader = Color.fromRGBO(85, 78, 143, 1);
  static const Color TextHeaderGrey = Color.fromRGBO(104, 104, 104, 1);
  static const Color TextSubHeaderGrey = Color.fromRGBO(161, 161, 161, 1);
  static const Color TextSubHeader = Color.fromRGBO(139, 135, 179, 1);
  static const Color TextBody = Color.fromRGBO(130, 160, 183, 1);
  static const Color TextGrey = Color.fromRGBO(198, 198, 200, 1);
  static const Color TextWhite = Color.fromRGBO(243, 243, 243, 1);
  static const Color HeaderCircle = Color.fromRGBO(255, 255, 255, 0.17);
}


void showRichDialog(context, {String title = 'کاربر گرامی!',  String text = 'بخش مورد نظر شما در حال طراحی است٬ از شکیبایی شما متشکریم!',int type = 2,String btnText = '!فهمیدم'} ) {
  showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return RichAlertDialog(
          alertTitle: Text(
            title,
            style: TextStyle(fontFamily: 'IRANSans',fontSize: 14.0,fontWeight: FontWeight.bold),
            textDirection: TextDirection.rtl,
          ),
          alertSubtitle: Text(
            text,
            style: TextStyle(fontFamily: 'IRANSans'),
            textDirection: TextDirection.rtl,
          ),
          actions: <Widget>[
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                width: MediaQuery.of(context).size.width - 100,
                padding: EdgeInsets.symmetric(vertical: 13),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius:
                    BorderRadius.all(Radius.circular(5)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: Color(0xffdf8e33).withAlpha(100),
                          offset: Offset(2, 4),
                          blurRadius: 8,
                          spreadRadius: 2)
                    ],
                    color: Colors.white),
                child: Text(
                  btnText,
                  style: TextStyle(
                      fontSize: 20,
                      color: Color(0xfff7892b),
                      fontFamily: 'IRANSans'),
                ),
              ),
            )
          ],
          alertType: type,
        );
      });
}
void ahowfillingdialogue(context, {String title = 'کاربر گرامی!',  String text = 'پر کردن تمامی بخش های اجباری است',int type = 2,String btnText = '!فهمیدم'} ) {
  showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return RichAlertDialog(
          alertTitle: Text(
            title,
            style: TextStyle(fontFamily: 'IRANSans',fontSize: 14.0,fontWeight: FontWeight.bold),
            textDirection: TextDirection.rtl,
          ),
          alertSubtitle: Text(
            text,
            style: TextStyle(fontFamily: 'IRANSans'),
            textDirection: TextDirection.rtl,
          ),
          actions: <Widget>[
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                width: MediaQuery.of(context).size.width - 100,
                padding: EdgeInsets.symmetric(vertical: 13),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius:
                    BorderRadius.all(Radius.circular(5)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: Color(0xffdf8e33).withAlpha(100),
                          offset: Offset(2, 4),
                          blurRadius: 8,
                          spreadRadius: 2)
                    ],
                    color: Colors.white),
                child: Text(
                  btnText,
                  style: TextStyle(
                      fontSize: 20,
                      color: Color(0xfff7892b),
                      fontFamily: 'IRANSans'),
                ),
              ),
            )
          ],
          alertType: type,
        );
      });
}