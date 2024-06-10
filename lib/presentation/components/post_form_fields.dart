import 'package:flutter/material.dart';

class PostFormFields extends StatelessWidget {
  final TextEditingController descripcionController;
  final TextEditingController ubicacionController;
  final VoidCallback onShare;

  const PostFormFields({
    Key? key,
    required this.descripcionController,
    required this.ubicacionController,
    required this.onShare,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: TextFormField(
            controller: descripcionController,
            decoration: const InputDecoration(
              border: InputBorder.none,
              labelText: 'Escribe un texto',
              labelStyle: TextStyle(
                fontSize: 18.0,
                color: Color(0xFF000000),
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: TextFormField(
            controller: ubicacionController,
            decoration: InputDecoration(
              border: InputBorder.none,
              labelText: 'Ubicación',
              labelStyle: const TextStyle(
                fontSize: 18.0,
                color: Color(0xFF000000),
                fontWeight: FontWeight.w400,
              ),
              prefixIcon: Image.asset(
                'assets/images/location.png',
                width: 50,
                height: 50,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 40.0),
          child: ElevatedButton(
            onPressed: onShare,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEEA1A3),
              minimumSize: const Size(312, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
            ),
            child: const Text(
              'Compartir',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
                fontWeight: FontWeight.normal,
                fontFamily: 'FiraSansCondensed',
              ),
            ),
          ),
        ),
      ],
    );
  }
}
