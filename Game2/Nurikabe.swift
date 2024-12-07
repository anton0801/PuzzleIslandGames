import SwiftUI

struct Cell: Identifiable {
    let id = UUID()
    var isBlack: Bool = false
    var number: Int? = nil
    var isPartOfIsland: Bool = false
}

struct NurikabeGame: View {
    @State private var grid: [[Cell]] = Array(repeating: Array(repeating: Cell(), count: 10), count: 10)
    @State private var gridSize: (rows: Int, cols: Int) = (10, 10)
    @State private var validationResult: String = ""
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            ZStack {
                Image("fon2")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
                ZStack {
                    Image("locked")
                        .resizable()
                        .frame(width: 280, height: 100)
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image("back")
                            .resizable()
                            .frame(width: 70, height: 70)
                    })
                    .padding(.top, -140)
                    .padding(.trailing, 290)
                    
                    Text("Nurikabe")
                        .font(.custom("HATTEN", size: 50))
                        .foregroundColor(.white)
                }
                .padding(.top, -300)
                
                GridView(grid: $grid, gridSize: gridSize)
                
                HStack {
                    Button(action: {
                        generateGrid()
                        validationResult = ""
                    }, label: {
                        ZStack {
                            Image("locked")
                                .resizable()
                                .frame(width: 140, height: 60)
                            Text("Restart")
                                .font(.custom("HATTEN", size: 30))
                                .foregroundColor(.white)
                        }
                    })
                    Spacer()
                        .frame(width: 100)
                    Button(action: {
                        validationResult = validateGrid() ? "Valid!" : "Invalid!"
                    }, label: {
                        ZStack {
                            Image("locked")
                                .resizable()
                                .frame(width: 140, height: 60)
                            Text("Check")
                                .font(.custom("HATTEN", size: 30))
                                .foregroundColor(.white)
                        }
                    })
                }
                .padding(.top, 400)
                
                if !validationResult.isEmpty {
                    Text(validationResult)
                        .font(.custom("HATTEN", size: 30))
                        .padding(.top, 500)
                        .foregroundColor(.white)
                }
            }
            .onAppear {
                generateGrid()
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    private func generateGrid() {
        grid = Array(repeating: Array(repeating: Cell(), count: gridSize.cols), count: gridSize.rows)
        
        for _ in 0..<(gridSize.rows * gridSize.cols / 10) {
            let randomRow = Int.random(in: 0..<gridSize.rows)
            let randomCol = Int.random(in: 0..<gridSize.cols)
            grid[randomRow][randomCol].number = Int.random(in: 1...6)
        }
        
        for row in 0..<gridSize.rows {
            for col in 0..<gridSize.cols {
                if grid[row][col].number == nil, Bool.random() {
                    grid[row][col].isBlack = true
                }
            }
        }
    }

    private func validateGrid() -> Bool {
        return areBlackCellsConnected() && areIslandsValid()
    }

    private func areBlackCellsConnected() -> Bool {
        let rows = grid.count
        let cols = grid[0].count
        var visited = Array(repeating: Array(repeating: false, count: cols), count: rows)
        
        var blackCells = [(Int, Int)]()
        for row in 0..<rows {
            for col in 0..<cols {
                if grid[row][col].isBlack {
                    blackCells.append((row, col))
                }
            }
        }

        guard let start = blackCells.first else { return true }

        func dfs(row: Int, col: Int) {
            if row < 0 || col < 0 || row >= rows || col >= cols || visited[row][col] || !grid[row][col].isBlack {
                return
            }
            visited[row][col] = true
            let directions = [(-1, 0), (1, 0), (0, -1), (0, 1), (-1, -1), (-1, 1), (1, -1), (1, 1)]
            for direction in directions {
                dfs(row: row + direction.0, col: col + direction.1)
            }
        }

        dfs(row: start.0, col: start.1)
        let connectedBlackCells = visited.flatMap { $0 }.filter { $0 }.count
        return connectedBlackCells == blackCells.count
    }


    private func areIslandsValid() -> Bool {
        let rows = grid.count
        let cols = grid[0].count
        var visited = Array(repeating: Array(repeating: false, count: cols), count: rows)

        func dfs(row: Int, col: Int) -> [(Int, Int)] {
            if row < 0 || col < 0 || row >= rows || col >= cols || visited[row][col] || (!grid[row][col].isPartOfIsland && grid[row][col].number == nil) {
                return []
            }
            visited[row][col] = true
            var island = [(row, col)]
            let directions = [(-1, 0), (1, 0), (0, -1), (0, 1), (-1, -1), (-1, 1), (1, -1), (1, 1)]
            for direction in directions {
                island += dfs(row: row + direction.0, col: col + direction.1)
            }
            return island
        }

        for row in 0..<rows {
            for col in 0..<cols {
                if (grid[row][col].isPartOfIsland || grid[row][col].number != nil) && !visited[row][col] {
                    let island = dfs(row: row, col: col)
                    let numberCells = island.filter { grid[$0.0][$0.1].number != nil }
                    if numberCells.count > 0 {
                        let expectedNumber = grid[numberCells.first!.0][numberCells.first!.1].number
                        if !numberCells.allSatisfy({ grid[$0.0][$0.1].number == expectedNumber }) {
                            return false
                        }
                    }
                    if numberCells.count == 1 && numberCells.count != island.count {
                        return false
                    }
                }
            }
        }
        return true
    }


}

struct GridView: View {
    @Binding var grid: [[Cell]]
    let gridSize: (rows: Int, cols: Int)

    var body: some View {
        VStack(spacing: 2) {
            ForEach(0..<gridSize.rows, id: \.self) { row in
                HStack(spacing: 2) {
                    ForEach(0..<gridSize.cols, id: \.self) { col in
                        CellView(cell: $grid[row][col])
                            .frame(width: 30, height: 30)
                    }
                }
            }
        }
        .padding()
    }
}

struct CellView: View {
    @Binding var cell: Cell

    var body: some View {
        ZStack {
            if cell.isBlack {
                Color.black
            } else if let number = cell.number {
                Color.white
                    .overlay(Text("\(number)").foregroundColor(.black))
            } else if cell.isPartOfIsland {
                Color.blue.opacity(0.8)
            } else {
                Color.white
            }
        }
        .border(Color.black, width: 1)
        .onTapGesture {
            toggleState()
        }
    }

    private func toggleState() {
        if cell.number != nil { return }

        if cell.isBlack {
            cell.isBlack = false
            cell.isPartOfIsland = true
        } else if cell.isPartOfIsland {
            cell.isPartOfIsland = false
        } else {
            cell.isBlack = true
        }
    }
}

#Preview {
    NurikabeGame()
}

