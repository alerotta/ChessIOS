//
//  ChessGameManager.swift
//  Chess
//
//  Created by Alessandro Rotta on 15/01/26.
//
import SwiftChess

class ChessGameManager{
    
    private var game : Game
    
    init(){
        let whitePlayer = Human(color: .white)
        let blackPlayer = Human(color: .black)
        self.game = Game(firstPlayer: whitePlayer, secondPlayer: blackPlayer)
    }
    
    var currentFEN : String {
        return generateFEN()
    }
    
    private func generateFEN() -> String {
        var fen = ""
        var stingRow = ""
        var emptySpaceCounter = 0
        
        for (index , sq) in game.board.squares.reversed().enumerated() {
            
            if let piece = sq.piece{
                //piecefoud
                var pieceChar : String
                
                if emptySpaceCounter != 0{
                    stingRow += "\(emptySpaceCounter)"
                }
                switch piece.type{
                    case .pawn : pieceChar = "p"
                    case .knight : pieceChar = "n"
                    case .bishop : pieceChar = "b"
                    case .rook : pieceChar = "r"
                    case .king : pieceChar = "k"
                    case .queen : pieceChar = "q"
                    }
                if piece.color == .white {
                    pieceChar = pieceChar.uppercased()
                }
                stingRow += pieceChar
            }
            else{
                //emptyspace
                emptySpaceCounter += 1
            }
            
            if ((index + 1) % 8) == 0 {
                if emptySpaceCounter != 0 {
                    stingRow += "\(emptySpaceCounter)"
                }
                fen += stingRow.reversed()
                stingRow = ""
                fen += "/"
                emptySpaceCounter = 0
            }
            
        }
        fen.removeLast()
        return fen
    }
    
    private func calculateIndex (row : Int , col : Int) -> Int {
        let rrow = 7 - row
        let rcol = 7 - col
        return rcol + (8 * rrow)
    }

    
    func getPieceMoves (row : Int , col : Int) -> [(row: Int , col : Int )]{
        var res : [(Int, Int)] = []
        let index = calculateIndex(row: row, col: col)
        let moves = game.board.possibleMoveLocationsForPiece(atLocation: BoardLocation(index: index))
        for move in moves {
            res.append(( 7 - move.x, 7 - move.y ))
        }
        return res
    }
    
    
}
