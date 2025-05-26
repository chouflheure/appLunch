
import SwiftUI

struct CellAskFriend: View {
    @Binding var isAskFriend: Bool
    @Binding var isAcceptedFriend: Bool
    @State var isShowProfile: Bool = false
    var userContact: UserContact
    var onClick: (() -> Void)
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Button(action: {
                    onClick()
                }) {
                    CachedAsyncImageView(
                        urlString: userContact.profilePictureUrl,
                        designType: .scaleImageMessageProfile
                    )
                    .padding(.trailing, 5)
                    /*
                    Image(.header)
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                        .frame(width: 35, height: 35)
                    */
                        .padding(.trailing, 5)
                }

                HStack {
                    (Text(userContact.pseudo)
                        .tokenFont(.Body_Inter_Medium_14)
                        .bold()
                     + Text(" ")
                     + Text("veut t’ajouter à ces amis.")
                        .tokenFont(.Body_Inter_Medium_14)
                     + Text(" ")
                     + Text("4min")
                        .tokenFont(.Placeholder_Inter_Regular_14)
                    )
                    .multilineTextAlignment(.leading)
                }
                .frame(height: 40)
                .padding(.trailing, 12)
                
                Spacer()
                
                HStack {
                    Button(action: {
                        isAcceptedFriend = true
                        isAskFriend = false
                    }) {
                        Text("Accepter")
                            .tokenFont(.Body_Inter_Medium_12)
                            .foregroundColor(.white)
                    }
                    .padding(.all, 10)
                    .background(.purpleLight)
                    .cornerRadius(10)
                    
                    Button(action: {
                        isAcceptedFriend = false
                        isAskFriend = false
                    }) {
                        Text("Refuser")
                            .foregroundColor(.white)
                            .tokenFont(.Body_Inter_Medium_12)
                            
                    }
                    .padding(.all, 9)
                    .cornerRadius(10)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(lineWidth: 1)
                            .foregroundColor(.white)
                    }
                }
            }
        }
        .padding(.horizontal, 12)
        .frame(height: 70)
        .background(.gray.opacity(0.4))
        .onTapGesture {
            onClick()
        }
    }
}
