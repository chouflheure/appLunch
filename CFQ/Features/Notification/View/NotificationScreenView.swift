import SwiftUI

struct NotificationScreenView: View {
    @ObservedObject var coordinator: Coordinator
    @StateObject var vm = NotificationViewModel()
    
    var body: some View {
        DraggableViewLeft(isPresented: $coordinator.showNotificationScreen) {
            SafeAreaContainer {
                VStack {
                    HStack(alignment: .center) {
                        Button(
                            action: {
                                withAnimation {
                                    coordinator.showNotificationScreen = false
                                }
                            },
                            label: {
                                Image(.iconArrow)
                                    .foregroundColor(.white)
                                    .frame(width: 24, height: 24)
                            })
                        Spacer()

                        Text("NOTIFICATIONS")
                            .tokenFont(.Title_Gigalypse_24)

                        Spacer()
                    }
                    .padding(.horizontal, 12)
                    .padding(.bottom, 10)

                    Divider()
                        .frame(height: 0.5)
                        .background(.white)
                        .padding(.bottom, 15)

                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 24) {
                            Text("Aujourd'hui")
                                .tokenFont(.Body_Inter_Medium_16)
                                .padding(.horizontal, 12)
                            CellRequestAction(
                                userContact: UserContact(
                                    uid: "",
                                    name: "",
                                    pseudo: "Lisa",
                                    profilePictureUrl:
                                        "https://firebasestorage.googleapis.com:443/v0/b/cfq-dev-7c39a.firebasestorage.app/o/images%2FJtISdWec8JV4Od1WszEGXkqEVAI2.jpg?alt=media&token=465277cd-251a-4810-87cb-2ca6834a7c6a",
                                    isActive: false
                                ),
                                onClick: {
                                    showProfileFriend(
                                        profileFriend:
                                            UserContact(
                                                uid: "",
                                                name: "",
                                                pseudo: "Lisa",
                                                profilePictureUrl:
                                                    "https://firebasestorage.googleapis.com:443/v0/b/cfq-dev-7c39a.firebasestorage.app/o/images%2FJtISdWec8JV4Od1WszEGXkqEVAI2.jpg?alt=media&token=465277cd-251a-4810-87cb-2ca6834a7c6a",
                                                isActive: false
                                            )
                                    )
                                }
                            )

                            Text("Hier")
                                .tokenFont(.Body_Inter_Medium_16)
                                .padding(.horizontal, 12)

                            CellRequestAction(
                                userContact: UserContact(
                                    uid: "",
                                    name: "",
                                    pseudo: "Lisa",
                                    profilePictureUrl:
                                        "https://firebasestorage.googleapis.com:443/v0/b/cfq-dev-7c39a.firebasestorage.app/o/images%2FJtISdWec8JV4Od1WszEGXkqEVAI2.jpg?alt=media&token=465277cd-251a-4810-87cb-2ca6834a7c6a",
                                    isActive: false
                                ),
                                onClick: {}
                            )
                            CellRequestAction(
                                userContact: UserContact(
                                    uid: "",
                                    name: "",
                                    pseudo: "Lisa",
                                    profilePictureUrl:
                                        "https://firebasestorage.googleapis.com:443/v0/b/cfq-dev-7c39a.firebasestorage.app/o/images%2FJtISdWec8JV4Od1WszEGXkqEVAI2.jpg?alt=media&token=465277cd-251a-4810-87cb-2ca6834a7c6a",
                                    isActive: false
                                ),
                                onClick: {}
                            )
                            CellRequestAction(
                                userContact: UserContact(
                                    uid: "",
                                    name: "",
                                    pseudo: "Lisa",
                                    profilePictureUrl:
                                        "https://firebasestorage.googleapis.com:443/v0/b/cfq-dev-7c39a.firebasestorage.app/o/images%2FJtISdWec8JV4Od1WszEGXkqEVAI2.jpg?alt=media&token=465277cd-251a-4810-87cb-2ca6834a7c6a",
                                    isActive: false
                                ),
                                onClick: {}
                            )
                        }
                    }
                }
            }
        }
    }

    func showProfileFriend(profileFriend: UserContact) {
        coordinator.profileUserSelected = User(
            uid: profileFriend.uid,
            name: profileFriend.name,
            pseudo: profileFriend.pseudo,
            profilePictureUrl: profileFriend.profilePictureUrl,
            isActive: profileFriend.isActive
        )
        withAnimation {
            coordinator.showProfileFriend = true
        }
    }
}

#Preview {
    SafeAreaContainer {
        NotificationScreenView(coordinator: Coordinator())
    }
}
