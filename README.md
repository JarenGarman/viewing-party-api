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
{
    "data": {
        "id": "4",
        "type": "user",
        "attributes": {
            "name": "Me",
            "username": "its_me",
            "viewing_parties_hosted": [
                {
                    "id": 1,
                    "name": "Juliet's Bday Movie Bash!",
                    "start_time": "2025-02-01T10:00:00.000Z",
                    "end_time": "2025-02-01T14:30:00.000Z",
                    "movie_id": 278,
                    "movie_title": "The Shawshank Redemption",
                    "host_id": 4
                }
            ],
            "viewing_parties_invited": []
        }
    }
}
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

#### Show Movie

To get the details of a particular movie, send a `GET` request to `<base_path>/movies/<Movie ID>`

Example: `GET http://127.0.0.1:3000/api/v1/movies/278`

Response:

```json
{
    "data": {
        "id": "278",
        "type": "movie",
        "attributes": {
            "title": "The Shawshank Redemption",
            "vote_average": 8.709,
            "summary": "Imprisoned in the 1940s for the double murder of his wife and her lover, upstanding banker Andy Dufresne begins a new life at the Shawshank prison, where he puts his accounting skills to work for an amoral warden. During his long stretch in prison, Dufresne comes to be admired by the other inmates -- including an older prisoner named Red -- for his integrity and unquenchable sense of hope.",
            "total_reviews": 17,
            "release_year": 1994,
            "runtime": "2 hours, 22 minutes",
            "genres": [
                "Drama",
                "Crime"
            ],
            "cast": [
                {
                    "character": "Ellis Boyd 'Red' Redding",
                    "actor": "Morgan Freeman"
                },
                {
                    "character": "Andy Dufresne",
                    "actor": "Tim Robbins"
                },
                {
                    "character": "Warden Norton",
                    "actor": "Bob Gunton"
                },
                ...
            ],
            "reviews": [
                {
                    "author": "elshaarawy",
                    "review": "very good movie 9.5/10 محمد الشعراوى"
                },
                ...
            ]
        }
    }
}
```

### Viewing Parties

#### Create Viewing Party

To create a viewing party, send a `POST` request to `<base_path>/users/<User ID>/viewing_parties` with a JSON formatted body that contains the following *required* params:

1. name
2. start_time
3. end_time (must allow for the full runtime of the movie)
4. movie_id
5. movie_title
6. invitees

Example: `POST http://127.0.0.1:3000/api/v1/users/4/viewing_parties`

```json
{
    "name": "Juliet's Bday Movie Bash!",
    "start_time": "2025-02-01 10:00:00",
    "end_time": "2025-02-01 14:30:00",
    "movie_id": 278,
    "movie_title": "The Shawshank Redemption",
    "invitees": [1, 2, 3]
}
```

Response:

```json
{
    "data": {
        "id": "1",
        "type": "viewing_party",
        "attributes": {
            "name": "Juliet's Bday Movie Bash!",
            "start_time": "2025-02-01T10:00:00.000Z",
            "end_time": "2025-02-01T14:30:00.000Z",
            "movie_id": 278,
            "movie_title": "The Shawshank Redemption"
        },
        "relationships": {
            "users": {
                "data": [
                    {
                        "id": "1",
                        "type": "user"
                    },
                    {
                        "id": "2",
                        "type": "user"
                    },
                    {
                        "id": "3",
                        "type": "user"
                    }
                ]
            }
        }
    }
}
```

#### Invite User to Existing Viewing Party

To invite a user to an existing viewing party, send a `PATCH` request to `<base_path>/users/<User ID>/viewing_parties/<Viewing Party ID` with a JSON formatted body that contains the following *required* param:

1. invitees_user_id

Example: `PATCH http://127.0.0.1:3000/api/v1/users/4/viewing_parties/1`

```json
{
      "invitees_user_id": 5
}
```

Response:

```json
{
    "data": {
        "id": "1",
        "type": "viewing_party",
        "attributes": {
            "name": "Juliet's Bday Movie Bash!",
            "start_time": "2025-02-01T10:00:00.000Z",
            "end_time": "2025-02-01T14:30:00.000Z",
            "movie_id": 278,
            "movie_title": "The Shawshank Redemption"
        },
        "relationships": {
            "users": {
                "data": [
                    {
                        "id": "1",
                        "type": "user"
                    },
                    {
                        "id": "2",
                        "type": "user"
                    },
                    {
                        "id": "3",
                        "type": "user"
                    },
                    {
                        "id": "5",
                        "type": "user"
                    }
                ]
            }
        }
    }
}
```
