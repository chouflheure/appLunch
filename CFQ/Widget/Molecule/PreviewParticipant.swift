
import SwiftUI

struct PreviewProfile: View {
    var pictures: [UIImage]
    var previewProfileType: PreviewProfileType

    var body: some View {
        HStack {
            PreviewMultiplePicture()
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
