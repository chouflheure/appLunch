
import SwiftUI

struct FeedView: View {
    @ObservedObject var coordinator: Coordinator
    // @EnvironmentObject var user: User
    var user = User(
        uid: "1234567890",
        name: "John",
        firstName: "Doe",
        pseudo: "johndoe",
        location: ["Ici"],
        friends: ["77MKZdb3FJX8EFvlRGotntxk6oi1"],
        isPrivateAccount: false
    )
    var body: some View {
        VStack {
            HStack {
                Button(action: {}) {
                    Image(.iconAddfriend)
                        .frame(width: 24, height: 24)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Image(.iconNotifs)
                        .frame(width: 24, height: 24)
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                    
                    Image(.iconMessagerie)
                        .frame(width: 24, height: 24)
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 16)
            }

            VStack(alignment: .leading) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack() {
                        SwitchStatusUserProfile(
                            viewModel: SwitchStatusUserProfileViewModel(user: user)
                        )
                        ForEach(0..<5) { index in
                            CirclePictureStatus(isActive: false, onClick: {
                                withAnimation {
                                    coordinator.showProfileFriend = true
                                }
                            })
                                .frame(width: 48, height: 48)
                                .padding(.leading, 17)
                                .onTapGesture {
                                    
                                }
                        }.frame(height: 100)
                    }
                }
            }
            
            Divider()
                .background(.white)

            CFQCollectionView()

            Divider()
                .background(.white)
        }
    }
}


#Preview {
    ZStack {
        NeonBackgroundImage()
        FeedView(coordinator: .init())
    }.ignoresSafeArea()
}
