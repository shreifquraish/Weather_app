import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthCubit() : super(AuthInitial()) {
  print('🔴 AuthCubit created - listening to auth changes');
  _auth.authStateChanges().listen((User? user) {
    print('🟡 Auth state changed: user = $user');
    if (user != null) {
      print('🟢 Emitting Authenticated');
      emit(Authenticated(user: user));
    } else {
      print('🔴 Emitting Unauthenticated');
      emit(Unauthenticated());
    }
  });
} 


  Future<void> login(String email, String password) async {
    try {
      emit(AuthLoading());
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      emit(Authenticated(user: userCredential.user!));
    } on FirebaseAuthException catch (e) {
      String message = _mapAuthError(e.code);
      emit(AuthError(message: message));
    } catch (e) {
      emit(AuthError(message: 'حدث خطأ غير متوقع'));
    }
  }


  Future<void> register(String email, String password) async {
    try {
      emit(AuthLoading());
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      emit(Authenticated(user: userCredential.user!));
    } on FirebaseAuthException catch (e) {
      String message = _mapAuthError(e.code);
      emit(AuthError(message: message));
    } catch (e) {
      emit(AuthError(message: 'حدث خطأ غير متوقع'));
    }
  }


  Future<void> logout() async {
    try {
      await _auth.signOut();

    } catch (e) {
      emit(AuthError(message: 'حدث خطأ أثناء تسجيل الخروج'));
    }
  }


  String _mapAuthError(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'هذا البريد الإلكتروني مسجل بالفعل';
      case 'invalid-email':
        return 'البريد الإلكتروني غير صالح';
      case 'weak-password':
        return 'كلمة المرور ضعيفة (6 أحرف على الأقل)';
      case 'user-not-found':
      case 'wrong-password':
        return 'البريد الإلكتروني أو كلمة المرور غير صحيحة';
      case 'network-request-failed':
        return 'خطأ في الاتصال بالإنترنت';
      default:
        return 'حدث خطأ: $code';
    }
  }
}