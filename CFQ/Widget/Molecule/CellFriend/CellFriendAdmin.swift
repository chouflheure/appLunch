
import SwiftUI

struct CellFriendAdmin: View {
    var name: String
    @Binding var isEditingAdmin: Bool
    @Binding var isAdmin: Bool

    var body: some View {
        ZStack {
            CellRoundedImageAndName(name: name)
                .padding(.leading, 10)
            
            Button(action: {
                if isEditingAdmin {
                    isAdmin.toggle()
                    print("@@@ tap")
                }
            }) {
                Image(.iconCrown)
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(isEditingAdmin && !isAdmin ? .white : .yellow)
                    .frame(width: 40, height: 40)
                    .offset(x: 8, y: -52)
                    .rotationEffect(Angle(degrees: 30))
                    .opacity(isAdmin || isEditingAdmin ? 1 : 0)
            }
            .frame(width: 60, height: 60)
        }
    }
}

#Preview {
    ZStack {
        NeonBackgroundImage()
        CellFriendAdmin(name: "test", isEditingAdmin: .constant(false), isAdmin: .constant(false))
    }
}
