// Provider for the email, initially returns an empty String.
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mytodo/providers/firebase_provider.dart';

final AutoDisposeStateProvider<String> emailProvider =
    StateProvider.autoDispose<String>((StateProviderRef<String> ref) {
  final User? user = ref.watch(firebaseProvider).currentUser;
  if (user != null) {
    // Fetch the email from Firebase Auth.
    final String email = user.email!;
    return email;
  } else {
    return 'e@mail.com';
  }
});
