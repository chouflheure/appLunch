
import SwiftUI

struct CirclePicture: View {
    @State var image: Image?

    var body: some View {
        ZStack {
            Image(.header)
                .resizable()
                .scaledToFill()
                .clipShape(Circle())
        }
    }
}

#Preview {
    CirclePicture()
        .frame(width: 30, height: 30)
}
