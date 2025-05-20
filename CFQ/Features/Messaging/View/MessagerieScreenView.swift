import Combine
import SwiftUI
import UIKit

enum MessagerieHeaderType {
    case cfq
    case people
    case event
}

protocol KeyboardReadable {
    var keyboardPublisher: AnyPublisher<CGFloat, Never> { get }
}

extension KeyboardReadable {
    var keyboardPublisher: AnyPublisher<CGFloat, Never> {
        Publishers.Merge(
            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillShowNotification)
                .compactMap { notification in
                    (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height
                },
            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillHideNotification)
                .map { _ in CGFloat(0) }
        )
        .eraseToAnyPublisher()
    }
}


struct MessagerieScreenView: View, KeyboardReadable {
    @Binding var isPresented: Bool
    @ObservedObject var viewModel = MessagerieScreenViewModel()
    @State private var text: String = ""

    @State private var lastText: String = ""
    @State private var showReaction: Bool = false
    @State private var isKeyboardVisible = false
    @State private var textViewHeight: CGFloat = 20
    @State private var keyboardHeight: CGFloat = 0

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

                            CFQMolecule(
                                name: "Charles", title: "CFQ Demain ?",
                                image: ""
                            )
                            .onTapGesture {
                                withAnimation {
                                    viewModel.showConversationOptionView = true
                                }
                            }

                            Spacer()

                            Button(action: {
                                // viewModel.showDetailGuest = true
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

                        ZStack {

                            /*
                            Image(.background3)
                                .resizable()
                                .opacity(0.8)
                                .ignoresSafeArea()
                            */

                            VStack(spacing: 0) {
                                ScrollViewReader { proxy in
                                    ScrollView(
                                        .vertical, showsIndicators: false
                                    ) {
                                        LazyVStack(spacing: 10) {
                                            CellMessageView()
                                                .rotationEffect(.degrees(180))
                                            CellMessageView()
                                                .rotationEffect(.degrees(180))
                                            CellMessageView()
                                                .rotationEffect(.degrees(180))
                                            CellMessageView()
                                                .rotationEffect(.degrees(180))
                                            CellMessageSendByTheUserView(
                                                textMessage: .constant(
                                                    "Test de message qui vient de l'user"
                                                ),
                                                onDoubleTap: {
                                                    withAnimation {
                                                        print("@@@ 2 tap ")
                                                        self.showReaction = true
                                                    }
                                                }
                                            )
                                            .rotationEffect(.degrees(180))
                                            .padding(.horizontal, 12)

                                            ForEach(
                                                (0..<viewModel.messages.count)
                                                    .reversed(), id: \.self
                                            ) { index in
                                                CellMessageView2(
                                                    textMessage:
                                                        $viewModel.messages[
                                                            index]
                                                )
                                                .padding(.horizontal, 12)
                                                .rotationEffect(.degrees(180))
                                            }
                                        }
                                        .frame(maxWidth: .infinity)
                                    }
                                    .rotationEffect(.degrees(180))

                                    .onChange(of: viewModel.messages.count) {
                                        _ in
                                        withAnimation(.easeOut(duration: 0.3)) {
                                            proxy.scrollTo(
                                                viewModel.messages.count - 1,
                                                anchor: .top)
                                        }
                                    }
                                }
                                Spacer()
                                    .frame(height: textViewHeight + 30)
                            }

                            VStack {
                                Spacer()
                                GeometryReader { geometry in
                                    HStack(alignment: .bottom) {
                                        GrowingTextView(
                                            text: $viewModel.textMessage,
                                            dynamicHeight: $textViewHeight,
                                            availableWidth: geometry.size.width - 80
                                        )
                                        .frame(height: textViewHeight)
                                        .padding(8)
                                        .background(.red)
                                        .cornerRadius(8)
                                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))

                                        if !viewModel.textMessage.isEmpty {
                                            Button(action: {
                                                viewModel.messages.append(viewModel.textMessage)
                                                viewModel.textMessage = ""
                                            }) {
                                                Image(.iconSend)
                                                    .foregroundColor(.white)
                                                    .padding(5)
                                                    .background(.purpleDark)
                                                    .clipShape(Circle())
                                            }
                                            .frame(width: 15, height: 15)
                                            .padding(.horizontal, 10)
                                            .padding(.bottom, 10)
                                        }
                                    }
                                    .padding(.horizontal, 12)
                                    .padding(.bottom, keyboardHeight == 0 ? 30 : keyboardHeight)

//                                     .padding(.bottom, keyboardHeight + 10) // ✅ dynamique
                                }
                                .frame(height: textViewHeight + 30)
                            }


                        }
                        .blur(radius: showReaction ? 10 : 0)
                        .allowsHitTesting(!showReaction)
                        // .ignoresSafeArea()
                    }
                    if showReaction {
                        destinationView()
                            // .transition(.move(edge: .trailing))
                            .zIndex(2)
                        // ReactionPreviewView(showReaction: $showReaction)
                    }
                }

                .scrollDismissesKeyboard(.interactively)
            }
        }
        .onReceive(keyboardPublisher) { height in
            withAnimation(.easeOut(duration: 0.25)) {
                self.keyboardHeight = height
            }
        }
        .animation(.easeOut(duration: 0.25), value: keyboardHeight)


        if viewModel.showConversationOptionView {
            destinationView()
                .transition(.move(edge: .trailing))
                .zIndex(1)
        }
    }

    @ViewBuilder
    func destinationView() -> some View {
        // ReactionPreviewView(showReaction: $showReaction)
        // MessagerieScreenView(isPresented: $viewModel.showDetailGuest)
        ConversationOptionView(
            isPresented: $viewModel.showConversationOptionView)
    }
}

#Preview {
    ZStack {
        NeonBackgroundImage()
        MessagerieScreenView(isPresented: .constant(true))
    }
}

struct ConversationOptionView: View {
    @Binding var isPresented: Bool

    var body: some View {
        DraggableViewLeft(isPresented: $isPresented) {
            SafeAreaContainer {
                VStack {
                    HeaderBackLeftScreen(
                        onClickBack: { withAnimation { isPresented = false } },
                        titleScreen: "Info du groupe "
                    )
                    ScrollView {
                        VStack {
                            Image(.header)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())

                            Text("Titre du groupe")
                                .tokenFont(.Title_Inter_semibold_24)

                            // MEDIA PART
                            ConversationOptionPart(
                                icon: .iconAdduser, title: "Ajouter quelqu'un",
                                onTap: {})
                            ConversationOptionPart(
                                icon: .iconSearch,
                                title: "Rechercher dans la conv", onTap: {})
                            ConversationOptionPart(
                                icon: .icon, title: "Medias", nbElement: 8,
                                onTap: {})

                            PageView(pageViewType: .invited)
                                .frame(height: 300)

                            Spacer()

                            Button("coucou", action: {})
                        }
                    }
                    .padding(.vertical, 20)
                    .padding(.horizontal, 12)
                }
            }
            .ignoresSafeArea(.keyboard)
            .onTapGesture {
                UIApplication.shared.endEditing()
            }
        }
    }
}

private struct ConversationOptionPart: View {
    var icon: ImageResource
    var title: String
    var nbElement: Int?
    var onTap: () -> Void

    var body: some View {
        HStack {
            Image(icon)
                .resizable()
                .scaledToFill()
                .frame(width: 20, height: 20)
                .foregroundColor(.white)
            Text(title)
                .tokenFont(.Body_Inter_Medium_16)
            Spacer()
            Text(nbElement != nil ? "\(nbElement!)" : "")
                .tokenFont(.Placeholder_Inter_Regular_16)
            Image(.iconArrow)
                .resizable()
                .scaledToFill()
                .frame(width: 20, height: 20)
                .foregroundColor(.gray)
                .rotationEffect(.init(degrees: 180))

        }
        .padding()
        .background(.black)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .stroke(.whiteTertiary, lineWidth: 1)
        }
        .onTapGesture {
            onTap()
        }
    }
}

#Preview {
    ZStack {
        NeonBackgroundImage()
        ConversationOptionView(isPresented: .constant(false))
    }
}
