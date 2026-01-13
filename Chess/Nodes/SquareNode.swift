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
        self.defaultColor = isLight ? .white : .black
        super.init(texture: nil, color: defaultColor, size: size)
        
        self.name = "square-\(col)-\(row)"
        self.zPosition = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    
    func hihglighSelected (){
        self.color = .yellow
    }
    
    func resetState(){
        self.color = defaultColor
    }
}
