import 'package:drivers_app/colors.dart';
import 'package:flutter/material.dart';

Widget documentlistwidget({
  required String imgSource,
  required String title,
}) {
  return Container(
    margin: const EdgeInsets.all(15),
    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: tertiary,
    ),
    child: Column(
      children: [

        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            imgSource,
            height: 150,
            width: 150,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              return SizedBox(height: 150,width: 150,child: Align(alignment: Alignment.center,child: CircularProgressIndicator()));
            },
            errorBuilder: (context, error, stackTrace) {
              return const SizedBox(
                height: 150,
                width: 150,
                child: Align(
                  alignment: Alignment.center,
                  child: Text('Error Loading Image'),
                ),
              );
            },
          ),
        ),
        Text(title)
      ],
    ),
  );
}
