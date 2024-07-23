// import 'package:firebase_auth/firebase_auth.dart';

// class MFAService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   Future<void> enableMFA() async {
//     final user = _auth.currentUser;
//     if (user != null) {
//       await user.multiFactor.enroll(PhoneMultiFactorGenerator.getAssertion());
//     }
//   }

//   Future<void> verifyMFA(String verificationId, String smsCode) async {
//     final credential = PhoneAuthProvider.credential(
//       verificationId: verificationId,
//       smsCode: smsCode,
//     );
//     await _auth.currentUser?.multiFactor
//         .enroll(PhoneMultiFactorGenerator.getAssertion(credential));
//   }
// }
