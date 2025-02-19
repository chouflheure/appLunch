
import SwiftUI

struct OnBoardingView: View {
    @AppStorage("isOnboarding") var hasAlreadyOnboarded: Bool?
    @State private var currentIndex = 0
    let onboardingView = [
        Image(.onboarding1),
        Image(.onboarding2),
        Image(.onboarding3),
        Image(.onboarding4)
    ]

    var body: some View {
        ZStack {
            NeonBackgroundImage()
            TabView(selection: $currentIndex) {
                ForEach(onboardingView.indices, id: \.self) { index in
                    if index == 3 {
                        ZStack {
                            onboardingView[index]
                                .resizable()
                                .ignoresSafeArea()
                            LargeButtonView(
                                action: {
                                    Logger.log("Click go to visit app", level: .action);
                                    hasAlreadyOnboarded = true
                                },
                                title: "Click ici pour découvrir l'App",
                                largeButtonType: .signNext
                            )
                            .frame(maxHeight: .infinity, alignment: .bottom)
                            .padding(.horizontal, 16)
                            
                        }
                    } else {
                        onboardingView[index]
                            .resizable()
                            .ignoresSafeArea()
                    }
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: currentIndex != 3 ? .always : .never))
            .ignoresSafeArea()
        }
    }
}

#Preview {
    OnBoardingView()
}
