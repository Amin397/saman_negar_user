import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:samannegarusers/dashboard/cars/models/carBrands.dart';
import 'package:samannegarusers/dashboard/cars/models/carColors.dart';
import 'package:samannegarusers/dashboard/cars/models/carGroups.dart';
import 'package:samannegarusers/dashboard/cars/models/typeOfCar.dart';
import 'package:samannegarusers/dashboard/util.dart';

class ViewHelper
{

  static pelak(context, platenumber1, platenumber2, platenumber3, platenumber4)
  {
    Size size = MediaQuery.of(context).size;

    return Container(
      width: size.width,
      height: size.height * .13,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
          border: Border.all(color: Colors.black , width: 1.5)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Flexible(
            flex: 2,
            child: Container(
              height: size.height,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("ایــــران",
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'IRANSans'),
                    ),
                    plaqueTextField(context, platenumber4 , true , 2 , 25.0 , platenumber4.text , false),
                  ],
                ),
              ),
            ),
          ),
          Container(width: 2 ,
              color: Colors.black),
          Flexible(
            flex: 3,
            child: Container(
              height: size.height,
              decoration: BoxDecoration(
              ),
              child: Center(
                child: plaqueTextField(context, platenumber3 , true , 3 , 30 , platenumber3.text , false),
              ),
            ),
          ),
          Flexible(
            flex: 3,
            child:  Container(
              height: size.height,
              decoration: BoxDecoration(
              ),
              child: Center(
                child: plaqueTextField(context, platenumber2, false, 1, 30 , platenumber2.text , false ),
              ),
            ),
          ),
          Flexible(
            flex: 3,
            child: Container(
              height: size.height,
              child: Center(
                child: plaqueTextField(context, platenumber1, true, 2, 30 , platenumber1.text , false),
              ),
            ),
          ),
          Container(width: 2 ,
              color: Colors.black),
          Flexible(
            flex: 2,
            child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(3.0),
                        bottomLeft: Radius.circular(3.0)),
                    color: Colors.blue.shade800),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Container(
                        height:size.height * .03,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.fill,
                                image:
                                Image.asset('assets/images/iran_flag.png').image
                            )
                        ),
                      ),
                    ),
                    Text(
                      'I.R.\nIRAN',
                      style: TextStyle(
                          color: Colors.white, fontSize: 16.0, height: 1),
                      textDirection: TextDirection.ltr,
                    )
                  ],
                )
            ),
          ),
        ],
      ),
    );
  }
  static plaqueTextField(context, controller , bool numeric , int maxLength , double fontSize , String hint , maskEnable ,[mask])
  {
    return  TextField(
      inputFormatters: (maskEnable) ? [
        mask
      ] : null,
      maxLength: maxLength,
      keyboardType: (numeric) ? TextInputType.number : TextInputType.text,
      textAlign: TextAlign.center,
      style:TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
          fontFamily: 'IRANSans'),
      textDirection: TextDirection.rtl,
      decoration: InputDecoration(
        hintText: hint,
        counterText: '',
        enabledBorder: InputBorder.none,
      ),
      controller: controller,
    );
  }



  static colorFutureId(callback , _carColorHint){
    return FutureBuilder<List<CarColors>>(
        future: fetchCarColors(),
        builder: (BuildContext context,
            AsyncSnapshot<List<CarColors>>
            snapshot) {
          print("colors : " +
              snapshot.data.toString());
          if (!snapshot.hasData)
            return LinearProgressIndicator(
              backgroundColor: Colors.white,
              valueColor:
              new AlwaysStoppedAnimation<
                  Color>(
                  CustomColors
                      .BlueDark),
            );
          return Container(
              decoration: BoxDecoration(
                borderRadius:
                BorderRadius.circular(
                    10.0),
                border: Border.all(
                    color: Colors.blueGrey,
                    style:
                    BorderStyle.solid,
                    width: 0.80),
              ),
              child:
              DropdownButtonHideUnderline(
                  child: DropdownButton<
                      CarColors>(
                      icon: Padding(
                        child: Icon(Icons
                            .branding_watermark),
                        padding:
                        EdgeInsets
                            .all(
                            10.0),
                      ),
                      style: TextStyle(
                          fontFamily:
                          'IRANSans',
                          color: Colors
                              .black54),
                      items: snapshot
                          .data
                          .map((carcolor) =>
                          DropdownMenuItem<
                              CarColors>(
                            child:
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.end,
                              crossAxisAlignment:
                              CrossAxisAlignment.end,
                              children: <
                                  Widget>[
                                Padding(
                                  padding: EdgeInsets.only(right: 30.0),
                                  child: new Text(
//                                                                  carcolor.id == widget.carcolorid ? _carColorHint =  carcolor.name : carcolor.name

                                    carcolor.name,
                                    style: TextStyle(
                                      fontFamily: 'IRANSans',
                                      fontSize: 12.0,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            value:
                            carcolor,
                          ))
                          .toList(),
                      onChanged: callback,
                      isExpanded: true,
                      hint: Padding(
                        padding:
                        EdgeInsets
                            .all(
                            10.0),
                        child: Text(
//                                                            colorvalue.id == widget.carcolorid ? colorvalue.name :
                            _carColorHint),
                      )
                  )
              )
          );
        });
  }
  static typeOfCarFutureId(callback , _typeOfCarHint , __typeOfCarFuture){
    return FutureBuilder<List<TypeOfCar>>(
        future: __typeOfCarFuture,
        builder: (BuildContext context,
            AsyncSnapshot<List<TypeOfCar>>
            snapshot) {
          if (!snapshot.hasData)
            return LinearProgressIndicator(
              backgroundColor: Colors.white,
              valueColor:
              new AlwaysStoppedAnimation<
                  Color>(
                  CustomColors
                      .BlueDark),
            );
          return Container(
              decoration: BoxDecoration(
                borderRadius:
                BorderRadius.circular(
                    10.0),
                border: Border.all(
                    color: Colors.blueGrey,
                    style:
                    BorderStyle.solid,
                    width: 0.80),
              ),
              child:
              DropdownButtonHideUnderline(
                  child: DropdownButton<
                      TypeOfCar>(
                      icon: Padding(
                        child: Icon(Icons
                            .branding_watermark),
                        padding:
                        EdgeInsets
                            .all(
                            10.0),
                      ),
                      style: TextStyle(
                          fontFamily:
                          'IRANSans',
                          color: Colors
                              .black54),
                      items: snapshot
                          .data
                          .map((typeOfCar) =>
                          DropdownMenuItem<
                              TypeOfCar>(
                            child:
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.end,
                              crossAxisAlignment:
                              CrossAxisAlignment.end,
                              children: <
                                  Widget>[
                                Padding(
                                  padding: EdgeInsets.only(right: 30.0),
                                  child: new Text(
                                    typeOfCar.name,
                                    style: TextStyle(
                                      fontFamily: 'IRANSans',
                                      fontSize: 12.0,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            value:
                            typeOfCar,
                          ))
                          .toList(),
                      onChanged: (TypeOfCar value) {callback(value);},
                      isExpanded: true,
                      hint: Padding(
                        padding:
                        EdgeInsets
                            .all(
                            10.0),
                        child: Text(
                          _typeOfCarHint,
                        ),
                      )
                  )
              )
          );
        });
  }
  static carBrandFutureId(callBack , _carBrandHint){
    return FutureBuilder<List<CarBrands>>(
        future: fetchCarBrands(),
        builder: (BuildContext
        context,
            AsyncSnapshot<
                List<CarBrands>>
            snapshot) {
          if (!snapshot.hasData)
            return LinearProgressIndicator(
              backgroundColor:
              Colors.white,
              valueColor:
              new AlwaysStoppedAnimation<
                  Color>(
                  CustomColors
                      .BlueDark),
            );
          return Container(
              decoration:
              BoxDecoration(
                borderRadius:
                BorderRadius
                    .circular(
                    10.0),
                border: Border.all(
                    color: Colors
                        .blueGrey,
                    style: BorderStyle
                        .solid,
                    width: 0.80),
              ),
              child:
              DropdownButtonHideUnderline(
                  child: DropdownButton<
                      CarBrands>(
                      icon:
                      Padding(
                        child: Icon(
                            Icons
                                .branding_watermark),
                        padding:
                        EdgeInsets.all(
                            10.0),
                      ),
                      style: TextStyle(
                          fontFamily:
                          'IRANSans',
                          color: Colors
                              .black54),
                      items: snapshot
                          .data
                          .map((carBrand) =>
                          DropdownMenuItem<
                              CarBrands>(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(right: 30.0),
                                  child: new Text(
                                    carBrand.name,
                                    style: TextStyle(
                                      fontFamily: 'IRANSans',
                                      fontSize: 12.0,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            value: carBrand,
                          ))
                          .toList(),
                      onChanged: (CarBrands value){
                        callBack(value);
                      },
                      isExpanded:
                      true,
                      hint:
                      Padding(
                        padding:
                        EdgeInsets.all(
                            10.0),
                        child:
                        Text(
                          _carBrandHint,
                        ),
                      )
                  )
              )
          );
        });
  }
  static carGroupeFutureId(callBack , _carGroupHint){
    return FutureBuilder<List<CarGroups>>(
        future: fetchCarGroups(),
        builder: (BuildContext
        context,
            AsyncSnapshot<
                List<CarGroups>>
            snapshot) {
          if (!snapshot.hasData)
            return LinearProgressIndicator(
              backgroundColor:
              Colors.white,
              valueColor:
              new AlwaysStoppedAnimation<
                  Color>(
                  CustomColors
                      .BlueDark),
            );
          return Container(
              decoration:
              BoxDecoration(
                borderRadius:
                BorderRadius
                    .circular(
                    10.0),
                border: Border.all(
                    color: Colors
                        .blueGrey,
                    style: BorderStyle
                        .solid,
                    width: 0.80),
              ),
              child:
              DropdownButtonHideUnderline(
                  child: DropdownButton<
                      CarGroups>(
                      icon:
                      Padding(
                        child: Icon(
                            Icons
                                .drive_eta),
                        padding:
                        EdgeInsets.all(
                            10.0),
                      ),
                      style: TextStyle(
                          fontFamily:
                          'IRANSans',
                          color: Colors
                              .black54),
                      items: snapshot
                          .data
                          .map((carGroup) =>
                          DropdownMenuItem<
                              CarGroups>(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(right: 30.0),
                                  child: new Text(
                                    carGroup.name,
                                    style: TextStyle(
                                      fontFamily: 'IRANSans',
                                      fontSize: 12.0,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            value: carGroup,
                          ))
                          .toList(),
                      onChanged: (CarGroups value) {
                        callBack(value);
                      },
                      isExpanded:
                      true,
                      hint:
                      Padding(
                        padding:
                        EdgeInsets.all(
                            10.0),
                        child:
                        Text(
                          _carGroupHint,
                        ),
                      )
                  )
              )
          );
        }
    );
  }



  static insuranceDatePicker(BuildContext context , DateInsurance , function , title , color , bool start){
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            child: Material(
              elevation: 5.0,
              borderRadius: BorderRadius.all(Radius.circular(6.0)),
              child: Container(
                height: size.height * .055,
                width: size.width * .35,
                decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.all(Radius.circular(6.0))
                ),
                child: Center(
                  child: Text(title ,style: TextStyle(
                      fontSize: 12.0,
                      color: (!start) ? Colors.white : Colors.black,
                  ),),
                ),
              ),
            ),
            onTap: (){
              function();
            },
          ),
          Text('${DateInsurance}',style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w600
          ),),
        ],
      ),
    );
  }




  static insuranceTypeFutureId(callBack , _insuranceTypeHint){

  }



}