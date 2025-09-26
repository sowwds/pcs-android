# Практическая 4 Ефремов Алексей ЭФБО-10-23

#### Скриншоты
<img height="400" alt="image" src="https://github.com/user-attachments/assets/a4e86c38-3ba5-4628-bd42-881fbe4b450e" />
<img height="400" alt="image" src="https://github.com/user-attachments/assets/1da78faa-e373-4ace-8da6-9ce8b57678f9" />
<img height="400" alt="image" src="https://github.com/user-attachments/assets/e9516265-e816-4625-9bf3-dd4161ee0c1b" />


#### Использованные виджеты
| Виджет | Описание |
|--------|----------|
| `Scaffold` | Основной(каркас). |
| `AppBar` | Заголовок приложения. |
| `Column` | Вертикальная компоновка текста и кнопок. |
| `Text` | Текст "Значение счётчика: $counter". |
| `ElevatedButton` | Кнопки "Увеличить" и "Сбросить". |
| `Container` | Фон кнопок, закруглённые углы. |
| `Padding` | Отступы для `Column` (16px). |
| `SizedBox` | Отступы: 30px (текст-кнопка), 20px (между кнопками). |

#### Обновление состояния
- Используется `StatefulWidget`.
- Переменная `int counter = 0`.
- `setState()`:
  - `increment()`: `counter++` (кнопка "Увеличить").
  - `incrementLong()`: `counter += 10` (долгое нажатие на кнопку "Увеличить").
  - `reset()`: `counter = 0` (кнопка "Сбросить").
- `Text` обновляется при изменении `counter`.

#### Обработанные события
- "Увеличить": `onPressed` (+1), `onLongPress` (+10).
- "Сбросить": `onPressed` (сброс до 0).
