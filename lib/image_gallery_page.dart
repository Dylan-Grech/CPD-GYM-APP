import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class ImageGalleryPage extends StatefulWidget {
  @override
  _ImageGalleryPageState createState() => _ImageGalleryPageState();
}

class _ImageGalleryPageState extends State<ImageGalleryPage> {
  List<File> _images = [];

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> _loadImages() async {
    final directory = await getApplicationDocumentsDirectory();
    final picturesDirectory = Directory('${directory.path}/Pictures');

    if (await picturesDirectory.exists()) {
      final List<FileSystemEntity> files = picturesDirectory.listSync();
      setState(() {
        _images = files
            .where((file) => file.path.endsWith('.jpg')) 
            .map((file) => File(file.path))
            .toList();
      });

      print("Images found: ${_images.length}");
      _images.forEach((file) {
        print("Image: ${file.path}");
      });
    } else {
      print("Pictures directory does not exist.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('In-App Gallery')),
      body: _images.isEmpty
          ? Center(child: Text('No images yet'))
          : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, 
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemCount: _images.length,
              itemBuilder: (context, index) {
                return Image.file(
                  _images[index],
                  fit: BoxFit.cover,
                );
              },
            ),
    );
  }
}
