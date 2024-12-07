import SwiftUI

struct ContentView: View {
    @State private var currentImage = "l1"
    @State private var progress = 0
    @State private var timerRunning = true
    @State private var navigateToGame = false

    private let images = ["l1", "l2", "l3", "l1"]

    var body: some View {
        NavigationStack {
            ZStack {
                Image("fon")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
                
                VStack {
                    ZStack {
                        Image(currentImage)
                            .resizable()
                            .frame(width: 150, height: 150)
                            .animation(.easeInOut, value: currentImage)
                        
                        Text("\(progress)%")
                            .font(.custom("HATTEN", size: 30))
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()
                    }
                    
                    Spacer()
                        .frame(height: 50)
                    
                    Image("Loading")
                }
                .padding(.top, 400)
                
                NavigationLink("", destination: Games(), isActive: $navigateToGame)
                    .hidden()
            }
            .onAppear {
                startLoadingAnimation()
            }
        }
    }

    private func startLoadingAnimation() {
        Timer.scheduledTimer(withTimeInterval: 0.7, repeats: true) { timer in
            if progress >= 100 {
                timer.invalidate()
                timerRunning = false
                navigateToGame = true
            } else {
                progress += 25
                currentImage = images[(progress / 25) % images.count]
            }
        }
    }
}


#Preview {
    ContentView()
}

