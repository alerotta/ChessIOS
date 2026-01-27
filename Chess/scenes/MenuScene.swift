//
//  MenuScene.swift
//  Chess
//
//  Created by Alessandro Rotta on 13/01/26.
//
import SpriteKit
import SwiftUI


class MenuScene: SKScene {
    
    enum menuState {
        case main
        case timeSelect
    }
    
    let mainContainer = SKNode()
    let timeSelectContainer = SKNode()
    
    var currentMenuState : menuState = .main
    var selectedGameType : String?
    //var selectedTimeButton : SKShapeNode?
    
    override func didMove(to view: SKView) {
        
        backgroundColor = SKColor(red: 226/255, green: 205/255, blue: 181/255, alpha: 1)
        setupMainButtons()
        setupTimeButtons()
    }
    
    
    func handleMainMenuClick (node: MenuButtonNode){
        
        
        if node.text == "Local" {
            selectedGameType = "Offline"
            animateToTimeSelection()
            
        }
        else if node.text == "Back" {
            selectedGameType = nil
            animateToGameSelection()
        }
        else if node.text == "Start Game" {
            //add guard for selected game type
            
            for nd in timeSelectContainer.children{
                
                if let timeNode = nd as? MenuButtonToggleNode {
                    if timeNode.isToggle {
                        switch timeNode.text{
                        case "10:00" : startGame(600)
                        case "5:00" : startGame(300)
                        case "3:00" : startGame(180)
                        default : return
                        }
                    }
                }
            }
            return
        }
    }
    
    func handleTimeMenuClick (node : MenuButtonNode) {
        
        for nd in timeSelectContainer.children{
            
            if let timeNode = nd as? MenuButtonToggleNode {
                if timeNode !== node {timeNode.removeToggle()}
            }
            
        }
    }
    
    
    func startGame (_ matchDuration : TimeInterval){
        let gameScene = GameScene(size : self.size, matchDuration: matchDuration)
        gameScene.scaleMode = .aspectFill
        let transition = SKTransition.fade(withDuration: 0.2)
        view?.presentScene(gameScene, transition: transition)
        
    }
    
    
    
    func setupMainButtons (){
        addChild(mainContainer)
        mainContainer.position = CGPoint(x: frame.midX , y: frame.midY )
        

        let offlineBtn = MenuButtonNode (size: CGSize(width: 200, height: 50),
                                         position: CGPoint(x: 0, y: +35 ),
                                         text: "Local",
                                         action: handleMainMenuClick)
        let onlineBtn = MenuButtonNode (size: CGSize(width: 200, height: 50),
                                        position: CGPoint(x:0, y: -35),
                                        text: "Online",
                                        action: handleMainMenuClick)
        
        mainContainer.addChild(offlineBtn)
        mainContainer.addChild(onlineBtn)
        
    }
    
    
    func setupTimeButtons (){
        addChild(timeSelectContainer)
        
        let tenMinButton = MenuButtonToggleNode(size: CGSize(width: 200, height: 50),
                                                position: CGPoint(x: 0, y: +140 ),
                                                text: "10:00",
                                                toggleAction: handleTimeMenuClick)
        let fiveMinButton = MenuButtonToggleNode(size: CGSize(width: 200, height: 50),
                                                position: CGPoint(x: 0, y: 70 ),
                                                text: "5:00",
                                                toggleAction: handleTimeMenuClick)
        
        let threeMinButton = MenuButtonToggleNode(size: CGSize(width: 200, height: 50),
                                                  position: CGPoint(x: 0, y: -0 ),
                                                  text: "3:00",
                                                  toggleAction: handleTimeMenuClick)
        
        let startButton = MenuButtonNode (size: CGSize(width: 200, height: 50),
                                        position: CGPoint(x:0, y: -70),
                                        text: "Start Game",
                                        action: handleMainMenuClick)
        
        let backButton = MenuButtonNode (size: CGSize(width: 200, height: 50),
                                        position: CGPoint(x:0, y: -140),
                                        text: "Back",
                                        action: handleMainMenuClick)
        
        timeSelectContainer.position = CGPoint(x: frame.midX , y: frame.midY )
        timeSelectContainer.alpha = 0
        timeSelectContainer.addChild(tenMinButton)
        timeSelectContainer.addChild(fiveMinButton)
        timeSelectContainer.addChild(threeMinButton)
        timeSelectContainer.addChild(backButton)
        timeSelectContainer.addChild(startButton)
        
    }
    
    
    func animateToTimeSelection (){
        isUserInteractionEnabled = false
        let fadeOut = SKAction.fadeOut(withDuration: 0.2)
        let fadeIn = SKAction.fadeIn(withDuration: 0.3)
        
        mainContainer.run(fadeOut){
            self.currentMenuState = .timeSelect
            self.timeSelectContainer.run(fadeIn)
            self.isUserInteractionEnabled = true
        }
    }
    
    func animateToGameSelection (){
        isUserInteractionEnabled = false
        let fadeOut = SKAction.fadeOut(withDuration: 0.2)
        let fadeIn = SKAction.fadeIn(withDuration: 0.3)
        
        
        timeSelectContainer.run(fadeOut){
            self.currentMenuState = .main
            self.mainContainer.run(fadeIn)
            self.isUserInteractionEnabled = true
        }
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
