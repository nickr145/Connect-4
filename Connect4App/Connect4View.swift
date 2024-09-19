//
//  Connect4View.swift
//  Connect4App
//
//  Created by Nicholas Rebello on 2024-09-16.
//

import SwiftUI

struct Connect4View: View {
    @StateObject private var game = Connect4Model()
    
    var body: some View {
        VStack {
            Text("Connect 4")
                .font(.largeTitle)
                .padding()
            
            if let winner = game.winner {
                Text("\(winner == .red ? "Red" : "Yellow") wins!")
                    .font(.title)
                    .foregroundColor(winner == .red ? .red : .yellow)
                    .padding()
            }
            
            GeometryReader { geometry in
                let gridWidth = geometry.size.width
                let gridHeight = geometry.size.height
                let cellSize = min(gridWidth / 7, gridHeight / 6)

                VStack {
                    Spacer()
                    VStack(spacing: 2) {
                        ForEach((0..<6).reversed(), id: \.self) { row in
                            HStack(spacing: 2) {
                                ForEach(0..<7, id: \.self) { col in
                                    Circle()
                                        .frame(width: cellSize, height: cellSize)
                                        .foregroundColor(pieceColor(at: col, row: row))
                                        .overlay(Circle().stroke(Color.black, lineWidth: 1))
                                        .onTapGesture {
                                            if game.winner == nil {
                                                game.dropPiece(in: col)
                                            }
                                        }
                                }
                            }
                        }
                    }
                    .frame(width: cellSize * 7, height: cellSize * 6)
                    .padding(.vertical)
                    Spacer()
                }
                .frame(width: gridWidth, height: gridHeight)
            }
            .padding()

            // Reset Button
            Button(action: game.resetGame) {
                Text("Reset Game")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.top, 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
    }
    
    private func pieceColor(at col: Int, row: Int) -> Color {
        if let player = game.board[col][row] {
            return player == .red ? .red : .yellow
        } else {
            return .gray
        }
    }
}

#Preview {
    Connect4View()
}
