import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData.light(useMaterial3: true),
    home: const ScaffoldExample(),
  ));
}

class ScaffoldExample extends StatelessWidget {
  const ScaffoldExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Weather App ʕ•ᴥ•ʔ'),
      ),
      body: const CityForm(),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Container(height: 50.0),
      ),
    );
  }
}

class CityForm extends StatefulWidget {
  const CityForm({super.key});

  @override
  CityFormState createState() {
    return CityFormState();
  }
}

class CityFormState extends State<CityForm> {
  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();
  String _displayedText = '';
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextFormField(
              controller: _textController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'City',
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      _displayedText = _textController.text;
                      _textController.clear();
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Text submitted successfully')),
                    );
                  }
                },
                child: const Text('Submit'),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _displayedText,
            style: const TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }
}
