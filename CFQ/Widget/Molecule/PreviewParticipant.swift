
import SwiftUI

struct PreviewProfile: View {
    var pictures: [UIImage]
    var previewProfileType: PreviewProfileType

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
            Text(previewProfileType.rawValue)
                .foregroundStyle(.white)
        }
    }
}

#Preview {
    ZStack {
        Color.blue.edgesIgnoringSafeArea(.all)
        PreviewProfile(pictures: [.profile, .profile, .profile, .profile], previewProfileType: .userComming)
    }
}
