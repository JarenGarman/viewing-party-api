# Viewing Part API - Solo Project

This is the base repo for the Viewing Party Solo Project for Module 3 in Turing's Software Engineering Program.

## About this Application

Viewing Party is an application that allows users to explore movies and create a Viewing Party Event that invites users and keeps track of a host. Once completed, this application will collect relevant information about movies from an external API, provide CRUD functionality for creating a Viewing Party and restrict its use to only verified users.

## Setup

1. Fork and clone the repo
2. Install gem packages: `bundle install`
3. Setup the database: `rails db:{drop,create,migrate,seed}`
4. Start the server: `rails server`

## Endpoints

The following endpoints are assuming the rails server is running locally with the default **base_path**: `http://127.0.0.1:3000/api/v1`

### Users

#### Create User

To create a user, send a `POST` request to `<base_path>/users` with a JSON formatted body that contains the following *required* params:

1. name
2. username (must be unique)
3. password
4. password_confirmation (must match password)

Example: `POST http://127.0.0.1:3000/api/v1/users`

```json
{
    "name": "Me",
    "username": "its_me",
    "password": "<Password>",
    "password_confirmation": "<Password>"
}
```

Response:

```json
{
    "data": {
        "id": "4",
        "type": "user",
        "attributes": {
            "name": "Me",
            "username": "its_me",
            "api_key": "<API_Key>"
        }
    }
}
```

#### Get All Users

To get a list of all users, send a `GET` request to `<base_path>/users`

Example: `GET http://127.0.0.1:3000/api/v1/users`

Response:

```json
{
    "data": [
        {
            "id": "1",
            "type": "user",
            "attributes": {
                "name": "Danny DeVito",
                "username": "danny_de_v"
            }
        },
        {
            "id": "2",
            "type": "user",
            "attributes": {
                "name": "Dolly Parton",
                "username": "dollyP"
            }
        },
        {
            "id": "3",
            "type": "user",
            "attributes": {
                "name": "Lionel Messi",
                "username": "futbol_geek"
            }
        },
        {
            "id": "4",
            "type": "user",
            "attributes": {
                "name": "Me",
                "username": "its_me"
            }
        }
    ]
}
```

#### Get User Details

To get the details of a particular user (including viewing parties), send a `GET` request to `<base_path>/users/<User ID>`

Example: `GET http://127.0.0.1:3000/api/v1/users/4`

Response:

```json
```

### Sessions

#### Login

To login, send a `POST` request to `<base_path>/sessions` with a JSON formatted body that contains the following *required* params:

1. username
2. password

Example: `POST http://127.0.0.1:3000/api/v1/sessions`

```json
{
    "username": "its_me",
    "password": "<Password>"
}
```

Response:

```json
{
    "data": {
        "id": "4",
        "type": "user",
        "attributes": {
            "name": "Me",
            "username": "its_me",
            "api_key": "<API_Key>"
        }
    }
}
```

### Movies

#### Top Rated Movies

To get a list of top rated movies (maximum of 20), send a `GET` request to `<base_path>/movies`

Example: `GET http://127.0.0.1:3000/api/v1/movies`

Response:

```json
{
    "data": [
        {
            "id": "278",
            "type": "movie",
            "attributes": {
                "title": "The Shawshank Redemption",
                "vote_average": 8.709
            }
        },
        {
            "id": "238",
            "type": "movie",
            "attributes": {
                "title": "The Godfather",
                "vote_average": 8.689
            }
        },
        {
            "id": "240",
            "type": "movie",
            "attributes": {
                "title": "The Godfather Part II",
                "vote_average": 8.569
            }
        },
        ...
    ]
}
```

#### Search Movies

To search for a list of movies by title (maximum of 20), send a `GET` request to `<base_path>/movies` with a query param `search` equal to a URL encoded string of your search term.

Example: `GET http://127.0.0.1:3000/api/v1/movies?search=Lord%20of%20the%20Rings`

Response:

```json
{
    "data": [
        {
            "id": "122",
            "type": "movie",
            "attributes": {
                "title": "The Lord of the Rings: The Return of the King",
                "vote_average": 8.482
            }
        },
        {
            "id": "123",
            "type": "movie",
            "attributes": {
                "title": "The Lord of the Rings",
                "vote_average": 6.6
            }
        },
        {
            "id": "839033",
            "type": "movie",
            "attributes": {
                "title": "The Lord of the Rings: The War of the Rohirrim",
                "vote_average": 6.631
            }
        },
        ...
    ]
}
```
