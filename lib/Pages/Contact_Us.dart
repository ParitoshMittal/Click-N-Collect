import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsPage extends StatelessWidget {
  final String email = 'connect.clickncollect@gmail.com';

  const ContactUsPage({super.key});

  void _launchEmailApp() async {
    final Uri uri = Uri(
      scheme: 'mailto',
      path: email,
    );

    if (await canLaunch(uri.toString())) {
      await launch(uri.toString());
    } else {
      throw 'Could not launch email app.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Us'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Contact us through our Email Id',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24.0,),
              ),
              const SizedBox(height: 8.0),
              GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: email));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Email copied to clipboard.')),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.grey[200],
                  ),
                  child: SelectableText(
                    email,
                    style: const TextStyle(fontSize: 16.0),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () => launch('mailto:$email'),
                child: const Text('Contact Us'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
