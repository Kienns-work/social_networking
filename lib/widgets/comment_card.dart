import 'package:flutter/material.dart';

import '../utils/utils.dart';

class CommentCard extends StatelessWidget {
  const CommentCard({super.key, this.snap});

  final snap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundImage: NetworkImage(snap["avatar"]),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                          text: "${snap["name"]}",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: " ${snap["text"]}")
                    ]),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Text(
                      caculateTimeDurationFromNow(
                          snap["datePublished"].toDate()),
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(8),
            child: Icon(Icons.favorite_border),
          )
        ],
      ),
    );
  }
}
