import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dopplerv1/models/users.dart';

final userRef = FirebaseFirestore.instance.collection('users');
final commentsRef = FirebaseFirestore.instance.collection('comments');
final chatRoomRef = FirebaseFirestore.instance.collection('chatRoom');
final chatListRef = FirebaseFirestore.instance.collection('chatLists');
final imageRef = FirebaseFirestore.instance.collection('imageRef');
final activityFeedRef = FirebaseFirestore.instance.collection('activityFeed');
final calenderRef = FirebaseFirestore.instance.collection('calenderRef');

AppUserModel? currentUser;
bool? isAdmin;
