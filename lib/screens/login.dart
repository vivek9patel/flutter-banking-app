import 'package:flutter/material.dart';
import 'package:basic_banking/screens/home.dart';
import 'package:basic_banking/authentication/sign_in_google.dart';

class Home extends StatelessWidget {
  const Home({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage("images/login_bg.jpg"),
        fit: BoxFit.cover,
      )),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SafeArea(child: Body()),
      ),
    );
  }
}

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      alignment: Alignment.center,
      widthFactor: 1,
      heightFactor: 1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image(
                image: AssetImage("images/logo.png"),
                height: 200,
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                "Basic Banking",
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "by",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[900]),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "vivek9patel",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.blueGrey[800]),
                  ),
                ],
              )
            ],
          ),
          Column(
            children: [
              Container(
                width: 200,
                child: RaisedButton(
                    color: Colors.white,
                    shape: StadiumBorder(),
                    padding: EdgeInsets.all(10),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image(
                            image: AssetImage("images/google_logo.png"),
                            height: 32,
                          ),
                          Text("Sign in with Google")
                        ]),
                    onPressed: () {
                      signInWithGoogle().then((userDetails) {
                        if (userDetails != null) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    CustomersList(userDetails: userDetails)),
                            (Route<dynamic> route) => false,
                          );
                        } else {
                          print("Error in Sign in With Google!");
                        }
                      });
                    }),
              ),
              SizedBox(
                height: 100,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
