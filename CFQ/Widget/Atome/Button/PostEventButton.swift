
import SwiftUI

struct PostEventButton: View{
    var action: () -> Void
    var cornerRadius: CGFloat = 6
    @Binding var isEnable: Bool

    var body: some View {
        Button(action: action, label: {
            Text("Poster")
                .foregroundColor(.white.opacity(isEnable ? 1 : 0.5))
                .padding(.horizontal, 15)
                .padding(.vertical, 10)
                .font(.system(size: 15, weight: .bold))
        })
        .background(Color(hex: "B098E6").opacity(isEnable ? 1 : 0.5))
        .cornerRadius(10)
        .disabled(!isEnable)
    }

}
