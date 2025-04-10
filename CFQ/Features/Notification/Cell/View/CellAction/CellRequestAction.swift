
import SwiftUI

struct CellRequestAction: View {
    @State var isAskFriend = true
    @State var isAcceptedFriend = true

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if isAskFriend {
                CellAskFriend(
                    isAskFriend: $isAskFriend,
                    isAcceptedFriend: $isAcceptedFriend
                )
            } else {
                CellResponseFriend(isAcceptedFriend: isAcceptedFriend)
            }
        }
        .frame(height: 50)
    }
}

#Preview {
    ZStack {
        Color.black
        CellRequestAction()
    }
    .ignoresSafeArea()
}
