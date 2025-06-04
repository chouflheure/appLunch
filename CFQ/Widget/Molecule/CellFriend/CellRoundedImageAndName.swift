
import SwiftUI

struct CellRoundedImageAndName: View {
    var userPreview: UserContact

    var body: some View {
        VStack(alignment: .center) {
            CirclePicture(urlStringImage: userPreview.profilePictureUrl)
                .frame(width: 56, height: 56)
            Text(userPreview.pseudo)
                .tokenFont(.Body_Inter_Medium_12)
                .textCase(.lowercase)
        }
        .padding(.leading, 17)
    }
}

