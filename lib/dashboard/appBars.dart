import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:samannegarusers/dashboard/plugins/zoom_scaffold.dart';
import 'package:samannegarusers/funcs.dart';
import 'package:samannegarusers/login/constants.dart';
import 'util.dart';

fullAppbar(BuildContext context, {String data = 'یادآوری ای ندارید!'}) {
      return PreferredSize(
        preferredSize: Size.fromHeight(210.0),
        child: GradientAppBar(
          flexibleSpace: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              CustomPaint(
                painter: CircleOne(),
              ),
              CustomPaint(
                painter: CircleTwo(),
              ),
            ],
          ),
          leading: IconButton(
              icon: Icon(
                Icons.info_outline,
                color: Colors.white,
              ),
              color: Colors.white,
              onPressed: () {}),
          title: Center(
            child: Container(
              margin: EdgeInsets.only(top: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'سامان نگار ایرانیان',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'IRANSans'),
                  ),
                  Text(
                    'سامانه ی خدمات بیمه و ارزیابی خسارت',
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w300,
                        fontFamily: 'IRANSans'),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            GestureDetector(
              child: Container(
                margin: EdgeInsets.fromLTRB(0, 20, 20, 0),
                child: ClipRRect(
                  child: Image.asset('assets/images/photo.png'),
                  borderRadius: BorderRadius.circular(50.0),
                ),
              ),
              onTap: () {
                Provider.of<MenuController>(context, listen: false).toggle();
              },
            )
          ],
          elevation: 5,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [CustomColors.HeaderOrange, CustomColors.HeaderYellowLight],
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(10),
            child: Directionality(
                textDirection: TextDirection.rtl,
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  padding: EdgeInsets.fromLTRB(15, 5, 15, 0),
                  decoration: BoxDecoration(
                    color: CustomColors.HeaderGreyLight,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'یادآوری امروز',
                            style: TextStyle(
                                fontFamily: 'IRANSans',
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Text(
                            null != data ? data : '',
                            style: TextStyle(
                                fontFamily: 'IRANSans',
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w300),
                          )
                        ],
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 2.9,
                      ),
                      Image.asset(
                        'assets/images/bell-left.png',
                        scale: 1.3,
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 80),
                        child: Icon(
                          Icons.clear,
                          color: Colors.white,
                          size: 18.0,
                        ),
                      ),
                    ],
                  ),
                )),
          ),
        ),
      );
}

Widget emptyAppBar(BuildContext context) {
  return PreferredSize(
    preferredSize: Size.fromHeight(MediaQuery.of(context).size.height / 14),
    child: GradientAppBar(
      flexibleSpace: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          CustomPaint(
            painter: CircleOne(),
          ),
          CustomPaint(
            painter: CircleTwo(),
          ),
        ],
      ),
      leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pop();
          }),
      title: Center(
        child: Container(
          margin: EdgeInsets.only(top: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'سامان نگار ایرانیان',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'IRANSans'),
              ),
              Text(
                'سامانه ی خدمات بیمه و ارزیابی خسارت',
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w300,
                    fontFamily: 'IRANSans'),
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        GestureDetector(
          child: Container(
            margin: EdgeInsets.fromLTRB(0, 20, 20, 0),
            child: ClipRRect(
              child: Image.asset('assets/images/photo.png'),
              borderRadius: BorderRadius.circular(50.0),
            ),
          ),
          onTap: () {
            Provider.of<MenuController>(context, listen: false).toggle();
          },
        )
      ],
      elevation: 5,
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [CustomColors.HeaderOrange, CustomColors.HeaderYellowLight],
      ),
    ),
  );
}

class CircleOne extends CustomPainter {
  Paint _paint;

  CircleOne() {
    _paint = Paint()
      ..color = CustomColors.HeaderCircle
      ..strokeWidth = 10.0
      ..style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(Offset(28.0, 0.0), 99.0, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class CircleTwo extends CustomPainter {
  Paint _paint;

  CircleTwo() {
    _paint = Paint()
      ..color = CustomColors.HeaderCircle
      ..strokeWidth = 10.0
      ..style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(Offset(-30, 20), 50.0, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
