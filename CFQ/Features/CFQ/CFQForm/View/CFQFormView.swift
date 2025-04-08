
import SwiftUI

struct CFQFormView: View {
    @State var text = String()
    @State var guestNumber = 0
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center, spacing: 0) {
                Text("CFQ ?")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.leading, 40)

                Button(action: {
                    Logger.log("Click to close CFQForm", level: .action)
                }) {
                    Image(.iconCross)
                        .foregroundStyle(.white)
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
                
                CustomTextField(
                    text: $text,
                    keyBoardType: .default,
                    placeHolder: "CFQ",
                    textFieldType: .cfq
                )
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
            
            HStack {
                Spacer()
                PostEventButton(action: {})
                    .padding(.trailing, 16)
            }

            // Bazar(arrayPicture: arrayPicture, arrayFriends: arrayFriends)
        }

    }
}

#Preview {
    ZStack {
        NeonBackgroundImage()
        CFQFormView()
    }.ignoresSafeArea()
}


struct CellFriendsAdd: View {
    var name: String
    var onAdd: (() -> Void)

    var body: some View {
        HStack(spacing: 0){
            CirclePicture()
                .frame(width: 48, height: 48)
            HStack {
                Text(name)
                    .foregroundColor(.white)
                    .padding(.leading, 8)
                    .lineLimit(1)
            }
            Spacer()
            Button(action: {
                onAdd()
            }) {
                Image(systemName: "plus")
                    .foregroundColor(.purpleText)
                    .frame(width: 24, height: 24)
            }
        }.padding(.horizontal, 16)
    }
}

struct CellTeamAdd: View {
    var name: String
    var teamNumber: Int

    var body: some View {
        HStack(spacing: 0){
            CirclePicture()
                .frame(width: 48, height: 48)
            HStack {
                Text(name)
                    .foregroundColor(.white)
                    .padding(.leading, 8)
                    .lineLimit(1)
                Text("-")
                    .foregroundColor(.white)
                Text("\(teamNumber) membres")
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
        NeonBackgroundImage()
        // CellFriendsAdd()
    }.ignoresSafeArea()
}
