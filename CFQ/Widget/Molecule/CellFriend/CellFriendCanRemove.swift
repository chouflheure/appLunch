
import SwiftUI

struct CellFriendCanRemove: View {
    var userPreview: UserContact
    var onRemove: (() -> Void)

    var body: some View {
        ZStack {
            CellRoundedImageAndName(userPreview: userPreview)
            .padding(.leading, 17)

            Button(action: {
                onRemove()
            }) {
                Image(systemName: "xmark")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 8, height: 8)
                    .foregroundColor(.black)
                    .padding(6)
                    .background(Color.white)
                    .clipShape(Circle())
            }
            .offset(x: 35, y: -30)
        }.background(.clear)
    }
}
