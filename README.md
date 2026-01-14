# [CHESSIOS] ♟️

![Swift](https://img.shields.io/badge/Swift-5.0+-orange.svg)
![Platform](https://img.shields.io/badge/Platform-iOS-lightgrey.svg)
![License](https://img.shields.io/badge/License-MIT-blue.svg)

## 📖 Overview

**[Project Name]** is an iOS application designed to simulate a fully functional chess game.

The primary objective of this repository is to serve as an educational exploration of **Swift** and the **SpriteKit** framework. While the game is fully playable, the codebase emphasizes learning game loop mechanics, node management, and 2D rendering on iOS.

## 🚀 Technology Stack

* **Language:** Swift
* **Game Engine:** SpriteKit
* **UI/UX:** UIKit & SpriteKit
* **Logic Dependency (Current):** [ChessKit](https://github.com/topics/chesskit)

## 🧩 Architecture & Game Logic

### Current Implementation
At this stage, the project focuses heavily on the **visual and interactive** aspects of the game.
* **Rendering:** SpriteKit is used to render the board, pieces, and animations.
* **Rules:** The application currently relies on the external `ChessKit` library to validate moves, check for checkmate/stalemate, and maintain the board state.

### Future Goals
The roadmap includes a significant refactor to remove the dependency on `ChessKit`. The ultimate goal is to write a custom chess engine and logic layer directly within this project to deepen understanding of algorithms and data structures in Swift.

## ✨ Features

* **Classic Chess Gameplay:** Full 8x8 board support.
* **SpriteKit Rendering:** Smooth animations for piece movement and capturing.
* **Move Validation:** Legal move highlighting (powered by ChessKit).
* **Game States:** Detection of check, checkmate, and stalemate.

## 🛠️ Installation & Setup

To run this project locally, follow these steps:

1.  **Clone the repository:**
    ```bash
    git clone [https://github.com/](https://github.com/)[your-username]/[project-name].git
    ```
2.  **Navigate to the directory:**
    ```bash
    cd [project-name]
    ```
3.  **Open the project:**
    Open the `.xcodeproj` file in Xcode.
4.  **Resolve Dependencies:**
    If using Swift Package Manager, wait for Xcode to fetch `ChessKit`.
5.  **Build and Run:**
    Select your target simulator or device and hit **Run (Cmd+R)**.

## 🗺️ Roadmap

- [x] Initial SpriteKit board setup.
- [x] Integrate ChessKit for move validation.
- [ ] Add sound effects for moves and captures.
- [ ] Implement a main menu and settings screen.
- [ ] **Major Refactor:** Replace ChessKit with custom native logic.
- [ ] Add simple AI opponent.

## 🤝 Contributing

Contributions are welcome! If you have suggestions for optimizing the SpriteKit nodes or tips for writing a custom chess engine, feel free to open a pull request.

## 📄 License

This project is open source and available under the [MIT License](LICENSE).
