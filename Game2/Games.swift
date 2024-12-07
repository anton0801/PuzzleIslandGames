import SwiftUI

struct Games: View {
    @State private var currentGameIndex = 0
    @State private var showTop = false
    let games = [
        ("NURIKABE1", "nurikabe"),
        ("HASHI1", "Hashi"),
        ("SLITHERLINK1", "Slitherlink")
    ]

    var body: some View {
        NavigationView {
            ZStack {
                Image("fon")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()

                VStack {

                    Image(games[currentGameIndex].0)
                        .resizable()
                        .frame(width: 250,height: 50)
                    Spacer()
                        .frame(height: 30)
                    Image(games[currentGameIndex].1)

                    if currentGameIndex == 0 {
                        NavigationLink(destination: NurikabeGame()) {
                            Image("play")
                                .resizable()
                                .frame(width: 220, height: 110)
                        }
                    } else {
                        Button(action: {

                        }, label: {
                            ZStack{
                                Image("locked")
                                    .resizable()
                                    .frame(width: 220, height: 110)
                                Text("LOCKED")
                                    .font(.custom("HATTEN", size: 40))
                                    .foregroundColor(.white)
                                   
                            }
                        })
                    }

                    Image("swipeNext")
                    Spacer()
                        .frame(height: 30)

                    ZStack {
                        HStack(spacing: 30) {
                            Button(action: {
                                showTop = true
                            }, label: {
                                Image("coliseum")
                            })
                            .fullScreenCover(isPresented: $showTop) {
                                TopScore()
                            }
//                            Button(action: {}, label: {
//                                Image("piramyd")
//                            })
//                            Button(action: {}, label: {
//                                Image("prize")
//                            })
                        }
                    }
                }
            }
            .gesture(
                DragGesture()
                    .onEnded { value in
                        if value.translation.width < -50 {
                            currentGameIndex = (currentGameIndex + 1) % games.count
                        } else if value.translation.width > 50 {
                            currentGameIndex = (currentGameIndex - 1 + games.count) % games.count
                        }
                    }
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarBackButtonHidden(true)
    }
}


#Preview {
    Games()
}

