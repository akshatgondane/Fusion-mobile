import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fusion/Components/appBar.dart';
import 'package:fusion/Components/side_drawer.dart';
import 'package:fusion/models/academic.dart';
import 'package:fusion/screens/Academic/Apply_for_Bonafide/pdf_services.dart';
import 'package:fusion/services/academic_service.dart';
import 'package:http/http.dart';

class Bonafide extends StatefulWidget {

  @override
  _BonafideState createState() => _BonafideState();
}

class _BonafideState extends State<Bonafide> {

  var details={
    1:"Bonafide for Fee Structure",
    2:"Bonafide for Sim Card",
    3:"Bonafide for Passport",
    4:"Bonafide for Education loan",
    5:"Other purposes",
  };
  List<DropdownMenuItem<int>> _bonafideItems = [];
  void loadlist(){
    _bonafideItems=[];
    for(int i=1; i<=details.length; i++){
      _bonafideItems.add(
        DropdownMenuItem(
            child: Text(details[i]!),
          value:i,
        )
      );
    }
  }

  int _value=1;
  String bonafidefor="Bonafide for Fee Structure";
  @override
  Widget build(BuildContext context) {
    TextEditingController otherReasonTextEditingController = new TextEditingController();
    final arguments = ModalRoute.of(context)!.settings.arguments as Map;
    loadlist();
    return Scaffold(
      appBar: DefaultAppBar().buildAppBar(),
      drawer: SideDrawer(),
      body:Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:[
            Text("Apply for Bonafide"),
            Text("Please select the purpose of bonafide:"),
            DropdownButton<int>(
                items:_bonafideItems,
              value:_value,
              onChanged: (value){
                  setState(() {
                    _value = value!;
                    bonafidefor=details[_value]!;
                    print(bonafidefor);
                  });
              },
              isExpanded: true,
            ),

            Container(
              child: _value == 5? Padding(
                padding: EdgeInsets.all(15),
                child: TextField(
                  controller: otherReasonTextEditingController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Reason",
                      hintText: "Enter Your Reason"
                  ),
                ),
              ) : Container(),
            ),
            
            ElevatedButton(
                onPressed: ()
                async {
                  print("First Name: " + arguments['firstName']);
                  print("Last Name: " + arguments['lastName']);
                  print("Branch: " + arguments['branch']);
                  PdfService pdfService = new PdfService();

                  if(_value == 5 && otherReasonTextEditingController.text.toString() == "")
                    {
                      Fluttertoast.showToast(
                          msg: "Please Enter Your Reason",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
                      return;
                    }
                  final data = await pdfService.generatePdf(bonafidefor == "Other purposes"? otherReasonTextEditingController.text.toString() : bonafidefor.substring(13), arguments["firstName"] + " " + arguments["lastName"], "2019064", arguments["branch"], "B.TECH");
                  pdfService.openFile(data);
                },
                child: Text("Submit"),
            ),
          ]
        ),
      ),
    );
  }
}
