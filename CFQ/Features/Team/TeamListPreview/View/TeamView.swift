import SwiftUI

struct TeamView: View {
    @ObservedObject var coordinator: Coordinator
    @StateObject var viewModel: TeamListScreenViewModel
    @EnvironmentObject var user: User

    init(coordinator: Coordinator) {
        self.coordinator = coordinator
        self._viewModel = StateObject(wrappedValue: TeamListScreenViewModel(coordinator: coordinator))
    }

    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Text(StringsToken.Team.teamTitle)
                    .tokenFont(.Title_Gigalypse_24)
            }
            .padding(.top, 50)

            ScrollView(.vertical, showsIndicators: false) {
                NavigationLink(
                    destination: {
                        TeamFormView(coordinator: coordinator)
                    },
                    label: {
                        Image(.iconPlus)
                            .resizable()
                            .scaledToFill()
                            .foregroundColor(.white)
                            .padding(.vertical, 16)
                            .frame(width: 40, height: 40)
                            .padding(.vertical, 30)
                    }
                )
                
                if viewModel.teams.isEmpty {
                    Text("Pas encore de Team")
                        .tokenFont(.Title_Gigalypse_24)
                        .padding(.top, 100)
                } else {
                    ForEach(Array(viewModel.teams.indices), id: \.self) { index in
                        NavigationLink(destination: {
                            TeamDetailView(
                                coordinator: coordinator,
                                team: viewModel.teams[index]
                            )
                        }) {
                            CellTeamView(
                                coordinator: coordinator,
                                team: viewModel.teams[index]
                            )
                            .padding(.bottom, 16)
                        }
                    }
                }
            }
            .padding(.horizontal, 12)
        }
        .onAppear {
            viewModel.startListeningToTeams()
        }
    }
}
