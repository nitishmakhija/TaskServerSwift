# TaskerServer

This is a simple project with server side code written in Swift. It contais few concepts which can/should have production ready server side application. Especially it focuses on:
 - MVC pattern - described on Medium [article](https://medium.com/@mczachurski/server-side-swift-mvc-f52b833ef84b)
 - Unit tests - described on Medium [article](https://medium.com/@mczachurski/server-side-swift-mvc-unit-tests-13232c56de56)
 - Configuration files - described on Medium [article](https://medium.com/@mczachurski/server-side-swift-configuration-files-c5d9fe740357)
 - Data access (ORM) - described on Medium [article](https://medium.com/@mczachurski/server-side-swift-object-relational-mapping-orm-68879d9a1aa3)
 - Services, Repositories & Data validation - described on Medium [article](https://medium.com/@mczachurski/server-side-swift-services-repositories-data-validation-d6988c24e720)
 - Authentication & Authorization - described on Medium [article](https://medium.com/@mczachurski/server-side-swift-authentication-authorization-cc6ea70ccd5f)
 - Resource based authorization - described on Medium [article](https://medium.com/@mczachurski/server-side-swift-resource-based-authorization-62ef4e006e77)
 - Docker on Azure - described on Medium [article](https://medium.com/@mczachurski/server-side-swift-docker-on-azure-5778be8f207)
 
## Getting started

### Swift 

Verify that you have Swift installed: `swift --version`. Command should produce message similar to this one:

```
Apple Swift version 4.0 (swiftlang-900.0.65 clang-900.0.37)
Target: x86_64-apple-macosx10.9
```

If Swift is not installed on you computer follow the steps described on [Swift.org](https://swift.org/getting-started/#installing-swift).

### Perfect prerequisites

**macOS**
Everything you need is already installed.

**Ubuntu Linux**
Perfect runs in Ubuntu Linux 16.04 environments. Perfect relies on OpenSSL, libssl-dev, and uuid-dev. To install these, in the terminal, type:

```
sudo apt-get install openssl libssl-dev uuid-dev
```

### Build and run project

Now you’re ready to build application. The following will clone and build project. It will launch a local server that will run on port 8181 on your computer:

```
git clone https://github.com/mczachurski/TaskServerSwift.git
cd TaskServerSwift
swift build
.build/debug/TaskServerSwift
```

The server is now running and waiting for connections. Access http://localhost:8181/ to see the greeting. Hit "control-c" to terminate the server.

## API

Below there is a description of all API endpoints which exists in the application.

### Health controller

Actions in health controller.

#### Get health

Endpoint which returns information about application status.

|               |            |
|---------------|------------|
| Method        | GET        |
| Uri           | /health    |
| Authorization | anonymous  |

Response example:

```json
{
    "message": "I'm fine and running!"
}
```

Curl:

```bash
curl -X GET \
  http://localhost:8181/health \
  -H 'Cache-Control: no-cache'
```

### Account controller

Controller with actions for managing user account.

#### Creating new user

Endpoint where user can create a new account in the system.

|               |                   |
|---------------|-------------------|
| Method        | POST              |
| Uri           | /account/register |
| Authorization | anonymous         |

Request example:

```json
{
    "name": "John Doe",
    "email": "john.doe@some-email.com",
    "password": "p@ssw0rd",
    "isLocked": false
}
```

Response example:

```json
{
    "email": "john.doe@some-email.com",
    "id": "8A267133-E50F-442D-AEFF-6C388E4D87C7",
    "roles": [],
    "name": "John Doe",
    "isLocked": false
}
```

Curl:

```bash
curl -X POST \
  http://localhost:8181/account/register \
  -H 'Cache-Control: no-cache' \
  -H 'Content-Type: application/json' \
  -d '{
    "name": "John Doe",
    "email": "john.doe@some-email.com",
    "password": "p@ssw0rd",
    "isLocked": false
}'
```

#### Signing in

Endpoint for signing in into the system. Endpoint returns JWT token which can be used for all further communication.

|               |                   |
|---------------|-------------------|
| Method        | POST              |
| Uri           | /account/signIn   |
| Authorization | anonymous         |

Request example:

```json
{
    "email": "john.doe@some-email.com",
    "password": "p@ssw0rd"
}
```

Response example:

```json
{
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1lIjoiam9obi5kb2VAc29tZS1lbWFpbC5jb20iLCJpc3MiOiJ0YXNrZXItc2VydmVyLWlzc3VlciIsImlhdCI6MTUyMDY2OTE5MS43NDc5LCJleHAiOjE1MjA3MDUxOTEuNzQ3OSwicm9sZXMiOltdLCJ1aWQiOiIzNTk0NTc2NS00QTYxLTQ2NjEtOUVBQS04NTcwRjY1RTQ1OTgifQ.UorB8ZT2gU7LCp4pagiTeVVMqs0e5KHC04zi2wsvRmg"
}
```

Curl:

```bash
curl -X POST \
  http://localhost:8181/account/signIn \
  -H 'Cache-Control: no-cache' \
  -H 'Content-Type: application/json' \
  -d '{
    "email": "john.doe@some-email.com",
    "password": "p@ssw0rd"
}'
```

#### Changing password

Endpoint where user can change his password to the system.

|               |                         |
|---------------|-------------------------|
| Method        | POST                    |
| Uri           | /account/changePassword |
| Authorization | signed in               |

Request example:

```json
{
    "email": "john.doe@some-email.com",
    "password": "p@ssw0rd"
}
```

Curl:

```bash
curl -X POST \
  http://localhost:8181/account/changePassword \
  -H 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1lIjoiam9obi5kb2VAc29tZS1lbWFpbC5jb20iLCJpc3MiOiJ0YXNrZXItc2VydmVyLWlzc3VlciIsImlhdCI6MTUyMDY2OTE5MS43NDc5LCJleHAiOjE1MjA3MDUxOTEuNzQ3OSwicm9sZXMiOltdLCJ1aWQiOiIzNTk0NTc2NS00QTYxLTQ2NjEtOUVBQS04NTcwRjY1RTQ1OTgifQ.UorB8ZT2gU7LCp4pagiTeVVMqs0e5KHC04zi2wsvRmg' \
  -H 'Cache-Control: no-cache' \
  -H 'Content-Type: application/json' \
  -d '{
    "email": "john.doe@some-email.com",
    "password": "p@ssw0rd"
}'
```


### Tasks

Controller with actions for managing tasks.

#### Get tasks

Endpoint returns all tasks from system.

|               |                         |
|---------------|-------------------------|
| Method        | GET                     |
| Uri           | /tasks                  |
| Authorization | signed in               |

Response example:

```json
[
    {
        "id": "6DEB0425-DE7E-4F8E-9674-6139B05883EC",
        "name": "Create new controllers",
        "isFinished": false
    },
    {
        "id": "C046B24B-92DC-4712-B434-98C1C2D19295",
        "name": "Create authorization",
        "isFinished": false
    }
]
```

Curl:

```bash
curl -X GET \
  http://localhost:8181/tasks \
  -H 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1lIjoiam9obi5kb2VAc29tZS1lbWFpbC5jb20iLCJpc3MiOiJ0YXNrZXItc2VydmVyLWlzc3VlciIsImlhdCI6MTUyMDY2OTE5MS43NDc5LCJleHAiOjE1MjA3MDUxOTEuNzQ3OSwicm9sZXMiOltdLCJ1aWQiOiIzNTk0NTc2NS00QTYxLTQ2NjEtOUVBQS04NTcwRjY1RTQ1OTgifQ.UorB8ZT2gU7LCp4pagiTeVVMqs0e5KHC04zi2wsvRmg' \
  -H 'Cache-Control: no-cache'
```

#### Get task by id

Endpoint returns specific tasks by his identifier (id).

|               |                         |
|---------------|-------------------------|
| Method        | GET                     |
| Uri           | /tasks/{id}             |
| Authorization | signed in               |

Response example:

```json
{
    "id": "6DEB0425-DE7E-4F8E-9674-6139B05883EC",
    "name": "Create new controllers",
    "isFinished": false
}
```

Curl:

```bash
curl -X GET \
  http://localhost:8181/tasks/6DEB0425-DE7E-4F8E-9674-6139B05883EC \
  -H 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1lIjoiam9obi5kb2VAc29tZS1lbWFpbC5jb20iLCJpc3MiOiJ0YXNrZXItc2VydmVyLWlzc3VlciIsImlhdCI6MTUyMDY2OTE5MS43NDc5LCJleHAiOjE1MjA3MDUxOTEuNzQ3OSwicm9sZXMiOltdLCJ1aWQiOiIzNTk0NTc2NS00QTYxLTQ2NjEtOUVBQS04NTcwRjY1RTQ1OTgifQ.UorB8ZT2gU7LCp4pagiTeVVMqs0e5KHC04zi2wsvRmg' \
  -H 'Cache-Control: no-cache'
```

#### Create new task

Endpoint for creating new tasks in the system.

|               |                         |
|---------------|-------------------------|
| Method        | POST                    |
| Uri           | /tasks                  |
| Authorization | signed in               |

Request example:

```json
{
    "name": "Create new controllers",
    "isFinished": false
}
```

Response example:

```json
{
    "id": "6DEB0425-DE7E-4F8E-9674-6139B05883EC",
    "name": "Create new controllers",
    "isFinished": false
}
```

Curl:

```bash
curl -X POST \
  http://taskerserverswift.azurewebsites.net/tasks \
  -H 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1lIjoiam9obi5kb2VAc29tZS1lbWFpbC5jb20iLCJpc3MiOiJ0YXNrZXItc2VydmVyLWlzc3VlciIsImlhdCI6MTUyMDY2OTE5MS43NDc5LCJleHAiOjE1MjA3MDUxOTEuNzQ3OSwicm9sZXMiOltdLCJ1aWQiOiIzNTk0NTc2NS00QTYxLTQ2NjEtOUVBQS04NTcwRjY1RTQ1OTgifQ.UorB8ZT2gU7LCp4pagiTeVVMqs0e5KHC04zi2wsvRmg' \
  -H 'Cache-Control: no-cache' \
  -H 'Content-Type: application/json' \
  -d '{
    "name": "Create new controllers",
    "isFinished": false
}'
```

#### Update tasks

Endpoint for updating tasks

|               |                         |
|---------------|-------------------------|
| Method        | PUT                     |
| Uri           | /tasks/{id}             |
| Authorization | signed in               |

Request example:

```json
{
    "id": "6DEB0425-DE7E-4F8E-9674-6139B05883EC",
    "name": "Create new actions",
    "isFinished": false
}
```

Response example:

```json
{
    "id": "6DEB0425-DE7E-4F8E-9674-6139B05883EC",
    "name": "Create new actions",
    "isFinished": false
}
```

Curl:

```bash
curl -X PUT \
  http://localhost:8181/tasks/6DEB0425-DE7E-4F8E-9674-6139B05883EC \
  -H 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1lIjoiam9obi5kb2VAc29tZS1lbWFpbC5jb20iLCJpc3MiOiJ0YXNrZXItc2VydmVyLWlzc3VlciIsImlhdCI6MTUyMDY2OTE5MS43NDc5LCJleHAiOjE1MjA3MDUxOTEuNzQ3OSwicm9sZXMiOltdLCJ1aWQiOiIzNTk0NTc2NS00QTYxLTQ2NjEtOUVBQS04NTcwRjY1RTQ1OTgifQ.UorB8ZT2gU7LCp4pagiTeVVMqs0e5KHC04zi2wsvRmg' \
  -H 'Cache-Control: no-cache' \
  -H 'Content-Type: application/json' \
  -d '{
    "id": "6DEB0425-DE7E-4F8E-9674-6139B05883EC",
    "name": "Create new actions",
    "isFinished": false
}'
```

#### Deleting tasks

Endpoint where user can delete his tasks.

|               |                         |
|---------------|-------------------------|
| Method        | DELETE                  |
| Uri           | /tasks/{id}             |
| Authorization | signed in               |

Curl:

```bash
curl -X DELETE \
  http://localhost:8181/tasks/6DEB0425-DE7E-4F8E-9674-6139B05883EC \
  -H 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1lIjoiam9obi5kb2VAc29tZS1lbWFpbC5jb20iLCJpc3MiOiJ0YXNrZXItc2VydmVyLWlzc3VlciIsImlhdCI6MTUyMDY2OTE5MS43NDc5LCJleHAiOjE1MjA3MDUxOTEuNzQ3OSwicm9sZXMiOltdLCJ1aWQiOiIzNTk0NTc2NS00QTYxLTQ2NjEtOUVBQS04NTcwRjY1RTQ1OTgifQ.UorB8ZT2gU7LCp4pagiTeVVMqs0e5KHC04zi2wsvRmg' \
  -H 'Cache-Control: no-cache'
```

### Users

self.add(method: .get, uri: "/users", authorization: .inRole(["Administrator"]), handler: all)
self.add(method: .get, uri: "/users/{id}", authorization: .inRole(["Administrator"]), handler: get)
self.add(method: .post, uri: "/users", authorization: .inRole(["Administrator"]), handler: post)
self.add(method: .put, uri: "/users/{id}", authorization: .inRole(["Administrator"]), handler: put)
self.add(method: .delete, uri: "/users/{id}", authorization: .inRole(["Administrator"]), handler: delete)