
import SwiftUI

struct CirclePictureStatusAndPseudo: View {
    var userPreview: UserContact

    var body: some View {
        VStack {
            CirclePictureStatus(
                userPreview: userPreview
            )
            .frame(width: 72, height: 72)
            .padding(.bottom, 4)
            
            Text(userPreview.pseudo)
                .tokenFont(.Body_Inter_Regular_10)
                .textCase(.lowercase)
        }
    }
}

#Preview {
    ZStack {
        NeonBackgroundImage()
        CirclePictureStatusAndPseudo(userPreview: UserContact(uid: "123", pseudo: "Test"))
    }
}
