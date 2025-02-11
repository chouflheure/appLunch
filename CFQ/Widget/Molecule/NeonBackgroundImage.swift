
import SwiftUI

struct NeonBackgroundImage: View {
    var body: some View {
        Image(.backgroundNeon)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .ignoresSafeArea()
    }
}
