import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final firstCamera = cameras.first;
  runApp(CameraApp(firstCamera));
}

class CameraApp extends StatelessWidget {
  final CameraDescription camera;

  const CameraApp(this.camera);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Camera Server App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CameraServerScreen(camera),
    );
  }
}

class CameraServerScreen extends StatefulWidget {
  final CameraDescription camera;

  const CameraServerScreen(this.camera);

  @override
  _CameraServerScreenState createState() => _CameraServerScreenState();
}

class _CameraServerScreenState extends State<CameraServerScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Camera Server App'),
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _startServer,
        tooltip: 'Start Server',
        child: Icon(Icons.play_arrow),
      ),
    );
  }

  void _startServer() async {
    final cascade = Cascade().add((Request request) async {
      if (request.url.path == '/test') {
        // Return a simple text response
        return Response.ok('Test endpoint working!');
      } else if (request.url.path == '/camera.jpg') {
        // Capture a photo from the camera
        final imgBytes = await _capturePhoto();
        if (imgBytes.isNotEmpty) {
          return Response.ok(imgBytes, headers: {'Content-Type': 'image/jpeg'});
        } else {
          return Response.notFound('Not Found');
        }
      } else {
        final imgBytes = await _capturePhoto();
        if (imgBytes.isNotEmpty) {
          return Response.ok(imgBytes, headers: {'Content-Type': 'image/jpeg'});
        } else {
          return Response.notFound('Not Found');
        }
        return Response.notFound('Not Found');
      }
    });

    final handler =
        Pipeline().addMiddleware(logRequests()).addHandler(cascade.handler);

    final server = await shelf_io.serve(handler, '192.168.1.203', 8123);
    print('Server started at http://${server.address.host}:${server.port}');
    print('Local IP: ${server.address.address}');
  }

  Future<List<int>> _capturePhoto() async {
    try {
      final XFile capturedFile = await _controller.takePicture();
      if (capturedFile != null) {
        final List<int> imageBytes =
            await File(capturedFile.path).readAsBytes();
        return imageBytes;
      } else {
        print('Captured file is null');
        return [];
      }
    } catch (error) {
      print('Error capturing photo: $error');
      return []; // Return an empty list on error
    }
  }
}
