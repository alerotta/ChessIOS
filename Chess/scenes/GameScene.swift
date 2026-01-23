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
    
    var chessGameManager : ChessGameManager
    var chessBoard : BoardNode!
    var gameOverPanel : GameOverNode!
    var selectedSquare : SquareNode?
    var selectedPiece : PieceNode?
    var availableMoves : [(Int, Int)]?
    var initialposition: CGPoint?
    var turnColor : PieceColor = .white
    
    var topBackgroundPart : SKShapeNode!
    var bottomBackgroundPart : SKShapeNode!
    var whiteTimerLabel : SKLabelNode!
    var blackTimerLabel :  SKLabelNode!
    
    var isDragging : Bool = false
    
    init(size: CGSize, matchDuration: TimeInterval) {
            // Initialize the manager
            self.chessGameManager = ChessGameManager(matchDuration: matchDuration)
            
            // Pass the value to the manager immediately
            self.chessGameManager.whiteTime = matchDuration
            self.chessGameManager.blackTime = matchDuration
            
            // Call the superclass init
            super.init(size: size)
        }
    
    required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    

        
    override func didMove(to view: SKView) {
        
        
        
        
        backgroundColor = SKColor(red: 226/255, green: 205/255, blue: 181/255, alpha: 1)
        let screenWidth = self.size.width
        let margin: CGFloat = 20.0
        let availableWidth = screenWidth - (margin * 2)
        let squareSize = availableWidth / 8
        
        self.chessGameManager.onColorUpdate = {[weak self] color in
            self?.updateTurnVisuals(color: color)
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
        isDragging = false
        
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
                        resetSelection()
                        
                        
                    }
                    else{
                        resetSelection()
                    }
                }
                
            }
            else{
                
                if selectedPiece != nil {
                    //move +no eat+ reset to initial state
                    
                    
                    if let moveResult = chessGameManager.makeMove(fromCol: selectedSquare!.col,
                                                           fromRow: selectedSquare!.row,
                                                           toCol: square.col,
                                                        toRow: square.row){
                        let moveAction = SKAction.move(to: square.position, duration: 0.1)
                        selectedPiece?.run(moveAction)
                        
                        if let rookPositions =  moveResult.isCastling{
                            let startingRookPosition = rookPositions[0]
                            let finalRookPosition = rookPositions[1]
                            guard let startingSquare = chessBoard.square(at: (col: startingRookPosition.x, row: startingRookPosition.y)) else {return}
                            guard let finalSquare = chessBoard.square(at: (col: finalRookPosition.x, row: finalRookPosition.y)) else {return}
                            let nodes = chessBoard.nodes(at:startingSquare.position)
                            let rookPiece = nodes.first(where: { $0 is PieceNode }) as? PieceNode
                            
                            let moveRookAction = SKAction.move(to: finalSquare.position, duration: 0.1)
                            rookPiece?.run(moveRookAction)
                        }
                        if let enPassantCapturedPawn = moveResult.isEnPassant{
                            guard let squareToCapture = chessBoard.square(at: (col: enPassantCapturedPawn.x, row: enPassantCapturedPawn.y)) else {return}
                            let nodes = chessBoard.nodes(at:squareToCapture.position)
                            let pawnPiece = nodes.first(where: { $0 is PieceNode }) as? PieceNode
                            print("here")
                            pawnPiece?.removeFromParent()
                        }
                        resetSelection()
                        
                        
                    }
                    else{
                        resetSelection()
                    }
                    
                }
                
            }
            
        }
        else{
            resetSelection()
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self.chessBoard)
        isDragging = true
        selectedPiece?.position = location
        selectedPiece?.zPosition = 2
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else { return }
        guard let startingSquare = selectedSquare else {return}
        guard let movingPiece = selectedPiece else {return}
        if !isDragging {return}
        
        let location = touch.location(in: self.chessBoard)
        let nodes = chessBoard.nodes(at:location)
        let pieceToEat = nodes.compactMap { $0 as? PieceNode }
                            .first(where: { $0.pieceColor != turnColor })
        
        if let finalSquare = nodes.first(where: { $0 is SquareNode }) as? SquareNode {
            
            if let moveResult = chessGameManager.makeMove(fromCol: startingSquare.col,
                                                          fromRow: startingSquare.row,
                                                          toCol: finalSquare.col,
                                                          toRow: finalSquare.row){
                
                let moveAction = SKAction.move(to: finalSquare.position, duration: 0.1)
                movingPiece.run(moveAction)
                
                pieceToEat?.removeFromParent()
                
                if let rookPositions =  moveResult.isCastling{
                    let startingRookPosition = rookPositions[0]
                    let finalRookPosition = rookPositions[1]
                    guard let startingRookSquare = chessBoard.square(at: (col: startingRookPosition.x, row: startingRookPosition.y)) else {return}
                    guard let finalRookSquare = chessBoard.square(at: (col: finalRookPosition.x, row: finalRookPosition.y)) else {return}
                    let nodes = chessBoard.nodes(at:startingRookSquare.position)
                    let rookPiece = nodes.first(where: { $0 is PieceNode }) as? PieceNode
                    
                    let moveRookAction = SKAction.move(to: finalRookSquare.position, duration: 0.1)
                    rookPiece?.run(moveRookAction)
                }
                if let enPassantCapturedPawn = moveResult.isEnPassant{
                    guard let squareToCapture = chessBoard.square(at: (col: enPassantCapturedPawn.x, row: enPassantCapturedPawn.y)) else {return}
                    let nodes = chessBoard.nodes(at:squareToCapture.position)
                    let pawnPiece = nodes.first(where: { $0 is PieceNode }) as? PieceNode
                    pawnPiece?.removeFromParent()
                }
                resetSelection()
                
            }
            else{
                let moveAction = SKAction.move(to: startingSquare.position, duration: 0.1)
                movingPiece.run(moveAction)
                resetSelection()
            }
            
        }
        else{
            let moveAction = SKAction.move(to: startingSquare.position, duration: 0.1)
            movingPiece.run(moveAction)
            resetSelection()
            
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
    
    private func resetSelection (){
        selectedPiece?.zPosition = 1
        selectedPiece = nil
        selectedSquare?.resetState()
        selectedSquare = nil
    }
        
    private func setupPosition (){
        let piecesInfos = chessGameManager.getPiecesInfo()
        for pieceInfo in piecesInfos{
            chessBoard.spawnPiece(type: pieceInfo.type, pieceColor:  pieceInfo.color, at: (col: pieceInfo.col, row: pieceInfo.row))
        }
    }
    
    
    private func setupBackgroundZones () {
        let size = self.size
        let halfHeight = size.height / 2
        
        topBackgroundPart = SKShapeNode(rectOf: CGSize(width: size.width, height: halfHeight))
        topBackgroundPart.zPosition = -10
        topBackgroundPart.fillColor = .darkGray
        topBackgroundPart.strokeColor = .lightGray
        topBackgroundPart.lineWidth = 2.0
        topBackgroundPart.alpha = 0.7
        topBackgroundPart.position =  CGPoint(x: size.width * 0.5, y: size.height * 0.75)
        addChild(topBackgroundPart)
        
        bottomBackgroundPart = SKShapeNode(rectOf: CGSize(width: size.width, height: halfHeight))
        bottomBackgroundPart.zPosition = -10
        bottomBackgroundPart.fillColor = .white
        bottomBackgroundPart.strokeColor = .lightGray
        bottomBackgroundPart.lineWidth = 2.0
        bottomBackgroundPart.alpha = 0.7
        bottomBackgroundPart.position =  CGPoint(x: size.width * 0.5, y: size.height * 0.25)
        addChild(bottomBackgroundPart)
        
        
        
    }
    
    
    
    func updateTurnVisuals(color : PieceColor) {
        // Define how an "Active" and "Inactive" zone should look
        let activeAlpha: CGFloat = 0.7
        let inactiveAlpha: CGFloat = 0.2

        
        if color == PieceColor.white {
            // Highlight Bottom (White), Deactivate Top (Black)
            
            // 1. Animate the change for a smooth transition
            bottomBackgroundPart.run(.fadeAlpha(to: activeAlpha, duration: 0.3))
            topBackgroundPart.run(.fadeAlpha(to: inactiveAlpha, duration: 0.3))
            
        } else {
            // Highlight Top (Black), Deactivate Bottom (White)
            
            topBackgroundPart.run(.fadeAlpha(to: activeAlpha, duration: 0.3))
            bottomBackgroundPart.run(.fadeAlpha(to: inactiveAlpha, duration: 0.3))
            
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
        let scene = GameScene(size: CGSize(width: 375, height: 812), matchDuration: 300)
                scene.scaleMode = .aspectFill
        
        return SpriteView(scene: scene)
                    .ignoresSafeArea()
                    .previewDisplayName("Game Scene Preview")
    }
}

