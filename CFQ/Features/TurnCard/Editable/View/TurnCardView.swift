
import SwiftUI
import Lottie

struct TurnCardView: View {
    @ObservedObject var coordinator: Coordinator
    @StateObject var coreDataViewModel = TurnCoreDataViewModel()
    @State private var toast: Toast? = nil
    @StateObject var viewModel: TurnCardViewModel

    init(coordinator: Coordinator, coreDataViewModel: TurnCoreDataViewModel) {
        self.coordinator = coordinator

        let turn = coordinator.turnSelectedPreview ?? TurnPreview(
                uid: "",
                titleEvent: "",
                dateStartEvent: nil,
                admin: "",
                description: "",
                invited: [""],
                mood: [],
                messagerieUUID: "",
                placeTitle: "",
                placeAdresse: "",
                placeLatitude: 0,
                placeLongitude: 0,
                imageEvent: nil
            )

        _viewModel = StateObject(wrappedValue: TurnCardViewModel(turn: turn, coordinator: coordinator))
    }
    
    var body: some View {
        DraggableViewLeft(isPresented: $coordinator.showTurnCardView) {
            SafeAreaContainer {
                ZStack {
                    VStack {
                        HeaderBackLeftScreen(
                            onClickBack: {
                                withAnimation {
                                    coordinator.showTurnCardView = false
                                    coordinator.turnSelected = nil
                                }
                            },
                            titleScreen: StringsToken.Turn.titleTurnPreview,
                            thirdElement: AnyView(Button(action: {
                                viewModel.showDetailTurnCard = true
                            }) {
                                Image(.iconEdit)
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.white)
                                    .frame(width: 24)
                            }),
                            isShowDivider: false
                        )
                        .padding(.horizontal, 16)
                        .zIndex(2)
                        
                        ZStack {
                            GradientCardView()
                            
                            VStack {
                                // Header ( Date / Picture / TURN )
                                HeaderCardPreviewView(viewModel: viewModel)
                                    .padding(.bottom, 15)
                                    .frame(height: 150)
                                
                                // Title ( Title / Guest )
                                TitleTurnCardPreviewView(viewModel: viewModel)
                                    .padding(.horizontal, 16)
                                    .padding(.top, 20)
                                
                                // Informations ( Mood / Date / Loc )
                                MainInformationsPreviewView(viewModel: viewModel)
                                    .padding(.horizontal, 16)
                                
                                // Description ( Bio event )
                                DescriptionTurnCardPreviewView(viewModel: viewModel)
                                    .padding(.horizontal, 16)
                                
                                Spacer()
                            }
                        }
                        .cornerRadius(20)
                        .padding(.horizontal, 12)
                        .frame(height: 550)
                        .padding(.bottom, 30)
                        .zIndex(1)
                        .onTapGesture {
                            withAnimation {
                                viewModel.showDetailTurnCard = true
                            }
                        }
                        Spacer()
                        
                        HStack(spacing: 30) {
                            Button(action: {
                                coreDataViewModel.addTurn(
                                    turn: TurnPreview(
                                        uid: UUID().description,
                                        titleEvent: viewModel.titleEvent,
                                        dateStartEvent: viewModel.dateEventStart,
                                        admin: coordinator.user?.uid ?? "",
                                        description: viewModel.description,
                                        invited: [],
                                        mood: [],
                                        messagerieUUID: "",
                                        placeTitle: "",
                                        placeAdresse: "",
                                        placeLatitude: 0,
                                        placeLongitude: 0,
                                        imageEvent: viewModel.imageSelected
                                    )
                                )
                            }, label: {
                                HStack {
                                    Image(.iconSave)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 30)
                                        .foregroundColor(.white)
                                        .padding(.leading, 15)
                                        .padding(.vertical, 10)
                                        .font(.system(size: 10, weight: .bold))
                                    
                                    Text("Brouillon")
                                        .tokenFont(.Body_Inter_Medium_14)
                                        .padding(.trailing, 15)
                                        .padding(.vertical, 10)
                                        .font(.system(size: 15, weight: .bold))
                                }
                            })
                            .frame(width: 150)
                            .background(.clear)
                            .cornerRadius(10)
                            .overlay {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(style: StrokeStyle(lineWidth: 1))
                                    .foregroundColor(.white)
                                    .background(.clear)
                            }
                            
                            Button(action: {
                                viewModel.pushDataTurn {
                                    success, message in
                                    if success {
                                        withAnimation {
                                            coordinator.showTurnCardView = false
                                            coordinator.turnSelected = nil
                                        }
                                    } else {
                                        toast = Toast(
                                            style: .error,
                                            message: message
                                        )
                                    }
                                }
                            }, label: {
                                HStack {
                                    Image(.iconSend)
                                        .foregroundColor(.white)
                                        .padding(.leading, 15)
                                        .padding(.vertical, 10)
                                    
                                    Text("Publier")
                                        .tokenFont(.Body_Inter_Medium_14)
                                        .padding(.trailing, 15)
                                        .padding(.vertical, 10)
                                        .font(.system(size: 15, weight: .bold))
                                }
                            })
                            .frame(width: 150)
                            .background(Color(hex: "B098E6").opacity(1))
                            .cornerRadius(10)
                        }
                    }
                    .blur(radius: viewModel.isLoading ? 10 : 0)
                    .allowsHitTesting(!viewModel.isLoading)
                    
                    if viewModel.isLoading {
                        ZStack {
                            LottieView(animation: .named(StringsToken.Animation.loaderCircle))
                                .playing()
                                .looping()
                                .frame(width: 150, height: 150)
                        }
                        .zIndex(3)
                    }
                }
            }
        }
        .toastView(toast: $toast)
        .fullScreenCover(isPresented: $viewModel.showDetailTurnCard) {
            TurnCardDetailsView(viewModel: viewModel, coordinator: coordinator)
        }
    }
}

#Preview {
    // TurnCardView(isShow: .constant(true))
}



/*

struct TurnCardViewAnimation: View {
    @StateObject var viewModel = TurnCardViewModel()
    var isShow: Bool
    var select: (Bool) -> Void
    @State private var dragOffset: CGFloat = 0

    // @EnvironmentObject var user: User
    var user = User(
        uid: "1234567890",
        name: "John",
        firstName: "Doe",
        pseudo: "johndoe",
        location: ["Ici"]
    )

    var body : some View {
        
        ZStack {
            GradientCardView()

            VStack {
                // Header
                HeaderCardPreviewView(viewModel: viewModel)
                    .padding(.bottom, 15)
                    .frame(height: 100)

                // Title
                TitleTurnCardPreviewView(viewModel: viewModel)
                    .padding(.horizontal, 16)

                // Informations
                MainInformationsPreviewView(viewModel: viewModel)
                    .padding(.horizontal, 16)

                // Description
                DescriptionTurnCardPreviewView(viewModel: viewModel)
                    .padding(.horizontal, 16)

                Spacer()
            }
            .cornerRadius(20)
            .frame(height: 500)
            .padding(.horizontal, 12)
        }
        .offset(y: dragOffset)
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    if isShow {
                        dragOffset = gesture.translation.height
                    }
                }
                .onEnded { gesture in
                    if isShow && dragOffset > 50 {
                        withAnimation(.spring()) {
                            dragOffset = 0
                            select(false)
                            viewModel.isEditing = false
                        }
                    } else {
                        withAnimation(.spring()) {
                            dragOffset = 0
                        }
                    }
                }
            )
        .onTapGesture {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                print("@@@ selected")
                select(!isShow)
                viewModel.isEditing = !isShow
            }
        }
    }
}
*/
/*
struct Screen: View {
    @State var selectedCradId: UUID? = nil
    var cards: [TurnCard] = [
        TurnCard(title: "test1"),
        TurnCard(title: "test2"),
        TurnCard(title: "test3")
    ]

    var body: some View {
        VStack {
            Spacer()
            ZStack {
                ForEach(cards.indices, id: \.self) { card in
                    TurnCardViewAnimation(isShow: selectedCradId == cards[card].id,
                                 select: {self.selectedCradId = $0 ? cards[card].id : nil}
                    )
                    .offset(y: calculateOffSetForCard(at: card))
                }
            }.frame(height: 10)
        }
    }

    func calculateOffSetForCard(at index: Int) -> CGFloat {
        let selectedCardIndex = cards.firstIndex(where: {$0.id == selectedCradId})
        switch selectedCardIndex {
        case .none:
            return CGFloat(index * 80)
        case .some(let selectedIndex) where selectedIndex == index:
            let screenHeight = UIScreen.main.bounds.height
            let cardHeight: CGFloat = 500
            let centerOffset = (screenHeight - (cardHeight - CGFloat(index * 80))) / 2
            return -screenHeight/2
        case .some:
            return 300

        }
    }
}

#Preview {
    Screen()
}
*/
