//
//  GameOverNode.swift
//  Chess
//
//  Created by Alessandro Rotta on 20/01/26.
//
import SpriteKit

class GameOverNode : SKNode {
    
        var onRestart: (() -> Void)?
        var onMenu: (() -> Void)?
        
        // Constants for button names so we can identify clicks
        private let restartButtonName = "restartBtn"
        private let menuButtonName = "menuBtn"
    
    required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    
    init ( sceneSize :  CGSize , title : String, message: String){
        super.init()
        self.isUserInteractionEnabled = true
        self.zPosition = 100
        
        let overlay = SKShapeNode(rectOf: sceneSize)
        overlay.fillColor = .black
        overlay.strokeColor = .clear
        overlay.alpha = 0.6
        addChild(overlay)
        
        let panelSize = CGSize(width : sceneSize.width * 0.8, height: sceneSize.height * 0.6)
        let panel = SKShapeNode (rectOf: panelSize, cornerRadius: 20)
        panel.fillColor = .white
        panel.strokeColor = .gray
        panel.lineWidth = 2
        addChild(panel)
    
        let titleLabel = SKLabelNode(text: title)
        titleLabel.fontName = "AvenirNext-Medium"
        titleLabel.fontSize = 32
        titleLabel.color = .black
        titleLabel.position = CGPoint(x: 0, y: 20)
        //titleLabel.verticalAlignmentMode = .center
       // panel.addChild(titleLabel)
        
        let msgLabel = SKLabelNode(text: message)
        msgLabel.fontName = "AvenirNext-Medium"
        msgLabel.fontSize = 20
        msgLabel.fontColor = .darkGray
        msgLabel.position = CGPoint(x: 0, y: 20)
        panel.addChild(msgLabel)
        
        let btnY: CGFloat = -50
        let btnSpacing: CGFloat = 60
                
        createButton(name: restartButtonName, text: "Play Again", position: CGPoint(x: 0, y: btnY), parent: panel)
        createButton(name: menuButtonName, text: "Exit to Menu", position: CGPoint(x: 0, y: btnY - btnSpacing), parent: panel)
    }
    
    private func createButton(name: String, text: String, position: CGPoint, parent: SKNode) {
            let btnSize = CGSize(width: 200, height: 44)
            let btn = SKShapeNode(rectOf: btnSize, cornerRadius: 10)
            btn.name = name // Vital for touch detection
            btn.position = position
            btn.fillColor = .systemBlue
            btn.strokeColor = .clear
            
            let label = SKLabelNode(text: text)
            label.name = name // Name the label too, in case the user taps the text specifically
            label.fontName = "AvenirNext-Bold"
            label.fontSize = 18
            label.verticalAlignmentMode = .center
            label.fontColor = .white
            
            btn.addChild(label)
            parent.addChild(btn)
        }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            guard let touch = touches.first else { return }
            let location = touch.location(in: self)
            
            // Check what node was tapped
            let nodesAtPoint = nodes(at: location)
            
            for node in nodesAtPoint {
                if node.name == restartButtonName {
                    self.onRestart?()

                } else if node.name == menuButtonName {
                    self.onMenu?()
                    /*
                    runButtonAnimation(node: node) {
                        self.onMenu?()
                    }
                     */
                }
            }
        }
        
        private func runButtonAnimation(node: SKNode, completion: @escaping () -> Void) {
            let scaleDown = SKAction.scale(to: 0.95, duration: 0.1)
            let scaleUp = SKAction.scale(to: 1.0, duration: 0.1)
            let sequence = SKAction.sequence([scaleDown, scaleUp, SKAction.run(completion)])
            node.run(sequence)
        }
}
