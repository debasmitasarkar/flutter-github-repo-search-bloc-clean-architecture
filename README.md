# GitHub Repository Search App

## Overview

The **GitHub Repository Search App** allows users to search for GitHub repositories by name, view repository details, and explore open issues within a repository. This project leverages the following technologies:

- **Flutter** for building the UI
- **BLoC (Business Logic Component)** for state management
- **RxDart** for event streams and debouncing
- **Dartz** for functional programming, including error handling with `Either`
- **JsonSerializable** for JSON serialization
- **GitHub API** for fetching repository and issue data
- **Clean Architecture** for organizing code into layers

## Features

- **Search GitHub Repositories:** Search for repositories by their name, sort results by repo full_name alphabetically.
- **Pagination:** Load more repositories as you scroll (infinite scrolling).
- **Repository Details:** View details of each repository, including the owner, stars, forks, and issues.
- **Open Issues:** Navigate to a detailed page showing all open issues for a repository, with pagination for loading more issues.
- **Debounced Search:** Search input is debounced to avoid making too many requests to the GitHub API.
- **Functional Programming Concepts:** Uses functional programming principles to handle data transformations, error handling, and state management.

## Folder Structure

```bash
.
├── lib
│   ├── core
│   │   ├── error                # Custom exceptions and failure classes
│   │   ├── base_usecase.dart    # Base class for use cases following Clean Architecture
│   ├── data
│   │   ├── datasources          # Remote data sources interacting with GitHub API
│   │   ├── models               # Data models for repositories and issues
│   ├── domain
│   │   ├── entities             # Repository and Issue entities
│   │   ├── repositories         # Repository interface
│   │   ├── usecases             # Use cases for fetching repositories and issues
│   ├── presentation
│   │   ├── search_repo          # BLoC, UI widgets, and states for the repo search page
│   │   ├── search_repo_detail   # BLoC, UI widgets, and states for the issue detail page
│   └── main.dart                # App entry point
├── test                         # Unit and widget tests
├── pubspec.yaml                 # Project dependencies
└── README.md                    # This file
```

## Steps to run the project:

- **Extract the project files** : If you downloaded the project as a zip, unzip it to a folder and open in any IDE.
- **Install dependencies** : Run the following command to install all Flutter dependencies:
```bash
flutter pub get
```
- **Run the build runner** : The project uses JSON serialization. Run the build runner to generate the necessary model files:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```
- **Run the app** : Start the app on your local device or emulator:
```bash
flutter run
```