import SwiftUI

struct TeamDetailView: View {
    @ObservedObject var coordinator: Coordinator
    @StateObject var viewModel = TeamDetailViewModel()
    @State var isPresentedSeetings = false
    @EnvironmentObject var user: User

    private var team: TeamGlobal

    init(coordinator: Coordinator) {
        self.coordinator = coordinator
        guard let teamDetail = coordinator.teamDetail else {
            coordinator.showTeamDetail = false
            self.team = TeamGlobal(uid: "", title: "Error", pictureUrlString: "", friends: [], admins: [])
            return
        }

        self.team = teamDetail
    }

    var body: some View {
        DraggableViewLeft(isPresented: $coordinator.showTeamDetail) {
            SafeAreaContainer {
                VStack {
                    HStack {
                        Button(action: {
                            withAnimation {
                                coordinator.showTeamDetail = false
                            }
                        }) {
                            Image(.iconArrow)
                                .foregroundColor(.white)
                                .frame(width: 24, height: 24)
                        }
                        
                        Spacer()

                        Text(team.title)
                            .foregroundColor(.white)
                            .tokenFont(.Title_Gigalypse_24)
                        
                        Spacer()

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

                    }
                    .padding(.horizontal, 16)

                    ScrollView(.vertical, showsIndicators: false) {
                        VStack {
                            CachedAsyncImageView(urlString: team.pictureUrlString, designType: .scaleImageTeam)
                                .frame(width: 90, height: 90)
                                .padding(.vertical, 16)
                                .padding(.bottom, 16)

                            HStack {
                                Button(action: {
                                    withAnimation {
                                        coordinator.showTeamDetail = false
                                        coordinator.selectedTab = 2
                                    }
                                }) {
                                    ZStack {
                                        Circle()
                                            .fill(
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
                                        ForEach(coordinator.teamDetail?.friends ?? UserContact().userContactDefault(), id: \.self) { user in
                                            CellFriendAdmin (
                                                userPreview: user,
                                                isEditingAdmin: .constant(false),
                                                isAdmin: Binding(
                                                    get: {
                                                        coordinator.teamDetail?.admins.contains(user) ?? false
                                                    },
                                                    set: { newValue in
                                                        if newValue {
                                                            coordinator.teamDetail?.admins.append(user)
                                                        } else {
                                                            coordinator.teamDetail?.admins.remove(at: 0)

                                                        }
                                                    }
                                                )
                                            ).padding(.trailing, 12)
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
                                        .overlay() {
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(lineWidth: 1)
                                                .foregroundColor(.white)
                                        }
                                }
                            } else {
                                Divider()
                                    .overlay(.whitePrimary)
                                
                                CFQCollectionView(coordinator: coordinator)
                                    .padding(.vertical, 10)
                                
                                Divider()
                                    .overlay(.whiteSecondary)
                            }
                        }

                    }
                }
            }
        }
        .sheet(isPresented: $isPresentedSeetings) {
            SettingsTeamDetailSheet(
                coordinator: coordinator,
                isAdmin: viewModel.isAdmin(userUUID: user.uid, admins: coordinator.teamDetail?.admins),
                isPresented: $isPresentedSeetings
            )
            .presentationDragIndicator(.visible)
            .presentationDetents([.height(120)])
        }
        .padding(.vertical, 30)
    }
}
