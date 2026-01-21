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
    var gameOverPanel : GameOverNode!
    var selectedSquare : SquareNode?
    var selectedPiece : PieceNode?
    var availableMoves : [(Int, Int)]?
    var initialposition: CGPoint?
    var turnColor : PieceColor = .white
    
    var topBackgroundPart : SKSpriteNode!
    var bottomBackgroundPart : SKSpriteNode!
    var whiteTimerLabel : SKLabelNode!
    var blackTimerLabel :  SKLabelNode!
    

        
    override func didMove(to view: SKView) {
        
        
        
        
        backgroundColor = SKColor(red: 226/255, green: 205/255, blue: 181/255, alpha: 1)
        let screenWidth = self.size.width
        let margin: CGFloat = 20.0
        let availableWidth = screenWidth - (margin * 2)
        let squareSize = availableWidth / 8
        
        self.chessGameManager.onColorUpdate = {[weak self] color in
            //self?.updateTurnVisuals(color: color)
            self?.turnColor = color
        }
        
        chessBoard = BoardNode(squareSize: squareSize)
        setupPosition()
        
        setupBackgroundZones()
        chessBoard.zRotation += .pi
        chessBoard.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        addChild(chessBoard)
        
        setupTimerLabels()
        setupObservers()
        
        
        }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self.chessBoard)
        let nodes = chessBoard.nodes(at:location)
        let touchedPiece = nodes.first(where: { $0 is PieceNode }) as? PieceNode
        let touchedSquare = nodes.first(where: { $0 is SquareNode }) as? SquareNode
        
        var moveResult: MoveResult?
        
        if let square = touchedSquare{
            
            if let piece = touchedPiece{
                
                
                if selectedSquare == nil {
                    if piece.pieceColor == turnColor{
                        selectedPiece = piece
                        selectedSquare = square
                        square.hihglight()
                        //highlightPossibleMoves(row: square.row, col: square.col)
                    }
                }
                else {
                    moveResult = chessGameManager.makeMove(fromCol: selectedSquare!.col,
                                                           fromRow: selectedSquare!.row,
                                                           toCol: square.col,
                                                           toRow: square.row)
                    if moveResult != nil {
                        let moveAction = SKAction.move(to: square.position, duration: 0.1)
                        selectedPiece?.run(moveAction)
                        piece.removeFromParent()
                        selectedPiece = nil
                        selectedSquare?.resetState()
                        selectedSquare = nil
                        
                        
                    }
                    else{
                        selectedPiece = nil
                        selectedSquare?.resetState()
                        selectedSquare = nil
                    }
                }
                
            }
            else{
                
                if selectedPiece != nil {
                    //move +no eat+ reset to initial state
                    
                    moveResult = chessGameManager.makeMove(fromCol: selectedSquare!.col,
                                                           fromRow: selectedSquare!.row,
                                                           toCol: square.col,
                                                           toRow: square.row)
                    if moveResult != nil {
                        let moveAction = SKAction.move(to: square.position, duration: 0.1)
                        selectedPiece?.run(moveAction)
                        selectedPiece = nil
                        selectedSquare?.resetState()
                        selectedSquare = nil
                        
                    }
                    else{
                        selectedPiece = nil
                        selectedSquare?.resetState()
                        selectedSquare = nil
                    }
                    
                }
                
            }
            
        }
        else{
            //reset to nothing selected
            selectedPiece = nil
            selectedSquare?.resetState()
            selectedSquare = nil
        }
        
    }
    
        
       
    /*
    private func highlightPossibleMoves(row : Int, col : Int){
        
        self.availableMoves = chessGameManager.getPieceMoves(row: row, col: col)
        guard let moves = availableMoves else { return }
        for move in moves {
            chessBoard.square(at: (col: move.0, row: move.1))?.showMoveIndicator()
        }
        
    }
    
    private func removeHighlightPossibleMoves () {
        guard let moves = self.availableMoves else { return }
        for move in moves {
            chessBoard.square(at: (col: move.0, row: move.1))?.removeMoveInidcator()
        }
        self.availableMoves = nil
    }
     */
        
    private func setupPosition (){
        let piecesInfos = chessGameManager.getPiecesInfo()
        for pieceInfo in piecesInfos{
            chessBoard.spawnPiece(type: pieceInfo.type, pieceColor:  pieceInfo.color, at: (col: pieceInfo.col, row: pieceInfo.row))
        }
    }
    
    
    private func setupBackgroundZones () {
        let size = self.size
        let halfHeight = size.height / 2
        
        topBackgroundPart = SKSpriteNode(color: .darkGray, size: CGSize(width: size.width, height: halfHeight))
            
        topBackgroundPart.position = CGPoint(x: size.width * 0.5, y: size.height * 0.75)
            topBackgroundPart.zPosition = -10 // Place behind the board (assuming board is 0 or higher)
            addChild(topBackgroundPart)
            
        
        bottomBackgroundPart = SKSpriteNode(color: .white, size: CGSize(width: size.width, height: halfHeight))
        bottomBackgroundPart.position = CGPoint(x: size.width * 0.5, y: size.height * 0.25)
            bottomBackgroundPart.zPosition = -10
            addChild(bottomBackgroundPart)
    }
    
    func updateTurnVisuals(color : PieceColor) {
        // Define how an "Active" and "Inactive" zone should look
        let activeAlpha: CGFloat = 0.8
        let inactiveAlpha: CGFloat = 0.2
        
        // Optional: Change color tint if desired
        let activeColor: UIColor = .systemBlue // Or keep original
        let inactiveColor: UIColor = .gray
        
        if color == PieceColor.white {
            // Highlight Bottom (White), Deactivate Top (Black)
            
            // 1. Animate the change for a smooth transition
            bottomBackgroundPart.run(.fadeAlpha(to: activeAlpha, duration: 0.3))
            topBackgroundPart.run(.fadeAlpha(to: inactiveAlpha, duration: 0.3))
            
            // Optional: If you want to change colors too
            bottomBackgroundPart.color = activeColor
            topBackgroundPart.color = inactiveColor
            
        } else {
            // Highlight Top (Black), Deactivate Bottom (White)
            
            topBackgroundPart.run(.fadeAlpha(to: activeAlpha, duration: 0.3))
            bottomBackgroundPart.run(.fadeAlpha(to: inactiveAlpha, duration: 0.3))
            
            // Optional: Color change
            topBackgroundPart.color = activeColor
            bottomBackgroundPart.color = inactiveColor
        }
    }
    
    func setupTimerLabels (){
        
        whiteTimerLabel = SKLabelNode(fontNamed: "Courier-Bold")
        whiteTimerLabel.text = formatTime(chessGameManager.whiteTime)
        whiteTimerLabel.fontSize = 24
        whiteTimerLabel.fontColor = .black
        bottomBackgroundPart.addChild(whiteTimerLabel)
        
        blackTimerLabel = SKLabelNode(fontNamed: "Courier-Bold")
        blackTimerLabel.text = formatTime(chessGameManager.whiteTime)
        blackTimerLabel.fontSize = 24
        blackTimerLabel.fontColor = .white
        blackTimerLabel.zRotation = .pi
        topBackgroundPart.addChild(blackTimerLabel)
    }
    
    func setupObservers (){
        chessGameManager.onTimeUpdate = { [weak self] whiteTime, blackTime in
            DispatchQueue.main.async {
                            self?.whiteTimerLabel.text = self?.formatTime(whiteTime)
                            self?.blackTimerLabel.text = self?.formatTime(blackTime)
                        }
        }
        
        chessGameManager.onGameOver = { [weak self] result in
            guard let self = self else {return}
            let panel = GameOverNode(sceneSize: self.size,
                                     title: "Game Over",
                                     message: result)
            panel.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
            self.addChild(panel)

            
        }
    }
    
    func formatTime (_ totalSeconds : TimeInterval) -> String {
        let seconds = Int(totalSeconds) % 60
        let minutes = Int(totalSeconds) / 60
        
        return String(format: "%02d:%02d", minutes, seconds)
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

