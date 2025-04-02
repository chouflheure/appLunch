
import SwiftUI

struct FeedView: View {
    @EnvironmentObject var user: User

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

            VStack(alignment: .leading) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack() {
                        SwitchStatusUserProfile(
                            viewModel: SwitchStatusUserProfileViewModel(user: user)
                        )
                        ForEach(0..<5) { index in
                            CirclePictureStatus(isActive: true)
                                .frame(width: 48, height: 48)
                                .padding(.leading, 17)
                                .onTapGesture {
                                    print("@@@ ")
                                }
                        }.frame(height: 100)
                    }
                }
            }
            
            Divider()
                .background(.white)

            CFQCollectionView()

            Divider()
                .background(.white)
        }
    }
}


#Preview {
    ZStack {
        NeonBackgroundImage()
        FeedView()
    }.ignoresSafeArea()
}
