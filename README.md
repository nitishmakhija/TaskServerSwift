# TaskerServer

This is a simple project with server side code written in Swift. It contais few concepts which can/should have production ready server side application. Especially it focuses on:
 - MVC pattern - described on Medium [article](https://medium.com/@mczachurski/server-side-swift-mvc-f52b833ef84b)
 - Unit tests - described on Medium [article](https://medium.com/@mczachurski/server-side-swift-mvc-unit-tests-13232c56de56)
 - Configuration files - described on Medium [article](https://medium.com/@mczachurski/server-side-swift-configuration-files-c5d9fe740357)
 - Data access (ORM) - described on Medium [article](https://medium.com/@mczachurski/server-side-swift-object-relational-mapping-orm-68879d9a1aa3)
 - Services - todo
 - Data validation - todo
 - Authorization - todo
 - Logging system - todo
 
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
