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
import '../components/post_form_fields.dart';

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
    required this.aspectRatio,
  }) : super(key: key);

  @override
  State<DisplayImages> createState() => _DisplayImagesState();
}

class _DisplayImagesState extends State<DisplayImages> {
  final TextEditingController _ubicacionController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final PostRepositoryImpl _postRepository = PostRepositoryImpl(FirebaseConnection());

  Future<void> _sharePost() async {
    try {
      SelectedByte selectedByte = widget.selectedBytes[0];
      String mediaUrl = await _postRepository.uploadFile(selectedByte.selectedFile, !selectedByte.isThatImage);

      PostModel post = PostModel(
        name: 'kristell',
        descripcion: _descripcionController.text,
        ubicacion: _ubicacionController.text,
        img: mediaUrl,
        isVideo: !selectedByte.isThatImage,
      );

      await CreatePostUseCase(_postRepository).execute('post', post);
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
      body: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: ListView.builder(
          itemBuilder: (context, index) {
            SelectedByte selectedByte = widget.selectedBytes[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  selectedByte.isThatImage
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: SizedBox(
                      width: 312,
                      height: 200,
                      child: Image.file(selectedByte.selectedFile, fit: BoxFit.cover),
                    ),
                  )
                      : _DisplayVideo(selectedByte: selectedByte),
                  const SizedBox(height: 20),
                  PostFormFields(
                    descripcionController: _descripcionController,
                    ubicacionController: _ubicacionController,
                    onShare: _sharePost,
                  ),
                ],
              ),
            );
          },
          itemCount: widget.selectedBytes.length,
        ),
      ),
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
                        controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
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
