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
        setupStartingPosition()
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
    
   func square( at gridPos: (col: Int, row: Int)) -> SquareNode?{
        guard gridPos.row >= 0 && gridPos.row < 8,
                  gridPos.col >= 0 && gridPos.col < 8 else {
                print("Error: Coordinate out of bounds: \(gridPos)")
                return nil
            }

            return squares[gridPos.row][gridPos.col]
        }
    
    
    private func spawnPiece (type: PieceType, pieceColor : PieceColor , at gridPos: (col:Int , row : Int)){
        
        guard let targetSquare = square(at: gridPos) else{
            print ("error: Grid position \(gridPos) does not exist")
            return
        }
        
        let pieceSize = CGSize(width: self.squareSize * 0.9, height: self.squareSize * 0.9)
        let piece = PieceNode(type: type, pieceColor: pieceColor, size: pieceSize)
        piece.position = targetSquare.position
        addChild(piece)
    }
    
    func setupStartingPosition(){
        for col in 0 ..< 8 {
            //pawns
            spawnPiece(type: PieceType.pawn, pieceColor: PieceColor.black, at: (col: col, row: 6))
            spawnPiece(type: PieceType.pawn, pieceColor: PieceColor.white, at: (col: col, row: 1))
            
        }
        
        //rooks
        spawnPiece(type: PieceType.rook, pieceColor: PieceColor.black, at: (col: 0, row: 7))
        spawnPiece(type: PieceType.rook, pieceColor: PieceColor.black, at: (col: 7, row: 7))
        spawnPiece(type: PieceType.rook, pieceColor: PieceColor.white, at: (col: 0, row: 0))
        spawnPiece(type: PieceType.rook, pieceColor: PieceColor.white, at: (col: 7, row: 0))
        
        //knights
        spawnPiece(type: PieceType.knight, pieceColor: PieceColor.black, at: (col: 1, row: 7))
        spawnPiece(type: PieceType.knight, pieceColor: PieceColor.black, at: (col: 6, row: 7))
        spawnPiece(type: PieceType.knight, pieceColor: PieceColor.white, at: (col: 1, row: 0))
        spawnPiece(type: PieceType.knight, pieceColor: PieceColor.white, at: (col: 6, row: 0))
        
        //bishops
        spawnPiece(type: PieceType.bishop, pieceColor: PieceColor.black, at: (col: 2, row: 7))
        spawnPiece(type: PieceType.bishop, pieceColor: PieceColor.black, at: (col: 5, row: 7))
        spawnPiece(type: PieceType.bishop, pieceColor: PieceColor.white, at: (col: 2, row: 0))
        spawnPiece(type: PieceType.bishop, pieceColor: PieceColor.white, at: (col: 5, row: 0))
        
        //queens
        spawnPiece(type: PieceType.queen, pieceColor: PieceColor.black, at: (col: 3, row: 7))
        spawnPiece(type: PieceType.queen, pieceColor: PieceColor.white, at: (col: 4, row: 0))
        
        //kings
        spawnPiece(type: PieceType.king, pieceColor: PieceColor.black, at: (col: 4, row: 7))
        spawnPiece(type: PieceType.king, pieceColor: PieceColor.white, at: (col: 3, row: 0))
    }
    
    func gridPosition(at point: CGPoint) -> (col: Int, row: Int)? {
        // 1. Calculate the offset used during creation
        let offset = -(squareSize * 4) + (squareSize / 2)
        
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


