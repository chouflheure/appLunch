
import SwiftUI

struct CirclePictureStatusAndPseudo: View {
    var userPreview: UserContact
    var onClick: () -> Void

    var body: some View {
        VStack {
            CirclePictureStatus(
                userPreview: userPreview,
                onClick: { onClick() }
            )
            .frame(width: 72, height: 72)
            .padding(.bottom, 4)
            Text(userPreview.pseudo)
                .tokenFont(.Body_Inter_Medium_14)
        }
    }
}

#Preview {
    ZStack {
        NeonBackgroundImage()
        CirclePictureStatusAndPseudo(userPreview: UserContact(uid: "123", pseudo: "Test"), onClick: {})
    }
}
