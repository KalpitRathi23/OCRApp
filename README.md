# Thai ID OCR App

The Thai ID OCR App is designed to extract information from Thai ID cards using Optical Character Recognition (OCR). The application integrates with the Google Vision API for OCR processing, stores the results in a MongoDB database, and provides a user-friendly web interface for interacting with the system.

## Features

- OCR Processing: Utilizes the Google ML Kit Text Recognition to accurately read text from different Thai ID cards.
- Image Cropping: Allows users to crop and upload specific regions of Thai ID card images for OCR processing.
- Data Extraction and Structuring: Parses OCR results to extract key information such as ID number, name, last name, date of birth, date of issue, and date of expiry.
- User Interface: Provides a UI to upload Thai ID card images (png, jpeg, jpg) and view JSON results.

## Dependencies

In a Flutter project, dependencies are managed using the pubspec.yaml file.
- image_picker: Allows users to pick images from the device gallery.
- image_cropper: Provides functionality for image cropping. This is useful for selecting specific regions of an image before OCR processing.
- google_mlkit_text_recognition: Integrates Google's ML Kit for Text Recognition, which is used for OCR processing in your app.

## Setup

Here is the link to the google Drive containing the APK of application. Please download and install this APK. After this, you are good to go.
- [OCR Apk](https://drive.google.com/file/d/1yORtR7qLWfYhfiTCuBHzMHyHx4aHMaMY/view?usp=sharing)
