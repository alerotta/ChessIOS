//
//  ChessGameManager.swift
//  Chess
//
//  Created by Alessandro Rotta on 15/01/26.
//
import SwiftChess
import Foundation

struct MoveResult {
    let origin : (x : Int, y: Int)
    let destination : (x : Int, y: Int)
    let capturedSquare : (x : Int, y: Int)?
    let isPromotion : Bool
    let isCastling : Bool
    
    init (origin : (x : Int, y: Int),destination : (x : Int, y: Int), capturedSquare : (x : Int, y: Int)?, isPromotion : Bool,  isCastling : Bool ) {
        self.origin = origin
        self.destination = destination
        self.capturedSquare = capturedSquare
        self.isPromotion = isPromotion
        self.isCastling = isCastling
        
    }
}


class ChessGameManager {
    
    private var game : Game
    var onColorUpdate: ((PieceColor) -> Void)?
    var turnColor : Color = .white{
        didSet {
            handleColorUpdate(turnColor)
        }
    }
    
    private var timer : Timer?
    
    var whiteTime : TimeInterval = 300
    var blackTime : TimeInterval = 300
    
    var onTimeUpdate : ((_ whiteTime: TimeInterval, _ blackTime: TimeInterval) -> Void)?
    var onTimeExpired : ((_ winner : String) -> Void)?
    

    
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
    
    func makeMove (fromCol : Int , fromRow: Int, toCol : Int, toRow: Int) -> MoveResult? {
        
        startTimer()
        if let player = game.currentPlayer as? Human {
            
            let currentLocation = BoardLocation(x: fromCol, y: fromRow)
            let newLocation = BoardLocation(x: toCol, y: toRow)
            let capturedPiecePosition : (x : Int , y : Int)?
            
            
            do {
                //try to make a move
                try player.movePiece(from: currentLocation,to: newLocation)
                //modify the color of the turn
                turnColor = game.currentPlayer.color
                //check if there was a capture
                if isCaptured(x: toCol, y: toRow){
                    capturedPiecePosition = (toCol,toRow)
                    
                    //retun moveresult
                    onTimeUpdate?(whiteTime,blackTime)
                    return MoveResult (
                        origin: (fromCol,fromRow),
                        destination: (toCol,toRow),
                        capturedSquare: capturedPiecePosition,
                        isPromotion: false,
                        isCastling: false)
                }
                else{
                    onTimeUpdate?(whiteTime,blackTime)
                    return MoveResult (
                        origin: (fromCol,fromRow),
                        destination: (toCol,toRow),
                        capturedSquare: nil,
                        isPromotion: false,
                        isCastling: false)
                }
            }
            catch{
                return nil
            }
        }
        return nil
    }
    
    private func isCaptured (x : Int , y : Int) -> Bool {
        let sq  = game.board.getPiece(at: BoardLocation(x: x, y: y))
        if sq == nil {
            return false
        }
        return true
    }
    
    
    private func handleColorUpdate (_ color : Color){
        let c : PieceColor
        switch color {
        case .white : c = PieceColor.white
        case .black : c = PieceColor.black
        }
        onColorUpdate?(c)
        
    }
    
    private func startTimer(){
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true ){ [weak self] _ in
            self?.tick()
        }
        
    }
    
    private func stopTimer (){
        timer?.invalidate()
        timer = nil
    }
    
    private func tick (){
        
        if turnColor == .white{
            whiteTime -= 1
        }
        else {
            blackTime -= 1
        }
        onTimeUpdate?(whiteTime,blackTime)
    }
    
    
    
    
    
    
}
