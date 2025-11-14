# Практическая 10 Ефремов Алексей ЭФБО-10-23

### **Цели работы:**
1. Подключить Flutter-приложение к локальной базе данных SQLite (пакет sqflite).
2. Создать таблицы и реализовать базовый CRUD: добавление, чтение, обновление, удаление.
3. Настроить класс-помощник для работы с БД и отделить слой данных от UI.
4. Отработать миграции схемы и диагностику частых ошибок.

### **Ход работы:**

#### 1. Подготовка проекта и добавление зависимостей

В `pubspec.yaml` были добавлены зависимости `sqflite` и `path_provider` для работы с локальной базой данных.

#### 2. Структура проекта

*   `lib/models/note.dart`: Модель данных `Note` с полями `id`, `title`, `body`, `createdAt`, `updatedAt` и методами для сериализации (`toMap`/`fromMap`).
*   `lib/data/db_helper.dart`: Класс `DBHelper` для инкапсуляции всей логики работы с SQLite. Он управляет открытием БД, созданием таблиц (`onCreate`) и предоставляет асинхронные CRUD-методы (`insertNote`, `fetchNotes`, `updateNote`, `deleteNote`).
*   `lib/pages/notes_page.dart`: UI-слой, который использует `DBHelper` для отображения, добавления, редактирования и удаления заметок. Для асинхронности используется `FutureBuilder`.

#### 3. Ключевые моменты реализации

*   **Создание таблицы:** Таблица `notes` создается при первом запуске приложения с помощью `db.execute` в коллбеке `onCreate` `openDatabase`.
*   **CRUD-операции:** Все операции с БД crud реализованы как асинхронные `Future` методы в `DBHelper`, чтобы не блокировать UI.
*   **Отображение данных:** `FutureBuilder` в `notes_page.dart` подписывается на `DBHelper.fetchNotes()` и отображает либо индикатор загрузки, либо список заметок.
*   **Обновление UI:** После каждой операции, изменяющей данные (создание, редактирование, удаление), вызывается метод `_reload()`, который заново получает данные из БД и перестраивает UI через `setState`.
*   **Удаление:** Реализовано с помощью виджета `Dismissible`, что позволяет удалять заметки свайпом.

#### 4. Контрольные скриншоты

1.  **Скриншот приложения с пустым списком (первый запуск):**
    <img height="400" alt="image" src="PLACEHOLDER_EMPTY_LIST_SCREENSHOT" />

2.  **Скриншот после добавления заметки:**
    <img height="400" alt="image" src="PLACEHOLDER_NOTE_ADDED_SCREENSHOT" />

3.  **Скриншот окна редактирования и итоговой записи:**
    <img height="400" alt="image" src="PLACEHOLDER_EDIT_DIALOG_SCREENSHOT" />

4.  **Скриншот после удаления заметки:**
    <img height="400" alt="image" src="PLACEHOLDER_NOTE_DELETED_SCREENSHOT" />

### **Ошибки и их решения**

В ходе работы особых проблем не возникло. Только с асинхронностью и правильным использованием `FutureBuilder` и `setState` для обновления ui. Также важно не забывать увеличивать версию бд в `DBHelper` при изменении чтобы сработал коллбек `onUpgrade`.

### **Ссылки на файлы**
*   [lib/main.dart](yefremov_notes_sqlite_app/lib/main.dart)
*   [lib/models/note.dart](yefremov_notes_sqlite_app/lib/models/note.dart)
*   [lib/data/db_helper.dart](yefremov_notes_sqlite_app/lib/data/db_helper.dart)
*   [lib/pages/notes_page.dart](yefremov_notes_sqlite_app/lib/pages/notes_page.dart)
