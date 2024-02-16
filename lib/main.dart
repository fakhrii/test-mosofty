// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:test_technique/blocs/mobile_bloc.dart';
import 'package:test_technique/constants.dart';
import 'package:test_technique/repositories/person_repository.dart';
import 'package:test_technique/views/assign_form.dart';
import 'package:test_technique/views/mobile_form.dart';

import 'models/mobile_model.dart';
import 'networking/api_response.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Test - Mosofty'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late MobileBloc mobileBloc;
  MobileRepository _mobileRepository = MobileRepository();

  void reloadList() {
    setState(() {
      mobileBloc = MobileBloc(Constants.token);
    });
  }

  @override
  void initState() {
    mobileBloc = MobileBloc(Constants.token);
    _mobileRepository.fetchEmployees(Constants.token);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 60),
          child: ListView(
            children: <Widget>[
              StreamBuilder<ApiResponse<List<Mobile>>>(
                stream: mobileBloc.mobilesStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    switch (snapshot.data!.status) {
                      case Status.LOADING:
                        return Center(child: CircularProgressIndicator());
                      case Status.COMPLETED:
                        if (snapshot.data!.data != null) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                                children: List.generate(snapshot.data!.data!.length, (index) {
                              Mobile mobile = snapshot.data!.data![index];
                              return Card(
                                  child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("${mobile.name}"),
                                    Text("${mobile.num}"),
                                    Row(
                                      children: [
                                        IconButton(
                                            icon: Icon(Icons.edit),
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => MobileForm(
                                                            mobile: mobile,
                                                          ))).then((value) => reloadList());
                                            },
                                        ),
                                        IconButton(
                                            color: Colors.red,
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return Dialog(
                                                      child: Padding(
                                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                                                        child: Column(
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: [
                                                            Text('Are you sure you want delete this element'),
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                              children: [
                                                                TextButton(
                                                                    onPressed: () {
                                                                      Navigator.pop(context);
                                                                    },
                                                                    child: Text('Cancel')),
                                                                ElevatedButton(
                                                                    onPressed: () async {
                                                                      await _mobileRepository.deleteMobile(
                                                                          mobile, Constants.token);
                                                                      Navigator.pop(context);
                                                                      reloadList();
                                                                    },
                                                                    child: Text('Confirm')),
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  });
                                            },
                                            icon: Icon(Icons.delete)),
                                      ],
                                    )
                                  ],
                                ),
                              ));
                            })),
                          );
                        } else {
                          return Center(child: Text('No element'));
                        }

                      case Status.ERROR:
                        return Text(
                          snapshot.error.toString(),
                        );
                      default:
                        return Container();
                    }
                  }

                  if (snapshot.connectionState == ConnectionState.waiting)
                    return Center(child: CircularProgressIndicator());

                  return Container();
                },
              )
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: "add",
            child: Icon(Icons.add),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => MobileForm())).then((value) => reloadList());
            },
          ),
          SizedBox(width: 20,),
          FloatingActionButton(
            heroTag: "assign",
            child: Icon(Icons.person_add),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => AssignForm())).then((value) => reloadList());
            },
          ),

        ],
      ),
    );
  }
}
