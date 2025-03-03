
import SwiftUI

struct FeedView: View {

    var body: some View {
        VStack {
            HStack {
                Button(action: {}) {
                    Image(.iconAddfriend)
                        .frame(width: 24, height: 24)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Image(.iconNotifs)
                        .frame(width: 24, height: 24)
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                    
                    Image(.iconMessagerie)
                        .frame(width: 24, height: 24)
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 16)
            }
            
            /*
            VStack(alignment: .leading) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack() {
                        ForEach(0..<5) { index in
                            CirclePictureStatus(isActive: .constant(true))
                                .frame(width: 48, height: 48)
                                .padding(.leading, 17)
                        }.frame(height: 100)
                    }
                }
            }
            */
        }
    }
}


#Preview {
    ZStack {
        NeonBackgroundImage()
        FeedView()
    }.ignoresSafeArea()
}
