import SwiftUI

class HeaderPreviewCardTurn {
    var backgroundImageEvent: ImageResource?
    var title: String
    var date: DateLabel?

    init(backgroundImageEvent: ImageResource?, title: String, date: DateLabel?)
    {
        self.backgroundImageEvent = backgroundImageEvent
        self.title = title
        self.date = date
    }
}

struct TurnListScreen: View {

    @ObservedObject var coordinator: Coordinator
    @StateObject var vm = TurnCoreDataViewModel()

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

                        ForEach(Array(vm.savedTurns.enumerated()), id: \.element.id) { index, element in
                            CellPreviewCardTurn(
                                turn: TurnPreview(
                                    uid: element.id.debugDescription,
                                    titleEvent: element.titleEvent ?? "",
                                    date: element.dateEvent,
                                    admin: "",
                                    description: element.descriptionEvent ?? "",
                                    invited: [""],
                                    mood: [0],
                                    messagerieUUID: "",
                                    placeTitle: "",
                                    placeAdresse: "",
                                    placeLatitude: 0,
                                    placeLongitude: 0,
                                    imageEvent: UIImage(data: element.imageEvent ?? Data())
                                ),
                                coordinator: coordinator,
                                onDelete: {
                                    vm.deleteTurn(at: index)
                                }
                            )
                            .padding(.bottom, 15)
                        }
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
    var turn: TurnPreview
    @ObservedObject var coordinator: Coordinator
    var onDelete: () -> Void = { }

    private func textFormattedShortFormat(date: Date?) -> (jour: String, mois: String) {
        let formatter = DateFormatter()
        var jour = ""
        var mois = ""
        
        if let date = date {
            formatter.dateFormat = "d"
            formatter.locale = Locale(identifier: "fr_FR")
            jour = formatter.string(from: date).capitalized
            
            formatter.dateFormat = "MMM"
            formatter.locale = Locale(identifier: "fr_FR")
            mois = formatter.string(from: date).uppercased()
        }

        return (jour, mois)
    }
    
    var body: some View {

        VStack(spacing: 0) {
            ZStack {
                HStack {
                    if let date = turn.date {
                        VStack(alignment: .center) {
                            Text(textFormattedShortFormat(date: date).jour)
                                .tokenFont(.Title_Inter_semibold_24)
                            Text(textFormattedShortFormat(date: date).mois)
                                .tokenFont(.Body_Inter_Regular_14)
                        }
                        .padding(.leading, 30)
                    } else {
                        Image(.iconDate)
                            .resizable()
                            .foregroundColor(.white)
                            .frame(width: 25, height: 25)
                            .padding(.leading, 30)
                    }
                    Text(turn.titleEvent)
                        .tokenFont(.Title_Gigalypse_24)
                        .padding(.vertical, 21)
                        .padding(.leading, 10)
                        .padding(.trailing, 20)
                    
                    Spacer()
                }
                .background(.black)
                .clipShape(
                    CustomRoundedCorners(
                        radius: 30, corners: [.topLeft, .topRight]))
                
                HStack {
                    Spacer()
                    Button(action: {
                        onDelete()
                    }) {
                        Image(systemName: "xmark")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 10, height: 10)
                            .foregroundColor(.white)
                            .padding(9)
                            .background(Color.black)
                            .clipShape(Circle())
                            .overlay {
                                Circle()
                                    .strokeBorder(Color.white, lineWidth: 1)
                            }
                    }
                    .padding(.trailing, 5)
                    .offset(y: -30)
                }
            }
            .frame(height: 60)

            ZStack {
                CustomRoundedCorners(
                    radius: 30, corners: [.bottomLeft, .bottomRight]
                )
                .fill(.gray)
                .frame(height: 150)

                if let image = turn.imageEvent {
                    Image(uiImage: image)
                        .resizable()
                        .clipShape(
                            CustomRoundedCorners(
                                radius: 30,
                                corners: [.bottomLeft, .bottomRight])
                        )
                        .frame(
                            width: UIScreen.main.bounds.width - 32, height: 150)
                }

                Button(action: {
                    withAnimation {
                        coordinator.showTurnCardView = true
                        coordinator.turnSelectedPreview = turn
                    }
                }) {
                    Text("Modifier")
                        .tokenFont(.Body_Inter_Regular_16)
                        .foregroundColor(.white)
                        .padding(.horizontal, 30)
                        .padding(.vertical, 10)
                        .background(.black)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .overlay {
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
/*
#Preview {
    CellPreviewCardTurn(
        turn: Turn(
            uid: "", titleEvent: "turn.titleEvent", date: Date(),
            pictureURLString: "", admin: "",
            description: "turn.descriptionEvent", invited: [""],
            participants: [""], mood: [0], messagerieUUID: "", placeTitle: "",
            placeAdresse: "", placeLatitude: 0, placeLongitude: 0),
        coordinator: Coordinator())

}*/

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
