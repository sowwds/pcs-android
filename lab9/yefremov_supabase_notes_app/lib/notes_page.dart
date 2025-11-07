import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  late final Stream<List<Map<String, dynamic>>> _notesStream;

  @override
  void initState() {
    super.initState();
    final uid = Supabase.instance.client.auth.currentUser!.id;
    _notesStream = Supabase.instance.client
        .from('notes')
        .stream(primaryKey: ['id'])
        .eq('user_id', uid)
        .order('created_at', ascending: false);
  }

  Future<void> _createNote(String title, String content) async {
    final uid = Supabase.instance.client.auth.currentUser!.id;
    print('Attempting to create note with user_id: $uid');
    await Supabase.instance.client.from('notes').insert({
      'user_id': uid,
      'title': title,
      'content': content,
      'updated_at': DateTime.now().toIso8601String(),
    });
  }

  Future<void> _updateNote(String id, String title, String content) async {
    await Supabase.instance.client.from('notes').update({
      'title': title,
      'content': content,
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', id);
  }

  Future<void> _deleteNote(String id) async {
    print('Attempting to delete note with id: $id');
    try {
      final response = await Supabase.instance.client
          .from('notes')
          .delete()
          .eq('id', id);
      if (response != null && response.isNotEmpty) {
        print('Note with id: $id successfully deleted.');
      } else {
        print('Note with id: $id not deleted. Check RLS or if ID exists.');
      }
    } catch (e) {
      print('Error deleting note with id: $id. Error: $e');
    }
  }

  void _openCreateDialog() {
    final titleCtrl = TextEditingController();
    final contentCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Новая заметка'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Заголовок')),
            TextField(controller: contentCtrl, decoration: const InputDecoration(labelText: 'Текст')),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          FilledButton(
            onPressed: () async {
              await _createNote(titleCtrl.text.trim(), contentCtrl.text.trim());
              if (mounted) Navigator.pop(context);
            },
            child: const Text('Сохранить'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Supabase Notes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await Supabase.instance.client.auth.signOut();
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _notesStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Ошибка загрузки: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final notes = snapshot.data!;

          if (notes.isEmpty) {
            return const Center(child: Text('Пока нет заметок'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: notes.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, i) {
              final n = notes[i];
              return Dismissible(
                key: ValueKey(n['id']),
                background: Container(color: Colors.red.withOpacity(.1)),
                onDismissed: (_) => _deleteNote(n['id'].toString()),
                child: Card(
                  child: ListTile(
                    title: Text(n['title'] ?? '(без названия)', maxLines: 1, overflow: TextOverflow.ellipsis),
                    subtitle: Text(n['content'] ?? '', maxLines: 2, overflow: TextOverflow.ellipsis),
                    onTap: () {
                      final tc = TextEditingController(text: n['title'] ?? '');
                      final cc = TextEditingController(text: n['content'] ?? '');
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('Редактировать'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(controller: tc, decoration: const InputDecoration(labelText: 'Заголовок')),
                              TextField(controller: cc, decoration: const InputDecoration(labelText: 'Текст')),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Отмена'),
                            ),
                            FilledButton(
                              onPressed: () async {
                                await _updateNote(n['id'].toString(), tc.text.trim(), cc.text.trim());
                                if (mounted) Navigator.pop(context);
                              },
                              child: const Text('Обновить'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openCreateDialog,
        tooltip: 'Add Note',
        child: const Icon(Icons.add),
      ),
    );
  }
}
