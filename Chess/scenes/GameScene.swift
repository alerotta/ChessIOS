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
    var selectedSquare : SquareNode?
    var selectedPiece : PieceNode?
    var availableMoves : [(Int, Int)]?
    var initialposition: CGPoint?
    

        
    override func didMove(to view: SKView) {
        
        
        
        
        backgroundColor = SKColor(red: 226/255, green: 205/255, blue: 181/255, alpha: 1)
        let screenWidth = self.size.width
        let margin: CGFloat = 20.0
        let availableWidth = screenWidth - (margin * 2)
        let squareSize = availableWidth / 8
        
        self.chessGameManager.onColorUpdate = {[weak self] color in
            self?.updateColor(color: color)
        }
        
        
        
        chessBoard = BoardNode(squareSize: squareSize)
        setupPosition()
        chessBoard.zRotation += .pi
        chessBoard.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        addChild(chessBoard)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else { return }
        let location = touch.location(in: self.chessBoard)
        let nodes = chessBoard.nodes(at:location)
        
        
        let touchedPiece = nodes.first(where: { $0 is PieceNode }) as? PieceNode
        let touchedSquare = nodes.first(where: { $0 is SquareNode }) as? SquareNode
        
        if let square = touchedSquare{
            
            //full square touched
            if let piece = touchedPiece{
                
                // first time selection
                if selectedPiece == nil{
                    selectedPiece = piece
                    selectedSquare = square
                    selectedSquare?.hihglight()
                    highlightPossibleMoves(row: square.row, col: square.col)
                }
                //double tap the same -> deselect
                else if piece === selectedPiece{
                    selectedPiece = nil
                    selectedSquare?.resetState()
                    selectedSquare = nil
                    removeHighlightPossibleMoves(availableMoves: availableMoves)
                }
                else if piece.color == selectedPiece?.color {
                    selectedSquare?.resetState()
                    removeHighlightPossibleMoves(availableMoves: availableMoves)
                    selectedPiece = piece
                    selectedSquare = square
                    selectedSquare?.hihglight()
                    highlightPossibleMoves(row: square.row, col: square.col)

                }
                else if piece.color != selectedPiece?.color{
                    // check moves and move
                }
            }
            // empty square touched
            else{
                if selectedPiece != nil {
                    //check move and make it
                    
                    let moveAction = SKAction.move(to: square.position, duration: 0.1)
                    
                    chessGameManager.makeMove(fromCol: selectedSquare?.col,
                                              fromRow: selectedSquare?.row,
                                              toCol: square.col,
                                              toRow: square.row)
                    selectedPiece?.run(moveAction)
                    selectedPiece = nil
                    selectedSquare?.resetState()
                    selectedSquare=nil
                    removeHighlightPossibleMoves(availableMoves: availableMoves)
                }
                else {return}
            }
            
        }
        else{
            selectedSquare?.resetState()
            selectedPiece = nil
            selectedSquare = nil
        }
        
    }
    
    private func highlightPossibleMoves(row : Int, col : Int){
        
        availableMoves = chessGameManager.getPieceMoves(row: row, col: col)
        guard let moves = availableMoves else { return }
        for move in moves {
            chessBoard.square(at: (col: move.0, row: move.1))?.showMoveIndicator()
        }
        
    }
    
    private func removeHighlightPossibleMoves (availableMoves : [(Int,Int)]? ) {
        guard let moves = availableMoves else { return }
        for move in moves {
            chessBoard.square(at: (col: move.0, row: move.1))?.removeMoveInidcator()
            self.availableMoves = nil
        }
    }
        
    private func setupPosition (){
        let piecesInfos = chessGameManager.getPiecesInfo()
        for pieceInfo in piecesInfos{
            chessBoard.spawnPiece(type: pieceInfo.type, pieceColor:  pieceInfo.color, at: (col: pieceInfo.col, row: pieceInfo.row))
        }
    }
    
    private func updateColor (color : PieceColor ){
        print ("color is changed \(color)")
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

