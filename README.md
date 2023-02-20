# Приложение "Путеводитель по торрент-трекерам(начальная версия)"

<div>
  <a href="https://rubyonrails.org">
    <img src="https://img.shields.io/badge/Rails-7.0.3-ff0000?logo=RubyonRails&logoColor=white&?style=for-the-badge"
    alt="Rails badge" />
  </a>
  <a href="https://rubyonrails.org">
    <img src="https://img.shields.io/badge/Ruby-3.1.2-ff0000?logo=Ruby&logoColor=white&?style=for-the-badge"
    alt="Rails badge" />
  </a>
</div>

#### "Путеводитель по торрент-трекерам" - поисковик по торрент трекерам


Все очень просто:

1. Вводим нужные данные в поисковик
2. Если требуется, выбираем сортировку поиска
3. Жмём поиск

---
### Важно!
1. В вашей ситеме должен быть установлен менеджер пакетов Yarn или Npm.
2. Запуск команд производится в консоли вашей опреционой системы.

### Пошаговое руководство запуска приложения.

### Скачать репозиторий:

Перейдите в папку, в которую вы хотите скачать исходный код Ruby on Rails, и запустите:

```
$ git clone https://github.com/juwpan/torrent_search_engine.git
```
```
$ cd torrent_search_engine
```

### Установка зависимостей

```
yarn install
```
```
bundle install
```
### Запуск миграции

```
bundle exec rails db:create
```
```
bundle exec rails db:migrate
```

### Установка стилей
```
yarn build:css
```
```
yarn build
```

### Создание ключей:

В корне папки создайте файл
```
.env
```
Заполните данные

Вид:
```
export ACCOUNT='login'
export PASSWORD='password'
```

### Запуск приложения

```
rails s
```
