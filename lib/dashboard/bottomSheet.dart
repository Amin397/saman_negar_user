import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:samannegarusers/request/screens/home_screen.dart';
import 'cars/forms/addCar.dart';
import 'insuranceAndValue/forms/add_insurance.dart';
import 'util.dart';

class Modal {
  mainBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height - 80,
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Stack(
            alignment: AlignmentDirectional.topCenter,
            children: <Widget>[
              Positioned(
                top: MediaQuery.of(context).size.height / 25,
                left: 0,
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.elliptical(175, 30),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height / 2 - 340,
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop(false);
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          child: Image.asset('assets/images/fab-delete.png'),
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: <Color>[
                                CustomColors.PurpleLight,
                                CustomColors.PurpleDark,
                              ],
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(50.0),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: CustomColors.PurpleShadow,
                                blurRadius: 10.0,
                                spreadRadius: 5.0,
                                offset: Offset(0.0, 0.0),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          SizedBox(height: 10),
                          Text(
                            'لغو',
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(height: 20),
                          RaisedButton(
                            onPressed: () {
                              print("botoomsheet button pressed");
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => HomeScreen()),
                              );
                              // Navigator.pop(context);
                            },
                            textColor: Colors.white,
                            padding: const EdgeInsets.all(0.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Container(
                              width: MediaQuery.of(context).size.width / 1.2,
                              height: 60,
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: <Color>[
                                    CustomColors.HeaderYellowLight,
                                    CustomColors.BlueDark,
                                  ],
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8.0),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: CustomColors.BlueShadow,
                                    blurRadius: 2.0,
                                    spreadRadius: 1.0,
                                    offset: Offset(0.0, 0.0),
                                  ),
                                ],
                              ),
                              padding:
                                  const EdgeInsets.fromLTRB(20, 10, 20, 10),
                              child: Center(
                                child: const Text(
                                  'ثبت درخواست ارزیابی خسارت',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }



 carListBottomSheet(BuildContext context) {
   Navigator.of(context).push(PageTransition(child: AddCar(), type: PageTransitionType.downToUp));
 }

  insuranceListBottomSheet(BuildContext context) {
    Navigator.of(context).push(PageTransition(child: AddInsurance(), type: PageTransitionType.downToUp));
  }

}
