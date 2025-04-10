
import SwiftUI

struct CellFriendPseudoNoAction: View {
    var pseudo: String
    var coordinator: Coordinator
    var isSelected: Bool = false

    var body: some View {
        HStack(spacing: 0) {
            HStack {
                CirclePicture()
                    .frame(width: 48, height: 48)
                
                Text(pseudo)
                    .foregroundColor(.white)
                    .padding(.leading, 8)
                
                Spacer()
            }
            .onTapGesture {
                withAnimation {
                    coordinator.showProfileFriend = true
                }
            }
        }
    }
}

struct CellFriendPseudoNoAction_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            NeonBackgroundImage()
            CellFriendPseudoNoAction(
                pseudo: "Charlouu",
                coordinator: .init()
            )
        }.ignoresSafeArea()
    }
}
