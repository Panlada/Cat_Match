import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import '/models/models.dart';

class User extends Equatable {
  final String? id;
  final String name;
  final double age;
  final String gender;
  final String species;
  final String color;

  final List<dynamic> imageUrls;
  final Location? location;
  final String bio;
  final List<String>? behavior;
  final List<String>? medicalHistory;

  final List<String>? swipeLeft;
  final List<String>? swipeRight;
  final List<Map<String, dynamic>>? matches;

  final List<String>? speciesPreference;
  final List<String>? colorPreference;
  final List<String>? genderPreference;
  final List<double>? ageRangePreference;
  final int? distancePreference;

  const User({
    this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.species,
    required this.color,
    required this.imageUrls,
    this.location,
    required this.bio,
    required this.behavior,
    required this.medicalHistory,
    this.swipeLeft,
    this.swipeRight,
    this.matches,
    this.colorPreference,
    this.speciesPreference,
    this.genderPreference,
    this.ageRangePreference,
    this.distancePreference,
  });

  static const User empty = User(
    // ignore: use_build_context_synchronously
    id: '',
    name: '',
    age: 0.0,
    gender: '',
    species: '',
    color: '',
    imageUrls: [],
    location: Location.initialLocation,
    bio: '',
    behavior: [],
    medicalHistory: [],

    matches: [],
    swipeLeft: [],
    swipeRight: [],
    distancePreference: 10,
    colorPreference: [],
    speciesPreference: [],
    ageRangePreference: [0, 20],
    genderPreference: [],
  );

  @override
  List<Object?> get props => [
        id,
        name,
        age,
        gender,
        species,
        color,
        imageUrls,
        location,
        bio,
        behavior,
        medicalHistory,
        swipeLeft,
        swipeRight,
        matches,
        genderPreference,
        colorPreference,
        speciesPreference,
        ageRangePreference,
        distancePreference,
      ];

  static User fromSnapshot(DocumentSnapshot snap) {
    var data = snap.data() as Map<String, dynamic>?;

    List<String> userColorPreference = [];
    List<String> userSpeciesPreference = [];
    List<String> userGenderPreference = [];
    List<double> userAgeRangePreference = [];
    int userDistancePreference = 10;
    String species = '';
    String color = '';
    List<String> behavior = [];
    List<String> medicalHistory = [];

    if (data != null) {
      // behavior
      if (data.containsKey('behavior') &&
          data['behavior'] != null &&
          data['behavior'].isNotEmpty) {
        behavior = (data['behavior'] as List)
            .map((behavior) => behavior as String)
            .toList();
      } else {
        behavior = []; // default
      }
      // behavior

      // medical history
      if (data.containsKey('medicalHistory') &&
          data['medicalHistory'] != null &&
          data['medicalHistory'].isNotEmpty) {
        medicalHistory = (data['medicalHistory'] as List)
            .map((medicalHistory) => medicalHistory as String)
            .toList();
      } else {
        medicalHistory = []; // default
      }
      // medical history

      // color preference
      if (data.containsKey('colorPreference') &&
          data['colorPreference'] != null &&
          data['colorPreference'].isNotEmpty) {
        userColorPreference = (data['colorPreference'] as List)
            .map((color) => color as String)
            .toList();
      } else {
        userColorPreference = []; // default
      }
      // color preference

      // species preference
      if (data.containsKey('speciesPreference') &&
          data['speciesPreference'] != null &&
          data['speciesPreference'].isNotEmpty) {
        userSpeciesPreference = (data['speciesPreference'] as List)
            .map((species) => species as String)
            .toList();
      } else {
        userSpeciesPreference = []; // default
      }
      // species preference

      // gender preference
      if (data.containsKey('genderPreference') &&
          data['genderPreference'] != null &&
          data['genderPreference'].isNotEmpty) {
        userGenderPreference = (data['genderPreference'] as List)
            .map((gender) => gender as String)
            .toList();
      } else {
        userGenderPreference = ["Male", "Female"]; // default
      }
      // gender preference

      // age preference
      if (data.containsKey('ageRangePreference') &&
          data['ageRangePreference'] != null &&
          data['ageRangePreference'].isNotEmpty) {
        userAgeRangePreference = (data['ageRangePreference'] as List)
            .map((age) => age as double)
            .toList();
      } else {
        userAgeRangePreference = [0.0, 100.0]; // default
      }
      // age preference

      // distance preference
      if (data.containsKey('distancePreference') &&
          data['distancePreference'] != null) {
        userDistancePreference = data['distancePreference'];
      } else {
        userDistancePreference = 100; // default
      }
      // distance preference

      // species
      if (data.containsKey('species') && data['species'] != null) {
        species = data['species'];
      } else {
        species = "British Shorthair"; // default
      }
      // species

      // color
      if (data.containsKey('color') && data['color'] != null) {
        color = data['color'];
      } else {
        color = "White"; // default
      }
      // color
    }

    User user = User(
      id: snap.id,
      name: snap['name'],
      age: snap['age'],
      gender: snap['gender'],
      species: species,
      color: color,
      imageUrls: snap['imageUrls'],
      location: Location.fromJson(snap['location']),
      bio: snap['bio'],
      behavior: behavior,
      medicalHistory: medicalHistory,
      swipeLeft: (snap['swipeLeft'] as List)
          .map((swipeLeft) => swipeLeft as String)
          .toList(),
      swipeRight: (snap['swipeRight'] as List)
          .map((swipeRight) => swipeRight as String)
          .toList(),
      matches: (snap['matches'] as List)
          .map((matches) => matches as Map<String, dynamic>)
          .toList(),
      colorPreference: userColorPreference,
      speciesPreference: userSpeciesPreference,
      genderPreference: userGenderPreference,
      ageRangePreference: userAgeRangePreference,
      distancePreference: userDistancePreference,
    );
    return user;
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'age': age,
      'gender': gender,
      'species': species,
      'color': color,
      'imageUrls': imageUrls,
      'location': location!.toMap(),
      'bio': bio,
      'behavior': behavior,
      'medicalHistory': medicalHistory,
      'swipeLeft': swipeLeft,
      'swipeRight': swipeRight,
      'matches': matches,
      'colorPreference': colorPreference,
      'speciesPreference': speciesPreference,
      'genderPreference': genderPreference,
      'ageRangePreference': ageRangePreference,
      'distancePreference': distancePreference,
    };
  }

  User copyWith({
    String? id,
    String? name,
    double? age,
    String? gender,
    String? species,
    String? color,
    List<dynamic>? imageUrls,
    Location? location,
    String? bio,
    List<String>? behavior,
    List<String>? medicalHistory,
    List<String>? swipeLeft,
    List<String>? swipeRight,
    List<Map<String, dynamic>>? matches,
    List<String>? colorPreference,
    List<String>? speciesPreference,
    List<String>? genderPreference,
    List<double>? ageRangePreference,
    int? distancePreference,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      species: species ?? this.species,
      color: color ?? this.color,
      imageUrls: imageUrls ?? this.imageUrls,
      location: location ?? this.location,
      bio: bio ?? this.bio,
      behavior: behavior ?? this.behavior,
      medicalHistory: medicalHistory ?? this.medicalHistory,
      swipeLeft: swipeLeft ?? this.swipeLeft,
      swipeRight: swipeRight ?? this.swipeRight,
      matches: matches ?? this.matches,
      colorPreference: colorPreference ?? this.colorPreference,
      speciesPreference: speciesPreference ?? this.speciesPreference,
      genderPreference: genderPreference ?? this.genderPreference,
      ageRangePreference: ageRangePreference ?? this.ageRangePreference,
      distancePreference: distancePreference ?? this.distancePreference,
    );
  }
}
