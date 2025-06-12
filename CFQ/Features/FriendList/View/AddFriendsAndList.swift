import SwiftUI

struct AddFriendsAndListView: View {
    @Binding var arrayPicture: Set<UserContact>
    @Binding var arrayFriends: Set<UserContact>
    @ObservedObject var coordinator: Coordinator

    var onRemove: ((UserContact) -> Void)
    var onAdd: ((UserContact) -> Void)
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Invités")
                    .foregroundColor(.white)
                Text(arrayPicture.count.description)
                    .foregroundColor(.white)
            }.padding(.horizontal, 16)

            VStack(alignment: .leading) {
                ScrollView(.horizontal, showsIndicators: false) {
                    VStack {
                        HStack {
                            ForEach(Array(arrayPicture), id: \.self) { user in
                                CellFriendCanRemove(userPreview: user) {
                                    onRemove(user)
                                }
                                .onTapGesture {
                                    coordinator.profileUserSelected = User(
                                        uid: user.uid,
                                        name: user.name,
                                        pseudo: user.pseudo,
                                        profilePictureUrl: user.profilePictureUrl,
                                        isActive: user.isActive
                                    )
                                    withAnimation {
                                        coordinator.showProfileFriend = true
                                    }
                                }
                            }.frame(height: 100)
                        }
                    }
                }
            }

            Divider()
                .background(.white)

            VStack {
                ScrollView(.vertical) {
                    VStack(alignment: .leading) {
                        ForEach(Array(arrayFriends), id: \.self) { user in
                            CellFriendsAdd(userPreview: user) {
                                onAdd(user)
                            }
                            .padding(.top, 15)
                            .onTapGesture {
                                print("@@@ tap cell")
                                coordinator.profileUserSelected = User(
                                    uid: user.uid,
                                    name: user.name,
                                    pseudo: user.pseudo,
                                    profilePictureUrl: user.profilePictureUrl,
                                    isActive: user.isActive
                                )
                                withAnimation {
                                    coordinator.showProfileFriend = true
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
