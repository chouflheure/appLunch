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

                Text(StringsToken.Turn.titleTurn)
                    .bold()
                    .tokenFont(.Title_Gigalypse_24)

                Spacer()
            }
            .padding(.top, 50)
            .padding(.bottom, 15)

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    HStack {
                        Spacer()
                        VStack {
                            Text(StringsToken.Turn.newTurn)
                                .textCase(.uppercase)
                                .padding(.bottom, 5)
                            Button(
                                action: {
                                    withAnimation {
                                        coordinator.turnSelectedPreview = nil
                                        coordinator.showTurnCardView = true
                                    }
                                },
                                label: {
                                    Image(.iconPlus)
                                        .resizable()
                                        .foregroundColor(.white)
                                        .frame(width: 35, height: 35)
                                })
                        }
                        Spacer()
                    }
                    .padding(.all, 30)

                    VStack(alignment: .leading) {
                        Text(StringsToken.Turn.brouillon + "\(vm.savedTurns.count > 1 ? "s" : "") " + "(\(vm.savedTurns.count))")
                            .tokenFont(.Body_Inter_Medium_14)
                            .padding(.bottom, 20)

                        ForEach(Array(vm.savedTurns.enumerated()), id: \.element.id) { index, element in
                            CellPreviewCardTurn(
                                turn: TurnPreview(
                                    uid: element.id.debugDescription,
                                    titleEvent: element.titleEvent ?? "",
                                    dateStartEvent: element.dateEvent,
                                    admin: coordinator.user?.uid ?? "",
                                    description: element.descriptionEvent ?? "",
                                    invited: [""],
                                    mood: [],
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
        
        .onChange(of: coordinator.showTurnCardView) { _ in
            if !coordinator.showTurnCardView {
                vm.fecthTurn()
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
                    if let date = turn.dateStartEvent {
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
                    .padding(.trailing, 0)
                    .offset(x: 5, y: -30)
                    .frame(width: 40, height: 40)
                }
            }
            .zIndex(2)
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
                        .scaledToFill()
                        .frame(width: UIScreen.main.bounds.width - 32, height: 150)
                        .clipped()
                        .clipShape(
                            CustomRoundedCorners(
                                radius: 30,
                                corners: [.bottomLeft, .bottomRight])
                        )
                        .frame(height: 150)
                       
                }
            }
            .onTapGesture {
                coordinator.turnSelectedPreview = turn
                withAnimation {
                    coordinator.showTurnCardView = true
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
