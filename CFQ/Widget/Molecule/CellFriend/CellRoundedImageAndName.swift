
import SwiftUI

struct CellRoundedImageAndName: View {
    var name: String

    var body: some View {
        VStack(alignment: .center) {
            CirclePicture()
                .frame(width: 56, height: 56)
            Text(name)
                .tokenFont(.Body_Inter_Medium_12)
        }
        .padding(.leading, 17)
    }
}

