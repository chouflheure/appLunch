
import SwiftUI

struct CFQFormView: View {
    @State var text = String()
    @State var guestNumber = 0
    var arrayPicture = [CirclePicture(), CirclePicture(), CirclePicture(), CirclePicture(), CirclePicture(), CirclePicture(), CirclePicture(), CirclePicture()]

    var arrayFriends = [CellFriendsAdd(), CellFriendsAdd(), CellFriendsAdd(), CellFriendsAdd(), CellFriendsAdd(), CellFriendsAdd(), CellFriendsAdd(), CellFriendsAdd()]
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center, spacing: 0) {
                Text("CFQ ?")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.leading, 40)

                Button(action: {}) {
                    Image(.iconCross)
                        .frame(width: 24, height: 24)
                }.padding(.trailing, 16)
            }
            .padding(.top, 50)
            .padding(.bottom, 50)

            Spacer()

            HStack(spacing: 12) {
                Image(.header)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .cornerRadius(100)
                
                TextFieldBGBlackFull(text: $text, keyBoardType: .default, placeHolder: "CFQ")
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
            
            HStack {
                Spacer()
                PostEventButton(action: {})
                    .padding(.trailing, 16)
            }
            
            // Recherche bar
            
            HStack {
                Text("Invités")
                    .foregroundColor(.white)
                Text("(\(arrayPicture.count))")
                    .foregroundColor(.white)
            }.padding(.horizontal, 16)
            
            VStack(alignment: .leading) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack() {
                        ForEach(arrayPicture.indices, id: \.self) { index in
                            ZStack {
                                arrayPicture[index]
                                    .frame(width: 48, height: 48)
                                    .padding(.leading, 17)
                                Button(action: {
                                    print("Bouton fermé")
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
                                .offset(x: 35, y: -20)
                            }.frame(height: 100)
                        }
                    }
                }
            }
            Divider()
                .background(.white)
            
            VStack {
                ScrollView(.vertical) {
                    ForEach(arrayPicture.indices, id: \.self) { index in
                        ZStack {
                            arrayFriends[index]
                                .padding(.top, 30)
                        }
                    }
                }
            }
        }

    }
}

#Preview {
    ZStack {
        Image(.backgroundNeon)
            .resizable()
        CFQFormView()
    }.ignoresSafeArea()
}


struct CellFriendsAdd: View {
    var body: some View {
        HStack(spacing: 0){
            CirclePicture()
                .frame(width: 48, height: 48)
            HStack {
                Text("les méchantes")
                    .foregroundColor(.white)
                    .padding(.leading, 8)
                    .lineLimit(1)
                Text("-")
                    .foregroundColor(.white)
                Text("7 membres")
                    .foregroundColor(.whiteSecondary)
            }
            Spacer()
            Button(action: {}) {
                Image(systemName: "plus")
                    .foregroundColor(.purpleText)
                    .frame(width: 24, height: 24)
            }
        }.padding(.horizontal, 16)
    }
}

#Preview {
    ZStack {
        Image(.backgroundNeon)
            .resizable()
        CellFriendsAdd()
    }.ignoresSafeArea()
}
