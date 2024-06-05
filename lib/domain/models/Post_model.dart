
import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {

  PostModel({
    required this.name,
    required this.descripcion,
    required this.ubicacion,
    required this.img,
  });

  String name;
  String descripcion;
  String ubicacion;
  String img;

  factory PostModel.fromMap(Map<String, dynamic> json) => PostModel(
    name: json['name'],
    ubicacion: json['ubicacion'],
    descripcion: json['descripcion'],
    img: json['img'],
  );

  Map<String, dynamic> toMap() => {
    'name': name,
    'ubicacion': ubicacion,
    'descripcion': descripcion,
    'img': img,
  };

  factory PostModel.fromFirestore(DocumentSnapshot documentSnapshot) {
    var post= PostModel.fromMap(documentSnapshot.data() as Map<String, dynamic>);
    return post;
  }
}
