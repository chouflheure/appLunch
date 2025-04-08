
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

    var array = [HeaderPreviewCardTurn(backgroundImageEvent: nil, title: "TESSSST", date: nil),
                 HeaderPreviewCardTurn(backgroundImageEvent: .header, title: "Tomorolland", date: DateLabel(dayEventString: "20", monthEventString: "oct")),
                 HeaderPreviewCardTurn(backgroundImageEvent: .header, title: "TESSSST", date: nil),
                 HeaderPreviewCardTurn(backgroundImageEvent: nil, title: "TESSSST", date: nil),
                 HeaderPreviewCardTurn(backgroundImageEvent: nil, title: "TESSSST", date: nil),
                 HeaderPreviewCardTurn(backgroundImageEvent: .header, title: "Tomorolland", date: DateLabel(dayEventString: "20", monthEventString: "oct")),
                 HeaderPreviewCardTurn(backgroundImageEvent: nil, title: "TESSSST", date: nil),
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
                        Text("Brouillons " + "(\(array.count))")
                            .tokenFont(.Body_Inter_Medium_12)
                        
                        ForEach(0..<array.count, id: \.self) { index in
                            CellPreviewCardTurn(data: array[index], coordinator: coordinator)
                                .padding(.bottom, 15)
                        }
                    }
                    .padding(.leading, 16)
                }
            }
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

#Preview {
    ZStack {
        Color.white
        CellPreviewCardTurn(
            data: HeaderPreviewCardTurn(
                backgroundImageEvent: nil,
                title: "",
                date: nil
            ),
            coordinator: Coordinator()
        )
    }
}
