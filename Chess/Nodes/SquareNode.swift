//
//  SquareNode.swift
//  Chess
//
//  Created by Alessandro Rotta on 13/01/26.
//
import SpriteKit

class SquareNode : SKSpriteNode {
    
    let row : Int
    let col : Int
    private let defaultColor : SKColor
    private var moveIndicator : SKShapeNode?
    
    init (row : Int , col: Int, size: CGSize , isLight:Bool){
        self.row = row
        self.col = col
        let lightColor = SKColor(red: 249/255, green: 243/255, blue: 223/255, alpha: 1)
        let darkColor = SKColor(red: 86/255, green: 123/255, blue: 92/255, alpha: 1)
        self.defaultColor = isLight ? lightColor : darkColor
        super.init(texture: nil, color: defaultColor, size: size)
        
        self.name = "square-\(col)-\(row)"
        self.zPosition = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    
    func showMoveIndicator(){
        guard moveIndicator == nil else {return}
        let dotRadius = self.size.width / 4
        let dot = SKShapeNode(circleOfRadius: dotRadius)
        dot.fillColor = SKColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 0.7)
        dot.strokeColor = .clear
        dot.zPosition = 1
        dot.position = CGPoint(x: 0, y: 0)
        addChild(dot)
        self.moveIndicator = dot
    }
    
    func removeMoveInidcator() {
        moveIndicator?.removeFromParent()
        moveIndicator = nil
    }
    
    func highlighSelected (){
        self.color = .yellow
    }
    
    func resetState(){
        self.color = defaultColor
    }
}
