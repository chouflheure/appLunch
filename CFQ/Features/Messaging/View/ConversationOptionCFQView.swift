import SwiftUI

struct ConversationOptionCFQView: View {
    @ObservedObject var coordinator: Coordinator
    @State var setFriendsState = Set<UserContact>()
    @State var allFriendsState = Set<UserContact>()
    @State var navigateToTeamEdit = false
    
    var cfq: CFQ

    init(cfq: CFQ, coordinator: Coordinator) {
        
        self.cfq = cfq
        self.coordinator = coordinator
    }

    private var setFriends: [UserContact] {
        coordinator.user?.userFriendsContact?.filter { friend in
            cfq.participants?.contains(friend.uid) ?? false
        } ?? []
    }
    
    private var allFriends: [UserContact] {
        coordinator.user?.userFriendsContact ?? []
    }
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                VStack {
                    ModernCachedAsyncImage(
                        url: cfq.userContact?.profilePictureUrl ?? ""
                    )
                    .scaledToFill()
                    .frame(width: 90, height: 90)
                    .clipShape(Circle())

                    Text(cfq.title)
                        .tokenFont(.Title_Inter_semibold_24)

                    // MEDIA PART
                    NavigationLink(destination: {
                        ListFriendToAdd(
                            isPresented: .constant(true),
                            coordinator: coordinator,
                            friendsOnTeam: $setFriendsState,
                            allFriends: $allFriendsState,
                            showArrowDown: false
                        )
                        .customNavigationFlexible(
                            leftElement: {
                                NavigationBackIcon()
                            },
                            centerElement: {
                                Text("Qui dans le CFQ ?")
                                    .tokenFont(.Title_Gigalypse_24)
                            },
                            rightElement: {
                                EmptyView()
                            },
                            hasADivider: true
                        )
                    }) {
                        ConversationOptionPart(
                            icon: .iconAdduser,
                            title: "Ajouter quelqu'un"
                        )
                    }

                    ConversationOptionPart(
                        icon: .iconSearch,
                        title: "Rechercher dans la conv"
                    )

                    ConversationOptionPart(
                        icon: .icon,
                        title: "Medias",
                        nbElement: 8
                    )

                    NavigationLink(destination: {
                        TurnCardView(
                            turn: Turn(
                                uid: "",
                                titleEvent: "",
                                dateStartEvent: nil,
                                dateEndEvent: nil,
                                pictureURLString: "",
                                admin: cfq.admin,
                                description: "",
                                invited: cfq.users,
                                participants: [],
                                denied: [],
                                mayBeParticipate: [],
                                mood: [],
                                messagerieUUID: "",
                                placeTitle: "",
                                placeAdresse: "",
                                placeLatitude: 0,
                                placeLongitude: 0,
                                timestamp: Date(),
                                link: "",
                                lintiTitle: "",
                                imageEvent: nil,
                                userUID: ""
                            ),
                            coordinator: coordinator
                        )
                    }) {
                        ConversationOptionPart(
                            icon: .iconPlus,
                            title: "Creéer un turn"
                        )
                    }

                    UserInCFQ(invited: Array(setFriends), participants: Array(allFriends))

                    Spacer()
                }
            }
            .padding(.vertical, 20)
            .padding(.horizontal, 12)

        }
        .onAppear {
            setFriendsState = Set(setFriends)
            allFriendsState = Set(allFriends)
        }
        .customNavigationFlexible(
            leftElement: {
                NavigationBackIcon()
            },
            centerElement: {
                Text("Info")
                    .tokenFont(.Title_Gigalypse_24)
            },
            rightElement: {
                EmptyView()
            },
            hasADivider: true
        )
        .ignoresSafeArea(.keyboard)
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
    }
}

private struct UserInCFQ: View {
    
    @State var selectedIndex = 0
    var pageViewType: PageViewType = .invited
    @State var invited = [UserContact]()
    @State var participants = [UserContact]()
    
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    ForEach(0..<pageViewType.titles.count, id: \.self) { index in
                        VStack {
                            Text(pageViewType.title(at: index))
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(selectedIndex == index ? .white : .gray)
                            
                            Rectangle()
                                .frame(height: 3)
                                .foregroundColor(selectedIndex == index ? .white : .clear)
                                .padding(.horizontal, 10)
                        }
                        .frame(maxWidth: .infinity)
                        .onTapGesture {
                            withAnimation {
                                selectedIndex = index
                            }
                        }
                    }
                }
                .padding(.top, 20)

                ScrollView(.vertical, showsIndicators: false) {
                    if selectedIndex == 0 {
                        LazyVStack(spacing: 20) {
                            if invited.isEmpty {
                                Text("Personne ici")
                                    .tokenFont(.Label_Gigalypse_12)
                                    .padding(.top, 200)
                            } else {
                                CollectionViewParticipant(participants: $invited)
                            }
                        }
                        .padding(.top, 24)
                    } else if selectedIndex == 1 {
                        LazyVStack(spacing: 20) {
                            if participants.isEmpty {
                                Text("Personne ici")
                                    .tokenFont(.Label_Gigalypse_12)
                                    .padding(.top, 200)
                            }
                            else {
                                CollectionViewParticipant(participants: $participants)
                            }
                        }
                        .padding(.top, 24)
                        
                    }
                    
                }
            }
        }
    }
}

private struct ConversationOptionPart: View {
    var icon: ImageResource
    var title: String
    var nbElement: Int?

    var body: some View {
        HStack {
            Image(icon)
                .resizable()
                .scaledToFill()
                .frame(width: 20, height: 20)
                .foregroundColor(.white)
            Text(title)
                .tokenFont(.Body_Inter_Medium_16)
            Spacer()
            Text(nbElement != nil ? "\(nbElement!)" : "")
                .tokenFont(.Placeholder_Inter_Regular_16)
            Image(.iconArrow)
                .resizable()
                .scaledToFill()
                .frame(width: 20, height: 20)
                .foregroundColor(.gray)
                .rotationEffect(.init(degrees: 180))

        }
        .padding()
        .background(.black)
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .stroke(.whiteTertiary, lineWidth: 1)
        }
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
