import SwiftUI


import UIKit
import FirebaseFirestore

class SearchViewController: UIViewController, UISearchBarDelegate {

    let searchBar = UISearchBar()
    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
    }

    private func setupSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "Rechercher un utilisateur..."
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchBar)

        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Appeler la fonction de recherche lorsque le texte change
        searchUsers(with: searchText)
    }

    private func searchUsers(with query: String) {
        // Assurez-vous que la requête n'est pas vide
        guard !query.isEmpty else { return }

        // Effectuer la recherche dans Firestore
        db.collection("users")
            .whereField("name", isGreaterThanOrEqualTo: query)
            .whereField("name", isLessThanOrEqualTo: query + "\u{f8ff}")
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Erreur lors de la recherche d'utilisateurs : \(error.localizedDescription)")
                    return
                }

                // Traiter les documents retournés
                for document in querySnapshot?.documents ?? [] {
                    let userData = document.data()
                    print("Utilisateur trouvé : \(userData)")
                    // Traiter les données de l'utilisateur comme nécessaire
                }
            }
    }
}



struct CachedImageTest: View {
    let imageUrls = [
        "https://fastly.picsum.photos/id/259/300/200.jpg?hmac=e_J_gQv6y2AxQsJlXwfkBEowmdfiLmsjeGQIRDLQEuI",
        "https://fastly.picsum.photos/id/1021/300/200.jpg?hmac=Uwq-p1xg_lU331olJw79oBVMPMWXSnwp5E9SsFgF87g",
        "https://fastly.picsum.photos/id/613/300/200.jpg?hmac=HBef6BibNUIRVnUP6cjqz8gfXjGiA2spUhRV_R91eqo",
        "https://fastly.picsum.photos/id/260/300/200.jpg?hmac=VffmZ4w9F53iikwGIGpglNpADhZiEqsuwJFwIGOE4Zg",
        "https://fastly.picsum.photos/id/1054/300/200.jpg?hmac=QdR5jgF9dCDjHJSERQn6DN6dAeNWaVa54JbmsNZo2Q0"
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 16) {
                    ForEach(imageUrls, id: \.self) { url in
                        ModernCachedAsyncImage(
                            url: url,
                            placeholder: Image(systemName: "photo.fill")
                        )
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 150)
                        .clipped()
                        .cornerRadius(12)
                        .shadow(radius: 4)
                    }
                }
                .padding()
            }
            .navigationTitle("Images en Cache")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Vider Cache") {
                        print("@@@ vider cache")
                        ImageCacheManager.shared.clearCache()
                    }
                }
            }
        }
    }
}



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
