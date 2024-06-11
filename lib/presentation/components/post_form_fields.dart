import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../../domain/models/song_model.dart';

class PostFormFields extends StatefulWidget {
  final TextEditingController descripcionController;
  final TextEditingController ubicacionController;
  final Function(String songUrl) onShare;
  final List<Song> songs;

  const PostFormFields({
    Key? key,
    required this.descripcionController,
    required this.ubicacionController,
    required this.onShare,
    required this.songs,
  }) : super(key: key);

  @override
  _PostFormFieldsState createState() => _PostFormFieldsState();
}

class _PostFormFieldsState extends State<PostFormFields> {
  late Song selectedSong;
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    print("AudioPlayer inicializado");
    // Ensure there is at least one song available, otherwise set a default "No Song" option
    selectedSong = widget.songs.isNotEmpty ? widget.songs[0] : Song('No Song', '');
  }

  void _playSelectedSong(String url) async {
 try{
      print('Intentando reproducir: $url');
      Source audioSource = UrlSource(url);
      await _audioPlayer.play(audioSource);
      Timer(Duration(seconds: 10), () {
        _audioPlayer.pause();
        print('Reproducción pausada después de 10 segundos');
     });
    } catch (e) {
      print('Error durante la reproducción del audio: $e');
    }

  }



  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: TextFormField(
            controller: widget.descripcionController,
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
            controller: widget.ubicacionController,
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
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: DropdownButton<Song>(
            value: selectedSong,
            onChanged: (Song? newValue) {
              if (newValue != null) {
                setState(() {
                  selectedSong = newValue;
                  _playSelectedSong(newValue.url);
                });
              }
            },
            items: widget.songs.map<DropdownMenuItem<Song>>((Song song) {
              return DropdownMenuItem<Song>(
                value: song,
                child: Text(song.name),
              );
            }).toList(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 40.0),
          child: ElevatedButton(
            onPressed: () => widget.onShare(selectedSong.url),
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
