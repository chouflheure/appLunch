
import SwiftUI

struct HeaderBackLeftScreen: View {
    var onClickBack: (() -> Void)
    var titleScreen: String
    var onClickDots: (() -> Void)?

    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            Button(
                action: {
                    onClickBack()
                },
                label: {
                    Image(.iconArrow)
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.white)
                }
            )

            Spacer()

            Text(titleScreen)
                .tokenFont(.Title_Inter_semibold_24)
                .textCase(.uppercase)
                .padding(.leading, -24)
            
            Spacer()
            
        }
        .padding(.horizontal, 12)
    }
}


struct HeaderBackRightScreen: View {
    var onClickBack: (() -> Void)
    var titleScreen: String
    var onClickDots: (() -> Void)?

    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            
            Spacer()
            
            Text(titleScreen)
                .tokenFont(.Title_Inter_semibold_24)
                .textCase(.uppercase)
                .padding(.trailing, -24)
            
            Spacer()
            
            Button(
                action: {
                    onClickBack()
                },
                label: {
                    Image(.iconArrow)
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.white)
                        .rotationEffect(Angle(degrees: 180))
                }
            )
        }
        .padding(.horizontal, 12)
        .background(.clear)
    }
}

#Preview {
    ZStack {
        NeonBackgroundImage()
        HeaderBackRightScreen(onClickBack: {}, titleScreen: "Test")
    }
}
