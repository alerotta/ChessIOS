//
//  GameScene.swift
//  Chess
//
//  Created by Alessandro Rotta on 08/01/26.
//

import SpriteKit
import SwiftUI
import UIKit
import GameplayKit

protocol GameSceneDelegate: AnyObject {
    func pauseGame()
    func goToMenu()
}


class GameScene: SKScene {
    
    weak var gameDelegate : GameSceneDelegate?
    
    let buttonContainerWhite = SKNode ()
    let buttonContainerBlack = SKNode ()
    let chessGameManager : ChessGameManager
    var chessBoard : BoardNode!
    var gameOverPanel : GameOverNode!
    var selectedSquare : SquareNode?
    var selectedPiece : PieceNode?
    var availableMoves : [(Int, Int)]?
    var initialposition: CGPoint?
    var turnColor : PieceColor = .white
    var isGameActive : Bool = true
    
    var topBackgroundPart : SKShapeNode!
    var bottomBackgroundPart : SKShapeNode!
    var whiteTimerLabel : SKLabelNode!
    var blackTimerLabel :  SKLabelNode!
    
    var isDragging : Bool = false
    var matchDuration : TimeInterval
    
    init(size: CGSize, matchDuration: TimeInterval) {
        

        self.matchDuration = matchDuration
        self.chessGameManager = ChessGameManager(matchDuration: matchDuration)
            
        
        self.chessGameManager.whiteTime = matchDuration
        self.chessGameManager.blackTime = matchDuration
            
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
        
        setupButtons (verticalOffset: squareSize*5 , horizontalOffset : availableWidth/2)
        setupObservers()
        
        
        }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else { return }
        let location = touch.location(in: self.chessBoard)
        let nodes = chessBoard.nodes(at:location)
        let touchedPiece = nodes.first(where: { $0 is PieceNode }) as? PieceNode
        let touchedSquare = nodes.first(where: { $0 is SquareNode }) as? SquareNode
        isDragging = false
        
        
            
        // *** the following part deals with touches over the board ***
        
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
                    guard let startingsq = selectedSquare else {return}
                    guard let movingPiece = selectedPiece else {return}
                    
                    move(movingPiece: movingPiece, startingSquare: startingsq, finalSquare: square, moveBackAction: nil)
                }
                
            }
            else{
                if selectedPiece != nil {
                    guard let startingsq = selectedSquare else {return}
                    guard let movingPiece = selectedPiece else {return}
                    move(movingPiece: movingPiece, startingSquare: startingsq, finalSquare: square, moveBackAction: nil)

                }
                
            }
            
        }
        else{
            resetSelection()
        }
        
        // *** board touch logic end here. ***
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
        let moveBackAction = SKAction.move(to: startingSquare.position, duration: 0.1)
        if !isDragging {return}
        
        let location = touch.location(in: self.chessBoard)
        let nodes = chessBoard.nodes(at:location)
        if let finalSquare = nodes.first(where: { $0 is SquareNode }) as? SquareNode {
            
            move(movingPiece: movingPiece, startingSquare: startingSquare, finalSquare: finalSquare, moveBackAction: moveBackAction)
            
        }
        else{
            movingPiece.run(moveBackAction)
            resetSelection()
            
        }
    }
     
    
    private func move (movingPiece: PieceNode ,startingSquare : SquareNode , finalSquare: SquareNode, moveBackAction : SKAction?) {
        
        if let moveResult = chessGameManager.makeMove(fromCol: startingSquare.col,
                                                      fromRow: startingSquare.row,
                                                      toCol: finalSquare.col,
                                                      toRow: finalSquare.row){
            let moveAction = SKAction.move(to: finalSquare.position, duration: 0.1)
            movingPiece.run(moveAction)
            
            // check for captured pieces
            if let capturedPiece = moveResult.capturedSquare {
                guard let squareCaptured = chessBoard.square(at: (col: capturedPiece.x, row: capturedPiece.y)) else {return}
                let nodes = chessBoard.nodes(at:squareCaptured.position)
                let pieceToEat = nodes.compactMap { $0 as? PieceNode }.first(where: { $0.pieceColor == turnColor })
                pieceToEat?.removeFromParent()
                resetSelection()
            }
            //check for castling
            if let rookPositions = moveResult.isCastling{
                guard let startRookSquare = chessBoard.square(at: (col: rookPositions[0].x, row: rookPositions[0].y)) else {return}
                guard let finalRookSquare = chessBoard.square(at: (col: rookPositions[1].x, row: rookPositions[1].y)) else {return}
                let nodes = chessBoard.nodes(at:startRookSquare.position)
                let rookPiece = nodes.first(where: { $0 is PieceNode }) as? PieceNode
                let moveRookAction = SKAction.move(to: finalRookSquare.position, duration: 0.1)
                rookPiece?.run(moveRookAction)
                resetSelection()
            }
            //check for enpassant
            if let capturedEnPassantPiece = moveResult.isEnPassant{
                guard let squareCaptured = chessBoard.square(at: (col: capturedEnPassantPiece.x, row: capturedEnPassantPiece.y)) else {return}
                let nodes = chessBoard.nodes(at:squareCaptured.position)
                let pawnPiece = nodes.first(where: { $0 is PieceNode }) as? PieceNode
                pawnPiece?.removeFromParent()
                resetSelection()
            }
        }
        else{
            resetSelection()
            if let action = moveBackAction {movingPiece.run(action)}
        }
    }
    
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
        let activeAlpha: CGFloat = 0.7
        let inactiveAlpha: CGFloat = 0.2

        
        if color == PieceColor.white {
            bottomBackgroundPart.run(.fadeAlpha(to: activeAlpha, duration: 0.3))
            topBackgroundPart.run(.fadeAlpha(to: inactiveAlpha, duration: 0.3))
            
        } else {
            topBackgroundPart.run(.fadeAlpha(to: activeAlpha, duration: 0.3))
            bottomBackgroundPart.run(.fadeAlpha(to: inactiveAlpha, duration: 0.3))
            
        }
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
            
            panel.onRestart = {[weak self] in
                self?.restartGame()
            }
            
            panel.onMenu = { [weak self] in
                self?.goToMenu()
            }
            panel.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
            self.addChild(panel)
            

            
        }
    }
    
    func formatTime (_ totalSeconds : TimeInterval) -> String {
        let seconds = Int(totalSeconds) % 60
        let minutes = Int(totalSeconds) / 60
        
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func createTimerLabel (isWhite: Bool , position : CGPoint) -> SKLabelNode {
        
        let timeLabel = SKLabelNode(fontNamed: "Impact")
        timeLabel.text = formatTime(chessGameManager.whiteTime)
        timeLabel.fontSize = 50
        timeLabel.position = CGPoint(x : position.x + (1.2 * timeLabel.fontSize), y: position.y)
        //timeLabel.position = position
        timeLabel.verticalAlignmentMode = .center
        
        
        if isWhite{
            timeLabel.fontColor = .black
        }
        else{
            timeLabel.fontColor = .white
            timeLabel.zRotation = .pi
        }
        return timeLabel
        
    }
    
    
    func setupButtons (verticalOffset : CGFloat , horizontalOffset : CGFloat) {
        
        addChild(buttonContainerWhite)
        addChild(buttonContainerBlack)
        
        buttonContainerWhite.position = CGPoint(x: frame.midX , y: frame.midY - verticalOffset)
        buttonContainerBlack.position = CGPoint(x: frame.midX , y: frame.midY + verticalOffset)
        
        let btnSize = CGSize(width: 50, height: 50)
        
    
        let buttonPause = GameButtonNode(size: btnSize,
                                         position:  CGPoint(x: horizontalOffset, y: 0 ),
                                         iconName: "pause.fill",
                                         isBlack: false,
                                         action: togglepause)
        
        
        let buttonResign = GameButtonNode(size: btnSize,
                                          position:  CGPoint(x: horizontalOffset + -70, y: 0  ),
                                          iconName: "flag",
                                          isBlack: false,
                                          action: {self.resign(str: "Black")})
        
        let buttonPauseB = GameButtonNode(size: btnSize,
                                          position:  CGPoint(x: horizontalOffset, y: 0 ),
                                          iconName: "pause.fill",
                                          isBlack: true,
                                          action: togglepause)
        
        
        let buttonResignB = GameButtonNode(size: btnSize,
                                           position:  CGPoint(x: horizontalOffset + -70, y: 0  ),
                                           iconName: "flag.fill",
                                           isBlack: true,
                                           action: {self.resign(str: "White")})
         
        
        whiteTimerLabel = createTimerLabel(isWhite: true, position: CGPoint(x:  -horizontalOffset , y: 0 ))
        blackTimerLabel = createTimerLabel(isWhite: false, position: CGPoint(x:  -horizontalOffset , y: 0 ))
        
        
        buttonContainerWhite.addChild(buttonPause)
        buttonContainerWhite.addChild(buttonResign)
        buttonContainerWhite.addChild(whiteTimerLabel)

        buttonContainerBlack.addChild(buttonPauseB)
        buttonContainerBlack.addChild(buttonResignB)
        buttonContainerBlack.addChild(blackTimerLabel)
        
    }

    
    func togglepause (){
        if isGameActive{
            chessGameManager.stopTimer()
            isGameActive = false
            self.isUserInteractionEnabled = false
            gameDelegate?.pauseGame()
        }

    }
    
    func resume () {
        if !isGameActive{
            chessGameManager.startTimer()
            isGameActive = true
            self.isUserInteractionEnabled = true
            self.view?.isPaused = false
        }
    }
    
    func resign(str : String) {
        chessGameManager.stopTimer()
        chessGameManager.onGameOver?(str + " won by resignation")
        
    }
    
    func restartGame () {
        let newScene = GameScene(size: self.size, matchDuration: matchDuration)
            newScene.scaleMode = self.scaleMode
            newScene.gameDelegate = self.gameDelegate
            
            // 2. Create a transition (Crossfade looks nice)
            let transition = SKTransition.crossFade(withDuration: 0.5)
            
            // 3. Present the new scene
            self.view?.presentScene(newScene, transition: transition)
    }
    
    func goToMenu (){
        gameDelegate?.goToMenu()
    }
    
}

struct GameScene_Preview: PreviewProvider {
    static var previews: some View {
        // Wrap in a GeometryReader to get the dynamic container size
        GeometryReader { proxy in
            SpriteView(
                // Use the size of the preview container, not a hardcoded number!
                scene: GameScene(size: proxy.size, matchDuration: 300)
            )
            .ignoresSafeArea()
        }
        .previewDisplayName("Dynamic Preview")
        
        // Optional: Add specific devices to check specific aspect ratios
        SpriteView(scene: GameScene(size: CGSize(width: 430, height: 932), matchDuration: 300))
            .previewDisplayName("iPhone 15 Pro Max")
            .ignoresSafeArea()
    }
}
