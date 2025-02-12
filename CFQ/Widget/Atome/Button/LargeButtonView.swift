
import SwiftUI

struct LargeButtonView: View{
    var action: () -> Void
    var title: String
    var largeButtonType: LargeButtonType
    var cornerRadius: CGFloat = 12

    var body: some View {
        Button(action: action, label: {
            Text(title)
                .foregroundColor(largeButtonType.data.foregroundColor)
                .padding()
                .frame(maxWidth: .infinity)
                .background(largeButtonType.data.background)
                .cornerRadius(cornerRadius)
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(Color.white, lineWidth: largeButtonType.data.hasStoke ? 0.5 : 0)
                )
                
        })
    }
}

#Preview {
    ZStack {
        NeonBackgroundImage()
        VStack {
            LargeButtonView(action: {}, title: "Connexion", largeButtonType: .signNext)
            LargeButtonView(action: {}, title: "Connexion", largeButtonType: .signBack)
            LargeButtonView(action: {}, title: "Connexion", largeButtonType: .addParticipant)
            LargeButtonView(action: {}, title: "Connexion", largeButtonType: .teamCreate)
        }
    }.ignoresSafeArea()
}
