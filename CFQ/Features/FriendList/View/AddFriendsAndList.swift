import SwiftUI

struct AddFriendsAndListView: View {
    @Binding var arrayPicture: Set<UserContact>
    @Binding var arrayFriends: Set<UserContact>
    var onRemove: ((UserContact) -> Void)
    var onAdd: ((UserContact) -> Void)
    
    var body: some View {

        VStack(alignment: .leading) {
            HStack {
                Text("Invités")
                    .foregroundColor(.white)
                Text("(\(arrayPicture.count))")
                    .foregroundColor(.white)
            }.padding(.horizontal, 16)

            VStack(alignment: .leading) {
                ScrollView(.horizontal, showsIndicators: false) {
                    VStack {
                        HStack {
                            ForEach(Array(arrayPicture), id: \.self) { user in
                                CellFriendCanRemove(name: user.name) {
                                    onRemove(user)
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
                            CellFriendsAdd(name: user.name) {
                                onAdd(user)
                            }
                            .padding(.top, 15)
                        }
                    }
                }
            }
        }
    }
}
