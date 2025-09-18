import 'dart:io';
import 'package:http_parser/http_parser.dart';

/// Determines the media type of a file based on its extension.
///
/// This function takes a [File] object and returns a map with the media type
/// and subtype, such as {'image': 'png'} or {'image': 'jpeg'}.
/// It handles common image formats like PNG, JPG, and GIF.
/// If the file extension is not recognized, it returns a default value.
MediaType getMediaTypeFromFile(String file) {
  final path = file.toLowerCase();
  final extension = path.split('.').last;

  switch (extension) {
    case 'png':
      return MediaType('image', 'png');
    case 'jpg':
    case 'jpeg':
      return MediaType('image', 'jpeg');
    case 'gif':
      return MediaType('image', 'gif');
    // You can add more cases for other media types here
    default:
      return MediaType('application', 'octet-stream');
  }
}
