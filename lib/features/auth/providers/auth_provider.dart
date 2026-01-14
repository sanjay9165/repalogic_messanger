import 'package:repalogic_messanger/utilities/common_exports.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

final authStateProvider = StreamProvider<User?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges();
});

final currentUserProvider = FutureProvider<UserModel?>((ref) async {
  final authRepository = ref.watch(authRepositoryProvider);
  final user = authRepository.getCurrentUser();

  if (user == null) return null;

  return await authRepository.getUserModel(user.uid);
});

final authControllerProvider =
    StateNotifierProvider<AuthController, AsyncValue<UserModel?>>((ref) {
      final authRepository = ref.watch(authRepositoryProvider);
      return AuthController(authRepository);
    });

class AuthController extends StateNotifier<AsyncValue<UserModel?>> {
  final AuthRepository _authRepository;

  AuthController(this._authRepository) : super(const AsyncValue.data(null));

  // Sign in with Google
  Future<void> signInWithGoogle() async {
    state = const AsyncValue.loading();

    try {
      final user = await _authRepository.signInWithGoogle();
      state = AsyncValue.data(user);
    } catch (e, stackTrace) {
      log('Error in signInWithGoogle: $e');
      state = AsyncValue.error(e, stackTrace);
    }
  }

  // Sign out
  Future<void> signOut() async {
    state = const AsyncValue.loading();

    try {
      await _authRepository.signOut();
      state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      log('Error in signOut: $e');
      state = AsyncValue.error(e, stackTrace);
    }
  }

  // Get current user
  UserModel? getCurrentUserModel() {
    return state.value;
  }

  // Check if user is signed in
  bool isSignedIn() {
    return _authRepository.isSignedIn();
  }
}
