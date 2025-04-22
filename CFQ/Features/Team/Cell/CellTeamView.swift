
import SwiftUI

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
            }
        }
    }
}
