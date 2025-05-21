import SwiftUI

struct GrowingTextView: UIViewRepresentable {
    @Binding var text: String
    @Binding var dynamicHeight: CGFloat
    var availableWidth: CGFloat
    var placeholder: String

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.delegate = context.coordinator
        textView.text = text
        textView.backgroundColor = .clear
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.widthAnchor.constraint(equalToConstant: availableWidth).isActive = true

        // Ajouter le placeholder
        let placeholderLabel = UILabel()
        placeholderLabel.text = placeholder
        placeholderLabel.font = UIFont.systemFont(ofSize: 16)
        placeholderLabel.sizeToFit()
        placeholderLabel.textColor = .lightGray
        textView.addSubview(placeholderLabel)

        placeholderLabel.frame.origin = CGPoint(x: 5, y: 0)
        placeholderLabel.isHidden = !text.isEmpty

        context.coordinator.placeholderLabel = placeholderLabel

        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        if uiView.text != self.text {
            uiView.text = self.text
        }
        Self.recalculateHeight(view: uiView, result: $dynamicHeight)

        // Mettre à jour la visibilité du placeholder
        context.coordinator.placeholderLabel?.isHidden = !text.isEmpty
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text, height: $dynamicHeight)
    }

    static func recalculateHeight(view: UITextView, result: Binding<CGFloat>) {
        let fittingSize = CGSize(width: view.bounds.width, height: .greatestFiniteMagnitude)
        let newSize = view.sizeThatFits(fittingSize)

        view.isScrollEnabled = newSize.height > 100
        view.showsVerticalScrollIndicator = false

        DispatchQueue.main.async {
            result.wrappedValue = min(max(newSize.height, 20), 100)
        }
    }

    class Coordinator: NSObject, UITextViewDelegate {
        var text: Binding<String>
        var height: Binding<CGFloat>
        weak var placeholderLabel: UILabel?

        init(text: Binding<String>, height: Binding<CGFloat>) {
            self.text = text
            self.height = height
        }

        func textViewDidChange(_ textView: UITextView) {
            self.text.wrappedValue = textView.text
            GrowingTextView.recalculateHeight(view: textView, result: height)

            // Mettre à jour la visibilité du placeholder
            placeholderLabel?.isHidden = !textView.text.isEmpty
        }
    }
}



struct TestEditTextfieldSize2: View {
    @State private var text = ""
    @State private var height: CGFloat = 20
    @ObservedObject private var keyboard = KeyboardResponder()

    var body: some View {
        ZStack {
            ScrollView {
                
            }
            VStack {
                Spacer()
                
                // Barre "personnalisée" collée au bas, monte avec clavier
                VStack {
                    HStack {
                        Button(action: {
                            print("Emoji tap")
                        }) {
                            Image(systemName: "face.smiling")
                        }
                        
                        GrowingTextView(text: $text, dynamicHeight: $height, availableWidth: UIScreen.main.bounds.width, placeholder: "test")
                            .frame(height: height)
                            .padding(8)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                        
                        Button("Envoyer") {
                            print("Envoyer : \(text)")
                            text = ""
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 6)
                    .padding(.bottom, 6)
                    .background(Color.white.shadow(radius: 2))
                }
                .padding(.bottom, keyboard.currentHeight)
                .animation(.easeOut(duration: 0.25), value: keyboard.currentHeight)
            }
            // .edgesIgnoringSafeArea(.bottom)
        }
    }
}

import SwiftUI
import Combine

class KeyboardResponder: ObservableObject {
    @Published var currentHeight: CGFloat = 0
    private var cancellable: AnyCancellable?

    init() {
        cancellable = NotificationCenter.default.publisher(for: UIResponder.keyboardWillChangeFrameNotification)
            .merge(with: NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification))
            .compactMap { notification in
                guard let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
                    return 0
                }
                return frame.origin.y >= UIScreen.main.bounds.height ? 0 : frame.height
            }
            .assign(to: \.currentHeight, on: self)
    }
}
