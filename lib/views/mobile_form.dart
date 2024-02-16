// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:test_technique/constants.dart';
import 'package:test_technique/repositories/person_repository.dart';

import '../models/mobile_model.dart';

class MobileForm extends StatefulWidget {
  MobileForm({Key? key, this.mobile}) : super(key: key);
  Mobile? mobile;

  @override
  State<MobileForm> createState() => _MobileFormState();
}

class _MobileFormState extends State<MobileForm> {
  Mobile? _mobile;
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  MobileRepository _mobileRepository = MobileRepository();
  @override
  void initState() {
    _mobile = widget.mobile;
    if(_mobile!=null){
      nameController.text=_mobile?.name??"";
      phoneController.text=_mobile?.num??"";
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_mobile != null ? "Updating phone" : "New phone"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0,top: 15),
              child: Text("Phone name:"),
            ),
            TextField(
              decoration: InputDecoration(border: OutlineInputBorder()),
              controller: nameController,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0,top: 15),
              child: Text("Num:"),
            ),
            TextField(
              decoration: InputDecoration(border: OutlineInputBorder()),
              controller: phoneController,
            ),

            SizedBox(height: 50,),
            ElevatedButton(onPressed:  () async{

              if(_mobile==null){
              Mobile mobile = Mobile(name: nameController.text,num: phoneController.text);
              await _mobileRepository.createMobile(mobile, Constants.token);

              }else{
                _mobile?.name = nameController.text;
                _mobile?.num = phoneController.text;
                await _mobileRepository.updateMobile(_mobile!, Constants.token);
              }
              Navigator.pop(context);
            }, child: Text(_mobile!=null?"Update phone":"Add new phone"))
          ],
        ),
      ),
    );
  }
}
