
import SwiftUI

struct CirclePictureStatusAndPseudo: View {
    var pseudo: String
    var isActive: Bool
    var onClick: () -> Void

    var body: some View {
        VStack {
            CirclePictureStatus(
                isActive: isActive,
                onClick: { onClick() }
            )
            .frame(width: 48, height: 48)
            .padding(.bottom, 4)
            Text(pseudo)
                .tokenFont(.Body_Inter_Medium_14)
        }
    }
}

#Preview {
    ZStack {
        NeonBackgroundImage()
        CirclePictureStatusAndPseudo(pseudo: "Test", isActive: true, onClick: {})
    }
}
