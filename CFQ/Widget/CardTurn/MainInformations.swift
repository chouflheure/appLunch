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
                        viewModel.textFormattedLongFormat.isEmpty
                            ? .gray : .white
                    )
                    .padding(.leading, 12)

                Text(
                    viewModel.textFormattedLongFormat.isEmpty
                        ? "Date" : viewModel.textFormattedLongFormat
                )
                .tokenFont(
                    viewModel.textFormattedLongFormat.isEmpty
                        ? .Placeholder_Inter_Regular_16 : .Body_Inter_Medium_16)

                Text(" | ")
                    .foregroundColor(.white)

                Text(
                    viewModel.textFormattedHours.isEmpty
                        ? "Heure de début" : viewModel.textFormattedHours
                )
                .tokenFont(.Placeholder_Inter_Regular_16)
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
                            .foregroundColor(.white)
                        
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
                                        firstName: user.firstName,
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
        .sheet(isPresented: $isPresentedLocalisation) {
            ContentView8(
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

#Preview {
    ZStack {
        Color.blue.edgesIgnoringSafeArea(.all)
        // MainInformationsView(viewModel: TurnCardViewModel())
    }
}
