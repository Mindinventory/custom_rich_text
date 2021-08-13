import 'package:custom_rich_text/custom_rich_text.dart';
import 'package:custom_rich_text/models/read_more_less_model.dart';
import 'package:flutter/material.dart';

import 'helper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage();

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.greenAccent.withOpacity(0.2),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Center(
            child: CustomRichText(
              text:
                  'MindInventory works with Enterprises, Startup, and Agencies since 2011'
                  ' providing web, mobile app development, enterprise mobility solutions & '
                  'DevOps services.\n'
                  '\nContact Us:\n'
                  'https://www.mindinventory.com'
                  '\nsales@mindinventory.com\n'
                  'India: +91-951-229-3490',
              readMoreLessModel: ReadMoreLessModel(
                trimLines: 2,
                readMoreLessStyle: kReadMoreLessStyle,
              ),
              textStyle: kTextStyle,
              linkStyle: kLinkStyle,
              highlightTermsStyle: kHighlightTermsStyle,
              onWebLinkTap: (web) {
                showSnackBar(web);
              },
              onPhoneTap: (phone) {
                showSnackBar(phone);
              },
              onEmailTap: (email) {
                showSnackBar(email);
              },
              highlightTerms: ['Mindinventory'],
              onTermTap: (text) {
                showSnackBar(text);
              },
            ),
          ),
        ),
      ),
    );
  }

  showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.greenAccent.withOpacity(0.3),
        content: Text(
          '$message has been clicked',
          style: kTextStyle,
        ),
      ),
    );
  }
}
