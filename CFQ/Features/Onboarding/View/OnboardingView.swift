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
        VStack {
            ZStack {
                TabView(selection: $currentIndex) {
                    ForEach(onboardingView.indices, id: \.self) { index in
                        if index == 3 {
                            ZStack {
                                onboardingView[index]
                                    .resizable()
                                    .scaledToFit()
                                
                                LargeButtonView(
                                    action: {
                                        Logger.log(
                                            "Clique go to visit app", level: .action
                                        )
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
                                .scaledToFit()
                        }
                    }
                }
                .tabViewStyle(
                    PageTabViewStyle(
                        indexDisplayMode: currentIndex != 3 ? .always : .never
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
            }
        }
        .fullBackground(imageName: StringsToken.Image.fullBackground)
    }
}

#Preview {
    OnboardingView()
}



struct OnboardingView_Old: View {
    @AppStorage("hasAlreadyOnboarded") var hasAlreadyOnboarded: Bool?
    @State var currentIndex = 0
    var onFinish: (() -> Void)?

    let onboardingView = [
        Image(.onboarding1),
        Image(.onboarding2),
        Image(.onboarding3),
        Image(.onboarding4),
    ]

    var body: some View {
        SafeAreaContainer {
            ZStack {
                TabView(selection: $currentIndex) {
                    ForEach(onboardingView.indices, id: \.self) { index in
                        if index == 3 {
                            ZStack {
                                onboardingView[index]
                                    .resizable()
                                    .scaledToFill()

                                LargeButtonView(
                                    action: {
                                        Logger.log(
                                            "Clique go to visit app",
                                            level: .action)
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
                        }
                    }
                }
                .tabViewStyle(
                    PageTabViewStyle(
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
        }
    }
}

#Preview {
    OnboardingView_Old()
}

struct OnboardingView3: View {
    @AppStorage("hasAlreadyOnboarded") var hasAlreadyOnboarded: Bool?
    @State var currentIndex = 0
    var onFinish: (() -> Void)?

    let onboardingView = [
        Image(.onboarding1),
        Image(.onboarding2),
        Image(.onboarding3),
        Image(.onboarding4),
    ]

    var body: some View {
        SafeAreaContainer {
            ZStack {
                TabView(selection: $currentIndex) {

                    ForEach(onboardingView.indices, id: \.self) { index in
                        onboardingView[index]
                            .resizable()
                            .scaledToFit()
                        if index == 3 {
                            //ZStack {
                            LargeButtonView(
                                action: {
                                    Logger.log(
                                        "Clique go to visit app", level: .action
                                    )
                                    onFinish?()
                                    hasAlreadyOnboarded = true
                                },
                                title: "Clique ici pour découvrir l'App",
                                largeButtonType: .signNext
                            )
                            // .frame(maxHeight: .infinity, alignment: .bottom)
                            // .padding(.horizontal, 16)

                            // }
                        }
                    }
                }
                .tabViewStyle(
                    PageTabViewStyle(
                        indexDisplayMode: currentIndex != 3 ? .always : .never
                    ))
            }
        }
    }
}

#Preview {
    OnboardingView3()
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
        VStack {
            ZStack {
                TabView(selection: $currentIndex) {
                    ForEach(onboardingView.indices, id: \.self) { index in
                        if index == 3 {
                            ZStack {
                                onboardingView[index]
                                    .resizable()
                                    .scaledToFit()
                                
                                LargeButtonView(
                                    action: {
                                        Logger.log(
                                            "Clique go to visit app", level: .action
                                        )
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
                                .scaledToFit()
                        }
                    }
                }
                .tabViewStyle(
                    PageTabViewStyle(
                        indexDisplayMode: currentIndex != 3 ? .always : .never
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
            }
        }
        .fullBackground(imageName: StringsToken.Image.fullBackground)
    }
}

#Preview {
    OnboardingView2()
}
