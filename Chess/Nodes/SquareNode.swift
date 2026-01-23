//
//  SquareNode.swift
//  Chess
//
//  Created by Alessandro Rotta on 13/01/26.
//
import SpriteKit
import SwiftUI

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
        
        //self.name = "square-\(col)-\(row)"
        self.zPosition = 0
        
        //border definition
        let border = SKShapeNode(rectOf: size)
        border.strokeColor = .black
        border.lineWidth = 1
        border.fillColor = .clear
        border.zPosition = 1
        
        //set up SquareNode
        if col == 0 {
            let label = SKLabelNode()
            label.text = String(row + 1)
            label.fontName = "Helvetica-Bold"
            label.fontSize = 7
            label.fontColor = .black
            label.zPosition = 1
            label.position = CGPoint(x:  size.width * 0.4, y:  -size.height * 0.3 )
            label.zRotation = .pi
            self.addChild(label)
        }
        if row == 0 {
            let label = SKLabelNode()
            label.text = Self.numberToChar(col)
            label.fontName = "Helvetica-Bold"
            label.fontSize = 7
            label.fontColor = .black
            label.zPosition = 1
            label.position = CGPoint(x: -size.width * 0.4, y:  size.height * 0.45 )
            label.zRotation = .pi
            self.addChild(label)
        }
        self.addChild(border)
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
    
    func hihglight (){
        self.color = .yellow
    }
    func resetState(){
        self.color = defaultColor
    }
    
    static func numberToChar (_ i : Int) -> String {
        switch i {
        case 0 : return "a"
        case 1 : return "b"
        case 2 : return "c"
        case 3 : return "d"
        case 4 : return "e"
        case 5 : return "f"
        case 6 : return "g"
        case 7 : return "h"
        default : return "errror"
        }
    }
    
}
