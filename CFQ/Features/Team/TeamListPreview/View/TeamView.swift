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

            ScrollView(.vertical, showsIndicators: false) {
                Button(action: {
                    withAnimation {
                        coordinator.showCreateTeam = true
                    }
                }) {
                    Image(.iconPlus)
                        .resizable()
                        .scaledToFill()
                        .foregroundColor(.white)
                        .padding(.vertical, 16)
                        .frame(width: 40, height: 40)
                }.padding(.vertical, 30)

                ForEach(Array(viewModel.teams.indices), id: \.self) { index in
                    CellTeamView(
                        coordinator: coordinator,
                        team: viewModel.teams[index],
                        onClick: {
                            selectedTeam = index
                            coordinator.teamDetail = viewModel.teamsGlobal[selectedTeam]
                            withAnimation(.easeInOut(duration: 0.3)) {
                                coordinator.showTeamDetail = true
                            }
                        }
                    )
                    .padding(.bottom, 16)
                }
            }
            .padding(.horizontal, 12)
        }.onChange(of: viewModel.teamsGlobal) { _ in
            coordinator.teamDetail = viewModel.teamsGlobal[selectedTeam]
        }
    }
}

#Preview {
    ZStack {
        NeonBackgroundImage()

    }.ignoresSafeArea()
}
