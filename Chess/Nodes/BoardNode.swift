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
        
        let offset = (squareSize * 4) - (squareSize / 2)
        
        for row in 0..<8 {
            
            var rowSquares : [SquareNode] = []
            
            for col in 0..<8 {
                
                let islight =  (row + col) % 2 == 1
                let square = SquareNode(row: row, col: col, size: CGSize(width: squareSize, height: squareSize), isLight: islight)
                let xPos = offset - (CGFloat(col) * squareSize)
                let yPos = offset - (CGFloat(row) * squareSize)
                square.position = CGPoint(x: xPos, y: yPos)
                addChild(square)
                rowSquares.append(square)
            }
            squares.append(rowSquares)
        }
    }
    
    func square( at gridPos: (col: Int, row: Int)) -> SquareNode?{
        guard gridPos.row >= 0 && gridPos.row < 8,
              gridPos.col >= 0 && gridPos.col < 8 else {
            print("Error: Coordinate out of bounds: \(gridPos)")
            return nil
        }
        
        return squares[gridPos.row][gridPos.col]
    }
    
    
    func spawnPiece (type: PieceType , pieceColor : PieceColor  , at gridPos: (col:Int , row : Int)){
        
        guard let targetSquare = square(at: gridPos) else{
            print ("error: Grid position \(gridPos) does not exist")
            return
        }
        
        let pieceSize = CGSize(width: self.squareSize * 0.9, height: self.squareSize * 0.9)
        let piece = PieceNode(type: type, pieceColor: pieceColor, size: pieceSize)
        piece.position = targetSquare.position
        if pieceColor == PieceColor.white {piece.zRotation += .pi}
        addChild(piece)
    }
        
        func gridPosition(at point: CGPoint) -> (col: Int, row: Int)? {
            // 1. Calculate the offset used during creation
            let offset = (squareSize * 4) - (squareSize / 2)
            
            // 2. Reverse the math: (x - offset) / size = column
            // We use "round" to find the nearest integer index
            let col = Int(round((point.x - offset) / squareSize))
            let row = Int(round((point.y - offset) / squareSize))
            
            // 3. Check bounds
            if col >= 0 && col < 8 && row >= 0 && row < 8 {
                return (col, row)
            }
            return nil
        }
    }

