
import SwiftUI

struct PreviewMessagerieScreenView: View {
    @ObservedObject var coordinator: Coordinator
    @ObservedObject var viewModel = PreviewMessagerieScreenViewModel()
    
    var body: some View {
        DraggableViewLeft(isPresented: $coordinator.showMessageScreen) {
            SafeAreaContainer {
                VStack {
                    HeaderBackLeftScreen(
                        onClickBack: {
                            withAnimation {
                                coordinator.showMessageScreen = false
                            }
                        },
                        titleScreen: StringsToken.Messaging.titleScreen
                    )
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(alignment: .leading) {
                            SearchBarView(
                                text: $viewModel.researchText,
                                placeholder: StringsToken.SearchBar.placeholderConversation,
                                onRemoveText: {
                                    viewModel.removeText()
                                },
                                onTapResearch: {
                                    viewModel.researche()
                                }
                            ).padding(.top, 16)
                            
                            ForEach(Array(viewModel.messageList), id: \.self) { data in
                                CellMessagingView(data: data) { _ in
                                    
                                }
                                    .padding(.top, 16)
                            }.padding(.horizontal, 16)
                        }
                    }
                    
                    
                }
            }
        }
    }
}

#Preview {
    ZStack {
        NeonBackgroundImage()
        PreviewMessagerieScreenView(coordinator: Coordinator())
    }.ignoresSafeArea()
}
