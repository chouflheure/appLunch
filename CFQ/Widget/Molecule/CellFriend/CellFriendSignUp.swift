
import SwiftUI

struct CellFriendSignUp: View {
    let userPreview: UserContactPhoneNumber
    @State var isSelected: Bool = false
    @State var isAskToBeFriend: ((_ askToBeFriend: Bool) -> Void)
    
    var body: some View {
        HStack(spacing: 15) {
            
            CirclePicture(urlStringImage: userPreview.profilePictureUrl)
                .frame(width: 40, height: 40)

            Text(userPreview.pseudo)
                .tokenFont(.Body_Inter_Medium_16)

            Text("~ " + userPreview.name + " ")
                .tokenFont(.Placeholder_Inter_Regular_16)

            Spacer()

            Button(action: {
                withAnimation {
                    isSelected.toggle()
                }
                
                isAskToBeFriend(isSelected)
                
                Logger.log(
                    isSelected ? "Demande d'ajout d'ami lors de l'inscription" : "Annulation de la demande d'ami",
                    level: .info
                )
            }) {
                if isSelected {
                    Text(StringsToken.General.cancel)
                        .tokenFont(.Body_Inter_Medium_16)
                } else {
                    Image(.iconAdduser)
                        .foregroundColor(.white)
                }
            }
        }
        .frame(
            maxWidth: .infinity,
            alignment: .init(horizontal: .leading, vertical: .top)
        )
        .padding(.horizontal, 16)
    }
}
