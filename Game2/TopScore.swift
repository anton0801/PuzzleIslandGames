import SwiftUI

struct TopScore: View {
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        ZStack {
            Image("fon2")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
            Image("top")
                .resizable()
                .frame(width: 350)
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Image("back")
                    .resizable()
                    .frame(width: 70, height: 70)
            })
            .padding(.top,-380)
            .padding(.trailing, 290)
          
        }

    }
}

#Preview {
    TopScore()
}
