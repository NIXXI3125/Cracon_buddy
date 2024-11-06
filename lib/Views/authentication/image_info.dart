// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// class imageInfo extends StatelessWidget {
//   imageInfo({
//     super.key,
//   });
//   final ImagePicker _picker = ImagePicker();
//   String aadharCardPath = '';
//   String panCardPath = '';
//   String RCPath = '';
//   String DriverPhotoPath = '';
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           imagepickerwidget(
//             context: context,
//             title: 'Aadhar Card',
//             picker: _picker,
//             path: aadharCardPath,
//             onImagePicked: (value) {
//               aadharCardPath = value;
//             },
//           ),
//           imagepickerwidget(
//             context: context,
//             title: 'Pan Card',
//             picker: _picker,
//             path: panCardPath,
//             onImagePicked: (value) {
//               panCardPath = value;
//             },
//           ),
//           imagepickerwidget(
//             context: context,
//             title: 'Registration Certificate',
//             picker: _picker,
//             path: RCPath,
//             onImagePicked: (value) {
//               RCPath = value;
//             },
//           ),
//           imagepickerwidget(
//             context: context,
//             title: 'Driver Photo',
//             picker: _picker,
//             path: DriverPhotoPath,
//             onImagePicked: (value) {
//               DriverPhotoPath = value;
//             },
//           ),
//           const SizedBox(
//             height: 50,
//           ),
//           ElevatedButton(
//             onPressed: () {
//               if (aadharCardPath == '' &&
//                   panCardPath == '' &&
//                   RCPath == '' &&
//                   DriverPhotoPath == '') {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(
//                     content: Text('Please select all images'),
//                   ),
//                 );
//               } else {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(
//                     content: Text('Images Uploaded Successfully'),
//                   ),
//                 );
//               }
//             },
//             child: const Text('Submit'),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
