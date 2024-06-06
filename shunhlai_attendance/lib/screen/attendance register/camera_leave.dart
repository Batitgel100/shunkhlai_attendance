// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shunhlai_attendance/screen/main/main_screen.dart';
import 'package:shunhlai_attendance/service/attendance/register_attendance.dart';

class CameraAppLeave extends StatefulWidget {
  final bool isInLocation;
  final Function(String) onImageCaptured;

  const CameraAppLeave(
      {Key? key, required this.onImageCaptured, required this.isInLocation})
      : super(key: key);

  @override
  _CameraAppLeaveState createState() => _CameraAppLeaveState();
}

class _CameraAppLeaveState extends State<CameraAppLeave> {
  late CameraController _durationController;
  late List<CameraDescription> cameras;
  bool isCameraInitialized = false;
  String base64String = '';
  RegisterAttendanceLeft registerAttendance = RegisterAttendanceLeft();

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  void registerCame() {
    registerAttendance.register(base64String, context);

    //   // Utils.flushBarSuccessMessage('Амжилттай бүртгэгдлээ.', context);
  }

  Future<void> initializeCamera() async {
    await requestCameraPermission();

    cameras = await availableCameras();
    _durationController = CameraController(cameras[0], ResolutionPreset.medium);

    // Set the image format group explicitly
    _durationController.setFlashMode(FlashMode.off);
    await _durationController.initialize();

    if (!mounted) {
      return;
    }

    setState(() {
      isCameraInitialized = true;
    });
  }

  Future<void> requestCameraPermission() async {
    var status = await Permission.camera.status;
    if (status.isDenied) {
      // We didn't ask for permission yet, so request it
      await Permission.camera.request();
    }
  }

  @override
  void dispose() {
    _durationController.dispose();
    super.dispose();
  }

  Future<void> captureAndConvertToBase64() async {
    if (!_durationController.value.isInitialized) {
      return;
    }
    XFile imageFile = await _durationController.takePicture();
    String base64String = await convertImageToBase64(imageFile.path);
    setState(() {
      this.base64String = base64String;
    });

    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              content: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.4,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue, width: 3),
                  borderRadius:
                      BorderRadius.circular(20), // Adjust the radius as needed
                  image: DecorationImage(
                    image: MemoryImage(base64Decode(base64String)),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      registerCame();
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const MainScreen()));
                    },
                    child: const Text('Илгээх'))
              ],
            ));
  }

  Future<String> convertImageToBase64(String imagePath) async {
    File imageFile = File(imagePath);
    Uint8List imageBytes = await imageFile.readAsBytes();
    String base64String = base64Encode(imageBytes);
    return base64String;
  }

  Future<void> toggleCamera() async {
    if (cameras.length < 2) {
      return; // There is only one camera, so no need to toggle
    }

    int currentCameraIndex = cameras.indexOf(_durationController.description);
    int newCameraIndex = (currentCameraIndex + 1) % cameras.length;
    CameraDescription newCamera = cameras[newCameraIndex];

    await _durationController.dispose();
    _durationController = CameraController(newCamera, ResolutionPreset.medium);
    _durationController.setFlashMode(FlashMode.off);
    await _durationController.initialize();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (!isCameraInitialized) {
      return Container(); // You can show a loading indicator here
    }

    return Scaffold(
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.18,
            color: Colors.black,
          ),
          Expanded(
            child: CameraPreview(_durationController),
          ),
          Container(
            color: const Color.fromARGB(255, 0, 0, 0),
            height: MediaQuery.of(context).size.height * 0.22,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 32.0, top: 35),
                        child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Буцах',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          captureAndConvertToBase64();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(25.0),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(60),
                                color: Colors.white),
                            height: 72,
                            width: 72,
                            padding: const EdgeInsets.all(2.0),
                            child: Container(
                              height: 70,
                              width: 70,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.black, width: 3),
                                  borderRadius: BorderRadius.circular(60),
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 32.0, top: 35),
                        child: InkWell(
                          onTap: toggleCamera,
                          child: const Icon(
                            Icons.cameraswitch_sharp,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
