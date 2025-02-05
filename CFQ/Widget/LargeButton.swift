
import SwiftUI


enum LargeButtonTpe {
    case signNext
    case signBack
    case team
}

struct LargeButtonData {
    
}

struct FullButtonLogIn: View{
    var action: () -> Void
    var title: String
    var color: Color
    var cornerRadius: CGFloat = 6

    var body: some View {
        Button(action: action, label: {
            Text(title)
                .foregroundColor(color)
                .padding()
                .frame(maxWidth: .infinity)
                .background(.black)
                .cornerRadius(cornerRadius)
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(Color.white, lineWidth: 0.5)
                )
                
        })
    }
}

struct PurpleButtonLogIn: View {
    var action: () -> Void
    var title: String
    var cornerRadius: CGFloat = 6

    var body: some View {
        Button(action: action, label: {
            Text(title)
                .foregroundColor(.purple)
                .padding()
                .frame(maxWidth: .infinity)
                .background(.clear)
        })
    }
}

#Preview {
    ZStack {
        NeonBackgroundImage()
        VStack {
            FullButtonLogIn(action: {}, title: "Connexion", color: .black)
            PurpleButtonLogIn(action: {}, title: "Connexion")
        }
    }.ignoresSafeArea()
}
