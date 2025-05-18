import SwiftUI

struct PreviewMessagerieScreenView: View {
    @ObservedObject var coordinator: Coordinator
    @ObservedObject var viewModel = PreviewMessagerieScreenViewModel()
    @State private var showDetail = false
    @State private var showDetailPopUp = false

    var body: some View {
        DraggableViewLeft(isPresented: $coordinator.showMessageScreen) {
            SafeAreaContainer {
                VStack(spacing: 0) {
                    HeaderBackLeftScreen(
                        onClickBack: {
                            withAnimation {
                                coordinator.showMessageScreen = false
                            }
                        },
                        titleScreen: StringsToken.Messaging.titleScreen
                    )
                    ScrollView(.vertical, showsIndicators: false) {
                        Spacer()
                            .frame(height: 12)
                        VStack(alignment: .leading) {
                            SearchBarView(
                                text: $viewModel.researchText,
                                placeholder: StringsToken.SearchBar
                                    .placeholderConversation,
                                onRemoveText: {
                                    viewModel.removeText()
                                },
                                onTapResearch: {
                                    viewModel.researche()
                                }
                            ).padding(.top, 16)

                            ForEach(viewModel.messageList, id: \.self) {
                                data in
                                CellMessagingView(data: data) { _ in
                                    withAnimation {
                                        showDetail = true
                                    }
                                }.padding(.top, 16)
                            }.padding(.horizontal, 16)
                        }
                    }

                }
            }
            .ignoresSafeArea(.keyboard)
            .onTapGesture {
                UIApplication.shared.endEditing()
            }
        }

        if showDetail {
            destinationView()
                .transition(.move(edge: .trailing))
                .zIndex(1)
        }
    }

    @ViewBuilder
    func destinationView() -> some View {
        MessagerieScreenView(isPresented: $showDetail)
    }
}

#Preview {
    ZStack {
        NeonBackgroundImage()
        PreviewMessagerieScreenView(coordinator: Coordinator())
    }.ignoresSafeArea()
}
