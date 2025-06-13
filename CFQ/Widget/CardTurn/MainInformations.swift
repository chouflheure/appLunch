import SwiftUI

struct MainInformationsPreviewView: View {
    @ObservedObject var viewModel: TurnCardViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    if viewModel.moods.isEmpty {
                        MoodTemplateView()
                    } else {
                        ForEach(Array(viewModel.moods), id: \.self) { mood in
                            Mood().data(for: mood)

                        }
                    }
                }
            }
            .padding(.horizontal, 12)

            HStack {

                Image(.iconDate)
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(
                        viewModel.textFormattedLongFormatStartEvent.isEmpty
                            ? .gray : .white
                    )
                    .padding(.leading, 12)

                Text(
                    viewModel.textFormattedLongFormatStartEvent.isEmpty
                    ? "Date de debut" : viewModel.textFormattedLongFormatStartEvent
                )
                .tokenFont(
                    viewModel.textFormattedLongFormatStartEvent.isEmpty
                        ? .Placeholder_Inter_Regular_16 : .Body_Inter_Medium_16)

                Text(" | ")
                    .foregroundColor(.white)

                Text(
                    viewModel.textFormattedHoursStartEvent.isEmpty
                    ? "Heure de début" : viewModel.textFormattedHoursStartEvent
                )
                .tokenFont(.Placeholder_Inter_Regular_16)
            }
            
            if !viewModel.textFormattedLongFormatEndEvent.isEmpty {
                HStack {
                    Text(viewModel.textFormattedLongFormatEndEvent)
                        .tokenFont(.Body_Inter_Medium_16)
                    
                    Text(" | ")
                        .foregroundColor(.white)
                    
                    Text(viewModel.textFormattedHoursEndEvent)
                        .tokenFont(.Placeholder_Inter_Regular_16)
                }
                .padding(.leading, 32)
            }

            HStack(alignment: .center) {

                Image(.iconLocation)
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(
                        viewModel.placeTitle.isEmpty ? .gray : .white)

                Text(
                    viewModel.placeTitle.isEmpty ? "Lieu" : viewModel.placeTitle
                )
                .tokenFont(
                    viewModel.placeTitle.isEmpty
                        ? .Placeholder_Inter_Regular_14 : .Body_Inter_Medium_14
                )
                .lineLimit(1)

                Text("|")
                    .foregroundColor(.white)

                Text(
                    viewModel.placeAdresse.isEmpty
                        ? "Adress" : viewModel.placeAdresse
                )
                .tokenFont(.Placeholder_Inter_Regular_14)
                .lineLimit(1)
            }
            .padding(.horizontal, 12)
            
            if !viewModel.link.isEmpty {
                HStack(alignment: .center) {
                    
                    Image(.iconLink)
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.white)
                    
                    Link(viewModel.linkTitle, destination: URL(string: viewModel.link) ?? URL(string: "https://www.google.com")!)
                        .tokenFont(.Body_Inter_Medium_14)
                        .lineLimit(1)
                }
                .padding(.horizontal, 12)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 15)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(.white, lineWidth: 0.8)
        )
    }
}

struct MainInformationsDetailView: View {
    @State private var showMoods = false
    @ObservedObject var viewModel: TurnCardViewModel
    @State var isPresentedLocalisation = false
    @State var isPresentedLink = false
    @State var showFriendProfile: Bool = false
    @ObservedObject var coordinator: Coordinator

    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 20) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        if viewModel.moods.isEmpty {
                            MoodTemplateView()
                        } else {
                            ForEach(Array(viewModel.moods), id: \.self) { mood in
                                Mood().data(for: mood)
                                
                            }
                        }
                    }
                }.onTapGesture {
                    showMoods.toggle()
                }
                .padding(.horizontal, 12)
                
                DatePickerMainInformations(viewModel: viewModel)
                    .padding(.horizontal, 12)
                
                HStack(alignment: .top) {
                    
                    Button(action: {
                        isPresentedLocalisation = true
                    }) {
                        Image(.iconLocation)
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(viewModel.placeTitle.isEmpty ? .whiteTertiary : .white)
                        
                        Text(
                            viewModel.placeTitle.isEmpty
                            ? "Lieu" : viewModel.placeTitle
                        )
                        .tokenFont(
                            viewModel.placeTitle.isEmpty
                            ? .Placeholder_Inter_Regular_16
                            : .Body_Inter_Medium_16)
                        
                        Text("|")
                            .foregroundColor(.white)
                        
                        Text(
                            viewModel.placeAdresse.isEmpty
                            ? "Adress" : viewModel.placeAdresse
                        )
                        .tokenFont(.Placeholder_Inter_Regular_16)
                    }
                }
                .padding(.horizontal, 12)
                
                HStack(alignment: .top) {
                    
                    Button(action: {
                        isPresentedLink = true
                    }) {
                        Image(.iconLink)
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(viewModel.link.isEmpty ? .whiteTertiary : .white)
                        
                        Text(viewModel.linkTitle.isEmpty ? "Un lien" : viewModel.linkTitle)
                            .tokenFont(viewModel.linkTitle.isEmpty ? .Placeholder_Inter_Regular_14 : .Body_Inter_Medium_14)
                            .lineLimit(1)
                    }
                }
                .padding(.horizontal, 12)
            }
            .padding(.vertical, 15)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(.white, lineWidth: 0.8)
            )
            
            VStack(alignment: .leading, spacing: 0) {
                ScrollView(.horizontal, showsIndicators: false) {
                    VStack {
                        HStack {
                            ForEach(Array(viewModel.setFriendsOnTurn), id: \.self) { user in
                                CellFriendCanRemove(userPreview: user) {
                                    viewModel.removeFriendsFromList(
                                        user: user
                                    )
                                }
                                .onTapGesture {
                                    showFriendProfile = true
                                    
                                    coordinator.profileUserSelected = User(
                                        uid: user.uid,
                                        name: user.name,
                                        pseudo: user.pseudo,
                                        profilePictureUrl: user
                                            .profilePictureUrl,
                                        isActive: user.isActive
                                    )
                                    
                                }
                            }.frame(height: 100)
                        }
                    }
                }
                .padding(.top, 15)
                
                Button(action: {
                    viewModel.showFriendsList = true
                }) {
                    HStack {
                        Image(.iconAddfriend)
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.white)
                        
                        Text(StringsToken.Turn.addYourFriendToTheEvent)
                            .tokenFont(.Body_Inter_Medium_16)
                    }
                }.padding(.vertical, 10)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .fullScreenCover(isPresented: $viewModel.showFriendsList) {
            ListFriendToAdd(
                isPresented: $viewModel.showFriendsList,
                coordinator: viewModel.coordinator,
                friendsOnTeam: $viewModel.setFriendsOnTurn,
                allFriends: $viewModel.friendListToAdd
            )
        }
        .sheet(isPresented: $isPresentedLink) {
            SelectLinkView(
                isPresented: $isPresentedLink, viewModel: viewModel
            )
            .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $isPresentedLocalisation) {
            SelectLocalisationView(
                viewModel: viewModel, isPresented: $isPresentedLocalisation
            )
            .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $showMoods) {
            ZStack {
                NeonBackgroundImage()
                VStack {
                    CollectionViewMoods(viewModel: viewModel)
                    Button(
                        action: { showMoods = false },
                        label: {
                            Text("Done")
                                .foregroundColor(.white)
                                .padding(.horizontal, 30)
                                .padding(.vertical, 10)
                                .background(.black)
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.white, lineWidth: 0.5)
                                )

                        })
                }
            }
            .presentationDragIndicator(.visible)
            .presentationDetents([.height(500)])
        }
    }
}

struct SelectLinkView: View {
    @Binding var isPresented: Bool
    @ObservedObject var viewModel: TurnCardViewModel

    var body: some View {
        VStack {
            TextField("Titre du lien", text: $viewModel.linkTitle)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            TextField("lien url", text: $viewModel.link)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button(action: {
                isPresented = false
            }) {
                Text("Done")
            }
        }.padding(.top, 40)
        Spacer()
    }
}
