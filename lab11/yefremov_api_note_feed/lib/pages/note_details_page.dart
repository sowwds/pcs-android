import 'package:flutter/material.dart';
import '../data/notes_repository.dart';
import '../models/note.dart';

class NoteDetailsPage extends StatelessWidget {
  final int id;
  final NotesRepository repo;
  const NoteDetailsPage({super.key, required this.id, required this.repo});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Note>(
      future: repo.get(id),
      builder: (context, snap) {
        if (snap.hasError) return const Scaffold(body: Center(child: Text('Ошибка')));
        if (!snap.hasData) return const Scaffold(body: Center(child: CircularProgressIndicator()));
        final n = snap.data!;
        return Scaffold(
          appBar: AppBar(title: Text('Запись #${n.id}')),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(n.body),
          ),
        );
      },
    );
  }
}
