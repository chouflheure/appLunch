
import SwiftUI

struct PostEventButton: View{
    var action: () -> Void
    var cornerRadius: CGFloat = 6

    var body: some View {
        Button(action: action, label: {
            HStack {
                Text("Poster")
                    .foregroundColor(.white)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 10)
                    .font(.system(size: 15, weight: .bold))
            }
        })
        .background(Color(hex: "B098E6"))
        .cornerRadius(10)
    }

}

#Preview {
    PostEventButton(action: {})
}
