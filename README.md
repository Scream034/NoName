# Amethyst

## Введение
- Имя игры: **Amethyst**
- Измерение: **2D top-down**
- [**Подробнее**](https://www.notion.so/UNKNOWN-2ffa7ae864e047b98ed4e45b641918e8#2827b652b71d4796a1a95483764167aa) *(Требуется доступ)*

## Требования
- **C#**: Знать, понимать данный язык, на нём большая часть проекта.
- **Godot Engine**: Используйте последнюю версию [Godot Engine .NET](https://github.com/godotengine/godot-builds/releases/download/4.3-dev5/Godot_v4.3-dev5_mono_win64.zip).
- **Visual Studio Code**: Рекомендуется использовать [Visual Studio Code](https://code.visualstudio.com) в качестве редактора кода (поддержка остальных редакторов кода не гарантируется).
- **Расширения**: Установите все расширения, перечисленные в файле [`.vscode/extensions.json`](https://github.com/Scream034/Amethyst/blob/Основная-ветка/.vscode/extensions.json) для наилучшей совместимости и функциональности.

## Важные замечания
### Стандарты кодирования
Для обеспечения согласованности и чистоты кода в этом проекте необходимо следовать установленным стандартам кодирования на `C#`!

#### Прочие соглашения
- Используйте осмысленные и описательные имена для переменных, функций и методов.
- Комментируйте с помощью `XML` сложные участки кода и логику для улучшения читаемости.
- Форматируйте код согласно общепринятым стандартам для улучшения его восприятия.

Соблюдение этих стандартов кодирования поможет поддерживать код чистым, понятным и единообразным, что значительно облегчит совместную работу над проектом и его дальнейшую поддержку.

## Установка проекта
1) Скачайте данный репозиторий.
2) Распакуйте архив.
3) Откройте [Godot Engine 4.3-dev5.mono](https://github.com/godotengine/godot-builds/releases/download/4.3-dev5/Godot_v4.3-dev5_mono_win64.zip).
4) Просканируйте папку с проектом или **"перетащите папку" в менеджер проектов**.
5) Найдите проект и начните редактировать.

## Установка `Visual Studio Code` и настройки
1) Скачать [Visual Studio Code](https://code.visualstudio.com) *(Альтернативные - не работают)* и установить.
2) Войдите в свой `GitHub` в `Visual Studio Code` через `Система управления версиями` *(CTRL+SHIFT+G)*!
3) Рекомендуемые расширения:
      - [**icrawl.discord-vscode**](https://marketplace.visualstudio.com/items?itemName=icrawl.discord-vscode): Транслирует ваши действия в профиль дискорда.
      - [**PKief.material-icon-theme**](https://marketplace.visualstudio.com/items?itemName=PKief.material-icon-theme): Удобные иконки для проводника.
      - [**MS-CEINTL.vscode-language-pack-ru**](https://marketplace.visualstudio.com/items?itemName=MS-CEINTL.vscode-language-pack-ru): Русифакатор интерфейса.
      - [**zhuangtongfa.material-theme**](https://marketplace.visualstudio.com/items?itemName=zhuangtongfa.material-theme): Классная тема.
      - [**VisualStudioExptTeam.vscodeintellicode**](https://marketplace.visualstudio.com/items?itemName=VisualStudioExptTeam.vscodeintellicode): Помогает писать код (подсказки).
      - [**mhutchie.git-graph**](https://marketplace.visualstudio.com/items?itemName=mhutchie.git-graph): Удобен в просмотре кода на review (в графическом виде история изменений).
      - [**eamodio.gitlens**](https://marketplace.visualstudio.com/items?itemName=eamodio.gitlens): Удобный в использовании git.
      - [**donjayamanne.githistory**](https://marketplace.visualstudio.com/items?itemName=donjayamanne.githistory): Удобен в просмотре истории действий репозитория.
      - [**geequlim.godot-tools**](https://marketplace.visualstudio.com/items?itemName=geequlim.godot-tools): Инструменты для работы с `GDScript`. **Требует настройки**
      - [**alfish.godot-files**](https://marketplace.visualstudio.com/items?itemName=alfish.godot-files): Упращает редактирование файлов `Godot Engine` (.res, .tscn, .scn, т.д.).
3) **Необходимые расширения для проекта:**
      - [**neikeq.godot-csharp-vscode**](https://marketplace.visualstudio.com/items?itemName=neikeq.godot-csharp-vscode): Нужен для работы `.NET` (C#) с `Godot Engine` и вашим `Visual Studio Code`.
      - [**k--kato.docomment**](https://marketplace.visualstudio.com/items?itemName=k--kato.docomment): Расширение для удобного документирования на `XML` в `C#`.
      - [**gruntfuggly.todo-tree**](https://marketplace.visualstudio.com/items?itemName=gruntfuggly.todo-tree): Для просмотра задач. (```TODO```, ```BUG```, ...)
4) Настройка `Godot Engine`:
      - Перейти в `Настройки редактора`.
      - В поиск вставить `dotnet/editor`, потом:
            - `External editor`: Значение `Visual Studio Code`.
            - `Custom Exec Path Args`: Сделать поле пустым.
5) Настройка проекта:
      - Выбрать файл `.vscode/launch.json`:
            - Найти в нём `configurations/program`, выставить новое значение: полный путь к файлу `Godot_v4.3-dev5_mono_win64.exe`
6) Можете приступать к редактированию кода!

## Обратная связь
Если у вас есть вопросы или предложения, вы можете связаться с нами:
- Создатель репозитория: `Telegram @paralax034`, `Discord paralax034`
- Сервер проекта (по приглашению).