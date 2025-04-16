import SwiftUI

struct TeamView: View {
    @ObservedObject var coordinator: Coordinator
    @StateObject var viewModel = TeamListScreenViewModel()
    
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

                ForEach(Array(viewModel.teams), id: \.self) { team in
                    CellTeamView(
                        coordinator: coordinator,
                        team: team
                    )
                    .padding(.bottom, 16)
                }
            }
            .padding(.horizontal, 12)
        }
    }
}

struct CellTeamView: View {
    @ObservedObject var coordinator: Coordinator
    var team: Team

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
                coordinator.showTeamDetail = true
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
