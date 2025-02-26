
import SwiftUI

struct LargeButtonView: View{
    var action: () -> Void
    var title: String
    var largeButtonType: LargeButtonType
    var isDisabled: Bool = false
    var cornerRadius: CGFloat = 12

    var body: some View {
        Button(action: action, label: {
            Text(title)
                .foregroundColor(
                    isDisabled ?
                        largeButtonType.data.foregroundColor.opacity(0.3) :
                        largeButtonType.data.foregroundColor
                )
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    isDisabled ?
                        largeButtonType.data.background.opacity(0.3) :
                        largeButtonType.data.background
                )
                .cornerRadius(cornerRadius)
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(Color.white, lineWidth: largeButtonType.data.hasStoke ? 0.5 : 0)
                )
                
        })
        .disabled(isDisabled)
        .onTapGesture {
            UIApplication.shared.endEditing(true)
        }
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
