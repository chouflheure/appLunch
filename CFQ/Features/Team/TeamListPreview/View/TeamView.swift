import SwiftUI

struct TeamView: View {
    @ObservedObject var coordinator: Coordinator
    @StateObject var viewModel: TeamListScreenViewModel
    @State var selectedTeam: Int = 0
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

                ForEach(Array(viewModel.teams.indices), id: \.self) { index in
                    CellTeamView(
                        coordinator: coordinator,
                        team: viewModel.teams[index],
                        onClick: {
                            selectedTeam = index
                            coordinator.teamDetail = viewModel.teams[selectedTeam]
                            withAnimation {
                                coordinator.showTeamDetail = true
                            }
                        }
                    )
                    .padding(.bottom, 16)
                }
            }
            .padding(.horizontal, 12)
        }
    }
}
