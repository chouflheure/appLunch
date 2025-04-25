
import SwiftUI

struct OnboardingView: View {
    @AppStorage("hasAlreadyOnboarded") var hasAlreadyOnboarded: Bool?
    @State var currentIndex = 0
    var onFinish: (() -> Void)?

    let onboardingView = [
        Image(.onboarding1),
        Image(.onboarding2),
        Image(.onboarding3),
        Image(.onboarding4)
    ]

    var body: some View {
        // SafeAreaContainer {
            ZStack {
                TabView(selection: $currentIndex) {
                    ForEach(onboardingView.indices, id: \.self) { index in
                        if index == 3 {
                            ZStack {
                                onboardingView[index]
                                    .resizable()
                                    .scaledToFill()
                                    .ignoresSafeArea()
                                
                                LargeButtonView(
                                    action: {
                                        Logger.log("Clique go to visit app", level: .action)
                                        onFinish?()
                                        hasAlreadyOnboarded = true
                                    },
                                    title: "Clique ici pour découvrir l'App",
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
                .tabViewStyle(PageTabViewStyle(
                    indexDisplayMode: currentIndex != 3 ? .always : .never
                ))
                
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
            }
            // .padding(.vertical, 25)
        // }
        .ignoresSafeArea()
    }
}

#Preview {
    OnboardingView()
}



struct OnboardingView2: View {
    @AppStorage("hasAlreadyOnboarded") var hasAlreadyOnboarded: Bool?
    @State var currentIndex = 0
    var onFinish: (() -> Void)?

    let onboardingView = [
        Image(.onboarding1),
        Image(.onboarding2),
        Image(.onboarding3),
        Image(.onboarding4)
    ]

    var body: some View {
        SafeAreaContainer {
            ZStack {
                TabView(selection: $currentIndex) {
                    ForEach(onboardingView.indices, id: \.self) { index in
                        if index == (onboardingView.count - 1) {
                            ZStack {
                                onboardingView[index]
                                    .resizable()
                                    .scaledToFill()
                                    .ignoresSafeArea()

                                LargeButtonView(
                                    action: {
                                        Logger.log("Clique go to visit app", level: .action)
                                        onFinish?()
                                        hasAlreadyOnboarded = true
                                    },
                                    title: "Clique ici pour découvrir l'App",
                                    largeButtonType: .signNext
                                )
                                .frame(maxHeight: .infinity, alignment: .bottom)
                                .padding(.horizontal, 16)
                                
                            }
                        } else {
                            onboardingView[index]
                                .resizable()
                                .scaledToFill()
                                .ignoresSafeArea()
                        }
                    }
                }
                .tabViewStyle(PageTabViewStyle(
                    indexDisplayMode: currentIndex != (onboardingView.count - 1) ? .always : .never
                ))
                
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
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    OnboardingView2()
}
