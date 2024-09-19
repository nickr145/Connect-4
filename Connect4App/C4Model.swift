//
//  C4Model.swift
//  Connect4App
//
//  Created by Nicholas Rebello on 2024-09-18.
//

import Foundation
import SwiftUI

// Define player types
enum Player {
    case red, yellow
}

// Connect 4 Model
class Connect4Model: ObservableObject {
    // Board state: 7 columns, 6 rows
    @Published var board: [[Player?]] = Array(repeating: Array(repeating: nil, count: 6), count: 7)
    
    // Keep track of the current player
    @Published var currentPlayer: Player = .red
    
    // Detect winner
    @Published var winner: Player? = nil
    
    // Drop a piece into a column
    func dropPiece(in column: Int) {
        if let row = board[column].firstIndex(where: { $0 == nil }) {
            board[column][row] = currentPlayer
            if checkForWin() {
                winner = currentPlayer
            } else {
                // Switch to the next player
                currentPlayer = currentPlayer == .red ? .yellow : .red
            }
        }
    }
    
    // Reset the game
    func resetGame() {
        board = Array(repeating: Array(repeating: nil, count: 6), count: 7) // Clear the board
        currentPlayer = .red // Start with red again
        winner = nil // Reset winner
    }
    
    // Check for win conditions
    func checkForWin() -> Bool {
        // Check horizontal, vertical, and diagonal
        return checkHorizontal() || checkVertical() || checkDiagonal()
    }
    
    private func checkHorizontal() -> Bool {
        for row in 0..<6 {
            for col in 0..<4 {
                if let player = board[col][row], checkLine(start: (col, row), delta: (1, 0), player: player) {
                    return true
                }
            }
        }
        return false
    }
    
    private func checkVertical() -> Bool {
        for col in 0..<7 {
            for row in 0..<3 {
                if let player = board[col][row], checkLine(start: (col, row), delta: (0, 1), player: player) {
                    return true
                }
            }
        }
        return false
    }
    
    private func checkDiagonal() -> Bool {
        // Check diagonals (both directions)
        for col in 0..<4 {
            for row in 0..<3 {
                if let player = board[col][row], checkLine(start: (col, row), delta: (1, 1), player: player) {
                    return true
                }
            }
        }
        for col in 0..<4 {
            for row in 3..<6 {
                if let player = board[col][row], checkLine(start: (col, row), delta: (1, -1), player: player) {
                    return true
                }
            }
        }
        return false
    }
    
    // Helper function to check a line of four in a given direction (delta)
    private func checkLine(start: (Int, Int), delta: (Int, Int), player: Player) -> Bool {
        for i in 0..<4 {
            let x = start.0 + i * delta.0
            let y = start.1 + i * delta.1
            if x < 0 || x >= 7 || y < 0 || y >= 6 || board[x][y] != player {
                return false
            }
        }
        return true
    }
}
