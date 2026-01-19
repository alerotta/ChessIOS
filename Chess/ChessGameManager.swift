//
//  ChessGameManager.swift
//  Chess
//
//  Created by Alessandro Rotta on 15/01/26.
//
import SwiftChess


class ChessGameManager {
    
    private var game : Game
    
    var onColorUpdate: ((PieceColor) -> Void)?
    var turnColor : Color = .white{
        didSet {
            handleColorUpdate(turnColor)
        }
    }
    

    
    init(){
        let whitePlayer = Human(color: .white)
        let blackPlayer = Human(color: .black)
        self.game = Game(firstPlayer: whitePlayer, secondPlayer: blackPlayer)
    }
    
    
    
    func getPiecesInfo() -> [(row : Int , col : Int , color : PieceColor , type : PieceType)]  {
        var info : [(row : Int , col : Int , color : PieceColor , type : PieceType)] = []
        
        for sq in game.board.squares {
            if let piece = sq.piece{
                
                let c : PieceColor
                switch piece.color {
                case .black : c = PieceColor.black
                case .white : c = PieceColor.white
                }
                
                let t : PieceType
                switch piece.type {
                case .pawn : t = PieceType.pawn
                case .rook : t = PieceType.rook
                case .bishop : t = PieceType.bishop
                case .knight : t = PieceType.knight
                case .king : t = PieceType.king
                case .queen : t = PieceType.queen
                }
                
                info.append((
                    row: piece.location.y,
                    col: piece.location.x,
                    color : c,
                    type: t
                ))
            }
        }
        return info
    }
     

    func getPieceMoves (row : Int , col : Int) -> [(row: Int , col : Int )]{
        var res : [(Int, Int)] = []
        let moves = game.board.possibleMoveLocationsForPiece(atLocation: BoardLocation(x: col, y: row))
        for move in moves {
            res.append((move.x,move.y))
        }
        return res
    }
    
    func makeMove (fromCol : Int? , fromRow: Int?, toCol : Int, toRow: Int){
        guard let fromCol else {return}
        guard let fromRow else {return}
        if let player = game.currentPlayer as? Human {
            let currentLocation = BoardLocation(x: fromCol, y: fromRow)
            let newLocation = BoardLocation(x: toCol, y: toRow)
            try! player.movePiece(from: currentLocation,to: newLocation)
            turnColor = game.currentPlayer.color
            
        }
    }
    
    private func handleColorUpdate (_ color : Color){
        let c : PieceColor
        switch color {
        case .white : c = PieceColor.white
        case .black : c = PieceColor.black
        }
        onColorUpdate?(c)
        
    }
    
    func getTurnColor () -> PieceColor {
        if turnColor == .white{
            return PieceColor.white
        }
        else {return PieceColor.black}
    }
    
    
    
    
}
