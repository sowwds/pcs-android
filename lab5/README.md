# Практическая 5 Ефремов Алексей ЭФБО-10-23

## Цели ПЗ
- Научиться отображать списки с помощью `ListView.builder`.
- Освоить навигацию (`Navigator.push`/`pop`) и передачу данных через конструктор.
- Реализовать добавление, редактирование и удаление заметок.

## Ход работы
1. Создание проекта: `flutter create simple_notes_yefremov`.
2. Реализована модель `Note` в `lib/models/note.dart` с полями `id`, `title`, `body` и методом `copyWith`.
3. В `main.dart` создан главный экран с `ListView.builder`, `FloatingActionButton` для добавления заметок, поиском в `AppBar` и удалением через `Dismissible`.
4. В `edit_note_page.dart` реализован экран добавления/редактирования с формой и сохранением через `Navigator.pop`.

**Ключевые фрагменты кода**:
- **Модель `Note`**:
  ```dart
  class Note {
    final String id;
    String title;
    String body;
    Note({required this.id, required this.title, required this.body});
    Note copyWith({String? title, String? body}) => Note(
          id: id,
          title: title ?? this.title,
          body: body ?? this.body,
        );
  }
  ```

- **ListView.builder с Dismissible**:
  ```dart
  ListView.builder(
    itemCount: _filteredNotes.length,
    itemBuilder: (context, i) {
      final note = _filteredNotes[i];
      return Dismissible(
        key: ValueKey(note.id),
        direction: DismissDirection.endToStart,
        background: Container(
          color: Colors.red,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 16),
          child: const Icon(Icons.delete, color: Colors.white),
        ),
        onDismissed: (direction) => _delete(note),
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            title: Text(note.title.isEmpty ? '(без названия)' : note.title),
            subtitle: Text(note.body, maxLines: 2, overflow: TextOverflow.ellipsis),
            onTap: () => _edit(note),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () => _delete(note),
            ),
          ),
        ),
      );
    },
  )
  ```

- **Поиск в AppBar**:
  ```dart
  AppBar(
    title: _isSearching
        ? TextField(
            controller: _searchController,
            decoration: const InputDecoration(hintText: 'Поиск по заголовку...'),
            autofocus: true,
            onChanged: (value) => setState(() => _searchQuery = value),
          )
        : const Text('Simple Notes'),
    actions: [
      IconButton(
        icon: Icon(_isSearching ? Icons.close : Icons.search),
        onPressed: _toggleSearch,
      ),
    ],
  )
  ```
  
- **Добавление/редактирование заметки**:
  ```dart
  Future<void> _addNote() async {
    final newNote = await Navigator.push<Note>(
      context,
      MaterialPageRoute(builder: (_) => const EditNotePage()),
    );
    if (newNote != null && mounted) {
      setState(() => _notes.add(newNote));
    }
  }
  ```

- **Удаление с Undo**:
  ```dart
  void _delete(Note note) {
    final index = _notes.indexOf(note);
    setState(() => _notes.removeAt(index));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Заметка удалена'),
        action: SnackBarAction(
          label: 'Отменить',
          onPressed: () => setState(() => _notes.insert(index, note)),
        ),
      ),
    );
  }
  ```


https://github.com/user-attachments/assets/43db2180-70b3-4346-aee7-c67f5cb38009

## Выводы
- **Что получилось**: Реализовал приложение с динамическим списком заметок, добавлением, редактированием, удалением (через кнопку и свайп), поиском по заголовку.
- **Что было сложным**:
  - Настройка `Dismissible` для свайп-удаления.
  - Реализация поиска с переключением `AppBar`.
