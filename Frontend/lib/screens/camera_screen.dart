import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import '../services/api_service.dart';
import '../app_routes.dart';

class CameraScreen extends StatefulWidget {
  final String category;
  const CameraScreen({super.key, required this.category});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    _cameraController = CameraController(
      _cameras![0],
      ResolutionPreset.medium,
    );
    await _cameraController!.initialize();
    setState(() {
      _isCameraInitialized = true;
    });
  }

  Future<void> _takePicture() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized || _isProcessing) return;

    setState(() {
      _isProcessing = true;
    });

    final XFile image = await _cameraController!.takePicture();
    await _analyzeImage(File(image.path));
  }

  Future<void> _pickFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      await _analyzeImage(File(picked.path));
    }
  }

  Future<void> _analyzeImage(File imageFile) async {
    final result = await ApiService.analyzeImage(imageFile.path, widget.category);
    setState(() {
      _isProcessing = false;
    });
    if (!mounted) return;
    Navigator.pushNamed(context, AppRoutes.results, arguments: {
      'category': widget.category,
      'imageUri': imageFile.path,
      'results': result
    });
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Scan ${widget.category} Ingredients'),
        backgroundColor: Colors.black,
      ),
      body: _isCameraInitialized
          ? Stack(
              children: [
                CameraPreview(_cameraController!),
                if (_isProcessing)
                  const Center(child: CircularProgressIndicator(color: Colors.white)),
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.photo_library, color: Colors.white, size: 30),
                        onPressed: _pickFromGallery,
                      ),
                      IconButton(
                        icon: const Icon(Icons.camera, color: Colors.white, size: 40),
                        onPressed: _takePicture,
                      ),
                    ],
                  ),
                ),
              ],
            )
          : const Center(child: CircularProgressIndicator(color: Colors.white)),
    );
  }
}
