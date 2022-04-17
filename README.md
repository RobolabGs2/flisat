# Flisat
Backend для блога на Elixir + Phoenix для курса Серверное программирование.


## Требования

Общие для всех:
1. Авторизация
2. Аутентификация
3. Проверка действий пользователя (нельзя изменять чужую сущность и т.д)
4. Пагинация на списках
5. Валидация парматеров для запросов (запрос не должен падать из-за кривого параметра)
6. Работа со сценариями ошибок
7. Покрытие тестами

Для блога:
 - посты
 - комменты
 - лайки(посты, коменты)
 - теги
 - поиск по: тегам, автору, по названию поста, по содержанию, по дате создания
 - фильтрация: по дате публикации, по автору, по тегам, по рейтингу
