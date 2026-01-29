//
//  MenuButtonNode.swift
//  Chess
//
//  Created by Alessandro Rotta on 26/01/26.
//

import SpriteKit

class MenuButtonNode : SKNode {
    
    private let pressDepth: CGFloat = 8.0
    private let animationSpeed: TimeInterval = 0.05
    private let faceColor : SKColor = SKColor(red: 170/255, green: 139/255, blue: 109/255, alpha: 1)
    private let baseColor : SKColor =  SKColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 1)
    
    private var actionBlock: ((MenuButtonNode)-> Void)?
    private var isEnabled: Bool = true
    
    fileprivate var baseNode: SKShapeNode!
    private var faceNode: SKShapeNode!
    private var labelNode: SKLabelNode?
    
    private var isPressed: Bool = false
    let text : String
    
    init (size: CGSize, position :CGPoint , text: String, action: @escaping (MenuButtonNode)-> Void){
        
        self.text = text
        
        super.init()
        self.actionBlock = action
        self.isUserInteractionEnabled = true
        self.position = position
        setupVisual(size: size, position: position, text: text)
    }
    
    init (size: CGSize, position :CGPoint , text: String, color : SKColor , action: @escaping (MenuButtonNode)-> Void){
        
        self.text = text
        
        super.init()
        self.actionBlock = action
        self.isUserInteractionEnabled = true
        self.position = position
        setupVisual(size: size, position: position, text: text)
        faceNode.fillColor = color
    }
    
    required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    
    func setupVisual (size: CGSize, position :CGPoint , text: String){
        
        
        baseNode = SKShapeNode(rectOf: size , cornerRadius: 10)
        baseNode.fillColor =  baseColor
        baseNode.position = CGPoint(x: -pressDepth/2, y: -pressDepth )
        baseNode.strokeColor = .clear
        addChild(baseNode)
        
        faceNode = SKShapeNode(rectOf: size , cornerRadius: 10)
        faceNode.fillColor =  faceColor
        faceNode.position = CGPoint.zero
        faceNode.strokeColor = .clear
        addChild(faceNode)
        
        labelNode = SKLabelNode(fontNamed: "Avenir-Heavy")
        labelNode?.text = text
        labelNode?.fontSize = 24
        labelNode?.fontColor = SKColor(red: 83/255, green: 61/255, blue: 42/255, alpha: 1)
        labelNode?.verticalAlignmentMode = .center
        labelNode?.position = .zero
        faceNode.addChild(labelNode!)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            guard isEnabled else { return }
            isPressed = true
            animatePress()
        }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            guard isPressed else { return }
            isPressed = false
            animateRelease()
            
            // Check if finger is still inside the button area
            if let touch = touches.first {
                let location = touch.location(in: self)
                // Define a hit area (faceNode's frame expanded slightly)
                if faceNode.frame.contains(location) {
                    actionBlock?(self)
                }
            }
        }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
            if isPressed {
                isPressed = false
                animateRelease()
            }
        }
    
    private func animatePress (){
        //let moveDown = SKAction.move(to: CGPoint(x: position.x - pressDepth/2 + 2 , y : position.y - pressDepth + 2), duration: animationSpeed)
        let moveDown = SKAction.move(by: CGVector(dx: -pressDepth/2 + 2, dy: -pressDepth + 2), duration: animationSpeed)
        faceNode.removeAllActions()
        faceNode.run(SKAction.group([moveDown]))
    }
    
    fileprivate func animateRelease (){
        let moveUp = SKAction.move(to: CGPoint.zero, duration: 0.1)
        faceNode.removeAllActions()
        faceNode.run(SKAction.group([moveUp]))
        
    }
    
    
    
}

class MenuButtonToggleNode : MenuButtonNode {
    
    var isToggle : Bool = false
    let toggleAction : ((MenuButtonToggleNode)-> Void)
    
    init(size: CGSize, position: CGPoint, text: String, toggleAction: @escaping (MenuButtonToggleNode) -> Void) {
        self.toggleAction = toggleAction
        super.init(size: size, position: position, text: text, action: { _ in })
        }
    
    required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isToggle{
            super.baseNode.fillColor = SKColor(red: 30/255, green: 130/255, blue: 30/255, alpha: 1)
            super.touchesBegan(touches, with: event)
            toggleAction(self)
            }
        else{
            super.animateRelease()
            super.baseNode.fillColor = SKColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 1)
        }
        isToggle.toggle()
        
 
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        return
    }
    
    func removeToggle () {
        isToggle = false
        animateRelease()
        super.baseNode.fillColor = SKColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 1)
    }
}
