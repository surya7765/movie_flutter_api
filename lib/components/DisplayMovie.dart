// import material.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import http as http
import 'package:http/http.dart' as http;

class DisplayMovie extends StatefulWidget {
  DisplayMovie({Key? key}) : super(key: key);

  @override
  State<DisplayMovie> createState() => _DisplayMovieState();
}

class _DisplayMovieState extends State<DisplayMovie> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _getUserData();
    _fetchData();
  }

  final queryParameters = {
    'category': 'movies',
    'language': 'kannada',
    'genre': 'all',
    'sort_by': 'voting',
  };

  var jsonData;

  // post data to url and get response
  void _fetchData() async {
    var response = await http.post(
        Uri.parse('https://hoblist.com/api/movieList'),
        body: queryParameters);
    // return response
    print(response.body);
    if (response.statusCode == 200) {
      setState(() {
        var data = json.decode(response.body);
        jsonData = data["result"];
        isLoading = true;
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  String _email = "";
  String _name = "";
  String _phone = "";
  String _profession = "";

  _getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _email = prefs.getString('email')!;
      _name = prefs.getString('name')!;
      _phone = prefs.getString('phone')!;
      _profession = prefs.getString('profession')!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text(_name.isEmpty ? 'Name' : _name),
            ),
            ListTile(
              leading: Icon(Icons.email_rounded),
              title: Text(_email.isEmpty ? 'Email' : _email),
            ),
            ListTile(
              leading: Icon(Icons.phone_android_rounded),
              title: Text(_phone.isEmpty ? 'Phone' : _phone),
            ),
            ListTile(
              leading: Icon(Icons.work_rounded),
              title: Text(_profession.isEmpty ? 'Profession' : _profession),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Display Movie'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.info_outline_rounded,
              color: Colors.white,
            ),
            onPressed: () {
              // do something
              showModalBottomSheet(
                context: context,
                // color is applied to main screen when modal bottom screen is displayed
                barrierColor: Colors.black.withOpacity(0.5),
                //background color for modal bottom screen
                backgroundColor: Colors.blueGrey,
                //elevates modal bottom screen
                elevation: 10,
                // gives rounded corner to modal bottom screen
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                builder: (BuildContext context) {
                  // UDE : SizedBox instead of Container for whitespaces
                  return SizedBox(
                    height: 200,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          newMethod(
                            boldtext: "Company",
                            normaltext: " : Geeksenergy Technologies Pvt. Ltd.",
                          ),
                          newMethod(
                            boldtext: "Address",
                            normaltext: " : Sanjayanagar, Bengaluru-56",
                          ),
                          newMethod(
                            boldtext: "Phone",
                            normaltext: " : 1234567890",
                          ),
                          newMethod(
                            boldtext: "Address",
                            normaltext: " : example@gmail.com",
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          )
        ],
      ),
      body: isLoading
          ? ListView.builder(
              itemCount: jsonData == null ? 0 : jsonData.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(50.0),
                      child: Image.network(
                        jsonData[index]["poster"],
                      ),
                    ),
                    title: Text(jsonData[index]["title"]),
                    subtitle: RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Genre: ',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: jsonData[index]["genre"],
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                          TextSpan(
                            text: '\nDirector: ',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: jsonData[index]["director"][0],
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                          TextSpan(
                            text: '\nStarring: ',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                // stars is a list so parsing it to string
                                text: jsonData[index]["stars"]
                                    .toString()
                                    .replaceRange(
                                        18,
                                        jsonData[index]["stars"]
                                            .toString()
                                            .length,
                                        "...")
                                    .replaceAll('[', '')
                                    .replaceAll(']', ''),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                          TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                // runTime can be null so deal with it
                                text: jsonData[index]["runTime"] == null
                                    ? ''
                                    : '\n\n' +
                                        jsonData[index]["runTime"].toString() +
                                        'mins | ' +
                                        jsonData[index]["language"],
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              TextSpan(
                                // runTime can be null so deal with it
                                text: '\n ' +
                                    jsonData[index]["pageViews"].toString() +
                                    'views',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              TextSpan(
                                // runTime can be null so deal with it
                                text: ' | voted by ' +
                                    jsonData[index]["totalVoted"].toString() +
                                    'people',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // trailling thumbsup icon with vote count text
                    trailing: Column(
                      children: <Widget>[
                        Icon(
                          Icons.thumb_up,
                          color: Colors.blue,
                        ),
                        Text(
                          jsonData[index]["totalVoted"].toString(),
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  Widget getTextWidgets(List<dynamic> strings) {
    return new Row(children: strings.map((item) => new Text(item)).toList());
  }

  RichText newMethod({required String boldtext, required String normaltext}) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          color: Colors.black,
        ),
        children: <TextSpan>[
          TextSpan(
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            text: boldtext,
          ),
          TextSpan(
            style: TextStyle(
              fontSize: 14,
            ),
            text: normaltext,
          ),
        ],
      ),
    );
  }
}
