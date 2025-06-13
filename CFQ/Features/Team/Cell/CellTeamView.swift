
import SwiftUI

struct CellTeamView: View {
    @ObservedObject var coordinator: Coordinator
    @ObservedObject var team: Team
    var onClick: (() -> Void)

    @State private var showImages = false

    var body: some View {
        HStack(alignment: .center) {
            CirclePicture(urlStringImage: team.pictureUrlString)
                .frame(width: 50, height: 50)
            VStack(alignment: .leading, spacing: 10) {
                Text(team.title)
                    .foregroundColor(.white)
                    .bold()

                HStack {
                    Group {
                        if !showImages {
                            // Placeholder
                            HStack(spacing: -15) {
                                ForEach(0..<min(4, team.friends.count), id: \.self) { index in
                                    Circle()
                                        .fill(Color.gray.opacity(0.4))
                                        .frame(width: 24, height: 24)
                                        .overlay(
                                            Circle()
                                                .stroke(Color.white, lineWidth: 1)
                                        )
                                }
                            }
                        } else {
                            // Images réelles
                            HStack(spacing: -15) {
                                ForEach(Array((team.friendsContact?.compactMap({ $0.profilePictureUrl }) ?? []).prefix(4).enumerated()), id: \.offset) { index, imageUrl in
                                    CachedAsyncImageView(
                                        urlString: imageUrl,
                                        designType: .scaleImageMessageProfile
                                    )
                                }
                            }
                        }
                    }
                    .animation(.easeInOut(duration: 0.3), value: showImages)
                    
                    Text("\(team.friends.count)")
                        .foregroundStyle(.white)
                        .bold()
                    Text("members")
                        .foregroundStyle(.white)
                }
                .frame(height: 24)
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
        .onReceive(team.$friendsContact) { friendsContact in
            DispatchQueue.main.async {
                showImages = friendsContact != nil && !(friendsContact?.isEmpty ?? true)
            }
        }
        .onAppear {
            showImages = team.friendsContact != nil && !(team.friendsContact?.isEmpty ?? true)
        }
    }
}
