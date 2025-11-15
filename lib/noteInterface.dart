import 'note.dart';
import 'Databases.dart'; 



Future<void> modifierUneNote(Note noteOriginale, String nouveauTitre, String nouveauContenu) async {
  
  final dbHelper = NotesDatabase(); 
  
  final noteModifiee = noteOriginale.copyWith(
    titre: nouveauTitre,
    contenu: nouveauContenu,
    dateCreation: DateTime.now(),
  );

  
  final rowsAffected = await dbHelper.updateNote(noteModifiee);

  print('Note modifiée. Lignes affectées: $rowsAffected');
}


Future<void> supprimerUneNote(int noteId) async {
  final dbHelper = NotesDatabase();

  final rowsAffected = await dbHelper.deleteNote(noteId);

  print('Note supprimée. Lignes affectées: $rowsAffected');
}