import SwiftUI

struct TeamView: View {
    @ObservedObject var coordinator: Coordinator
    @StateObject var viewModel = TeamListScreenViewModel()
    @State var selectedTeam: Int = 0

    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Text("MES TEAMs")
                    .tokenFont(.Title_Gigalypse_24)
            }

            ScrollView(.vertical, showsIndicators: false) {
                Button(action: {
                    coordinator.showCreateTeam = true
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
                            coordinator.teamDetail = viewModel.teams[selectedTeam]
                            withAnimation(.easeInOut(duration: 0.3)) {
                                coordinator.showTeamDetail = true
                            }
                        }
                    )
                    .padding(.bottom, 16)
                }
            }
            .padding(.horizontal, 12)
        }.onChange(of: viewModel.teams) { _ in
            coordinator.teamDetail = viewModel.teams[selectedTeam]
        }
    }
}

struct CellTeamView: View {
    @ObservedObject var coordinator: Coordinator
    var team: Team
    var onClick: (() -> Void)

    var body: some View {
        HStack(alignment: .center) {
            CirclePicture()
                .frame(width: 50, height: 50)
            VStack(alignment: .leading, spacing: 10) {
                Text(team.title)
                    .foregroundColor(.white)
                    .bold()
                PreviewProfile(
                    pictures: [.header],
                    previewProfileType: .userMemberTeam
                ).frame(height: 24)
            }.padding(.horizontal, 16)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.white, lineWidth: 1)
        )
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation {
                onClick()
                // coordinator.showTeamDetail = true
            }
        }
    }
}

#Preview {
    ZStack {
        NeonBackgroundImage()
        TeamView(coordinator: .init())
    }.ignoresSafeArea()
}
