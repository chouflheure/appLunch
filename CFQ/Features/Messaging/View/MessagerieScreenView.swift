import SwiftUI

enum MessagerieHeaderType {
    case cfq
    case people
    case event
}

struct MessagerieScreenView: View {
    @Binding var isPresented: Bool
    @ObservedObject var viewModel = MessagerieScreenViewModel()
    @State private var text: String = ""
    @State private var textViewHeight: CGFloat = 15
    @State private var lastText: String = ""

    var body: some View {
        DraggableViewLeft(isPresented: $isPresented) {
            SafeAreaContainer {
                ZStack {
                    VStack {
                        HStack {
                            Button(action: {
                                withAnimation {
                                    isPresented = false
                                }
                            }) {
                                Image(.iconArrow)
                                    .foregroundStyle(.white)
                                    .frame(width: 24, height: 24)
                            }

                            Spacer()

                            CFQMolecule(name: "Charles", title: "CFQ Demain")
                                .onTapGesture {
                                    print("@@@ tap")
                                }

                            Spacer()

                            Button(action: {
                                viewModel.showDetailGuest = true
                            }) {
                                Image(.iconGuests)
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.white)
                                    .frame(width: 24)
                            }.padding(.trailing, 16)

                            Button(action: {
                                viewModel.showSettingMessagerie = true
                            }) {
                                Image(.iconDots)
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.white)
                                    .frame(width: 24)
                            }
                        }
                        .padding(.horizontal, 12)

                        Divider()
                            .background(.white)

                        Spacer()
                        
                        CellMessageView()

                        AutoGrowingTextView2(
                            text: $viewModel.textMessage,
                            minHeight: 15,
                            calculatedHeight: $textViewHeight
                        )
                        .foregroundColor(.white)
                        .padding(.top, 30)
                        .padding(.horizontal, 12)
                        .padding(.bottom, 30)
                        .frame(height: textViewHeight)
                        .background(.black)
                        .zIndex(2)
                        .onChange(of: viewModel.textMessage) { newValue in
                            if newValue.count > viewModel.textMessage.count {
                                let diff = newValue.suffix(newValue.count - viewModel.textMessage.count)
                                if diff.contains("\n") {
                                    print("⏎ Retour à la ligne détecté !")
                                }
                            }

                            lastText = newValue
                            viewModel.textMessage = newValue
                        }
                        .overlay {
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white, lineWidth: 1)
                        }
                    }
                }
            }
        }

        if viewModel.showDetailGuest {
            destinationView()
                .transition(.move(edge: .trailing))
                .zIndex(1)
        }
    }

    @ViewBuilder
    func destinationView() -> some View {
        MessagerieScreenView(isPresented: $viewModel.showDetailGuest)
    }
}

#Preview {
    ZStack {
        NeonBackgroundImage()
        MessagerieScreenView(isPresented: .constant(true))
    }
}
