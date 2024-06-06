import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker_plus/image_picker_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:red_social/infraestructure/repositories/Firebase_db.dart';
import 'package:red_social/presentation/pages/Home_page.dart';
import 'package:video_player/video_player.dart';

import '../../domain/models/Post_model.dart';
import '../../domain/uses_cases/create_post_usecase.dart';
import '../../infraestructure/repositories/post_repositoryimpl.dart';


class ChoosePhotoPage extends StatefulWidget {
  const ChoosePhotoPage({Key? key}) : super(key: key);
  @override
  State<ChoosePhotoPage> createState() => _ChoosePhotoPageState();
}

class _ChoosePhotoPageState extends State<ChoosePhotoPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _openImagePicker();
    });
  }

  Future<void> _openImagePicker() async {
    ImagePickerPlus picker = ImagePickerPlus(context);
    SelectedImagesDetails? details = await picker.pickBoth(
      source: ImageSource.both,
      multiSelection: true,
      galleryDisplaySettings: GalleryDisplaySettings(
        cropImage: true,
        showImagePreview: true,
      ),
    );
    if (details != null) await displayDetails(details);
  }

  Future<void> displayDetails(SelectedImagesDetails details) async {
    await Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) {
          return DisplayImages(
            selectedBytes: details.selectedFiles,
            details: details,
            aspectRatio: details.aspectRatio,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Choose Photo')),
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class DisplayImages extends StatefulWidget {
  final List<SelectedByte> selectedBytes;
  final double aspectRatio;
  final SelectedImagesDetails details;

  const DisplayImages({
    Key? key,
    required this.details,
    required this.selectedBytes,
    required this.aspectRatio
  }) : super(key: key);

  @override
  State<DisplayImages> createState() => _DisplayImagesState();
}

class _DisplayImagesState extends State<DisplayImages> {
  final TextEditingController _ubicacionController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();

  Future<String> _uploadImage(File imageFile) async {
    try {
      Reference storageRef = FirebaseStorage.instance.ref().child('images/${DateTime.now().toString()}');

      UploadTask uploadTask = storageRef.putFile(imageFile);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      String downloadURL = await taskSnapshot.ref.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Error al cargar la imagen: $e');
      return '';
    }
  }

  Future<void> _sharePost() async {
    try {
      String imageUrl = await _uploadImage(widget.selectedBytes[0].selectedFile);


      PostModel post = PostModel(
        name: 'kristell',
        descripcion: _descripcionController.text,
        ubicacion: _ubicacionController.text,
        img: imageUrl,
      );

      await CreatePostUseCase(PostRepositoryImpl(FirebaseConnection())).execute('post', post);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } catch (e) {
      print('Error al compartir el post: $e');
    }
  }



@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nueva publicación')),

      body:
    Padding(
    padding: const EdgeInsets.only(top: 30),
      child: ListView.builder(
        itemBuilder: (context, index) {
          SelectedByte selectedByte = widget.selectedBytes[index];
          if (!selectedByte.isThatImage) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _DisplayVideo(selectedByte: selectedByte),
                  const SizedBox(height: 8),
                  TextField(

                    decoration: InputDecoration(
                      labelText: 'Descripción',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Otro texto',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: SizedBox(
                      width: 312,
                      height: 200,
                      child: Image.file(selectedByte.selectedFile,
                          fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30.0),
                    child: TextFormField(
                      controller: _descripcionController,
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30.0),
                    child: TextFormField(
                      controller: _ubicacionController,
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
                      onPressed:
                        _sharePost,
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
              ),
            );
          }
        },
        itemCount: widget.selectedBytes.length,
      ),)
    );
  }

}

class _DisplayVideo extends StatefulWidget {
  final SelectedByte selectedByte;
  const _DisplayVideo({Key? key, required this.selectedByte}) : super(key: key);

  @override
  State<_DisplayVideo> createState() => _DisplayVideoState();
}

class _DisplayVideoState extends State<_DisplayVideo> {
  late VideoPlayerController controller;
  late Future<void> initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    File file = widget.selectedByte.selectedFile;
    controller = VideoPlayerController.file(file);
    initializeVideoPlayerFuture = controller.initialize();
    controller.setLooping(true);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: SizedBox(
              width: 312,
              height: 200,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AspectRatio(
                    aspectRatio: controller.value.aspectRatio,
                    child: VideoPlayer(controller),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          if (controller.value.isPlaying) {
                            controller.pause();
                          } else {
                            controller.play();
                          }
                        });
                      },
                      child: Icon(
                        controller.value.isPlaying
                            ? Icons.pause
                            : Icons.play_arrow,
                        color: Colors.white,
                        size: 45,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(strokeWidth: 1),
          );
        }
      },
    );
  }
}
