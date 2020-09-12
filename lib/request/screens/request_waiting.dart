import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:load/load.dart';
import 'package:samannegarusers/dashboard/plugins/zoom_scaffold.dart';
import 'package:samannegarusers/dashboard/ui/menu.dart';
import 'package:samannegarusers/login/constants.dart';
import 'package:provider/provider.dart';
import 'package:samannegarusers/request/widgets/show_map.dart';

import '../../funcs.dart';

class RequestWaiting extends StatefulWidget {

  @override
  _RequestWaitingState createState() => _RequestWaitingState();
}

class _RequestWaitingState extends State<RequestWaiting> with TickerProviderStateMixin  {

  AudioCache _audioCache= new AudioCache();
  String _name = 'کاربر';
  String _lastName = 'گرامی';
  String _customer_id = '0';
  MenuController menuController;
  var customerData;

  Future<void> setData() async {

    showLoadingDialog(tapDismiss: false);
    var res = await makePostRequest(CustomStrings.CUSTOMERS,
        {'customer_id': await getPref('customer_id'), 'api_type': 'get'});
    res = res.json();

    _name = await res['data']['name'];
    _lastName = await res['data']['lname'];
    _customer_id = await res['data']['customer_id'];
    customerData = await res;
    hideLoadingDialog();
//
//    Future.delayed(const Duration(milliseconds: 500), () {
//      setState(() {
//        showModalBottomSheet(
//            context: context,
//            builder: (builder) {
//              return Text("erewrwerwe");
//            });
//      });
//    });

  }
  @override
  void initState() {
    super.initState();
    setData();
    _audioCache = AudioCache( fixedPlayer: AudioPlayer()..setReleaseMode(ReleaseMode.STOP));

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light
        .copyWith(statusBarColor: Colors.transparent));

    menuController = new MenuController(
      vsync: this,
    )..addListener(() => setState(() {}));
    menuController = new MenuController(
      vsync: this,
    )..addListener(() => setState(() {}));
  }
  PageController pageViewController;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: menuController,
//      builder: (context) => menuController,
      child: ZoomScaffold(
        menuScreen: MenuScreen(
          fullName: _name + ' ' + _lastName,
        ),
        contentScreen: Layout(contentBuilder: (cc) => scaffold(context)),
      ),
    );
  }



  Widget scaffold(BuildContext context) {

    return  WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
            resizeToAvoidBottomPadding: false,
//            body: ShowMap(),
            bottomSheet: FutureBuilder(
              future: Future.delayed(Duration(seconds: 15)),
              builder: (c, s) => s.connectionState == ConnectionState.done
                  ? Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.deepPurple , width: 1),
                  color: Colors.purple[200]
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text("علی صداقتی " ,
                    style: Theme.of(context)
                        .textTheme
                        .title
                        .copyWith(color: Colors.black),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,),
                    Text("شماره موبایل")
                  ],
                ),
              )
                  : Container(
                color: Colors.deepPurple,
                child: InkWell(
                  onTap: () {
                    print("pressed");
                    _audioCache.play("audio/beep.mp3");
                  },
                  child:ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child:Column(
                      children: <Widget>[
                        Image.asset('images/waiting.gif',
                            width: 500.0, height: 500.0),
                        RaisedButton(
                          child: Text(
                            "لغو",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'IRANSans'),
                          ),
                          color: Colors.orange,
                          focusColor: Colors.deepOrange,
                          onPressed:(){} ,
                        )

                      ],
                    ),
                  ),
                ),
              ),
            )
        ),
        )
    ;
  }
}

