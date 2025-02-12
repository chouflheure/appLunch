
import SwiftUI

struct PreviewParticipants: View {
    var pictures: [UIImage]

    var body: some View {
        HStack {
            HStack(spacing: -15) {
                Image(.profile)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .clipShape(Circle())
                
                Image(.profile)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .clipShape(Circle())
                
                Image(.profile)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .clipShape(Circle())
                
                Image(.profile)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .clipShape(Circle())
            }
            Text("28")
                .foregroundStyle(.white)
                .bold()
            Text("y vont")
                .foregroundStyle(.white)
        }
    }
}

#Preview {
    ZStack {
        Color.blue.edgesIgnoringSafeArea(.all)
        PreviewParticipants(pictures: [.profile, .profile, .profile, .profile])
    }
}
