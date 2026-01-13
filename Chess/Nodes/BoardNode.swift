//
//  BoardNode.swift
//  Chess
//
//  Created by Alessandro Rotta on 13/01/26.
//

import SpriteKit

class BoardNode : SKNode {
    
    private let squareSize : CGFloat
    var squares : [[SquareNode]] = []
    
    init(squareSize : CGFloat){
        self.squareSize = squareSize
        super.init()
        createGrid()
    }
    
    required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    
    private func createGrid () {
        
        let offset = -(squareSize * 4) + (squareSize / 2)
        
        for row in 0..<8 {
            
            var rowSquares : [SquareNode] = []
            
            for col in 0..<8 {
                
                let islight =  (row + col) % 2 == 0
                let square = SquareNode(row: row, col: col, size: CGSize(width: squareSize, height: squareSize), isLight: islight)
                let xPos = offset + (CGFloat(col) * squareSize)
                let yPos = offset + (CGFloat(row) * squareSize)
                square.position = CGPoint(x: xPos, y: yPos)
                addChild(square)
                rowSquares.append(square)
            }
            squares.append(rowSquares)
        }
    }
}


