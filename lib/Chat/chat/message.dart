import 'package:flutter/material.dart';

class Message extends StatelessWidget {
  const Message(
      {super.key,
      required this.userName,
      required this.message,
      required this.isMe,
      required this.imageUrl});
  final String userName;
  final String imageUrl;
  final String message;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: isMe ? Colors.grey[300] : Theme.of(context).primaryColor,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(14),
              topRight: const Radius.circular(14),
              bottomLeft: !isMe ? const Radius.circular(14) : Radius.zero,
              bottomRight: isMe ? const Radius.circular(14) : Radius.zero,
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
          child: Column(
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 8,
                    color: isMe ? Colors.black : Colors.white),
              ),
              // ignore: unnecessary_null_comparison
              if (imageUrl != null && imageUrl != " ") ...[
                Container(
                    padding: const EdgeInsets.all(1),
                    width: 250,
                    height: 300,
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.fill,
                    ))
              ],

              Text(
                message,
                style: TextStyle(color: isMe ? Colors.black : Colors.white),
                textAlign: isMe ? TextAlign.end : TextAlign.start,
              )
            ],
          ),
        ),
      ],
    );
  }
}
