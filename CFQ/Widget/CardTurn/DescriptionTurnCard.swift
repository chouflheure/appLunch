import SwiftUI

struct DescriptionTurnCardDetailView: View {
    @StateObject var viewModel: TurnCardViewModel
    @State private var textViewHeight: CGFloat = 100
    @State private var lastText: String = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            AutoGrowingTextView(
                text: $viewModel.description,
                minHeight: 100,
                calculatedHeight: $textViewHeight,
                placeholder: StringsToken.Turn.placeholderDescriptionEvent
            )
            .foregroundColor(.white)
            .frame(height: textViewHeight)
            .background(.clear)
            .onChange(of: viewModel.description) { newValue in
                print("Texte modifié : \(newValue)")

                if newValue.count > viewModel.description.count {
                    let diff = newValue.suffix(
                        newValue.count - viewModel.description.count)
                    if diff.contains("\n") {
                        print("⏎ Retour à la ligne détecté !")
                    }
                }

                lastText = newValue
                viewModel.description = newValue
            }
             
        }
    }
}

struct DescriptionTurnCardPreviewView: View {
    @StateObject var viewModel: TurnCardViewModel

    var body: some View {

        HStack {
            Text(viewModel.description.isEmpty ? StringsToken.Turn.placeholderDescriptionEvent : viewModel.description)
                .tokenFont(viewModel.description.isEmpty ? .Placeholder_Inter_Regular_14 : .Body_Inter_Regular_14)
                .padding(.bottom, 20)
                .padding(.top, 10)
                .lineLimit(3)
                .multilineTextAlignment(.leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}


struct AutoGrowingTextView: UIViewRepresentable {
    @Binding var text: String
    var minHeight: CGFloat
    @Binding var calculatedHeight: CGFloat
    var placeholder: String

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.delegate = context.coordinator
        textView.backgroundColor = .clear
        textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        textView.textColor = .white

        // Configuration du placeholder
        let placeholderLabel = UILabel()
        placeholderLabel.text = placeholder
        placeholderLabel.font = UIFont.preferredFont(forTextStyle: .body)
        placeholderLabel.sizeToFit()
        placeholderLabel.textColor = .lightGray
        textView.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: 8)

        // Masquer le placeholder si le texte n'est pas vide
        updatePlaceholderVisibility(textView: textView, placeholderLabel: placeholderLabel)

        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        if uiView.text != self.text {
            uiView.text = self.text
            // Mettre à jour la visibilité du placeholder
            if let placeholderLabel = uiView.subviews.first(where: { $0 is UILabel }) as? UILabel {
                updatePlaceholderVisibility(textView: uiView, placeholderLabel: placeholderLabel)
            }
        }

        AutoGrowingTextView.recalculateHeight(
            view: uiView, result: $calculatedHeight, minHeight: minHeight)
    }

    private func updatePlaceholderVisibility(textView: UITextView, placeholderLabel: UILabel) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }

    static func recalculateHeight(
        view: UIView, result: Binding<CGFloat>, minHeight: CGFloat
    ) {
        let newSize = view.sizeThatFits(
            CGSize(width: view.bounds.width, height: .greatestFiniteMagnitude))
        DispatchQueue.main.async {
            result.wrappedValue = max(newSize.height, minHeight)
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(
            text: $text,
            height: $calculatedHeight,
            minHeight: minHeight,
            placeholder: placeholder
        )
    }

    class Coordinator: NSObject, UITextViewDelegate {
        var text: Binding<String>
        var height: Binding<CGFloat>
        var minHeight: CGFloat
        var placeholder: String

        init(
            text: Binding<String>, height: Binding<CGFloat>, minHeight: CGFloat, placeholder: String
        ) {
            self.text = text
            self.height = height
            self.minHeight = minHeight
            self.placeholder = placeholder
        }

        func textViewDidChange(_ textView: UITextView) {
            text.wrappedValue = textView.text
            AutoGrowingTextView.recalculateHeight(view: textView, result: height, minHeight: minHeight)
            updatePlaceholderVisibility(textView: textView)
        }

        private func updatePlaceholderVisibility(textView: UITextView) {
            if let placeholderLabel = textView.subviews.first(where: { $0 is UILabel }) as? UILabel {
                placeholderLabel.isHidden = !textView.text.isEmpty
            }
        }

        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            if text == "\n" {
                // Ajoutez ici votre logique personnalisée
            }
            return true
        }
    }
}



import SwiftUI

struct AutoSizingTextView: UIViewRepresentable {
    @Binding var text: String
    @Binding var height: CGFloat
    let minHeight: CGFloat
    let maxHeight: CGFloat
    let onFocusChange: ((Bool) -> Void)? = nil

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.backgroundColor = UIColor.clear
        textView.delegate = context.coordinator
        textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
        DispatchQueue.main.async {
            let size = uiView.sizeThatFits(CGSize(width: uiView.bounds.width, height: CGFloat.greatestFiniteMagnitude))
            height = min(max(size.height, minHeight), maxHeight)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UITextViewDelegate {
        var parent: AutoSizingTextView

        init(_ parent: AutoSizingTextView) {
            self.parent = parent
        }

        func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
        }

        func textViewDidBeginEditing(_ textView: UITextView) {
            parent.onFocusChange?(true)
        }

        func textViewDidEndEditing(_ textView: UITextView) {
            parent.onFocusChange?(false)
        }
    }
}


struct AutoGrowingTextView2: UIViewRepresentable {
    @Binding var text: String
    var minHeight: CGFloat
    var maxHeight: CGFloat = 200  // Hauteur maximale avant de permettre le défilement
    @Binding var calculatedHeight: CGFloat

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.delegate = context.coordinator
        textView.backgroundColor = .clear
        textView.setContentCompressionResistancePriority(
            .defaultLow, for: .horizontal)
        textView.textColor = .white
        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        if uiView.text != self.text {
            uiView.text = self.text
        }

        AutoGrowingTextView2.recalculateHeight(
            view: uiView, result: $calculatedHeight, minHeight: minHeight,
            maxHeight: maxHeight)

        // Activer ou désactiver le défilement en fonction de la hauteur calculée
        uiView.isScrollEnabled = calculatedHeight >= maxHeight
    }

    static func recalculateHeight(
        view: UIView, result: Binding<CGFloat>, minHeight: CGFloat,
        maxHeight: CGFloat
    ) {
        let newSize = view.sizeThatFits(
            CGSize(width: view.bounds.width, height: .greatestFiniteMagnitude))
        let limitedHeight = min(max(newSize.height, minHeight), maxHeight)
        DispatchQueue.main.async {
            result.wrappedValue = limitedHeight
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(
            text: $text, height: $calculatedHeight, minHeight: minHeight,
            maxHeight: maxHeight)
    }

    class Coordinator: NSObject, UITextViewDelegate {
        var text: Binding<String>
        var height: Binding<CGFloat>
        var minHeight: CGFloat
        var maxHeight: CGFloat

        init(
            text: Binding<String>, height: Binding<CGFloat>, minHeight: CGFloat,
            maxHeight: CGFloat
        ) {
            self.text = text
            self.height = height
            self.minHeight = minHeight
            self.maxHeight = maxHeight
        }

        func textViewDidChange(_ textView: UITextView) {
            text.wrappedValue = textView.text
            AutoGrowingTextView2.recalculateHeight(
                view: textView, result: height, minHeight: minHeight,
                maxHeight: maxHeight)
        }

        func textView(
            _ textView: UITextView,
            shouldChangeTextIn range: NSRange,
            replacementText text: String
        ) -> Bool {
            if text == "\n" {
                // Tu peux ajouter ici une logique comme :
                // - Ajouter une puce
                // - Déclencher une validation
                // - Modifier ton texte manuellement
            }
            return true  // important pour que le saut de ligne fonctionne
        }
    }
}

#Preview {
    ZStack {
        Color.blue.edgesIgnoringSafeArea(.all)
        // DescriptionTurnCard(viewModel: TurnCardViewModel(), isPreviewCard: true)
    }
}
