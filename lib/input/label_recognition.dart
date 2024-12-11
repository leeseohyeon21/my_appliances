import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:my_appliances/input/register_screen.dart';

class LabelRecognitionScreen extends StatefulWidget {
  const LabelRecognitionScreen({super.key});

  @override
  State<LabelRecognitionScreen> createState() => _LabelRecognitionScreenState();
}

class _LabelRecognitionScreenState extends State<LabelRecognitionScreen> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  final TextRecognizer _textRecognizer = GoogleMlKit.vision.textRecognizer();
  bool _isProcessing = false;
  String? _recognizedText;

  Future<void> _pickImage(ImageSource source) async {
    setState(() {
      _isProcessing = true;
      _recognizedText = null;
    });

    try {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile == null) {
        setState(() => _isProcessing = false);
        return;
      }

      final imageFile = File(pickedFile.path);
      setState(() => _imageFile = imageFile);

      // 텍스트 인식 실행
      await _recognizeText(imageFile);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('에러 발생: $e')),
      );
      setState(() => _isProcessing = false);
    }
  }

  Future<void> _recognizeText(File imageFile) async {
    try {
      final inputImage = InputImage.fromFile(imageFile);
      final recognizedText = await _textRecognizer.processImage(inputImage);

      final modelNames = recognizedText.blocks
          .map((block) => block.text.trim()) // 텍스트의 앞뒤 공백 제거
          .where((text) => RegExp(r'^[A-Za-z]+[0-9]+[A-Za-z]+$').hasMatch(text))
          .toList();

      if (modelNames.isNotEmpty) {
        final initialModelName = modelNames.join(", ");
        setState(() => _recognizedText = initialModelName);

        // 등록 화면으로 이동
        context.push('/register', extra: initialModelName);
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => RegisterScreen(initialModelName: initialModelName),
        //   ),
        // );
      } else {
        setState(() => _recognizedText = "모델명을 찾을 수 없습니다.");
      }
    } catch (e) {
      setState(() {
        _recognizedText = "텍스트 인식 중 오류 발생: $e";
      });
    } finally {
      setState(() => _isProcessing = false);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('제품 라벨 인식'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_imageFile != null)
              Image.file(
                _imageFile!,
                width: double.infinity,
                height: 300,
                fit: BoxFit.cover,
              ),
            const SizedBox(height: 16),
            if (_isProcessing)
              const CircularProgressIndicator()
            else
              ElevatedButton.icon(
                onPressed: () => _pickImage(ImageSource.camera),
                icon: const Icon(Icons.camera_alt),
                label: const Text('카메라로 찍기'),
              ),
            ElevatedButton.icon(
              onPressed: () => _pickImage(ImageSource.gallery),
              icon: const Icon(Icons.photo),
              label: const Text('갤러리에서 선택'),
            ),
            const SizedBox(height: 16),
            if (_recognizedText != null)
              Text(
                '결과: $_recognizedText',
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textRecognizer.close();
    super.dispose();
  }
}
