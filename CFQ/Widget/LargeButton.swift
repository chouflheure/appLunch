
import SwiftUI


enum LargeButtonType {
    case signNext
    case signBack
    case teamCreate
    case addParticipant
    
    var data: LargeButtonData {
        switch self {
        case .signNext, .addParticipant:
            return LargeButtonData(
                background: .black,
                foregroundColor: .white,
                stoke: true
            )
        case .signBack:
            return LargeButtonData(
                background: .clear,
                foregroundColor: .purple,
                stoke: false
            )
        case .teamCreate:
            return LargeButtonData(
                background: .white,
                foregroundColor: .black,
                stoke: false
            )
        }
    }
}

struct LargeButtonData {
    let background: Color
    let foregroundColor: Color
    let stoke: Bool
}

struct FullButtonLogIn: View{
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
                        .stroke(Color.white, lineWidth: largeButtonType.data.stoke ? 0.5 : 0)
                )
                
        })
    }
}

#Preview {
    ZStack {
        NeonBackgroundImage()
        VStack {
            FullButtonLogIn(action: {}, title: "Connexion", largeButtonType: .signNext)
            FullButtonLogIn(action: {}, title: "Connexion", largeButtonType: .signBack)
            FullButtonLogIn(action: {}, title: "Connexion", largeButtonType: .addParticipant)
            FullButtonLogIn(action: {}, title: "Connexion", largeButtonType: .teamCreate)
        }
    }.ignoresSafeArea()
}
