
import SwiftUI

struct TeamDetailView: View {
    @StateObject var viewModel = TeamDetailViewModel()

    @State var isPresentedSeetings = false
    @State var navigateToTeamEdit = false

    @ObservedObject var coordinator: Coordinator
    @ObservedObject var team: Team

    @EnvironmentObject var user: User
    @Environment(\.dismiss) var dismiss

    init(coordinator: Coordinator, team: Team) {
        self.coordinator = coordinator
        self.team = team
    }

    var body: some View {
        VStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    ModernCachedAsyncImage(
                        url: team.pictureUrlString,
                        placeholder: Image(systemName: "photo.fill")
                    )
                    .clipShape(Circle())
                    .frame(width: 90, height: 90)
                    .padding(.bottom, 16)
                    
                    NavigationLink(destination: {
                        TurnCardView(
                            turn: Turn(
                                uid: "",
                                titleEvent: "",
                                dateStartEvent: nil,
                                pictureURLString: "",
                                admin: "",
                                description: "",
                                invited: team.friends,
                                participants: [],
                                denied: [],
                                mayBeParticipate: [],
                                mood: [],
                                messagerieUUID: "",
                                placeTitle: "",
                                placeAdresse: "",
                                placeLatitude: 0,
                                placeLongitude: 0,
                                timestamp: Date()
                            ),
                            coordinator: coordinator
                        )
                    }) {
                        HStack {
                            Image(.iconPlus)
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.white)
                            
                            Text("Créer un TURN pour la team")
                                .tokenFont(.Body_Inter_Semibold_16)
                        }
                    }
                    .padding(.vertical, 5)
                    .padding(.horizontal, 10)
                    .overlay {
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(.white, lineWidth: 1)
                    }
                    .padding(.bottom, 16)
                    
                    Divider()
                        .overlay(.white)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        VStack(spacing: 0) {
                            HStack(spacing: 0) {
                                ForEach(
                                    team.friendsContact ?? [], id: \.uid
                                ) { user in
                                    CellFriendAdmin(
                                        userPreview: user,
                                        isEditingAdmin: .constant(false),
                                        isAdmin: Binding(
                                            get: {
                                                guard
                                                    let admins = team
                                                        .adminsContact
                                                else { return false }
                                                return admins.contains(where: {
                                                    $0.uid == user.uid
                                                })
                                            },
                                            set: { newValue in
                                                guard
                                                    coordinator.teamDetail
                                                        != nil
                                                else { return }
                                                
                                                if newValue {
                                                    let isAlreadyAdmin =
                                                    team.adminsContact?
                                                        .contains(where: {
                                                            $0.uid == user.uid
                                                        }) ?? false
                                                    if !isAlreadyAdmin {
                                                        team.adminsContact?
                                                            .append(user)
                                                    }
                                                } else {
                                                    team.adminsContact?
                                                        .removeAll {
                                                            $0.uid == user.uid
                                                        }
                                                }
                                            }
                                        )
                                    )
                                    .padding(.trailing, 12)
                                }
                                .frame(height: 110)
                            }
                        }
                    }
                    .padding(.top, 10)
                    
                    if viewModel.isAdminEditing {
                        Button(action: {
                            withAnimation {
                                viewModel.isAdminEditing = false
                            }
                        }) {
                            Text("Done")
                                .tokenFont(.Body_Inter_Regular_16)
                                .foregroundColor(.white)
                                .padding(.horizontal, 30)
                                .padding(.vertical, 10)
                                .background(.black)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(lineWidth: 1)
                                        .foregroundColor(.white)
                                }
                        }
                    }
                }
            }
        }
        .padding(.vertical, 30)
        .sheet(isPresented: $isPresentedSeetings) {
            ZStack {
                Color.black
                    .ignoresSafeArea()
                VStack(alignment: .trailing, spacing: 30) {
                    if team.admins.contains(user.uid) {
                        // Remplacer NavigationLink par Button
                        Button(action: {
                            isPresentedSeetings = false
                            navigateToTeamEdit = true
                        }) {
                            HStack {
                                Image(.iconEdit)
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.white)
                                    .frame(width: 20)
                                
                                Text("Modifier la team")
                                    .foregroundColor(.white)
                                Spacer()
                            }
                        }
                    }
                    HStack {
                        Image(.iconTrash)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.white)
                        Button(
                            action: {
                                Logger.log("Quitter la team", level: .action)
                                isPresentedSeetings = false
                            },
                            label: {
                                Text("Quitter la team")
                                    .tokenFont(.Body_Inter_Medium_16)
                            })
                        Spacer()
                    }
                }
                .padding(.leading, 12)
            }
            .presentationDragIndicator(.visible)
            .presentationDetents([.height(120)])
        }
        .navigationDestination(isPresented: $navigateToTeamEdit) {
            TeamEditViewScreen(coordinator: coordinator, team: team)
        }
        .customNavigationFlexible(
            leftElement: {
                NavigationBackIcon()
            },
            centerElement: {
                NavigationTitle(title: team.title)
            },
            rightElement: {
                Button(action: {
                    withAnimation {
                        isPresentedSeetings = true
                    }
                }) {
                    Image(.iconDots)
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.white)
                        .frame(width: 24)
                }
            },
            hasADivider: false
        )
    }
}
