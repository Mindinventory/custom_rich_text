import 'package:custom_rich_text/custom_rich_text.dart';
import 'package:custom_rich_text/models/read_more_less_model.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'helper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          ),
          Positioned(
            top: 0.0,
            height: 350,
            width: MediaQuery.of(context).size.width,
            child: Container(
              color: Colors.black,
              padding: EdgeInsets.only(bottom: 60),
              child: Image.asset(
                kDetailImagePath,
                fit: BoxFit.fill,
              ),
            ),
          ),
          Positioned(
            top: 280,
            // height: 100,
            width: MediaQuery.of(context).size.width,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.white,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(40),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      kMindinventory,
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Colors.black),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5.0, bottom: 18.0),
                      child: Text(
                          'UI Design & Web, Mobile App Development Company',
                          style: kTextStyle),
                    ),
                    Text(
                      kDetails,
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Colors.black),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CustomRichText(
                      text: 'MindInventory is first-rate choice of the '
                          'clients worldwide. With sheer customer satisfaction in mind, we are profoundly '
                          'dedicated to developing highly intriguing apps that strictly meet the business '
                          'requirements and catering a wide spectrum of projects. Kickstart Your Digital '
                          'Journey Today and get all your queries and concerns answered by our business '
                          'development team. Our email address is sales@mindinventory.com, our website '
                          'https://www.mindinventory.com and our Contact number is +91-951-229-3490',
                      caseSensitive: false,
                      readMoreLessModel: ReadMoreLessModel(
                        trimLines: 2,
                        readMoreText: ' read more',
                        readLessText: ' read less',
                        readMoreLessStyle: kReadMoreLessStyle,
                      ),
                      textStyle: kTextStyle,
                      linkStyle: kLinkStyle,
                      highlightTermsStyle: kLinkStyle,
                      onWebLinkTap: (web) async {
                        await launch(web);
                      },
                      onPhoneTap: (phone) async {
                        await launch('tel:$phone');
                      },
                      onEmailTap: (email) async {
                        await launch('mailto:$email');
                      },
                      highlightTerms: [kMindinventory],
                      onTermTap: (text) async {
                        await launch('https://www.mindinventory.com/');
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 44,
            right: 20,
            child: Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.white,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: Image.asset(
                kLikedImagePath,
              ),
            ),
          ),
        ],
      ),
    );
  }

  showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.white,
        content: Text(
          '$message has been clicked',
          style: kReadMoreLessStyle,
        ),
      ),
    );
  }
}
