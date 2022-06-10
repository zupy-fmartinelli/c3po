import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

class ZupyJobsFirebaseUser {
  ZupyJobsFirebaseUser(this.user);
  User user;
  bool get loggedIn => user != null;
}

ZupyJobsFirebaseUser currentUser;
bool get loggedIn => currentUser?.loggedIn ?? false;
Stream<ZupyJobsFirebaseUser> zupyJobsFirebaseUserStream() =>
    FirebaseAuth.instance
        .authStateChanges()
        .debounce((user) => user == null && !loggedIn
            ? TimerStream(true, const Duration(seconds: 1))
            : Stream.value(user))
        .map<ZupyJobsFirebaseUser>(
            (user) => currentUser = ZupyJobsFirebaseUser(user));
