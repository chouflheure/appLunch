
import SwiftUI

class HeaderPreviewCardTurn {
    var backgroundImageEvent: ImageResource?
    var title : String
    var date: DateLabel?
    
    init(backgroundImageEvent: ImageResource?, title: String, date: DateLabel?) {
        self.backgroundImageEvent = backgroundImageEvent
        self.title = title
        self.date = date
    }
}

struct TurnListScreen: View {
    
    @ObservedObject var coordinator: Coordinator
    @StateObject var vm = TurnCoreDataViewModel()

    var arrayTurn = [
        Turn(uid: "1", titleEvent: "TESSSST", date: nil, pictureURLString: "", admin: "", description: "On va se faire une super soirée et se mettre une grosse ciasse uiiiiiii", invited: [""], participants: [""], mood: [0,1,2,3], messagerieUUID: "", placeTitle: "", placeAdresse: "", placeLatitude: 1.1, placeLongitude: 1.2),
        Turn(uid: "2", titleEvent: "Tomorolland", date: nil, pictureURLString: "", admin: "", description: "", invited: [""], participants: [""], mood: [0], messagerieUUID: "", placeTitle: "", placeAdresse: "", placeLatitude: 1.1, placeLongitude: 1.2),
        Turn(uid: "3", titleEvent: "Coucou", date: nil, pictureURLString: "", admin: "", description: "", invited: [""], participants: [""], mood: [0], messagerieUUID: "", placeTitle: "", placeAdresse: "", placeLatitude: 1.1, placeLongitude: 1.2),
        Turn(uid: "4", titleEvent: "Tomorolland", date: nil, pictureURLString: "", admin: "", description: "", invited: [""], participants: [""], mood: [0], messagerieUUID: "", placeTitle: "", placeAdresse: "", placeLatitude: 1.1, placeLongitude: 1.2),
        Turn(uid: "5", titleEvent: "TESSSST", date: nil, pictureURLString: "", admin: "", description: "", invited: [""], participants: [""], mood: [0], messagerieUUID: "", placeTitle: "", placeAdresse: "", placeLatitude: 1.1, placeLongitude: 1.2)
        
    ]
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                Text("TURN")
                    .bold()
                    .tokenFont(.Title_Gigalypse_24)
                
                Spacer()
            }
            .padding(.bottom, 15)
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    HStack {
                        Spacer()
                        Button(
                            action: {
                                withAnimation {
                                    coordinator.showTurnCardView = true
                                }
                            },
                            label: {
                                Image(.iconPlus)
                                    .resizable()
                                    .foregroundColor(.white)
                                    .frame(width: 35, height: 35)
                            })
                        Spacer()
                    }.padding(.bottom, 30)

                    VStack(alignment: .leading) {
                        Text("Brouillons " + "(\(vm.savedTurns.count))")
                            .tokenFont(.Body_Inter_Medium_12)

                        ForEach(vm.savedTurns) { turn in
                            CellPreviewCardTurn(turn: Turn(uid: turn.id.debugDescription, titleEvent: turn.titleEvent ?? "", date: nil, pictureURLString: "", admin: "", description: turn.descriptionEvent ?? "", invited: [""], participants: [""], mood: [0], messagerieUUID: "", placeTitle: "", placeAdresse: "", placeLatitude: 0, placeLongitude: 0), coordinator: coordinator)
                                .padding(.bottom, 15)
                        }
                        /*
                        ForEach(arrayTurn, id: \.self) { turn in
                            CellPreviewCardTurn(turn: turn, coordinator: coordinator)
                                .padding(.bottom, 15)
                        }
                         */
                    }
                    .padding(.leading, 16)
                }
            }
        }
        .onAppear {
            vm.fecthTurn()
        }
    }
}

#Preview {
    ZStack {
        NeonBackgroundImage()
        TurnListScreen(coordinator: Coordinator())
    }
}

struct CellPreviewCardTurn: View {
    var turn: Turn
    @ObservedObject var coordinator: Coordinator

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Image(.iconDate)
                    .resizable()
                    .foregroundColor(.white)
                    .frame(width: 15, height: 15)
                    .padding(.leading, 20)

                Text(turn.titleEvent)
                    .tokenFont(.Title_Gigalypse_20)
                    .padding(.vertical, 21)
                    .padding(.trailing, 20)

                Spacer()
            }
            .background(.black)
            .clipShape(CustomRoundedCorners(radius: 30, corners: [.topLeft, .topRight]))
            
            ZStack {
                CustomRoundedCorners(radius: 30, corners: [.bottomLeft, .bottomRight])
                    .fill(.gray)
                    .frame(height: 150)

                if !turn.pictureURLString.isEmpty{
                    Image(.header)
                        .resizable()
                        .clipShape(CustomRoundedCorners(radius: 30, corners: [.bottomLeft, .bottomRight]))
                        .frame(width: UIScreen.main.bounds.width - 32, height: 150)
                }
                
                Button(action: {
                    withAnimation {
                        coordinator.showTurnCardView = true
                        coordinator.turnSelected = turn
                    }
                }) {
                    Text("Modifier")
                        .tokenFont(.Body_Inter_Regular_16)
                        .foregroundColor(.white)
                        .padding(.horizontal, 30)
                        .padding(.vertical, 10)
                        .background(.black)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .overlay() {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(lineWidth: 1)
                                .foregroundColor(.white)
                        }
                }
            }
        }
        .frame(width: UIScreen.main.bounds.width - 32)
    }
}


struct CellPreviewCardTurn_Old: View {
    var data: HeaderPreviewCardTurn
    @ObservedObject var coordinator: Coordinator

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Image(.iconDate)
                    .resizable()
                    .foregroundColor(.white)
                    .frame(width: 15, height: 15)
                    .padding(.leading, 20)

                Text(data.title)
                    .tokenFont(.Title_Gigalypse_20)
                    .padding(.vertical, 21)
                    .padding(.trailing, 20)

                Spacer()
            }
            .background(.black)
            .clipShape(CustomRoundedCorners(radius: 30, corners: [.topLeft, .topRight]))
            
            ZStack {
                CustomRoundedCorners(radius: 30, corners: [.bottomLeft, .bottomRight])
                    .fill(.gray)
                    .frame(height: 150)

                if data.backgroundImageEvent != nil {
                    Image(.header)
                        .resizable()
                        .clipShape(CustomRoundedCorners(radius: 30, corners: [.bottomLeft, .bottomRight]))
                        .frame(width: UIScreen.main.bounds.width - 32, height: 150)
                }
                
                Button(action: {
                    withAnimation {
                        coordinator.showTurnCardView = true
                    }
                }) {
                    Text("Modifier")
                        .tokenFont(.Body_Inter_Regular_16)
                        .foregroundColor(.white)
                        .padding(.horizontal, 30)
                        .padding(.vertical, 10)
                        .background(.black)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .overlay() {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(lineWidth: 1)
                                .foregroundColor(.white)
                        }
                }
            }
        }
        .frame(width: UIScreen.main.bounds.width - 32)
    }
}


struct CustomRoundedCorners: Shape {
    var radius: CGFloat = 25.0
    var corners: UIRectCorner = [.allCorners]

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
