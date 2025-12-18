# Практическая 14 Ефремов Алексей ЭФБО-10-23

### **Цели работы:**
- Освоить базовые виды тестирования во Flutter: unit-, widget- и integration-tests.
- Настроить линтинг и статический анализ, повысить качество кода.
- Научиться профилировать производительность (FPS, jank, память, пропуски кадров) через DevTools и Performance Overlay.
- Применить практики оптимизации: уменьшение количества перестроений, работа со списками, изоляция тяжёлых вычислений, оптимизация изображений.
- Отработать цикл «поиск дефекта -> воспроизведение -> минимальный пример -> исправление -> тест/регресс».

### **Ход работы:**

#### 1. Подготовка и статический анализ (Шаг 0)

- **Обновление зависимостей:** `flutter pub upgrade` для обновления всех пакетов до последних совместимых версий.
- **Настройка линтера:** В `pubspec.yaml` была проверена и подтверждена зависимость `flutter_lints`. Файл `analysis_options.yaml` был настроен для использования набора правил `package:flutter_lints/flutter.yaml`.
- **Статический анализ:** Была запущена команда `flutter analyze`. Изначально было найдено 8 проблем, связанных с использованием устаревших API (`deprecated_member_use`) и неправильным порядком свойств в конструкторах виджетов (`sort_child_properties_last`). Все проблемы были последовательно исправлены в файлах:
    - `lib/core/utils/color_utils.dart`
    - `lib/features/habits/screens/habit_details_screen.dart`
    - `lib/features/habits/screens/habit_form_screen.dart`
    - `lib/features/habits/screens/today_screen.dart`
    - `lib/features/habits/widgets/habit_list_item.dart`
    - `lib/main.dart`

#### 2. Тестирование (Шаг 1, 2)

Были написаны unit- и widget-тесты для проверки ключевых частей приложения.

- **Unit-тесты (`test/utils_test.dart`):**
    - Были протестированы утилитарные классы `ColorUtils` и `IconUtils`.
    - Написано 7 тестов, покрывающих конвертацию цветов, обработку неверных форматов, а также получение иконок по имени (включая случаи с `null` и неверным именем).

- **Widget-тесты (`test/habit_form_screen_test.dart`):**
    - Написано 3 теста для экрана создания/редактирования привычки.
    - Проверки включают: корректный рендеринг UI, работу валидации поля "Name" и динамическое отображение полей для "привычки-счетчика" при активации переключателя.
    - В ходе написания тестов была решена проблема с падением тестов из-за неинициализированного `Supabase` и `shared_preferences` в тестовом окружении. Это было исправлено путем добавления `SharedPreferences.setMockInitialValues({});` и `Supabase.initialize(...)` в блок `setUpAll`. Также была решена проблема с виджетами за пределами экрана с помощью `tester.ensureVisible()`.

- **Покрытие тестами:**
    - После написания и исправления всех тестов была запущена команда `flutter test --coverage`.
    - **Итоговое покрытие составило 12.8%**. Это значение отражает покрытие только протестированных утилит и одного экрана, но демонстрирует применение методологии тестирования.

#### 3. Оптимизация (Шаг 5)

Были применены минимальные, но эффективные практики оптимизации.

1.  **Удаление баннера "Debug":** В `MaterialApp` было добавлено свойство `debugShowCheckedModeBanner: false`.
2.  **Использование `const`:** Проведен рефакторинг кода с добавлением `const` к виджетам и объектам, которые не меняются. Это уменьшает количество ненужных перестроений виджетов.
3.  **Использование `ValueKey` в списках:** В `ListView.builder` на главном экране (`today_screen.dart`) для `HabitListItem` был добавлен ключ `key: ValueKey(habit.id)`. Это помогает Flutter более эффективно отслеживать и обновлять элементы в списке.

#### 4. Обработка ошибок (Шаг 7)

Для улучшения пользовательского опыта при возникновении сбоев была реализована глобальная обработка ошибок.

- **Реализация:** В `main.dart` был добавлен блок `runZonedGuarded`, который перехватывает все ошибки, возникающие в приложении.
- **Перехватчики:**
    - `FlutterError.onError`: перехватывает ошибки, специфичные для Flutter.
    - `ErrorWidget.builder`: заменяет стандартный "красный экран смерти" на дружелюбный виджет, информирующий пользователя о проблеме.
- **Пример кода из `main.dart`:**
    ```dart
    ErrorWidget.builder = (FlutterErrorDetails details) {
      return Scaffold(
        backgroundColor: AppColors.base,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: AppColors.red, size: 48),
              const SizedBox(height: 16),
              Text(
                'Упс! Что-то пошло не так.',
                style: TextStyle(color: AppColors.text, fontSize: 18),
              ),
            ],
          ),
        ),
      );
    };
    ```

### **Ссылки на файлы**
*   [test/utils_test.dart](/solo-project/habit_tracker/test/utils_test.dart)
*   [test/habit_form_screen_test.dart](/solo-project/habit_tracker/test/habit_form_screen_test.dart)
*   [lib/main.dart](/solo-project/habit_tracker/lib/main.dart)
