// lib/note.dart
class Note {
  final int? id;
  final String titre;
  final String contenu;
  final DateTime dateCreation;

  Note({
    this.id,
    required this.titre,
    required this.contenu,
    required this.dateCreation,
  });

 
  Note copyWith({
    int? id,
    String? titre,
    String? contenu,
    DateTime? dateCreation,
  }) {
    return Note(
      id: id ?? this.id,
      titre: titre ?? this.titre,
      contenu: contenu ?? this.contenu,
      dateCreation: dateCreation ?? this.dateCreation,
    );
  }

  // Convertit un objet Note en Map.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titre': titre,
      'contenu': contenu,
      'dateCreation': dateCreation.millisecondsSinceEpoch,
    };
  }

  // Crée un objet Note à partir d'un Map.
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'] as int?,
      titre: map['titre'] as String,
      contenu: map['contenu'] as String,
      dateCreation: DateTime.fromMillisecondsSinceEpoch(map['dateCreation'] as int),
    );
  }
}