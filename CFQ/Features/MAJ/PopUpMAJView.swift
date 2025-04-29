
import SwiftUI
import Lottie

struct PopUpMAJView: View {
    var body: some View {
        ZStack() {
            
            VStack(spacing: 40) {
                Text("Mise à jour dispo")
                    .tokenFont(.Title_Gigalypse_20)
                    .padding(.top, 30)
                    .padding(.horizontal, 15)
                    .multilineTextAlignment(.center)
                
                Text("Une mise à jour est disponible sur le store et doit être faite. Elle va résoudre des bugs limitant la bonne utilisation de l'app")
                    .tokenFont(.Body_Inter_Medium_16)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 15)
                
                
                Button(action: {
                    // TODO: - Renvoyer vers le store
                }, label: {
                    HStack {
                        
                        TextShimmer(text: "Aller sur le store")
                            .foregroundColor(.white)
                            .padding(.horizontal, 15)
                            .padding(.vertical, 10)
                            .font(.system(size: 15, weight: .bold))
                    }
                })
                .frame(width: 150)
                .background(Color(hex: "B098E6"))
                .cornerRadius(10)
            }
            .frame(width: 300, height: 400)
            .background(.blackCard)
            .cornerRadius(12)
            .zIndex(2)
            .padding(.top, 40)
            
            ZStack {
                LottieView(animation: .named("rocketMAJ_WithoutSmoke"))
                    .playing()
                    .looping()
                    .frame(width: 300, height: 300)
                    .rotationEffect(.degrees(45))
                    .offset(y: -80)
            }
            .offset(y: -110)
            .zIndex(3)
        }
    }
}
#Preview {
    PopUpMAJView()
}


struct TextShimmer: View {
    var text: String
    @State var animation = false
    var textSize: CGFloat = 15.0

    var body: some View {
        ZStack {
            Text(text)
                .font(.system(size: textSize, weight: .bold))
                .foregroundColor(.white)
            
            HStack(spacing: 0){
                ForEach(0..<text.count, id: \.self) { index in
                    Text(String(text[text.index(text.startIndex, offsetBy: index)]))
                        .font(.system(size: textSize, weight: .bold))
                        .foregroundColor(.purple)
                }
            }
            .mask(
                Rectangle()
                    .fill(
                        LinearGradient(
                            gradient: .init(colors: [.white, .purple, .white]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .rotationEffect(.init(degrees: 70))
                    // .padding(20)
                    .offset(x: -150)
                    .offset(x: animation ? 300 : 0)
            )
            .onAppear(perform: {
                withAnimation(Animation.linear(duration: 2).repeatForever(autoreverses: false)) {
                    animation.toggle()
                }
            })
        }
    }
    
    func randomColor() -> Color {
        let color = UIColor(red: 1, green: .random(in: 0...1), blue: .random(in: 0...1), alpha: 1)
        return Color(color)
    }
}

#Preview {
    TextShimmer(text: "Hello, World!")
        .preferredColorScheme(.dark)
}
