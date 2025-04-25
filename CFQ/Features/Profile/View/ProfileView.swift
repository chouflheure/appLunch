
import SwiftUI

struct ProfileView: View {
    var isUserProfile: Bool = true
    @ObservedObject var coordinator: Coordinator
    @State private var showFriendList = false

    @EnvironmentObject var user: User
    /*
    var user = User(
        uid: "1234567890",
        name: "John",
        firstName: "Doe",
        pseudo: "johndoe",
        location: "Ici"
    )
     */
    
    @StateObject var viewModel = ProfileViewModel()

    var body: some View {
        VStack {
            HStack() {
                Spacer()
                Button(
                    action: {
                        viewModel.isShowingSettingsView = true
                    },
                    label: {
                        Image(.iconParametres)
                            .foregroundColor(.white)
                            .frame(width: 24, height: 24)
                    })
            }
            .padding(.trailing, 12)
            .padding(.bottom, 32)
            
            HStack {
                SwitchStatusUserProfile(viewModel: SwitchStatusUserProfileViewModel(user: user))
                    .padding(.trailing, 12)

                VStack(alignment: .leading, spacing: 12) {
                    PreviewPseudoName(
                        name: user.name,
                        firstName: user.firstName,
                        pseudo: user.pseudo
                    )

                    HStack(alignment: .center) {
                        Image(.iconLocation)
                            .resizable()
                            .frame(width: 16, height: 16)
                            .foregroundColor(.white)
                        Text("\(user.location)")
                            .tokenFont(.Body_Inter_Medium_16)
                    }
                }
                Spacer()
                Button(
                    action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            coordinator.showFriendList = true
                        }
                    },
                    label: {
                        Image(.iconUser)
                            .resizable()
                            .frame(width: 44, height: 44)
                            .foregroundColor(.white)
                    })
            }
            .padding(.bottom, 16)
            
            PageViewEvent()

        }
        .padding(.horizontal, 16)
        .fullScreenCover(isPresented: $viewModel.isShowingSettingsView) {
            SettingsView(coordinator: coordinator)
        }
    }
}

struct PageViewEvent: View {
    @State private var selectedIndex = 0
    let titles = ["TURNs", "CALENDRIER"]

    var body: some View {
        VStack {
            HStack {
                ForEach(0..<titles.count, id: \.self) { index in
                    VStack {
                        Text(titles[index])
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(selectedIndex == index ? .white : .gray)

                        Rectangle()
                            .frame(height: 3)
                            .foregroundColor(selectedIndex == index ? .white : .clear)
                            .padding(.horizontal, 10)
                    }
                    .frame(maxWidth: .infinity)
                    .onTapGesture {
                        withAnimation {
                            selectedIndex = index
                        }
                    }
                }
            }
            .padding(.top, 20)

            TabView(selection: $selectedIndex) {
                Text("Empty")
                    .foregroundColor(.white)
                    .tag(0)
                Text("Empty")
                    .foregroundColor(.white)
                    .tag(1)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        }
    }
}


#Preview {
    ZStack {
        Color.black
        ProfileView(coordinator: .init())
    }.ignoresSafeArea()
}
