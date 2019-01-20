import '../../models/user.dart';
import 'package:flutter/material.dart';
import '../../app/assets.dart';
import '../../app/app_colors.dart';
import '../../services/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatefulWidget {
  User profile;
  ProfileScreen({Key key, this.profile}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return new _OrderScreenState();
  }
}

class _OrderScreenState extends State<ProfileScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    UserService().fetchUser().then((QuerySnapshot res) {
      if (res != null) {
        print("fetchUser res.documents ${res.documents}");
        setState(() {
          widget.profile =
              User.fromJson(res.documents[res.documents.length - 1].data);
        });
        // print("fetchUser widget.profile ${widget.profile.toJson()}");
      } else {
        print("fetchUser res $res");
      }
    }).catchError((err) {
      print("fetchUser err $err");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
            elevation: .5,
            title: Text("Profile"),
            centerTitle: true,
            leading: new FlatButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: new Icon(Icons.arrow_back, color: AppColors.white),
            )),
        body: FutureBuilder<QuerySnapshot>(
            future: UserService().fetchUser(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(
                    child: const CircularProgressIndicator(),
                  );
                default:
                  if (snapshot.hasError || widget.profile == null) {
                    print(
                        'UserService().fetchUser snapshot Error: ${snapshot.error}');
                    return Text('Error: ${snapshot.error}');
                  } else {
                    print(
                        'UserService().fetchUser snapshot hasData: ${snapshot.data.documents.last}');

                    if (widget.profile != null) {
                      print(
                          'UserService().fetchUser snapshot widget.profilenew: ${widget.profile.toJson()}');

                      return Center(child:Column(
                        children: <Widget>[
                          widget.profile.thumbnailUrl != null
                              ? Container(
                                  padding: EdgeInsets.only(left: 10.0),
                                  height:
                                      MediaQuery.of(context).size.height * 0.5,
                                  child: Image.network(
                                      widget.profile.thumbnailUrl,
                                      fit: BoxFit.fitWidth))
                              : Padding(
                                  padding: EdgeInsets.all(0.0),
                                ),
                          new Text(""+"${widget.profile.username}",
                              style: Theme.of(context).textTheme.display2),
                          new Text(""+"${widget.profile.email}",
                              style: Theme.of(context).textTheme.display1),
                          new Text(""+"${widget.profile.mobile}",
                              style: Theme.of(context).textTheme.display1),
                          new Text(""+"${widget.profile.providerId}",
                              style: Theme.of(context).textTheme.display1),
                        ],
                      ));
                    } else {
                      return Text("Loading");
                    }
                  }
              }
            }));
  }
}
//{username: , email: shakti@sunfra.in, password: null, thumbnailUrl: https://lh5.googleusercontent.com/-Ft5Twugp9P8/AAAAAAAAAAI/AAAAAAAAAIQ/tsQamIZLYGI/s96-c/photo.jpg, uid: jCZ89vvFdOaO5lLRc08q2qrRLX23, providerId: firebase, mobile: null}
