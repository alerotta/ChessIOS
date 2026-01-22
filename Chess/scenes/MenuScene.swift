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
    var selectedTimeButton : SKSpriteNode?
    
    override func didMove(to view: SKView) {
        
        backgroundColor = SKColor(red: 226/255, green: 205/255, blue: 181/255, alpha: 1)
        setupMainButtons()
        setupTimeButtons()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        let location = touch.location(in: self)
        let nodesAtpoint = nodes(at: location)
        
        
        for node in nodesAtpoint {
            let clickedNode = node.name == "label" ? node.parent : node
            if currentMenuState == .main {
                handleMainMenuClick(node: clickedNode)
            } else if currentMenuState == .timeSelect {
                handleTimeMenuClick(node: clickedNode)
            }
        }
    }
    
    func handleMainMenuClick (node: SKNode?){
        guard let name = node?.name else { return }
        
        if name == "offlineBtn" {
            selectedGameType = "Offline"
            animateToTimeSelection()
        }
        /*
        else if name == "onlineBtn" {
            selectedGameType = "Online"
            animateToTimeSelection()
        }
        */
    }
    
    func handleTimeMenuClick (node : SKNode?) {
        guard let name = node?.name, let spriteNode = node as? SKSpriteNode else { return }
        
        if name.starts(with: "time") {
            toggleTimeButton(spriteNode)
        }
        else{
            switch selectedTimeButton?.name {
            case "timeThree" : startGame(180)
            case "timeFive" : startGame(300)
            case "timeTen" : startGame(600)
            default : return
            }
        }
        
        
    }
    
    func toggleTimeButton ( _ btn : SKSpriteNode){
        if let previous = selectedTimeButton {
            previous.color = SKColor(red: 170/255, green: 139/255, blue: 109/255, alpha: 1)
        }
        btn.color = .red
        selectedTimeButton = btn
    }
    
    func startGame (_ matchDuration : TimeInterval){
        guard let _ = selectedTimeButton else {return}
        let gameScene = GameScene(size : self.size, matchDuration: matchDuration)
        gameScene.scaleMode = .aspectFill
        let transition = SKTransition.fade(withDuration: 0.2)
        view?.presentScene(gameScene, transition: transition)
        
    }
    
    
    
    func setupMainButtons (){
        addChild(mainContainer)
        
        let offlineBtn = createButton(name: "offlineBtn",
                                      text: "Local",
                                      position: CGPoint(x: frame.midX, y: frame.midY - 30))
        let onlineBtn = createButton(name: "onlineBtn",
                                     text: "Online",
                                     position: CGPoint(x: frame.midX, y: frame.midY + 30 ))
        
        mainContainer.addChild(offlineBtn)
        mainContainer.addChild(onlineBtn)
        
    }
    
    func setupTimeButtons (){
        addChild(timeSelectContainer)
        timeSelectContainer.alpha = 0.0
        
        let threeMinButton = createButton(name: "timeThree", text: "3:00", position: CGPoint(x: frame.midX, y: frame.midY + 30))
        let fiveMinButton = createButton(name: "timeFive", text: "5:00", position: CGPoint(x: frame.midX, y: frame.midY - 30))
        let tenMinButton = createButton(name: "timeTen", text: "10:00", position: CGPoint(x: frame.midX, y: frame.midY - 90))
        let startButton =  createButton(name: "startGameBtn", text: "Start New Game", position: CGPoint(x: frame.midX, y: frame.midY - 150))
        
        timeSelectContainer.addChild(threeMinButton)
        timeSelectContainer.addChild(fiveMinButton)
        timeSelectContainer.addChild(tenMinButton)
        timeSelectContainer.addChild(startButton)
    }
    
    func createButton (name: String, text: String, position: CGPoint) -> SKSpriteNode {
        
        let button = SKSpriteNode(color: .gray, size: CGSize(width: 200, height: 50))
        button.name = name
        button.position = position
        button.color = SKColor(red: 170/255, green: 139/255, blue: 109/255, alpha: 1)
        
        let label = SKLabelNode(text: text)
        label.fontName = "Helvetica-Bold"
        label.fontSize = 20
        label.verticalAlignmentMode = .center
        label.zPosition = 1
        label.fontColor = SKColor(red: 83/255, green: 61/255, blue: 42/255, alpha: 1)
        
        button.addChild(label)
        return button
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
