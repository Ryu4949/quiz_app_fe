import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:quiz_app_fe/model/api_adapter.dart';
import 'package:quiz_app_fe/model/model_quiz.dart';
import 'package:quiz_app_fe/screen/screen_quiz.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Quiz> quizzes = [];
  bool isLoading = false;

  _fetchQuizzes() async {
    setState(() {
      isLoading = true;
    });
    String uri = 'http://127.0.0.1:8000/quiz/3/';
    final response = await http.get(Uri.parse(uri));
    if (response.statusCode == 200) {
      setState(() {
        quizzes = parseQuizzes(utf8.decode(response.bodyBytes));
        isLoading = false;
      });
    } else {
      throw Exception('failed to laod data');
    }
  }

  // List<Quiz> quizzes = [
  //   Quiz.fromMap({
  //     'title': 'test',
  //     'candidates': ['a', 'b', 'c', 'd'],
  //     'answer': 0
  //   }),
  //   Quiz.fromMap({
  //     'title': 'test',
  //     'candidates': ['a', 'b', 'c', 'd'],
  //     'answer': 0
  //   }),
  //   Quiz.fromMap({
  //     'title': 'test',
  //     'candidates': ['a', 'b', 'c', 'd'],
  //     'answer': 0
  //   }),
  // ];
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;

    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
          child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('My Quiz App'),
          backgroundColor: Colors.deepPurple,
          leading: Container(),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Image.asset('images/quiz.jpeg', width: width * 0.8),
            ),
            Padding(
              padding: EdgeInsets.all(width * 0.024),
            ),
            Text('????????? ?????? ???',
                style: TextStyle(
                  fontSize: width * 0.065,
                  fontWeight: FontWeight.bold,
                )),
            Text(
              '????????? ?????? ??? ?????????????????????.\n????????? ?????? ?????? ????????? ???????????????.',
              textAlign: TextAlign.center,
            ),
            Padding(padding: EdgeInsets.all(width * 0.048)),
            _buildStep(width, '1. ???????????? ????????? ?????? 3?????? ???????????????.'),
            _buildStep(width, '2. ????????? ??? ?????? ????????? ?????? ???\n?????? ?????? ????????? ???????????????.'),
            _buildStep(width, '3. ????????? ?????? ????????? ?????????!'),
            Padding(
              padding: EdgeInsets.all(width * 0.048),
            ),
            Container(
                padding: EdgeInsets.only(bottom: width * 0.036),
                child: Center(
                    child: ButtonTheme(
                        minWidth: width * 0.8,
                        height: height * 0.05,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ElevatedButton(
                          child: Text(
                            '?????? ?????? ??????',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            _fetchQuizzes().whenComplete(() {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => QuizScreen(
                                            quizzes: quizzes,
                                          )));
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                          ),
                        ))))
          ],
        ),
      )),
    );
  }

  Widget _buildStep(double width, String title) {
    return Container(
        padding: EdgeInsets.fromLTRB(
          width * 0.048,
          width * 0.024,
          width * 0.048,
          width * 0.024,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Icon(
              Icons.check_box,
              size: width * 0.04,
            ),
            Padding(padding: EdgeInsets.only(right: width * 0.024)),
            Text(title),
          ],
        ));
  }
}
