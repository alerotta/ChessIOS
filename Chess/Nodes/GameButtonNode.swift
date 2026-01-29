//
//  GameButtonNode.swift
//  Chess
//
//  Created by Alessandro Rotta on 29/01/26.
//
import SpriteKit

class GameButtonNode : SKNode {


    var backGroundNode : SKShapeNode
    var foreGroundNode : SKSpriteNode
    var actionBlock : ()-> Void
    var finalPostition : CGPoint
    
    init (size: CGSize, position :CGPoint , iconName: String , isBlack : Bool , action: @escaping ()-> Void){
        
        actionBlock = action
        let offsetY = -0 * size.height
        let offsetX =  -0.5 * size.width
        finalPostition = CGPoint( x : position.x + offsetX , y: position.y + offsetY )
        
        backGroundNode = SKShapeNode(rectOf: size , cornerRadius: 4)
        backGroundNode.fillColor = .clear
        backGroundNode.strokeColor = .clear
        
        
        let config = UIImage.SymbolConfiguration(pointSize: size.height * 0.5, weight: .bold)
        if let uiImage = UIImage(systemName: iconName, withConfiguration: config)?.withTintColor(.white, renderingMode: .alwaysOriginal) {
                    let texture = SKTexture(image: uiImage)
                    foreGroundNode = SKSpriteNode(texture: texture)
                    if isBlack {foreGroundNode.zRotation = .pi}
                    
                } else {
                    foreGroundNode = SKSpriteNode(color: .clear, size: .zero)
                    print("Error: SF Symbol '\(iconName)' not found.")
                }
        
        
        super.init()
        
        backGroundNode.position = finalPostition
        foreGroundNode.position = finalPostition

        
        self.isUserInteractionEnabled = true
        addChild(backGroundNode)
        addChild(foreGroundNode)
        
    }
    

    

    
    required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        backGroundNode.fillColor = .black
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        backGroundNode.fillColor = .clear
            
            guard let touch = touches.first else { return }
            let location = touch.location(in: self)
            
            
            if backGroundNode.contains(location) {
                actionBlock()
            }
        }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        backGroundNode.fillColor = .clear
    }
    
}
