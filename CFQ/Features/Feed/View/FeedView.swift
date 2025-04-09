
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
                }

                Spacer()

                NotificationButtonIcon(
                    numberNotificationUnRead: 0,
                    icon: .iconNotifs,
                    onTap: {
                    withAnimation {
                        coordinator.showNotificationScreen = true
                    }
                })

                NotificationButtonIcon(
                    numberNotificationUnRead: 10,
                    icon: .iconMessagerie,
                    onTap: {
                    withAnimation {
                        coordinator.showNotificationScreen = true
                    }
                })
                
            }.padding(.horizontal, 12)

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


struct NotificationButtonIcon: View {
    var numberNotificationUnRead: Int
    var icon: ImageResource
    var onTap: ( () -> Void )
    
    var body: some View {
        Button(action: {
            withAnimation {
                onTap()
            }
        }) {
            ZStack {
                Image(icon)
                    .frame(width: 24, height: 24)
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                
                if numberNotificationUnRead > 0 {
                    Circle()
                        .fill(Color.red)
                        .frame(width: 12, height: 12)
                        .offset(x: 12, y: -12)
                }
            }
        }
    }
}
