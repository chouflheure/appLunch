
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
                .cornerRadius(5)
                .frame(width: 40, height: 40)

            Rectangle()
                .foregroundColor(.black)
                .cornerRadius(5)
                .frame(width: 35, height: 35)
                .shadow(radius: 5)

            Image(systemName: "plus")
                .font(.system(size: 25, weight: .medium))
                .foregroundColor(.white)
        }
    }
}

#Preview {
    CustomPlusButtonTabBar()
}
