//
//  PieceNode.swift
//  Chess
//
//  Created by Alessandro Rotta on 14/01/26.
//
import SpriteKit

enum PieceColor : String {
    case white = "white"
    case black = "black"
}

enum PieceType : String {
    case pawn = "pawn"
    case rook = "rook"
    case knight = "knight"
    case bishop = "bishop"
    case queen = "queen"
    case king = "king"
}


class PieceNode : SKSpriteNode {
    
    let type : PieceType
    let pieceColor : PieceColor
    
    init (type: PieceType, pieceColor : PieceColor, size: CGSize){
        
        self.type = type
        self.pieceColor = pieceColor
        let imageName = "\(pieceColor.rawValue)_\(type.rawValue)"
        let texture = SKTexture(imageNamed: imageName)
        super.init(texture: texture, color: .clear, size: size)
        self.zPosition = 10
        self.name = "Piece"
    }
    
    required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
}

