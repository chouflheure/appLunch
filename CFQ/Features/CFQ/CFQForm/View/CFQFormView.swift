
import SwiftUI

struct CFQFormView: View {
    @State var guestNumber = 0
    @Binding var isPresented: Bool
    @ObservedObject var viewModel = CFQFormViewModel()

    var body: some View {
        DraggableViewLeft(isPresented: $isPresented) {
            SafeAreaContainer {
                VStack(alignment: .leading) {
                    HeaderBackLeftScreen(
                        onClickBack: {
                            withAnimation {
                                isPresented = false
                            }
                        },
                        titleScreen: "CFQ ?"
                    )
                    
                    VStack {
                        ScrollView(.vertical, showsIndicators: false) {
                            VStack {
                                HStack(alignment: .center, spacing: 12) {
                                    Image(.header)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 50, height: 50)
                                        .cornerRadius(100)
                                    
                                    CustomTextField(
                                        text: $viewModel.titleCFQ,
                                        keyBoardType: .default,
                                        placeHolder: "Demain",
                                        textFieldType: .cfq
                                    )
                                }
                                .padding(.top, 16)
                                .padding(.horizontal, 16)
                                
                                HStack {
                                    Spacer()
                                    PostEventButton(action: {
                                        
                                    })
                                    .padding(.trailing, 16)
                                }
                                .padding(.top, 5)
                                
                                SearchBarView(
                                    text: $viewModel.researchText,
                                    placeholder: StringsToken.SearchBar.placeholderFriend,
                                    onRemoveText: {
                                        viewModel.removeText()
                                    },
                                    onTapResearch: {
                                        viewModel.researche()
                                    }
                                )
                                .padding(.top, 16)
                                
                                AddFriendsAndListView(
                                    arrayPicture: $viewModel.friendsAdd,
                                    arrayFriends: $viewModel.friendsList,
                                    onRemove: { userRemoved in
                                        viewModel.removeFriendsFromList(user: userRemoved)
                                    },
                                    onAdd: { userAdd in
                                        viewModel.addFriendsToList(user: userAdd)
                                    }
                                )
                                .padding(.top, 15)
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ZStack {
        NeonBackgroundImage()
        CFQFormView(isPresented: .constant(true))
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
