# Практическая 8 Ефремов Алексей ЭФБО-10-23

### **Цели работы:**
1.  Подключить Flutter-приложение к Firebase через FlutterFire CLI.
2.  Освоить инициализацию `firebase_core` и работу с Cloud Firestore.
3.  Реализовать базовый CRUD (создание, чтение, обновление, удаление) для коллекции данных.
4.  Настроить минимальные правила безопасности Firestore для учебной среды.
5.  Сформировать практические навыки диагностики и устранения типовых ошибок подключения.

### **Ход работы:**

#### 1. Создание и привязка проекта Firebase

*   Проект был создан в Firebase console.
*   Привязка к flutter была через `firestore-cli` c помощью `flutterfire configure`.

#### 2. Установка пакетов и инициализация Firebase

*   В `pubspec.yaml` были добавлены зависимости:
    ```yaml
    dependencies:
      flutter:
        sdk: flutter
      firebase_core: ^2.24.2
      cloud_firestore: ^4.13.1
    ```
*   Инициализация Firebase была выполнена в `lib/main.dart` перед запуском приложения:
    ```dart
    //lib/main.dart
    import '''package:firebase_core/firebase_core.dart''';
    import '''firebase_options.dart''';

    void main() async {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      runApp(const NotesApp());
    }
    ```

#### 3. Структура коллекции
Структура коллекции `notes` в Cloud Firestore:
```json
{
  "title": "String",
  "content": "String",
  "createdAt": "Timestamp",
  "updatedAt": "Timestamp"
}
```

#### 4. Контрольные скриншоты

1.  **Скриншот настроенного проекта Firebase:**
   
    <img height="400" alt="image" src="https://github.com/user-attachments/assets/e59a9ef6-1663-44e0-9724-49b7e8d277bc" />


3.  **Скриншот запущенного приложения:**

    <img height="400" alt="image" src="https://github.com/user-attachments/assets/1e854622-9928-485a-81a6-27c4f3ac4cfa" />


5.  **Скриншот после добавления заметки:**
   
    <img height="400" alt="image" src="https://github.com/user-attachments/assets/4713b2bf-25c5-4441-969d-bef5a2263578" />
    <img height="400" alt="image" src="https://github.com/user-attachments/assets/3330e5cd-0063-444c-92f6-d2aa082b396a" />


7.  **Скриншот после редактирования заметки:**
   
    <img height="400" alt="image" src="https://github.com/user-attachments/assets/e1dcdd4c-6ed2-4760-862f-d2a4adf49fdf" />
    <img height="400" alt="image" src="https://github.com/user-attachments/assets/c45a5c54-9d63-4400-b882-680cd4f2851b" />


9.  **Скриншот после удаления заметки:**
    
    <img height="400" alt="image" src="https://github.com/user-attachments/assets/3ece85a5-81c1-4d0f-9734-6c3850ad5b62" />
    <img height="400" alt="image" src="https://github.com/user-attachments/assets/84d8523e-065a-4dc0-8436-fee4ec95c8b8" />



### **Безопасность: что поменять в продакшене**

Установленные правила безопасности:
```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if true;
    }
  }
}
```
Эти правила разрешают любому пользователю читать и изменять все данные в базе.

Для продакшена следует:
1.  Аутентификация (`firebase_auth`).
2.  Изменить правила безопасности:
    ```
    rules_version = '2';
    service cloud.firestore {
      match /databases/{database}/documents {
        // Заметки пользователя доступны только ему
        match /users/{userId}/notes/{noteId} {
          allow read, write: if request.auth != null && request.auth.uid == userId;
        }
      }
    }
    ```

### **Ошибки и их решения**
*   Настройка firebase console требовала включения двухфакторной аутентификации
*   Проблемы с установкой `firebase-cli`, конечный алогоритм выглядел так :
    1. `dart pub global activate flutterfire_cli`
    2. Установка firebase через `curl -sL https://firebase.tools | bash`
    3. Добавление `export PATH="$PATH":"$HOME/.pub-cache/bin"` в `.zshrc`, так как для firebase нужен кеш в PATH
    4. Аутентификация `firebase login`
    5. `firebase configure`

### **Ссылки на файлы**
*   [lib/main.dart](yefremov_firebase_notes_app/lib/main.dart)
*   [lib/notes_page.dart](yefremov_firebase_notes_app/lib/notes_page.dart)
