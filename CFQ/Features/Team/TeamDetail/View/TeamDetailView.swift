import SwiftUI

struct TeamDetailView: View {
    @ObservedObject var coordinator: Coordinator
    @StateObject var viewModel = TeamDetailViewModel()
    @State var isPresentedSeetings = false
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
                    CachedAsyncImageView(
                        urlString: team.pictureUrlString,
                        designType: .scaleImageTeam
                    )
                    .frame(width: 90, height: 90)
                    .padding(.vertical, 16)
                    .padding(.bottom, 16)

                    HStack {
                        Button(action: {
                            withAnimation {
                                dismiss()
                                coordinator.selectedTab = 2
                            }
                        }) {
                            ZStack {
                                Circle().fill(
                                    LinearGradient(
                                        colors: [
                                            Color(hex: "8A5BD0"),
                                            Color(hex: "5E44A7"),
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 53, height: 53)

                                Text("TURN")
                                    .tokenFont(.Label_Gigalypse_12)
                            }
                        }
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
                    } else {
                        //Divider()
                        //  .overlay(.whitePrimary)

                        //CFQCollectionView(coordinator: coordinator)
                        //  .padding(.vertical, 10)

                        //Divider()
                        //  .overlay(.whiteSecondary)
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

                    HStack {
                        Image(.iconEdit)
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.white)
                            .frame(width: 20)
                        NavigationLink(destination: {}) {
                            TeamEditViewScreen(coordinator: coordinator)
                        }
                        Spacer()
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
        .padding(.vertical, 30)
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
