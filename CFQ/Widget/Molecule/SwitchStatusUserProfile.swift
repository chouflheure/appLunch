
import SwiftUI

struct SwitchStatusUserProfile: View {
    @State var isOn = false

    var body: some View {
        ZStack{
            CirclePictureStatus()
                .frame(width: 70, height: 70)
            CustomToggleStatus()
                .offset(y: 40)
        }
    }
}

#Preview {
    ZStack {
        NeonBackgroundImage()
        SwitchStatusUserProfile()
    }.ignoresSafeArea()
}
