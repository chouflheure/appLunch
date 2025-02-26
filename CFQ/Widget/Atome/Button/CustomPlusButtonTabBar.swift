
import SwiftUI

struct CustomPlusButtonTabBar: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(LinearGradient(
                    gradient: Gradient(colors: [Color.purple, Color.blue.opacity(0.4)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
                .blur(radius: 1, opaque: true)
                .cornerRadius(10)
                .frame(width: 55, height: 55)

            Rectangle()
                .foregroundColor(.black)
                .cornerRadius(10)
                .frame(width: 50, height: 50)
                .shadow(radius: 30)

            Image(systemName: "plus")
                .font(.system(size: 30, weight: .bold))
                .foregroundColor(.white)
        }
    }
}
