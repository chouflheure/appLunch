
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

            Bazar()
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
