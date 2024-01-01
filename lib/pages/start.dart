import 'package:flutter/material.dart';

class Start extends StatelessWidget {
  const Start({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple,
      appBar: AppBar(
        title: const Text('To do list'),
        centerTitle: true,
        backgroundColor: Colors.black38,
        foregroundColor: Colors.white,
      ),
        body: Column(
          children: [
           const Text('Start'),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/todo');
                },
                child: const Text('Go to Home')
            )
          ],
        )
    );
  }
}
