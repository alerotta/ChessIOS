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
    
    var chessBoard : BoardNode!
    
    override func didMove(to view: SKView) {
        
        backgroundColor = SKColor(red: 226/255, green: 205/255, blue: 181/255, alpha: 1)
        let screenWidth = self.size.width
        let margin: CGFloat = 20.0
        let availableWidth = screenWidth - (margin * 2)
        let squareSize = availableWidth / 8
                
        // 2. Create the board
        chessBoard = BoardNode(squareSize: squareSize)
                
        // 3. Center it
        chessBoard.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
                
        // 4. Add to scene
        addChild(chessBoard)
            
        
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

