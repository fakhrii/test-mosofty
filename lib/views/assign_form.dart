// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:test_technique/constants.dart';
import 'package:test_technique/models/employee_model.dart';
import 'package:test_technique/repositories/person_repository.dart';

import '../models/mobile_model.dart';

class AssignForm extends StatefulWidget {
  AssignForm({Key? key}) : super(key: key);

  @override
  State<AssignForm> createState() => _AssignFormState();
}

class _AssignFormState extends State<AssignForm> {
  Mobile? _mobile;
  Employee? _employee;
  List<Mobile> mobiles= [];
  List<Employee> employees= [];
  TextEditingController phoneController = TextEditingController();

  MobileRepository _mobileRepository = MobileRepository();
  @override
  void initState() {
    if(_mobile!=null){
      phoneController.text=_mobile?.num??"";
    }
    loadData();
    super.initState();
  }
  loadData () async {
    mobiles = await _mobileRepository.fetchMobiles(Constants.token);
    employees = await _mobileRepository.fetchEmployees(Constants.token);
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Assign phone to employee"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text("Phone name:"),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(5)
              ),
              child: DropdownButton(
                underline: Container(),
                hint:Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text('Select a phone'),
                ),
                  isExpanded: true,

                  value: _mobile,
                  items: mobiles
                  .map((e) => DropdownMenuItem<Mobile>(
                value: e,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text(e.name!),
                ),
              ))
                  .toList(), onChanged: (value){
                setState(() {
                _mobile= value;
                phoneController.text = _mobile?.num??'';
                });

              }),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0,top: 15),
              child: Text("IMEI:"),
            ),
            TextField(
              decoration: InputDecoration(filled: true,fillColor: Colors.grey.shade300),
              enabled: false,
              controller: phoneController,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0,top: 15),
              child: Text("Employee:"),
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(5)
              ),
              child: DropdownButton(

                  underline: Container(),
                  isExpanded: true,
                hint: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text("Select an employee"),
                ),
                value: _employee,
                  items: employees
                  .map((e) => DropdownMenuItem<Employee>(
                value: e,


                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text(e.name!,),
                ),
              ))
                  .toList(), onChanged: (value){
                setState(() {
                  _employee= value;
                });

              }),
            ),

            SizedBox(height: 50,),
            ElevatedButton(onPressed:  () async{

              if(_mobile!=null && _employee!=null){

              await _mobileRepository.assignMobile(_mobile!.id!,_employee!.id!, Constants.token);
              Navigator.pop(context);
              }
            }, child: Text("Submit"))
          ],
        ),
      ),
    );
  }
}
