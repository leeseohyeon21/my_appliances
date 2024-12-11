import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class LabelScanScreen extends StatefulWidget {
  const LabelScanScreen({Key? key}) : super(key: key);

  @override
  _LabelScanScreenState createState() => _LabelScanScreenState();
}

class _LabelScanScreenState extends State<LabelScanScreen> {
  File? _image;
  final picker = ImagePicker();
  String _scannedText = '';
  String? _modelName;
  final TextEditingController _modelNameController = TextEditingController();

  bool _isModelNameSaved = false; // 모델명이 저장되었는지 여부
  bool _isImagePicked = false; // 이미지가 선택되었는지 여부

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _isImagePicked = true; // 이미지가 선택됨
      });
      _scanTextFromImage();
    }
  }

  Future<void> _scanTextFromImage() async {
    if (_image == null) return;

    final inputImage = InputImage.fromFile(_image!);
    final textRecognizer = GoogleMlKit.vision.textRecognizer();
    final recognizedText = await textRecognizer.processImage(inputImage);

    setState(() {
      _scannedText = recognizedText.text; // 인식된 텍스트 업데이트
    });

    _extractModelName(); // 모델명 추출 호출
  }

  void _extractModelName() {
    final regex = RegExp(r'([A-Z]{2,3}\d{2,4}[A-Z]?)'); // 모델명 추출 정규식
    final matches = regex.allMatches(_scannedText);

    if (matches.isNotEmpty) {
      _modelName = matches.first.group(0); // 모델명 설정
    } else {
      _modelName = null; // 매칭값 없을 때 null
    }

    setState(() {
      _modelNameController.text = _modelName ?? ''; // 모델명 필드 업데이트
    });
  }

  void _saveModelName() {
    setState(() {
      _isModelNameSaved = true; // 모델명 저장됨
      _isImagePicked = false; // 라벨 사진 숨김
    });

    context.push('/input/$_modelName');
  }

  @override
  void dispose() {
    _modelNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('라벨 스캔'),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        children: [
          if (_isModelNameSaved)
            SizedBox.shrink()
          else ...[
            if (_isImagePicked)
              _image == null
                  ? SizedBox.shrink()
                  : Image.file(_image!)
            else ...[
              Text('라벨 사진을 찍어주세요.'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('라벨 스캔'),
              ),
            ],
          ],
          SizedBox(height: 20),
          Text(
            '모델명 (수정 가능):',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: _modelNameController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: '모델명을 입력하세요',
            ),
          ),
          SizedBox(height: 20),
          if (!_isModelNameSaved)
            ElevatedButton(
              onPressed: _saveModelName,
              child: Text('모델명 저장'),
            ),
        ],
      ),
    );
  }
}

