import SwiftUI

struct Bazar: View {
    @Binding var arrayPicture: Set<UserContact>
    @Binding var arrayFriends: Set<UserContact>
    var onRemove: ((UserContact) -> Void)
    var onAdd: ((UserContact) -> Void)
    
    var body: some View {
        // Recherche bar
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
                                CellPictureCanRemove(name: user.name) {
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
                        }
                        /*
                        ForEach(arrayFriends.indices, id: \.self) { index in
                            CellFriendsAdd(name: arrayFriends[index].name)
                                .padding(.top, 10)
                        }
                         */
                    }
                }
            }
        }
        .background(.clear)
    }
}

struct CellPictureCanRemove: View {
    var name: String
    var onRemove: (() -> Void)

    var body: some View {
        ZStack {
            VStack(alignment: .center) {
                CirclePicture()
                    .frame(width: 48, height: 48)
                Text(name)
                    .tokenFont(.Body_Inter_Medium_12)
            }
            .padding(.leading, 17)

            Button(action: {
                onRemove()
            }) {
                Image(systemName: "xmark")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 8, height: 8)
                    .foregroundColor(.black)
                    .padding(6)
                    .background(Color.white)
                    .clipShape(Circle())
            }
            .offset(x: 35, y: -30)
        }.background(.clear)
    }
}

#Preview {
    ZStack {
        NeonBackgroundImage()
        // CellPictureCanRemove(name: "name Test")
    }.ignoresSafeArea()
}
