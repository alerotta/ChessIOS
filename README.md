# [Chess Sié] ♟️

![Swift](https://img.shields.io/badge/Swift-5.0+-orange.svg)
![Platform](https://img.shields.io/badge/Platform-iOS-lightgrey.svg)
![License](https://img.shields.io/badge/License-MIT-blue.svg)

## 📖 Overview

**[Chess Sié]** is an iOS application designed to simulate a fully functional chess game.

The primary objective of this repository is to serve as an educational exploration of **Swift** and the **SpriteKit** framework.

## 🚀 Technology Stack

* **Language:** Swift
* **Game Engine:** SwiftChess
* **UI/UX:** SpriteKit

## 🧩 Architecture & Game Logic

### Current Implementation
At this stage, the project focuses heavily on the **visual and interactive** aspects of the game.
* **Rendering:** SpriteKit is used to render the board, pieces, and animations.
* **Rules:** The application currently relies on the external `SwiftChess` library to validate moves, check for checkmate/stalemate, and maintain the board state.

### Future Goals
The roadmap includes a significant refactor to remove the dependency on `SwiftChess`. The ultimate goal is to write a custom chess engine and logic layer directly within this project to deepen understanding of algorithms and data structures in Swift.


## 📄 License

This project is open source and available under the [MIT License](LICENSE).
