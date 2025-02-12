
import SwiftUI
import MapKit

struct CustomPlusButton: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(LinearGradient(
                    gradient: Gradient(colors: [Color.purple, Color.blue.opacity(0.4)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
                .blur(radius: 1, opaque: true)
                .cornerRadius(10)
                .frame(width: 55, height: 55)

            Rectangle()
                .foregroundColor(.black)
                .cornerRadius(10)
                .frame(width: 50, height: 50)
                .shadow(radius: 30)

            Image(systemName: "plus")
                .font(.system(size: 30, weight: .bold))
                .foregroundColor(.white)
        }
    }
}

struct CustomTabView: View {
    @State private var selectedTab = 0
    @State private var selectedEvent: MapLocationEventData? = nil

    var body: some View {
        ZStack {
            Image(.backgroundNeon)
                .resizable()
                .ignoresSafeArea()
            VStack {
                Group {
                    if selectedTab == 0 {
                        // SignScreen()
                         Text("Feed")
                            .foregroundStyle(.white)
                    } else if selectedTab == 1 {
                        Text("Map Screen")
                            .foregroundStyle(.white)
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
                        // Test()
                        Text("Team Screen").foregroundStyle(.white)
                    } else {
                        Screen()
                        //Text("Profile Screen").foregroundStyle(.white)
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

                    CustomPlusButton()
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
        }
    }
}

struct TabButton: View {
    let iconUnselected: ImageResource
    let iconSelected: ImageResource
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(isSelected ? iconSelected : iconUnselected)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(isSelected ? .blue : .gray)
        }
    }
}


#Preview {
    CustomTabView()
}
