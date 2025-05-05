
import SwiftUI

struct CellFriendPseudoNameAction: View {
    enum CellFriendPseudoNameActionType {
        case remove
        case add
    }
    
    var pseudo: String
    var name: String
    var firstName: String
    var coordinator: Coordinator
    var isSelected: Bool = false
    var type: CellFriendPseudoNameActionType
    var isActionabled: (() -> Void)
    
    var body: some View {
        HStack(spacing: 0) {
            HStack {
                CirclePicture(urlStringImage: "")
                    .frame(width: 48, height: 48)
                VStack(alignment: .leading) {
                    Text(pseudo)
                        .foregroundColor(.white)
                        .lineLimit(1)
                    HStack {
                        Text(name)
                            .tokenFont(.Body_Inter_Regular_12)
                        Text((firstName.first?.uppercased() ?? "") + ".")
                            .tokenFont(.Body_Inter_Regular_12)
                    }
                }.padding(.leading, 8)
                
                Spacer()
            }
            .onTapGesture {
                withAnimation {
                    coordinator.showProfileFriend = true
                }
            }
            
            Button(action: {
                isActionabled()
            }) {
                if type == .remove {
                    Text("Supprimer")
                        .tokenFont(.Body_Inter_Medium_14)
                } else {
                    Image(.iconCross)
                        .resizable()
                        .frame(width: 14, height: 14)
                        .foregroundColor(.white)
                        .rotationEffect(Angle(degrees: 45))
                }
            }
            .padding(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.white, lineWidth: 1)
            )
        }
    }
}

#Preview {
    ZStack {
        NeonBackgroundImage()
        CellFriendPseudoNameAction(
            pseudo: "Charlouu",
            name: "Charles",
            firstName: "Calvignac",
            coordinator: .init(),
            type: .remove,
            isActionabled: {}
        )
    }.ignoresSafeArea()
}
