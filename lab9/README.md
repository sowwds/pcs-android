# Практическая 9 Ефремов Алексей ЭФБО-10-23

### **Цели работы:**
1.  Подключить Flutter-приложение к Supabase (Postgres + Auth + Realtime).
2.  Освоить инициализацию `supabase_flutter`, чтение/запись данных и потоковые обновления (stream()).
3.  Реализовать базовый CRUD (создание, чтение, обновление, удаление) с реактивным списком.
4.  Включить Row Level Security (RLS) и настроить безопасные политики доступа для аутентифицированных пользователей.

### **Ход работы:**

#### 1. Создание проекта Supabase и ключей

С созданием проекта, были получены `Project URL` и `Anon (public) key`.
На стороне Supabase была создана таблица `notes` со следующей схемой:
*   `id` uuid (PK, default: `gen_random_uuid()`)
*   `user_id` uuid (nullable = false)
*   `title` text
*   `content` text
*   `created_at` timestamp tz (default `now()`)
*   `updated_at` timestamp tz (default `now()`)

Для таблицы `notes` были включены политики Row Level Security по заданию

#### 2. Зависимости и инициализация

В `pubspec.yaml` были добавлены зависимости `supabase_flutter` и `flutter_dotenv`:
```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  supabase_flutter: ^2.5.1 # Или актуальная версия
  flutter_dotenv: ^5.1.0 # Или актуальная версия
```
Инициализация:
```dart
// lib/main.dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:yefremov_supabase_notes_app/auth_page.dart';
import 'package:yefremov_supabase_notes_app/notes_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  final String? supabaseUrl = dotenv.env['SUPABASE_URL'];
  final String? supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'];

  if (supabaseUrl == null || supabaseAnonKey == null) {
    throw Exception('Supabase URL or Anon Key not found in .env file');
  }

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Supabase Notes',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AuthGate(),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final session = snapshot.data?.session;
          if (session != null) {
            return const NotesPage();
          }
        }
        return const AuthPage();
      },
    );
  }
}
```
#### 3. Контрольные скриншоты

1.  **Скриншот настроенного проекта Supabase (Dashboard: Database → notes, включён RLS, список Policies):**
    *(Вставить скриншот)*

2.  **Скриншот экрана входа и экрана со списком (пустого и с данными):**
    *(Вставить скриншот)*

3.  **Скриншот после добавления заметки (элемент появился):**
    *(Вставить скриншот)*

4.  **Скриншот после редактирования заметки:**
    *(Вставить скриншот)*

5.  **Скриншот после удаления заметки:**
    *(Вставить скриншот)*

### **Безопасность: RLS в продакшене**

В проекте уже настроен RLS так, что пользователь работает только со своими заметками. Для продакшена, если не будет новых функций которые требюут более сложного RLS, с точки зрения безопасности надо добавить только валидацию вводимых данных.

### **Ошибки и их решения**

1.  **Ошибка RLS при создании заметки (`PostgrestException: new row violates row-level security policy`)**:
    *   **Проблема:** При попытке создать заметку возникала ошибка, указывающая на нарушение политики RLS
    *   **Решение:** Был использован `Restrictive` вместо `Permissive` в настройке RLS

### **Ссылки на файлы**
*   [lib/main.dart](lib/main.dart)
*   [lib/auth_page.dart](lib/auth_page.dart)
*   [lib/notes_page.dart](lib/notes_page.dart)
