
import SwiftUI
import MapKit
import FirebaseFirestore

struct CustomTabView: View {
    @State private var selectedTab = 0
    @State private var selectedEvent: MapLocationEventData? = nil
    @EnvironmentObject var user: User
    var coordinator: Coordinator

    var body: some View {
        ZStack {
            NeonBackgroundImage()

            VStack {
                Group {
                    if selectedTab == 0 {
                        Text("Feed")
                            .foregroundStyle(.white)
                        SwitchStatusUserProfile(viewModel: SwitchStatusUserProfileViewModel(user: user))
                    } else if selectedTab == 1 {
                        Text("Map")
                            .foregroundStyle(.white)
                        // CFQCollectionView()
                        // Test(selectedEvent: $selectedEvent)
                        /*
                        MapView(locations: [
                            MapLocationEventData(
                                coordinate: CLLocationCoordinate2D(latitude: 48.8566, longitude: 2.3522),
                                title: "Paris",
                                subtitle: "La ville lumière",
                                imageName: "Header"
                            ),
                            MapLocationEventData(
                                coordinate: CLLocationCoordinate2D(latitude: 48.8570, longitude: 2.3533),
                                title: "Paris",
                                subtitle: "La ville lumière",
                                imageName: "profile"
                            ),
                            MapLocationEventData(
                                coordinate: CLLocationCoordinate2D(latitude: 45.764, longitude: 4.8357),
                                title: "Lyon",
                                subtitle: "Capitale de la gastronomie",
                                imageName: "profile"
                            ),
                            MapLocationEventData(
                                coordinate: CLLocationCoordinate2D(latitude: 43.6045, longitude: 1.4442),
                                title: "Toulouse",
                                subtitle: "La ville rose",
                                imageName: "backgroundNeon"
                            )
                        ], selectedEvent: $selectedEvent)
                        .sheet(item: $selectedEvent) { event in
                            EventDetailView(event: event)
                        }
                         */
                    } else if selectedTab == 2 {
                        TurnCardView(
                            viewModel: TurnCardViewModel(),
                            isShow: false,
                            select: {selected in print("Card selected \(selected)")}
                        )
                    } else if selectedTab == 3 {
                        Screen()
                    } else {
                        ProfileView(coordinator: coordinator)
                    }
                }
                .frame(maxHeight: .infinity)

                HStack() {

                    Spacer()

                    TabButton(iconUnselected: .iconNavHome,
                              iconSelected: .iconNavHomeFilled,
                              isSelected: selectedTab == 0) {
                        selectedTab = 0
                    }

                    Spacer()

                    TabButton(iconUnselected: .iconNavMap,
                              iconSelected: .iconNavMapFilled,
                              isSelected: selectedTab == 1) {
                        selectedTab = 1
                    }

                    Spacer()

                    CustomPlusButtonTabBar()
                        .onTapGesture {
                            selectedTab = 2
                        }

                    Spacer()

                    TabButton(iconUnselected: .iconNavTeam,
                              iconSelected: .iconNavTeamFilled,
                              isSelected: selectedTab == 3) {
                        selectedTab = 3
                    }

                    Spacer()

                    TabButton(iconUnselected: .iconNavProfile,
                              iconSelected: .iconNavProfileFilled,
                              isSelected: selectedTab == 4) {
                        selectedTab = 4
                    }

                    Spacer()
                }
                .padding(.vertical)
                .background(.black)
            }
        }.padding(.bottom, 50)
    }
}

#Preview {
    CustomTabView(coordinator: .init())
}
