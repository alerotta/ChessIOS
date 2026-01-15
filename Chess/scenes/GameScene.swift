//
//  GameScene.swift
//  Chess
//
//  Created by Alessandro Rotta on 08/01/26.
//

import SpriteKit
import SwiftUI
import GameplayKit

class GameScene: SKScene {
    
    var chessGameManager : ChessGameManager = ChessGameManager()
    var chessBoard : BoardNode!
    var selectedPiece : PieceNode?
    var draggingPiece : PieceNode?
    var dragStartPosition: CGPoint?
    var hasDragged : Bool = false
    var initialposition: CGPoint?
    var availableMoves : [(Int, Int)] = []
    
    override func didMove(to view: SKView) {
        
        
        backgroundColor = SKColor(red: 226/255, green: 205/255, blue: 181/255, alpha: 1)
        let screenWidth = self.size.width
        let margin: CGFloat = 20.0
        let availableWidth = screenWidth - (margin * 2)
        let squareSize = availableWidth / 8

        let fen = chessGameManager.currentFEN
        
        chessBoard = BoardNode(squareSize: squareSize, fen: fen)
                
        // 3. Center it
        chessBoard.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
                
        // 4. Add to scene
        addChild(chessBoard)
    }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self.chessBoard)
        hasDragged = false
        let nodes = chessBoard.nodes(at:location)
        
        let touchedPiece = nodes.first(where: { $0 is PieceNode }) as? PieceNode
        let touchedSquare = nodes.first(where: { $0 is SquareNode }) as? SquareNode
        
        if let piece = touchedPiece{
            draggingPiece = piece
            dragStartPosition = piece.position
            piece.zPosition = 100
            piece.setScale(1.1)
        }
        
        
        if let square  = touchedSquare{
            self.availableMoves  = chessGameManager.getPieceMoves(row: square.row, col: square.col)
            for move in availableMoves {
                chessBoard.square(at: move )?.showMoveIndicator()
            }
        }
        
        
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, let piece = draggingPiece else { return }
        let location = touch.location(in: chessBoard)
        piece.position = location
        hasDragged = true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: chessBoard)
        
        if let piece = draggingPiece {
            piece.zPosition = 10 // Reset Z
            piece.setScale(1.0)  // Reset Scale
            
            if hasDragged {
               
                dropPiece(piece, at: location)
                selectedPiece = nil
            } else {
                
                piece.position = dragStartPosition ?? piece.position
                selectPiece(piece)
            }
            
            for move in availableMoves {
                chessBoard.square(at: move )?.removeMoveInidcator()
            }
            draggingPiece = nil
            dragStartPosition = nil
            return
        }
        
        if let currentSelection = selectedPiece, draggingPiece == nil {
            if let (col, row) = chessBoard.gridPosition(at: location),
               let targetSquare = chessBoard.square(at: (col: col, row: row)) {
                
                // Move the selected piece to this tapped square
                movePiece(currentSelection, to: targetSquare)
                
                // Deselect after moving
                selectedPiece = nil
            }
        }
    }
        
        // HELPER 1: Handle dropping a dragged piece
        func dropPiece(_ piece: PieceNode, at point: CGPoint) {
            if let (col, row) = chessBoard.gridPosition(at: point),
               let targetSquare = chessBoard.square(at: (col: col, row: row)) {
                
                // Valid Drop: Snap to square
                // NOTE: In the future, check isValidMove() here
                piece.run(SKAction.move(to: targetSquare.position, duration: 0.1))
                
            } else {
                // Invalid Drop (off board): Return to start
                if let start = dragStartPosition {
                    piece.run(SKAction.move(to: start, duration: 0.2))
                }
            }
        }
        
        // HELPER 2: Handle Tap-Tap moving
        func movePiece(_ piece: PieceNode, to targetSquare: SquareNode) {
            // Animate the move
            let action = SKAction.move(to: targetSquare.position, duration: 0.2)
            action.timingMode = .easeInEaseOut
            piece.run(action)
        }
        
        // HELPER 3: Handle Selection logic
    func selectPiece(_ piece: PieceNode) {
            // If we tap the SAME piece twice, deselect it
            if piece == selectedPiece {
                selectedPiece = nil
            } else {
                // Otherwise, select the new piece
                selectedPiece = piece
            }
        }
    
    
}

struct GameScene_Preview : PreviewProvider {
    static var previews : some View {
        let scene = GameScene(size: CGSize(width: 375, height: 812))
                scene.scaleMode = .aspectFill
        
        return SpriteView(scene: scene)
                    .ignoresSafeArea()
                    .previewDisplayName("Game Scene Preview")
    }
}

