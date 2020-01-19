//
//  TetrisGameViewModel.swift
//  Tetris
//
//  Created by SchwiftyUI on 1/12/20.
//  Copyright © 2020 SchwiftyUI. All rights reserved.
//

import SwiftUI
import Combine

class TetrisGameViewModel: ObservableObject {
    @Published var tetrisGameModel = TetrisGameModel()
    
    var numRows: Int { tetrisGameModel.numRows }
    var numColumns: Int { tetrisGameModel.numColumns }
    var gameBoard: [[TetrisGameSquare]] {
        var board = tetrisGameModel.gameBoard.map { $0.map(convertToSquare) }
        
        if let tetromino = tetrisGameModel.tetromino {
            for blockLocation in tetromino.blocks {
                board[blockLocation.column + tetromino.origin.column][blockLocation.row + tetromino.origin.row] = TetrisGameSquare(color: getColor(blockType: tetromino.blockType))
            }
        }
        
        return board
    }
    
    var anyCancellable: AnyCancellable?
    
    init() {
        anyCancellable = tetrisGameModel.objectWillChange.sink {
            self.objectWillChange.send()
        }
    }
    
    func convertToSquare(block: TetrisGameBlock?) -> TetrisGameSquare {
        return TetrisGameSquare(color: getColor(blockType: block?.blockType))
    }
    
    func getColor(blockType: BlockType?) -> Color {
        switch blockType {
        case .i:
            return .tetrisLightBlue
        case .j:
            return .tetrisDarkBlue
        case .l:
            return .tetrisOrange
        case .o:
            return .tetrisYellow
        case .s:
            return .tetrisGreen
        case .t:
            return .tetrisPurple
        case .z:
            return .tetrisRed
        case .none:
            return .tetrisBlack
        }
    }
    
    func squareClicked(row: Int, column: Int) {
        tetrisGameModel.blockClicked(row: row, column: column)
    }
}

struct TetrisGameSquare {
    var color: Color
}
