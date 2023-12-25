import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class RecognizePage extends StatefulWidget {
  final String? path;
  const RecognizePage({Key? key, this.path}) : super(key: key);

  @override
  State<RecognizePage> createState() => _RecognizePageState();
}

class _RecognizePageState extends State<RecognizePage> {
  bool _isBusy = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController idNumberController = TextEditingController();
  TextEditingController dateOfIssueController = TextEditingController();
  TextEditingController dateOfExpiryController = TextEditingController();
  TextEditingController dateOfBirthController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final InputImage inputImage = InputImage.fromFilePath(widget.path!);

    processImage(inputImage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("recognized page")),
        body: _isBusy == true
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildTextField("Name", nameController),
                    buildTextField("Last Name", lastNameController),
                    buildTextField("Identification Number", idNumberController),
                    buildTextField("Date of Issue", dateOfIssueController),
                    buildTextField("Date of Expiry", dateOfExpiryController),
                    buildTextField("Date of Birth", dateOfBirthController),
                  ],
                ),
              ));
  }

  Widget buildTextField(String labelText, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: labelText),
        readOnly: true,
      ),
    );
  }

  void processImage(InputImage image) async {
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

    setState(() {
      _isBusy = true;
    });

    log(image.filePath!);
    final RecognizedText recognizedText =
        await textRecognizer.processImage(image);
    extractInformationFromText(recognizedText);

    setState(() {
      _isBusy = false;
    });
  }

  void extractInformationFromText(RecognizedText text) {
    String fullText = text.text;

    // Extract Identification Number
    RegExp idNumberRegex =
        RegExp(r'(\d{1,2}\s*\d{4}\s*\d{5}\s*\d{2}\s*\d{1,2})');
    Match? idNumberMatch = idNumberRegex.firstMatch(fullText);
    idNumberController.text = idNumberMatch?.group(1) ?? '';

    // Extract Name
    RegExp nameRegex = RegExp(r'Name\s*(.+)');
    Match? nameMatch = nameRegex.firstMatch(fullText);
    nameController.text = nameMatch?.group(1)?.trim() ?? '';

    // Extract Last Name (immediately after "Miss Nattarika" or after "Last name")
    RegExp lastNameRegex = RegExp(r'Miss Nattarika\s*(\w+)|Last name\s*(\w+)');
    Match? lastNameMatch = lastNameRegex.firstMatch(fullText);
    lastNameController.text =
        lastNameMatch?.group(1) ?? lastNameMatch?.group(2) ?? '';

    // Extract Date of Birth
    RegExp dobRegex = RegExp(r'\b(\d{1,2} [a-zA-Z]+\.? \d{4})\b');
    Match? dobMatch = dobRegex.firstMatch(fullText);
    dateOfBirthController.text = dobMatch?.group(1)?.trim() ?? '';

    // Extract Date of Expiry (look for the one after "Date of Expiry" or just before it)
    RegExp expiryRegex = RegExp(r'\b(\d{1,2} [a-zA-Z]+\.? \d{4})\b');
    int indexOfExpiry = fullText.indexOf("Date of Expiry");
    Match? expiryMatch;

    if (indexOfExpiry != -1) {
      for (int i = indexOfExpiry; i < fullText.length; i++) {
        expiryMatch = expiryRegex.firstMatch(fullText.substring(i));
        if (expiryMatch != null) {
          dateOfExpiryController.text = expiryMatch.group(1)?.trim() ?? '';
          break;
        }
      }
    } else {
      expiryMatch = expiryRegex.firstMatch(fullText);
      dateOfExpiryController.text = expiryMatch?.group(1)?.trim() ?? '';
    }

    // Extract Date of Issue
    RegExp issueRegex = RegExp(r'\b(\d{1,2} [a-zA-Z]+,? \d{4})\b');
    Match? issueMatch = issueRegex.firstMatch(fullText);
    dateOfIssueController.text = issueMatch?.group(1)?.trim() ?? '';
  }

  // void extractInformationFromText(RecognizedText text) {
  //   List<String> lines = text.text.split('\n');

  //   // Extract Identification Number (line 5)
  //   if (lines.length >= 5) {
  //     idNumberController.text = lines[4].trim();
  //   }

  //   // Extract Date of Issue (line 6)
  //   if (lines.length >= 6) {
  //     dateOfIssueController.text = lines[5].trim();
  //   }

  //   // Extract Name (line 8)
  //   if (lines.length >= 8) {
  //     RegExp nameRegex = RegExp(r'Name\s*(.+)');
  //     RegExpMatch? nameMatch = nameRegex.firstMatch(lines[7]);
  //     if (nameMatch != null) {
  //       nameController.text = nameMatch.group(1)!.trim();
  //     }
  //   }

  //   // Extract Last Name (line 9)
  //   if (lines.length >= 9) {
  //     RegExp lastNameRegex = RegExp(r'Last name\s*(.+)');
  //     RegExpMatch? lastNameMatch = lastNameRegex.firstMatch(lines[8]);
  //     if (lastNameMatch != null) {
  //       lastNameController.text = lastNameMatch.group(1)!.trim();
  //     }
  //   }

  //   // Extract Date of Birth (line 12)
  //   if (lines.length >= 12) {
  //     dateOfBirthController.text = lines[11].trim();
  //   }

  //   // Extract Date of Expiry (line 15)
  //   if (lines.length >= 15) {
  //     dateOfExpiryController.text = lines[14].trim();
  //   }
  // }
}
