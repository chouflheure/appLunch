
import SwiftUI

struct ProfileView: View {
    var isUserProfile: Bool = true
    @ObservedObject var coordinator: Coordinator
    @State private var showFriendList = false
    @ObservedObject var user: User
    @StateObject var viewModel: ProfileViewModel

    init(coordinator: Coordinator) {
        self.coordinator = coordinator
        self.user = coordinator.user ?? User()
        self._viewModel = StateObject(wrappedValue: ProfileViewModel(coordinator: coordinator))
    }

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
                        Text(user.location)
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

            // PageViewEvent(coordinator: coordinator, titles: ["TURNs", "CALENDRIER"], turns: viewModel.turns)
           CustomTabViewDoubleProfile(coordinator: coordinator, titles:  ["TURNs", "CALENDRIER"], turns: viewModel.turns)
        }
        .padding(.horizontal, 16)
        .fullScreenCover(isPresented: $viewModel.isShowingSettingsView) {
            SettingsView(coordinator: coordinator, viewModel: SettingsViewModel(isGuestMode: user.uid == "Guest"))
        }
    }
}

struct PageViewEvent: View {
    @State private var selectedIndex = 0
    @ObservedObject var coordinator: Coordinator
    let titles: [String]
    let turns: [Turn]
    
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
                ScrollView (.vertical, showsIndicators: false) {
                    LazyVStack(spacing: 20) {
                        ForEach(turns.sorted(by: { $0.timestamp > $1.timestamp }), id: \.uid) { turn in
                            TurnCardFeedView(turn: turn, coordinator: coordinator)
                        }
                    }
                }
                .padding(.top, 24)
                .tag(0)

                Text("Empty")
                    .foregroundColor(.white)
                    .tag(1)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        }
    }
}

struct CustomTabViewDoubleProfile: View {
    @State private var selectedIndex = 0
    @ObservedObject var coordinator: Coordinator
    let titles: [String]
    let turns: [Turn]

    var body: some View {
        VStack {
            // Header fixe avec les titres
            HStack {
                ForEach(0..<titles.count, id: \.self) { index in
                    VStack {
                        Text(titles[index])
                            .tokenFont(selectedIndex == index ? .Body_Inter_Medium_14 : .Placeholder_Inter_Regular_14)

                        Rectangle()
                            .frame(height: 2)
                            .foregroundColor(selectedIndex == index ? .white : .clear)
                            .padding(.horizontal, 30)
                    }
                    .frame(maxWidth: .infinity)
                    .onTapGesture {
                        selectedIndex = index
                    }
                }
            }
            .padding(.top, 20)

            // Contenu défilable
            ScrollView(.vertical, showsIndicators: false) {
                if selectedIndex == 0 {
                    LazyVStack(spacing: 20) {
                        ForEach(turns.sorted(by: { $0.timestamp > $1.timestamp }), id: \.uid) { turn in
                            TurnCardFeedView(turn: turn, coordinator: coordinator)
                        }
                    }
                    .padding(.top, 24)
                } else {
                    Text("Feature en cours")
                        .tokenFont(.Label_Gigalypse_12)
                        .padding(.top, 50)
                }
            }
        }
    }
}
