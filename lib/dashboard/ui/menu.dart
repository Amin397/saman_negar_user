import 'package:page_transition/page_transition.dart';
import 'package:samannegarusers/dashboard/appBars.dart';
import 'package:samannegarusers/dashboard/plugins/zoom_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:samannegarusers/funcs.dart';
import 'package:samannegarusers/login/welcomePage.dart';

class MenuScreen extends StatelessWidget {
  final String imageUrl =
      "https://celebritypets.net/wp-content/uploads/2016/12/Adriana-Lima.jpg";
  final fullName;
  final List<MenuItem> options = [
    MenuItem(Icons.search, 'جستجو'),
    MenuItem(Icons.phone, 'تماس با ما'),
    MenuItem(Icons.favorite, 'علاقه مندی ها'),
    MenuItem(Icons.format_list_bulleted, 'درخواست ها'),
  ];

  MenuScreen({Key key, this.fullName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        //on swiping left
        print(details.delta.dx);
        if (details.delta.dx > 0) {
          Provider.of<MenuController>(context, listen: false).toggle();
        }
      },
      child: Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            padding: EdgeInsets.only(
                top: 62,
                right: 32,
                bottom: 8,
                left: MediaQuery.of(context).size.width / 2.9),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.grey.shade200,
                      offset: Offset(2, 4),
                      blurRadius: 5,
                      spreadRadius: 2)
                ],
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Color(0xfffbb448), Color(0xfff7892b)])),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 16, left: 10.0),
                      child: ClipRRect(
                        child:
                            Image.asset('assets/images/photo.png', scale: 3.5),
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        CustomPaint(
                          painter: CircleOne(),
                        ),
                        CustomPaint(
                          painter: CircleTwo(),
                        ),
                      ],
                    ),
                    Text(
                      fullName,
                      style: TextStyle(
                        fontFamily: 'IRANSans',
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                Column(
                  children: options.map((item) {
                    return ListTile(
                        title: Row(
                      children: <Widget>[
                        Icon(
                          item.icon,
                          color: Colors.white,
                          size: 20,
                        ),
                        SizedBox(width: 10.0),
                        Text(
                          item.title,
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'IRANSans',
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ],
                    ));
                  }).toList(),
                ),
                Spacer(),
                ListTile(
                  onTap: () {},
                  leading: Icon(
                    Icons.settings,
                    color: Colors.white,
                    size: 20,
                  ),
                  title: Text('تنظیمات',
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontFamily: 'IRANSans')),
                ),
                ListTile(
                  onTap: () {},
                  leading: Icon(
                    Icons.headset_mic,
                    color: Colors.white,
                    size: 20,
                  ),
                  title: Text('پشتیبانی',
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontFamily: 'IRANSans')),
                ),
                Row(
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
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color.fromRGBO(247, 137, 43, 0.0),
                          Color.fromRGBO(250, 0, 0, 0.5)
                        ]),
                  ),
                  child: ListTile(
                    onTap: () async {
                      await setPref('username', null);
                      await setPref('password', null);
                      Navigator.pushReplacement(
                          context,
                          PageTransition(
                              child: WelcomePage(),
                              type: PageTransitionType.leftToRight));
                    },
                    leading: Icon(
                      Icons.exit_to_app,
                      color: Colors.white,
                      size: 20,
                    ),
                    title: Text('خروج',
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontFamily: 'IRANSans')),
                  ),
                )
              ],
            ),
          )),
    );
  }
}

class MenuItem {
  String title;
  IconData icon;

  MenuItem(this.icon, this.title);
}
