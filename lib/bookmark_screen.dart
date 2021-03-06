import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'detail_screen.dart';

class BookmarkScreen extends StatefulWidget {
  final FirebaseUser user;
  List<DocumentSnapshot> monumentList;

  BookmarkScreen({this.user, this.monumentList});

  @override
  _BookmarkScreenState createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  Future getBookmarkedMonuments() async {
    QuerySnapshot query = await Firestore.instance
        .collection('bookmarks')
        .where("auth_id", isEqualTo: widget.user.uid)
        .getDocuments();
    return query.documents;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          title: Text(
            'Explore Bookmark Monuments',
            style: TextStyle(
                fontSize: 19.0,
                fontWeight: FontWeight.bold,
                color: Colors.amber),
          ),
        ),
        body: StreamBuilder(
            stream: Firestore.instance
                .collection('bookmarks')
                .where("auth_id", isEqualTo: widget.user.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return Center(child: CircularProgressIndicator());
              if (!snapshot.hasData || snapshot.data.documents.length <= 0)
                return Container(
                  child: Center(
                      child: Text(
                    'No Bookmarks!',
                    style:
                        TextStyle(fontWeight: FontWeight.w700, fontSize: 26.0),
                  )),
                );

              widget.monumentList = snapshot.data.documents;
              return ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: widget.monumentList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                        onTap: () {
                          print(widget.monumentList);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => DetailScreen(
                                        user: widget.user,
                                        monument: widget.monumentList[index],
                                        isBookMarked: true,
                                      )));
                        },
                        child: Card(
                            margin: EdgeInsets.all(15.0),
                            elevation: 10.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.2,
                                child: Row(children: <Widget>[
                                  Hero(
                                      tag: widget.monumentList[index]
                                              .data['wiki'] ??
                                          'monument-tag',
                                      child: Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.2,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.3,
                                        decoration: BoxDecoration(
                                            color: Colors.grey,
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(20.0),
                                                bottomLeft:
                                                    Radius.circular(20.0)),
                                            image: DecorationImage(
                                                image: NetworkImage(widget
                                                    .monumentList[index]
                                                    .data['image']),
                                                fit: BoxFit.cover)),
                                      )),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Expanded(
                                      child: Container(
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                        Text(
                                          widget
                                              .monumentList[index].data['name'],
                                          style: TextStyle(
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.57,
                                          child: Text(
                                            widget.monumentList[index]
                                                    .data['city'] +
                                                ', ' +
                                                widget.monumentList[index]
                                                    .data['country'],
                                            maxLines: 3,
                                            style: TextStyle(
                                              fontSize: 18.0,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Text(
                                              'Explore more',
                                              style: TextStyle(
                                                  color: Colors.amber,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(
                                              width: 6.0,
                                            ),
                                            Icon(
                                              Icons.chevron_right,
                                              color: Colors.amber,
                                            )
                                          ],
                                        ),
                                      ])))
                                ]))));
                  });
            }));
  }
}
