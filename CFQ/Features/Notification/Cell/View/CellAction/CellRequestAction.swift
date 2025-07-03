
import SwiftUI

struct CellRequestAction: View {
    @State var isAskFriend = true
    @State var isAcceptedFriend = true
    var userContact: UserContact
    var onClick: (() -> Void)

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if isAskFriend {
                CellAskFriend(
                    isAskFriend: $isAskFriend,
                    isAcceptedFriend: $isAcceptedFriend,
                    userContact: userContact,
                    onClick: onClick
                )
            } else {
                // CellResponseFriend(userContact: userContact, isAcceptedFriend: isAcceptedFriend)
            }
        }
        .frame(height: 50)
    }
}
