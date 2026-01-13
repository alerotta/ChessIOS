//
//  MenuScene.swift
//  Chess
//
//  Created by Alessandro Rotta on 13/01/26.
//
import SpriteKit
import SwiftUI




class MenuScene: SKScene {
    
    override func didMove(to view: SKView) {
        
        backgroundColor = SKColor(red: 226/255, green: 205/255, blue: 181/255, alpha: 1)
        
        let buttonSize = CGSize(width: 200, height: 60)
        let buttoncolor = SKColor(red: 170/255, green: 139/255, blue: 109/255, alpha: 1)
        let startButton = ButtonNode(size: buttonSize, text: "NEW GAME" , color: buttoncolor) { [weak self] in
            // 2. Define what happens when tapped
            print("Button Tapped: Starting Game...")
            self?.startGame()
        }
        startButton.position = CGPoint(x: frame.midX, y: frame.midY)
        startButton.zPosition = 10
        addChild(startButton)
    }
    
    
    func startGame (){
        
        let gameScene =  GameScene(size: self.size)
        gameScene.scaleMode = .aspectFill
        let transition = SKTransition.flipVertical(withDuration: 1.0)
        self.view?.presentScene(gameScene, transition: transition)
    }
}


struct MenuScene_Preview : PreviewProvider {
    static var previews : some View {
        let scene = MenuScene(size: CGSize(width: 375, height: 812))
                scene.scaleMode = .aspectFill
        
        return SpriteView(scene: scene)
                    .ignoresSafeArea()
                    .previewDisplayName("Menu Scene Preview")
    }
}
