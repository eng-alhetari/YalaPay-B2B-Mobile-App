import 'package:flutter/material.dart';

class TableHeader extends StatelessWidget {
  final String title;
  const TableHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    color: const Color.fromARGB(255, 237, 244, 248),
                    child: Text(
                      title, 
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[700],
                        fontSize: 16
                      ),
                    ),
                  ),
                );
  }
}

class TableEntry extends StatelessWidget {
  final String content;
  final Color? color;
  const TableEntry({super.key, required this.content, this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
                  child: Text(
                    content, 
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: color,
                      fontSize: 14,
                    ),
                  ),
                );
  }
}