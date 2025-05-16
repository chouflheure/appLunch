
import SwiftUI

struct NeonBackgroundImage: View {
    var body: some View {
        Image(.backgroundNeon)
            .resizable()
            .scaledToFill()
            .frame(minWidth: 0, minHeight: 0)
            .ignoresSafeArea()
    }
}

#Preview {
    NeonBackgroundImage()
}
