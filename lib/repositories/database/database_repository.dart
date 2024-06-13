import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rxdart/rxdart.dart';

import '/models/models.dart';
import '/repositories/repositories.dart';

class DatabaseRepository extends BaseDatabaseRepository {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  // get users from firebase firestore
  @override
  Stream<User> getUser(String userId) {
    return _firebaseFirestore
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((snap) => User.fromSnapshot(snap));
  }
  // get users from firebase firestore

  // get single chat data from firebase firestore
  @override
  Stream<Chat> getChat(String chatId) {
    return _firebaseFirestore
        .collection('chats')
        .doc(chatId)
        .snapshots()
        .map((doc) {
      return Chat.fromJson(
        doc.data() as Map<String, dynamic>,
        id: doc.id,
      );
    });
  }
  // get single chat data from firebase firestore

  // get users from firebase firestore
  @override
  Stream<List<User>> getUsers(User user) {
    return _firebaseFirestore
        .collection('users')
        .where('gender', whereIn: _selectGender(user))
        .snapshots()
        .map((snap) {
      return snap.docs.map((doc) => User.fromSnapshot(doc)).toList();
    });
  }
  // get users from firebase firestore

  _selectGender(User user) {
    if (user.genderPreference!.isEmpty) {
      return const ['Male', 'Female'];
    }
    return user.genderPreference;
  }

  // get chats from firebase firestore
  @override
  Stream<List<Chat>> getChats(String chatId) {
    return _firebaseFirestore
        .collection('chats')
        .where('userIds', arrayContains: chatId)
        .snapshots()
        .map((snap) {
      return snap.docs
          .map((doc) => Chat.fromJson(doc.data(), id: doc.id))
          .toList();
    });
  }
  // get chats from firebase firestore

  // get users to swipe with preference from firebase firestore
  @override
  Stream<List<User>> getUsersToSwipe(User user) {
    return Rx.combineLatest2(
      getUser(user.id!),
      getUsers(user),
      (
        User currentUser,
        List<User> users,
      ) {
        return users.where(
          (user) {
            bool isCurrentUser = user.id == currentUser.id;
            bool wasSwipedLeft = currentUser.swipeLeft!.contains(user.id);
            bool wasSwipedRight = currentUser.swipeRight!.contains(user.id);
            // ignore: collection_methods_unrelated_type
            bool isMatch = currentUser.matches!.contains(user.id);

            bool isColorPreferenceMatch =
                currentUser.colorPreference!.isNotEmpty
                    ? currentUser.colorPreference!.any(
                        (color) =>
                            color.toLowerCase() == user.color.toLowerCase(),
                      )
                    : true;

            bool isSpeciesPreferenceMatch =
                currentUser.speciesPreference!.isNotEmpty
                    ? currentUser.speciesPreference!.any(
                        (species) =>
                            species.toLowerCase() == user.species.toLowerCase(),
                      )
                    : true;

            bool isWithinAgeRange =
                user.age >= currentUser.ageRangePreference![0] &&
                    user.age <= currentUser.ageRangePreference![1];

            bool isWithinDistance = _getDistance(currentUser, user) <=
                currentUser.distancePreference;

            if (isCurrentUser) return false;
            if (wasSwipedLeft) return false;
            if (wasSwipedRight) return false;
            if (isMatch) return false;
            if (!isColorPreferenceMatch) return false;
            if (!isSpeciesPreferenceMatch) return false;
            if (!isWithinAgeRange) return false;
            if (!isWithinDistance) return false;

            return true;
          },
        ).toList();
      },
    );
  }
  // get users to swipe with preference from firebase firestore

  // calculate distance
  _getDistance(User currentUser, User user) {
    GeolocatorPlatform geolocator = GeolocatorPlatform.instance;
    var distanceInKm = geolocator.distanceBetween(
          currentUser.location!.lat.toDouble(),
          currentUser.location!.lon.toDouble(),
          user.location!.lat.toDouble(),
          user.location!.lon.toDouble(),
        ) ~/
        1000;

    // current user = currentUser.name
    // comapring user = user.name
    // distance between two user = distanceInKm

    return distanceInKm;
  }
  // calculate distance

  // get matched user
  @override
  Stream<List<Match>> getMatches(User user) {
    return Rx.combineLatest3(
      getUser(user.id!),
      getChats(user.id!),
      getUsers(user),
      (
        User user,
        List<Chat> userChats,
        List<User> otherUsers,
      ) {
        return otherUsers.where(
          (otherUser) {
            List<String> matches = user.matches!
                .map((match) => match['matchId'] as String)
                .toList();
            return matches.contains(otherUser.id);
          },
        ).map(
          (matchUser) {
            Chat chat = userChats.where(
              (chat) {
                return chat.userIds.contains(matchUser.id) &
                    chat.userIds.contains(user.id);
              },
            ).first;

            return Match(
              userId: user.id!,
              matchUser: matchUser,
              chat: chat,
            );
          },
        ).toList();
      },
    );
  }
  // get matched user

  // update user data accoring swipe
  @override
  Future<void> updateUserSwipe(
    String userId,
    String matchId,
    bool isSwipeRight,
  ) async {
    if (isSwipeRight) {
      await _firebaseFirestore.collection('users').doc(userId).update({
        'swipeRight': FieldValue.arrayUnion([matchId])
      });
    } else {
      await _firebaseFirestore.collection('users').doc(userId).update({
        'swipeLeft': FieldValue.arrayUnion([matchId])
      });
    }
  }
  // update user data accoring swipe

  // on udpate user match fn
  @override
  Future<void> updateUserMatch(
    String userId,
    String matchId,
  ) async {
    // Create a document in the chat collection to store the messages.
    String chatId = await _firebaseFirestore.collection('chats').add({
      'userIds': [userId, matchId],
      'messages': [],
    }).then((value) => value.id);

    // Add the match into the current user document.
    await _firebaseFirestore.collection('users').doc(userId).update({
      'matches': FieldValue.arrayUnion([
        {
          'matchId': matchId,
          'chatId': chatId,
        }
      ])
    });
    // Add the match into the other user document.
    await _firebaseFirestore.collection('users').doc(matchId).update({
      'matches': FieldValue.arrayUnion([
        {
          'matchId': userId,
          'chatId': chatId,
        }
      ])
    });
  }
  // on udpate user match fn

  // create user fn
  @override
  Future<void> createUser(User user) async {
    await _firebaseFirestore.collection('users').doc(user.id).set(user.toMap());
  }
  // create user fn

  // on udpate user data fn
  @override
  Future<void> updateUser(User user) async {
    return _firebaseFirestore
        .collection('users')
        .doc(user.id)
        .update(user.toMap())
        .then(
      (value) {
        // user document is updated in firebase
      },
    );
  }
  // on udpate user data fn

  // on udpate user image fn
  @override
  Future<void> updateUserPictures(User user, String imageName) async {
    String downloadUrl =
        await StorageRepository().getDownloadURL(user, imageName);

    return _firebaseFirestore.collection('users').doc(user.id).update({
      'imageUrls': FieldValue.arrayUnion([downloadUrl])
    });
  }
  // on udpate user image fn

  // delete user image fn
  @override
  Future<void> deleteUserPicture(User user, String imageName) async {
    String downloadUrl =
        await StorageRepository().getDownloadURL(user, imageName);

    return _firebaseFirestore.collection('users').doc(user.id).update({
      'imageUrls': FieldValue.arrayRemove([downloadUrl])
    });
  }
  // delete user image fn

  // send message fn
  @override
  Future<void> addMessage(String chatId, Message message) {
    return _firebaseFirestore.collection('chats').doc(chatId).update({
      'messages': FieldValue.arrayUnion(
        [
          Message(
            senderId: message.senderId,
            receiverId: message.receiverId,
            message: message.message,
            dateTime: message.dateTime,
            timeString: message.timeString,
          ).toJson()
        ],
      )
    });
  }
  // send message fn

  // delete chat fn
  @override
  Future<void> deleteMatch(String chatId, String userId, String matchId) async {
    // Remove the match from the this user document
    // await _firebaseFirestore.collection('users').doc(userId).update({
    //   'matches': FieldValue.arrayRemove([
    //     {'matchId': matchId, 'chatId': chatId}
    //   ])
    // });

    // remove from current user swipe right
    // await _firebaseFirestore.collection('users').doc(userId).update({
    //   'swipeRight': FieldValue.arrayRemove([matchId]),
    // });

    // remove from other user swipe right
    // await _firebaseFirestore.collection('users').doc(matchId).update({
    //   'swipeRight': FieldValue.arrayRemove([userId]),
    // });

    // Remove the match from the other user document
    // await _firebaseFirestore.collection('users').doc(matchId).update({
    //   'matches': FieldValue.arrayRemove([
    //     {'matchId': userId, 'chatId': chatId}
    //   ])
    // });

    // Delete the chat document
    await _firebaseFirestore.collection('chats').doc(chatId).delete();
  }
  // delete chat fn
}
