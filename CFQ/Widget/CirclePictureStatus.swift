
import SwiftUI

struct CirclePictureStatus: View {
    @State var image: Image?
    @State var isActiveTonight: Bool = true
    var size: CGFloat?

    var body: some View {
        ZStack {
            Image(.header)
                .resizable()
                .scaledToFill()
                .frame(width: size, height: size)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(style: StrokeStyle(lineWidth: 4))
                        .foregroundColor(isActiveTonight ? .active : .inactive)
                )
        }
    }
}

#Preview {
    CirclePictureStatus(size: 80)
}
