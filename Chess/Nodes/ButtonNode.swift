//
//  ButtonNode.swift
//  Chess
//
//  Created by Alessandro Rotta on 13/01/26.
//

import SpriteKit

class ButtonNode : SKNode {
    
    
    // variables
    private var backgroundNode : SKShapeNode!
    private var labelNode : SKLabelNode!
    
    var action: (() -> Void)?
    var isEnabled: Bool = true
    var labelText : String
    var buttonColor : SKColor
    
    private let selectedScale: CGFloat = 0.9
    private let originalScale: CGFloat = 1.0
    

    init(size: CGSize, text : String , color: SKColor, action: @escaping () -> Void){
        self.buttonColor = color
        self.labelText = text
        self.action = action
        
        super.init()
        
        self.isUserInteractionEnabled = true
        
        let rect = CGRect(origin: CGPoint(x: -size.width/2, y: -size.height/2), size: size)
        
        backgroundNode = SKShapeNode(rect: rect, cornerRadius: 10)
        backgroundNode.fillColor = color
        backgroundNode.strokeColor = .clear
        
        
        addChild(backgroundNode)
        
        labelNode = SKLabelNode(fontNamed: "Helvetica-Bold")
                labelNode.text = text
                labelNode.fontSize = 20
                labelNode.fontColor = SKColor(red: 83/255, green: 61/255, blue: 42/255, alpha: 1)
        
        labelNode.verticalAlignmentMode = .center
                labelNode.horizontalAlignmentMode = .center
                labelNode.zPosition = 1
        
        addChild(labelNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isEnabled else { return }
        self.run(SKAction.scale(to: selectedScale, duration: 0.1))
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isEnabled else { return }
        self.run(SKAction.scale(to: originalScale, duration: 0.1))
        if let touch = touches.first {
                    let location = touch.location(in: self.parent!)
                    
                    if self.contains(location) {
                        action?()
                    }
                }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.run(SKAction.scale(to: originalScale, duration: 0.1))
        }
    
}
