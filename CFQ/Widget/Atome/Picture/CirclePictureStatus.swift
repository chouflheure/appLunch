
import SwiftUI

struct CirclePictureStatus: View {
    @State var image: Image?
    @State var isActiveTonight: Bool = true

    var body: some View {
        ZStack {
            Image(.header)
                .resizable()
                .scaledToFill()
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(style: StrokeStyle(lineWidth: 2))
                        .foregroundColor(isActiveTonight ? .active : .inactive)
                )
        }
    }
}

#Preview {
    CirclePictureStatus()
}
