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
                Text("Invité\(arrayPicture.count > 1 ? "s" : "") :")
                    .foregroundColor(.white)

                Text(arrayPicture.count.description)
                    .foregroundColor(.white)
            }.padding(.horizontal, 16)

            VStack(alignment: .leading) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(Array(arrayPicture), id: \.self) { friend in
                            NavigationLink(
                                destination: FriendProfileView(
                                    coordinator: coordinator,
                                    user: coordinator.user ?? User(),
                                    friend: friend
                                )
                            ) {
                                CellFriendCanRemove(userPreview: friend) {
                                    onRemove(friend)
                                }
                            }
                        }.frame(height: 100)
                    }
                }
            }

            Divider()
                .background(.white)

            VStack {
                ScrollView(.vertical) {
                    VStack(alignment: .leading) {
                        ForEach(Array(arrayFriends), id: \.self) { friend in
                            NavigationLink(
                                destination: FriendProfileView(
                                    coordinator: coordinator,
                                    user: coordinator.user ?? User(),
                                    friend: friend
                                )
                            ) {
                                CellFriendsAdd(userPreview: friend) {
                                    onAdd(friend)
                                }
                                .padding(.top, 15)
                            }
                        }
                    }
                }
            }
        }
    }
}
