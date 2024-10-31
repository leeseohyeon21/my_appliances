import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:my_appliances/constants/common_size.dart';
import 'package:my_appliances/screens/start/intro_page.dart';
import 'package:my_appliances/states/user_provider.dart';
import 'package:provider/provider.dart';

class AuthPage extends StatefulWidget {
  AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

const duration = Duration(milliseconds: 300);

class _AuthPageState extends State<AuthPage> {
  final inputBorder = OutlineInputBorder(borderSide: BorderSide(color: Colors.grey),);

  TextEditingController _phoneNumberController = TextEditingController(text: "010");
  TextEditingController _verifiNumberController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  VerificationStatus _verificationStatus = VerificationStatus.none;

  double getVerificationBtnHeight(VerificationStatus status){
    switch(status){
      case VerificationStatus.none:
        return 0;
      case VerificationStatus.codeSent:
      case VerificationStatus.verifying:
      case VerificationStatus.verificationDone:
        return 48;
    }
  }

  @override
  void dispose(){
    _phoneNumberController.dispose();
    _verifiNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {

        Size size = MediaQuery.of(context).size;

        return IgnorePointer(
          ignoring: _verificationStatus == VerificationStatus.verifying,
          child: Form(  //유효성 검사 위젯
            key: _formKey,
            child: Scaffold(
              appBar: AppBar(
                title: Text('로그인 하기',
                    style: Theme.of(context).textTheme.headlineSmall
                ),
                elevation: AppBarTheme
                    .of(context)
                    .elevation,
              ),
              body: GestureDetector(
                onTap: (){
                  FocusScope.of(context).unfocus();
                },
                child: Padding(
                  padding: const EdgeInsets.all(common_bg_padding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                    Row(children: [
                      ExtendedImage.asset(
                        'assets/images/temp.jpg',
                        width: size.width*0.25,
                        height: size.width*0.25
                      ),
                      SizedBox(width: common_sm_padding),
                      Text('나의 가전은 전화번호로 가입합니다.\n여러분의 개인정보는 안전히 보관되며,\n외부에 노출되지 않습니다.',
                        style: Theme.of(context).textTheme.titleMedium),
                    ],),
                    SizedBox(height: common_bg_padding),
                    TextFormField(
                      validator: (phoneNumber) {
                        if (phoneNumber != null && phoneNumber.length == 13){
                          return null;
                        } else {
                          return '올바른 전화번호를 입력하세요.';
                        }
                      },
                      controller: _phoneNumberController,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [MaskedInputFormatter("000 0000 0000")],
                      decoration: InputDecoration(
                        border: inputBorder,
                        focusedBorder: inputBorder,
                      ),
                    ),
                    SizedBox(height: common_sm_padding),
                    TextButton(
                        onPressed: (){
                          //현재상태가 빈값이 아니면 유효성검사를 진행시켜라.
                          if (_formKey.currentState != null) {
                            bool passed = _formKey.currentState!.validate();
                            print(passed);
                            if (passed)
                              setState(() {
                                _verificationStatus = VerificationStatus.codeSent;
                              });
                          }
                        },
                        child: Text('인증문자 발송'),),
                  SizedBox(height: common_bg_padding),
                  AnimatedOpacity(
                    duration: Duration(milliseconds: 300),
                    opacity: (_verificationStatus == VerificationStatus.none)?0:1,
                    child: AnimatedContainer(
                      duration: duration,
                      height: getVerificationHeight((_verificationStatus)),
                      child: TextFormField(
                        controller: _verifiNumberController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [MaskedInputFormatter("000000")],
                        decoration: InputDecoration(
                          border: inputBorder,
                          focusedBorder: inputBorder,
                        ),
                      ),
                    ),
                  ),
                  AnimatedContainer(
                    duration: duration,
                    height: getVerificationBtnHeight(_verificationStatus),
                    child: TextButton(
                      onPressed: (){
                        attemptVerify();
                      },
                      child: (_verificationStatus == VerificationStatus.verifying)
                        ?CircularProgressIndicator(color: Colors.white)
                        : Text('인증하기'),),
                  ),
                  ],),
                ),
              ),
            ),
          ),
        );
      }
    );
  }

  double getVerificationHeight(VerificationStatus status){
    switch(status){
      case VerificationStatus.none:
        return 0;
      case VerificationStatus.codeSent:
      case VerificationStatus.verifying:
      case VerificationStatus.verificationDone:
        return 60+common_sm_padding;
    }
  }

  //인증하기 버튼 클릭시 인증중 처리함수
  void attemptVerify() async {
    //인증처리 중인 상태관리
    setState(() {
      _verificationStatus = VerificationStatus.verifying;
    });
    //퓨처함수로 인증 딜레이 시간 묘사
    await Future.delayed(Duration(seconds: 3));
    //인증처리 완료 상태관리
    setState(() {
      _verificationStatus = VerificationStatus.verificationDone;
    });
    context.read<UserProvider>().SetUserAuth(true);
  }

}

//검증상태 관리
enum VerificationStatus {
  none, codeSent, verifying, verificationDone
}
