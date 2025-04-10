
import SwiftUI

struct PreviewDoublePicture: View {
    var body: some View {
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
                .offset(x: -5, y: 10)
        }
    }
}


#Preview {
    ZStack {
        NeonBackgroundImage()
        PreviewDoublePicture()
    }.ignoresSafeArea()
}
