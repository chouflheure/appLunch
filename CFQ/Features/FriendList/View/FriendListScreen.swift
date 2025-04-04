
import SwiftUI

struct FriendListScreen: View {
    var coordinator: Coordinator
    @State var text = ""
    @Binding var show: Bool
    @State private var dragOffset: CGFloat = 0

    var body: some View {
        DraggableView(isPresented: $show) {
            SafeAreaContainer {
                VStack {
                    HStack(alignment: .center, spacing: 30) {
                        Button(
                            action: {
                                withAnimation {
                                    show = false
                                }
                            },
                            label: {
                                Image(.iconArrow)
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(.white)
                            }
                        )
                        
                        Text(StringsToken.Profile.Friends)
                            .tokenFont(.Title_Inter_semibold_24)
                            .textCase(.uppercase)
                        
                        Spacer()
                        
                    }
                    
                    Divider()
                        .background(.white)
                    
                    VStack(alignment: .leading) {
                        ScrollView(.vertical, showsIndicators: false) {
                            VStack(alignment: .leading) {
                                CustomTextField(
                                    text: $text,
                                    keyBoardType: .default,
                                    placeHolder: "Recherche",
                                    textFieldType: .searchBar
                                )
                                .padding(.top, 15)

                                ForEach(0..<10, id: \.self) { index in
                                    CellFriend(
                                        pseudo: "Charlouu",
                                        name: "Charles",
                                        firstName: "Calvignac",
                                        coordinator: coordinator
                                    )
                                    .padding(.top, 15)
                                    .padding(.horizontal, 12)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 12)
                }
            }
        }
    }
}

struct FriendListScreen_Previews: PreviewProvider {
    static var previews: some View {
        FriendListScreen(coordinator: .init(), show: .constant(false))
    }
}

struct CellFriend: View {
    var pseudo: String
    var name: String
    var firstName: String
    var coordinator: Coordinator

    var body: some View {
        HStack(spacing: 0) {
            HStack {
                CirclePicture()
                    .frame(width: 48, height: 48)
                VStack(alignment: .leading) {
                    Text(pseudo)
                        .foregroundColor(.white)
                        .lineLimit(1)
                    HStack {
                        Text(name)
                            .tokenFont(.Body_Inter_Regular_12)
                        Text((firstName.first?.uppercased() ?? "") + ".")
                            .tokenFont(.Body_Inter_Regular_12)
                    }
                }.padding(.leading, 8)
                
                Spacer()
            }
            .onTapGesture {
                withAnimation {
                    coordinator.showProfileFriend = true
                }
            }
            
            Button(action: {}) {
                Text("Supprimer")
                    .tokenFont(.Body_Inter_Medium_14)
            }
            .padding(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.white, lineWidth: 1)
            )
        }
    }
}

#Preview {
    ZStack {
        NeonBackgroundImage()
        CellFriend(pseudo: "Charlouu", name: "Charles", firstName: "Calvignac", coordinator: .init())
    }.ignoresSafeArea()
}
