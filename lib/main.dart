import 'package:flutter/material.dart';

void main() {
  runApp(const MonProjet());
}

// Modèle de Note (simulé pour l'affichage)
class Note {
  final int id;
  final String titre;
  final String contenu;

  Note({required this.id, required this.titre, required this.contenu});
}

// Liste de notes 
List<Note> notesSimulees = [
  Note(id: 1, titre: "La recontre ", contenu: "J'ai rencontré un bel homme à la bibliothèque de l'université aujourd'hui."),
  Note(id: 2, titre: "Idée d'App de suivi de santé", contenu: "Développer une application de suivi de santé pour mieux controler sa santé."),
 Note(id: 2, titre: "finir mon projet", contenu: "Rendre mon projet avant lundi."),
 Note(id: 2, titre: "programme", contenu: "Mettre au point un bon programme pour mieux gérer la semaine."),
 
];

class MonProjet extends StatelessWidget {
  const MonProjet({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Gestionnaire de Notes",
      debugShowCheckedModeBanner: false,
      home: PageDeConnexion(),
    );
  }
}

class PartieTexte extends StatelessWidget {
  const PartieTexte({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: const Text(
        "    L'espace idéal   \n"
        " pour ne rien perdre  \n",
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }
}


class PageDeConnexion extends StatefulWidget {
  const PageDeConnexion({super.key});

  @override
  State<PageDeConnexion> createState() => _PageDeConnexionState();
}

class _PageDeConnexionState extends State<PageDeConnexion> {
  final TextEditingController _nomUtilisateurController = TextEditingController();
  final TextEditingController _motDePasseController = TextEditingController();
  String _messageErreur = '';

  @override
  void dispose() {
    _nomUtilisateurController.dispose();
    _motDePasseController.dispose();
    super.dispose();
  }

  void _verifierConnexion() {
    String nom = _nomUtilisateurController.text.trim();
    String mdp = _motDePasseController.text.trim();

    setState(() {
      _messageErreur = '';
    });

    if (nom.isEmpty || mdp.isEmpty) {
      setState(() {
        _messageErreur = 'Veuillez remplir tous les champs.';
      });
      return;
    }

    // Identifiants valides : Bella / 1234
    if (nom == 'Bella' && mdp == '1234') {
      
      Navigator.pushReplacement( 
        context,
        MaterialPageRoute(
          builder: (context) => PageListeNotes(nomUtilisateur: nom),
        ),
      );
    } else {
      setState(() {
        _messageErreur = 'Nom d’utilisateur ou mot de passe incorrect.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Page de Connexion',
          style: TextStyle(color: Color.fromARGB(255, 26, 26, 26)),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 68, 155, 170),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/Pimages/cahier.png',
                height: 180,
                errorBuilder: (context, error, stackTrace) => const SizedBox(
                  height: 150,
                  child: Icon(Icons.note_alt, size: 80, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 30),
              const PartieTexte(),
              // Formulaire de connexion... (omission du reste du formulaire pour la concision)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _nomUtilisateurController,
                      decoration: InputDecoration(
                        labelText: 'Nom d’utilisateur',
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _motDePasseController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Mot de passe',
                        prefixIcon: const Icon(Icons.lock),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _verifierConnexion,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 241, 178, 199),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                      ),
                      child: const Text('Se connecter', style: TextStyle(fontSize: 18, color: Colors.black)),
                    ),
                    const SizedBox(height: 15),
                    if (_messageErreur.isNotEmpty)
                      Text(_messageErreur, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



class PageListeNotes extends StatefulWidget {
  final String nomUtilisateur;
  const PageListeNotes({super.key, required this.nomUtilisateur});

  @override
  State<PageListeNotes> createState() => _PageListeNotesState();
}

class _PageListeNotesState extends State<PageListeNotes> {
  // Liste de notes gérée par l'état (pour simuler l'interactivité)
  List<Note> notes = notesSimulees;

  // Fonction de simulation pour la modification/suppression
  void _supprimerNote(int id) {
    setState(() {
      notes.removeWhere((note) => note.id == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Note supprimée ')),
    );
  }

  // Fonction pour naviguer vers la page d'ajout/modification
  void _naviguerVersSaisie({Note? note}) async {
    final resultat = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PageSaisieNote(noteAModifier: note),
      ),
    );

    
    if (resultat != null && resultat is Note) {
      setState(() {
        if (note == null) {
          
          int nouvelId = (notes.isNotEmpty ? notes.last.id : 0) + 1;
          notes.add(Note(id: nouvelId, titre: resultat.titre, contenu: resultat.contenu));
        } else {
          
          final index = notes.indexWhere((n) => n.id == note.id);
          if (index != -1) {
            notes[index] = resultat;
          }
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(note == null ? 'Note ajoutée ! 📝' : 'Note modifiée ! ')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mes Notes - ${widget.nomUtilisateur}'),
        backgroundColor: const Color.fromARGB(255, 68, 155, 170),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const PageDeConnexion()),
                (Route<dynamic> route) => false,
              );
            },
            tooltip: 'Déconnexion',
          ),
        ],
      ),
      body: notes.isEmpty
          ? const Center(
              child: Text(
                "Vous n'avez aucune note. Ajoutez-en une !",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    title: Text(note.titre, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(
                      note.contenu,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis, 
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Bouton Modifier
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _naviguerVersSaisie(note: note), 
                        ),
                        // Bouton Supprimer
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _supprimerNote(note.id),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      // Bouton pour ajouter une nouvelle note
      floatingActionButton: FloatingActionButton(
        onPressed: () => _naviguerVersSaisie(), 
        backgroundColor: const Color.fromARGB(255, 241, 178, 199),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class PageSaisieNote extends StatefulWidget {
  final Note? noteAModifier; 

  const PageSaisieNote({super.key, this.noteAModifier});

  @override
  State<PageSaisieNote> createState() => _PageSaisieNoteState();
}

class _PageSaisieNoteState extends State<PageSaisieNote> {
  final TextEditingController _titreController = TextEditingController();
  final TextEditingController _contenuController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Pré-remplir les champs si une note est passée pour modification
    if (widget.noteAModifier != null) {
      _titreController.text = widget.noteAModifier!.titre;
      _contenuController.text = widget.noteAModifier!.contenu;
    }
  }

  @override
  void dispose() {
    _titreController.dispose();
    _contenuController.dispose();
    super.dispose();
  }

  void _enregistrerNote() {
    if (_titreController.text.isEmpty || _contenuController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez ajouter un titre et un contenu.')),
      );
      return;
    }

    
    final nouvelleNote = Note(
      
      id: widget.noteAModifier?.id ?? 0,
      titre: _titreController.text,
      contenu: _contenuController.text,
    );

    // Retourner la nouvelle note à la PageListeNotes
    Navigator.pop(context, nouvelleNote);
  }

  @override
  Widget build(BuildContext context) {
    bool isEditing = widget.noteAModifier != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Modifier la Note' : 'Ajouter une Note'),
        backgroundColor: const Color.fromARGB(255, 68, 155, 170),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titreController,
              decoration: const InputDecoration(
                labelText: 'Titre de la Note',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: TextField(
                controller: _contenuController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                expands: true, 
                decoration: const InputDecoration(
                  labelText: 'Contenu de la Note',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _enregistrerNote,
              icon: Icon(isEditing ? Icons.update : Icons.save, color: Colors.black),
              label: Text(
                isEditing ? 'Mettre à jour' : 'Enregistrer la Note',
                style: const TextStyle(color: Colors.black),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 241, 178, 199),
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}