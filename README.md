# Important! Grave! Важно!

-   Workers of the world, unite!
-   Proletoj el ĉiuj landoj, unuiĝu!
-   Пролетарии всех стран, соединяйтесь!

# Universo Platformo C#

[![Version](https://img.shields.io/badge/version-0.1.0--alpha-blue)](https://github.com/teknokomo/universo-platformo-csharp)
[![License: Omsk Open License](https://img.shields.io/badge/license-Omsk%20Open%20License-green)](LICENSE.md)

## Basic Information

Implementation of Universo Platformo / Universo MMOOMM / Universo Kiberplano built on Blazor WebAssembly, ASP.NET, and related C# stack. This project is a C# implementation of [Universo Platformo](https://github.com/teknokomo/universo-platformo-react) with multi-user functionality through Supabase integration and support for UPDL (Universal Platform Description Language) for creating 3D/AR/VR applications.

**This repository represents the C# implementation of Universo Platformo / Universo MMOOMM, contributing to global teknokomization and humanity's salvation from final enslavement and complete destruction through special mass multi-user virtual worlds like Universo MMOOMM, and a platform for their creation - Universo Platformo, initially with gaming functionality, then with the addition of Cyberplan functionality.**

Universo Platformo C# serves as the foundation for implementing **Universo Kiberplano** - a global planning and implementation system that unifies plans, tasks, and resources while controlling robots. This system aims to create a comprehensive framework for worldwide coordination of efforts, optimizing resource allocation, and enabling efficient automation through robotic systems, all within a unified digital environment.

More details about all this are written in "The Book of The Future" and various other materials of ours, most of which are still poorly structured and not in English, but right now work is underway to create new detailed documentation, which will be presented in many languages.

## Inspiration

Our wonderful project, which will help create a global teknokomization and save humanity from final enslavement and total destruction, is currently in pre-alpha stage. We are implementing a C# based version of Universo Platformo using Blazor WebAssembly for the frontend and ASP.NET for the backend, which will serve as a foundation for creating interactive 3D/AR/VR experiences.

This implementation focuses on creating a robust, type-safe platform using C# and .NET technologies to enable the creation of cross-platform 3D applications through a visual node-based interface.

## Where Am I and What Should I Do?

The near future, Omsk is the capital of the world, in the Olympus-1 tower, scientists explain to you that it is possible to connect your consciousness to a robot in another part of the Universe, in a parallel reality, controlled by robots we call Robocubans, through the recently discovered Great Ring system.

In Universo Platformo C#, you are at the control panel of this revolutionary technology. Through the visual node editor built with Blazor, you can create interactive 3D scenes, AR experiences, and VR worlds that bridge our reality with parallel universes.

Your mission is to help build and expand this platform, creating new exporters, enhancing the node system, and contributing to the publication mechanism that will allow these experiences to be shared across the multiverse.

## Contact Information

For questions or collaboration, please contact:

-   VK: [https://vk.com/vladimirlevadnij](https://vk.com/vladimirlevadnij)
-   Telegram: [https://t.me/Vladimir_Levadnij](https://t.me/Vladimir_Levadnij)
-   Email: [universo.pro@yandex.com](mailto:universo.pro@yandex.com)

Our website: [https://universo.pro](https://universo.pro)

## Overview

Universo Platformo C# is a project that provides:

-   **Multi-user functionality** through Supabase integration
-   **Universal node system (UPDL)** for describing scenes and logic
-   **Multi-platform export** capabilities for generating AR/VR/3D applications
-   **Publishing mechanism** for deploying generated applications
-   **Type-safe architecture** using C# and .NET technologies
-   **Modern web UI** using Blazor WebAssembly

The project aims to create a unified platform for developing interactive 3D applications that can be exported to various technologies including AR.js, PlayCanvas, Babylon.js, Three.js, and A-Frame.

## ⚠️ Architecture Warning: Mandatory Modular Structure

**CRITICAL**: This project follows a **NON-NEGOTIABLE** modular package architecture:

-   ✅ **ALL feature functionality MUST be in `src/packages/` directory**
-   ✅ Each feature MUST be split into `-frt` (frontend) and `-srv` (backend) packages
-   ✅ Each package MUST have a `base/` subdirectory for the primary implementation
-   ❌ **PROHIBITED**: Feature functionality outside `src/packages/` directory
-   ❌ **PROHIBITED**: Monolithic implementations mixing frontend and backend

**Rationale**: Packages will gradually migrate to separate repositories as the project matures. This architecture is NOT optional - it's fundamental to the project's long-term evolution.

See [Constitution Principle I](.specify/memory/constitution.md) for complete details.

## Current Status

**Current Version**: 0.1.0-alpha (November 2025)

**Primary Focus**:

-   Project structure setup
-   Monorepo architecture implementation using .NET solutions
-   Basic authentication and authorization with Supabase
-   MudBlazor UI component library integration
-   Package organization following the React version pattern

## Tech Stack

> **📖 Detailed Documentation**: For a comprehensive guide to the technology stack, build system, and authorization, see [TECH_STACK.md](TECH_STACK.md)

-   .NET 9.0 or later
-   C# 13.0
-   Blazor WebAssembly (Frontend)
-   ASP.NET Core (Backend)
-   Supabase (Multi-user functionality and database)
-   MudBlazor (Material Design UI components)
-   Entity Framework Core (ORM)

## Project Structure

**⚠️ MANDATORY ARCHITECTURE**: All features MUST be in `src/packages/`. See [Architecture Warning](#️-architecture-warning-mandatory-modular-structure) above.

```
universo-platformo-csharp/
├── src/
│   ├── packages/                  # ⚠️ ALL feature packages MUST go here
│   │   ├── analytics-frt/         # Analytics frontend
│   │   │   └── base/              # Base implementation
│   │   ├── analytics-srv/         # Analytics backend
│   │   │   └── base/              # Base implementation
│   │   ├── auth-frt/              # Authentication frontend
│   │   │   └── base/              # Base implementation
│   │   ├── auth-srv/              # Authentication backend
│   │   │   └── base/              # Base implementation
│   │   ├── clusters-frt/          # Clusters frontend
│   │   │   └── base/              # Base implementation
│   │   ├── clusters-srv/          # Clusters backend
│   │   │   └── base/              # Base implementation
│   │   ├── metaverses-frt/        # Metaverses frontend
│   │   │   └── base/              # Base implementation
│   │   ├── metaverses-srv/        # Metaverses backend
│   │   │   └── base/              # Base implementation
│   │   ├── spaces-frt/            # Spaces frontend
│   │   │   └── base/              # Base implementation
│   │   ├── spaces-srv/            # Spaces backend
│   │   │   └── base/              # Base implementation
│   │   ├── uniks-frt/             # Uniks frontend
│   │   │   └── base/              # Base implementation
│   │   ├── uniks-srv/             # Uniks backend
│   │   │   └── base/              # Base implementation
│   │   ├── updl/                  # UPDL node system
│   │   │   └── base/              # Base implementation
│   │   └── publish/               # Publication system
│   │       └── base/              # Base implementation
│   ├── shared/                    # ⚠️ ONLY for infrastructure libraries
│   │   ├── Universo.Types/        # Shared types
│   │   ├── Universo.Utils/        # Utility functions
│   │   ├── Universo.I18n/         # Internationalization
│   │   └── Universo.Common/       # Error handling, validation, caching
│   └── Universo.sln               # Main solution file
├── tests/                         # Test projects
├── docs/                          # Documentation (will be moved to separate repo)
└── tools/                         # Build and development tools
```

**What goes where:**
- **`packages/`** - ALL domain features (Authentication, Clusters, Metaverses, Templates, etc.)
- **`shared/`** - ONLY cross-cutting infrastructure (Types, Utils, I18n, Common infrastructure)
- **Root** - Solution files, documentation, configuration

This structure allows for:

-   **Modularity**: Each functional area is contained within its own package
-   **Type Safety**: Strong typing throughout the codebase using C#
-   **Easy Extension**: New packages can be added following the established pattern
-   **Clean Separation**: Clear boundaries between frontend and backend code
-   **Base Implementations**: Each package has a `base/` folder for future alternative implementations
-   **Repository Migration**: Packages can be moved to separate repos without refactoring

## Monorepo Management

Unlike the React version that uses PNPM, this C# implementation uses:

-   **.NET Solution files (.sln)** for organizing projects
-   **Directory.Build.props** for shared MSBuild properties
-   **Directory.Packages.props** for centralized package management
-   **NuGet** for package management
-   **MSBuild** for building the solution

This approach provides similar benefits to PNPM workspaces while staying within the .NET ecosystem.

## Features

### UPDL Node System

The Universal Platform Description Language (UPDL) provides a unified way to describe 3D scenes and interactions:

-   **Scene Nodes**: Define the environment and root container
-   **Object Nodes**: 3D models, primitives with materials and transformations
-   **Camera Nodes**: Different camera types with configurable properties
-   **Light Nodes**: Various light types with color and intensity controls
-   **Interaction Nodes**: Handle user input and events
-   **Animation Nodes**: Control object animations and behaviors

### Multi-Platform Export

The system can export to multiple platforms from a single UPDL description:

-   **AR.js / A-Frame**: Web-based augmented reality
-   **PlayCanvas**: PlayCanvas engine integration
-   **Babylon.js**: Advanced 3D rendering
-   **Three.js**: Popular 3D library for web
-   **A-Frame VR**: Virtual reality experiences

### Publication System

Easily publish and share your creations:

-   **URL Structure**: Clean URLs for accessing published projects
-   **Embedding**: Options for embedded or standalone viewing
-   **Versioning**: Support for project revisions

## Universo Platformo Functionality

Universo Platformo is a universal platform for developing metaverses, virtual reality, multiplayer games, and industrial applications. It provides tools for creating, editing, and managing projects in real-time, and supports integration with various technology stacks.

Key functional areas include:

-   **Metaverses**: Tools for creating virtual worlds with unique ecosystems
-   **Game Development**: Visual scripting, AI for NPCs, physics editors
-   **Networking**: Multiplayer support and real-time collaboration
-   **Asset Management**: 3D model import/export and asset optimization
-   **Industrial Integration**: CAD integration, digital twins, simulation tools
-   **Project Management**: Team collaboration and version control
-   **High-Level Abstraction**: Export/import between different game engines

## Universo MMOOMM Functionality

Universo MMOOMM is a massive multiplayer online game built on Universo Platformo. It's similar to EVE Online and Star Citizen but with additional functionality that helps people unite, create organizations, and implement Kiberplano (Cyberplan) functionality.

Key features include:

-   **Parallel Worlds**: Different worlds with unique economic systems
-   **Character Mechanics**: Character creation, development, and specialization
-   **Ship and Transport**: Ship management and customization
-   **Careers and Professions**: Military, trading, research, and manufacturing
-   **Economy and Trade**: Dynamic economy and production chains
-   **Social Mechanics**: Corporations, diplomacy, and politics
-   **Exploration**: Scanning, planetary exploration, and discoveries
-   **Base Building**: Construction of bases and territorial control
-   **Science and Technology**: Research and technology trees

## Cross-Platform Implementation

Universo Platformo is being developed on multiple technology stacks:

-   **C#**: This repository implements Universo Platformo on C#, Blazor, and ASP.NET
-   **React**: The original implementation ([Universo Platformo React](https://github.com/teknokomo/universo-platformo-react))
-   **Godot**: A parallel implementation using the Godot game engine
-   **PlayCanvas**: Another implementation using the PlayCanvas engine
-   **Quasar**: A version built with the Quasar framework

Each implementation shares the same core concepts and goals while leveraging the strengths of its respective technology stack.

## Getting Started

### Prerequisites

-   .NET 9.0 SDK or later
-   Visual Studio 2022, Visual Studio Code, or JetBrains Rider
-   Node.js (for tooling and some frontend build tasks)

### Installation

**NOTE**: This project is currently in early development stage. The following instructions will be updated as the project progresses.

1. Clone the repository

    ```bash
    git clone https://github.com/teknokomo/universo-platformo-csharp.git
    cd universo-platformo-csharp
    ```

2. Restore dependencies

    ```bash
    dotnet restore
    ```

3. Set up environment variables

    - Create `appsettings.Development.json` in backend projects
    - Add required Supabase configuration:
        ```json
        {
          "Supabase": {
            "Url": "your_supabase_url",
            "AnonKey": "your_supabase_anon_key",
            "JwtSecret": "your_supabase_jwt_secret"
          }
        }
        ```

4. Build the project

    ```bash
    dotnet build
    ```

5. Run the application

    ```bash
    dotnet run --project src/packages/main-srv/base
    ```

6. Access the application at [https://localhost:5001](https://localhost:5001)

### Development Mode

For development with hot-reloading:

```bash
dotnet watch --project src/packages/main-srv/base
```

## Roadmap

The development of Universo Platformo C# follows a phased approach:

### Phase 1: Foundation (Current)

-   Establishing the project structure and monorepo organization
-   Setting up basic authentication with Supabase
-   Implementing core package architecture
-   Creating the first feature packages (Clusters)
-   Setting up MudBlazor UI framework

### Phase 2: Core Features

-   Implementing the UPDL node system
-   Creating the first exporters for AR/VR technologies
-   Developing the publication system
-   Adding support for Metaverses, Spaces, and Uniks

### Phase 3: Integration

-   Connecting with robotic systems for Universo Kiberplano
-   Implementing resource management and planning tools
-   Creating digital twins for real-world environments
-   Developing comprehensive automation workflows

## Contributing

We welcome contributions to Universo Platformo C#! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

Please follow our coding standards:

-   Use C# naming conventions (PascalCase for classes, camelCase for private fields)
-   Write XML documentation comments for public APIs
-   Include unit tests for new functionality
-   Follow the established package structure

## License

This project is being implemented under the [Omsk Open License](https://universo.pro/ol) (Basic modification). Individual packages may have a different license, please check the license in each individual package.

The Omsk Open License is similar to the MIT license, but includes additional "Basic Provisions" aimed at creating a meaningful and secure public domain while protecting traditional values.

AI agents are actively used in the development of this project, which are trained on a variety of other projects and code of various free source projects. 

If you believe that some code in this repository violates your copyrights, please create an Issue describing this problem, specify which code violates your rights, show the original author's code and evidence that this code itself is not a copy of another code, describe your suggestions for resolving the problem (attribution, code replacement, etc.). 

In any case, thank you for your participation and contribution to the development of free source code, which directly or indirectly influenced the possibility of creating Universo Platformo C#!

## Differences from React Version

This C# implementation maintains the same conceptual architecture as the React version but adapts it to the .NET ecosystem:

-   **PNPM workspaces** → **.NET Solution with MSBuild**
-   **npm packages** → **NuGet packages and project references**
-   **TypeScript** → **C# with strong typing**
-   **React** → **Blazor WebAssembly**
-   **Express.js** → **ASP.NET Core**
-   **Passport.js** → **ASP.NET Core Identity with Supabase**
-   **Material-UI (MUI)** → **MudBlazor**
-   **React Router** → **Blazor Router**
-   **Redux/Zustand** → **Fluxor or Blazor state management**

## Architecture Principles

1. **Separation of Concerns**: Frontend and backend are separated into different packages
2. **Base Implementations**: Each package has a `base/` folder for core implementation, allowing future alternative implementations
3. **Type Safety**: Leveraging C# strong typing throughout the stack
4. **Modularity**: Each functional area is a separate package
5. **Testability**: Unit tests and integration tests for all major components
6. **Documentation**: Comprehensive XML documentation for all public APIs
7. **Internationalization**: Support for multiple languages from the start
