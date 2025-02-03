
import SwiftUI

struct CFQMolecule: View {
    @State var name: String
    @State var title: String

    let gradientBackground = LinearGradient(
        gradient: Gradient(colors: [Color(hex: "C6E7FF"), Color(hex: "A7A9E5")]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    var body: some View {
        ZStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 5) {
                Text(name)
                    .padding(.leading, 55)
                    .padding(.top, 5)
                    .foregroundColor(.white)

                Text(title)
                    .frame(height: 30)
                    .font(.system(size: 14))
                    .padding(.leading, 55)
                    .padding(.trailing, 15)
                    .foregroundColor(.white)
                    .background(gradientBackground)
                    .cornerRadius(20)
                    .padding(.bottom, 5)
            }
            .padding(.leading, 10)

            Image(.header)
                .resizable()
                .scaledToFill()
                .frame(width: 60, height: 60)
                .cornerRadius(100)
        }
    }
}

#Preview {
    ZStack {
        Image(.backgroundNeon)
        CFQMolecule(name: "Charles", title: "CFQ CE SOIR ?")
    }.ignoresSafeArea()
}
