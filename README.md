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


## Developing
To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
