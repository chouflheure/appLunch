import SwiftUI

struct OnboardingView: View {
    @AppStorage("hasAlreadyOnboarded") var hasAlreadyOnboarded: Bool?
    @State var currentIndex = 0
    var onFinish: (() -> Void)?

    @Environment(\.dismiss) var dismiss

    let onboardingView = [
        Image(.onboarding1),
        Image(.onboarding2),
        Image(.onboarding3),
        Image(.onboarding4),
        Image(.onboarding5),
    ]

    var body: some View {
        VStack {
            SafeAreaContainer {
                ZStack {
                    TabView(selection: $currentIndex) {
                        ForEach(onboardingView.indices, id: \.self) { index in

                            onboardingView[index]
                                .resizable()
                                .scaledToFit()
                        }
                    }
                    .tabViewStyle(
                        PageTabViewStyle(
                            indexDisplayMode: currentIndex != 4
                                ? .always : .never
                        )
                    )

                    VStack {
                        HStack {
                            Spacer()
                            Button(action: {
                                hasAlreadyOnboarded = true
                                onFinish?()
                            }) {
                                Text("Skip")
                                    .foregroundColor(.white)
                                    .underline()
                            }
                            .padding(.top, 70)
                            .padding(.trailing, 20)
                        }
                        Spacer()
                    }

                    if currentIndex == 4 {
                        ZStack {
                            LargeButtonView(
                                action: {
                                    Logger.log(
                                        "Clique go to visit app",
                                        level: .action
                                    )
                                    onFinish?()
                                    hasAlreadyOnboarded = true
                                },
                                title:
                                    "Clique ici pour découvrir l'App",
                                largeButtonType: .signNext
                            )
                            .zIndex(100)
                            .frame(
                                maxHeight: .infinity, alignment: .bottom
                            )
                            .padding(.bottom, 15)
                            .padding(.horizontal, 16)
                        }
                    }
                }
            }
        }
        .fullBackground(imageName: StringsToken.Image.fullBackground)
    }
}

#Preview {
    OnboardingView()
}
