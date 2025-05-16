//

import SwiftUI

struct DescriptionTurnCardFeedPreviewView: View {
    var turn: Turn

    init(turn: Turn) {
        self.turn = turn
    }
    
    @State private var expanded = false
    @State private var truncated = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            TruncatedTextWithColor(
                fullText: turn.description,
                truncated: $truncated
            )
            .foregroundColor(.white)
            .padding(.bottom, 20)
            .padding(.top, 10)
            .background(
                Text(turn.description)
                    .tokenFont(.Body_Inter_Medium_14)
                    .lineLimit(nil)
                    .background(
                        GeometryReader { fullSize in
                            Color.clear.onAppear {
                                let fullHeight = fullSize.size.height
                                let threeLineHeight =
                                    UIFont.preferredFont(forTextStyle: .body)
                                    .lineHeight * 3
                                if fullHeight > threeLineHeight {
                                    truncated = true
                                }
                            }
                        }
                    )
                    .hidden()
            )

        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct ExpandableTextView: View {
    let text: String
    @State private var expanded = false
    @State private var truncated = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            TruncatedTextWithColor(
                fullText: text,
                truncated: $truncated
            )
            .foregroundColor(.white)
            // .tokenFont(.Body_Inter_Medium_14)
            .padding(.bottom, 20)
            .padding(.top, 10)
            .background(
                Text(text)
                    .tokenFont(.Body_Inter_Medium_14)
                    .lineLimit(nil)
                    .background(
                        GeometryReader { fullSize in
                            Color.clear.onAppear {
                                let fullHeight = fullSize.size.height
                                let threeLineHeight =
                                    UIFont.preferredFont(forTextStyle: .body)
                                    .lineHeight * 3
                                if fullHeight > threeLineHeight {
                                    truncated = true
                                }
                            }
                        }
                    )
                    .hidden()
            )

        }
    }
}

// Structure pour le texte tronqué avec couleur
struct TruncatedTextWithColor: View {
    let fullText: String
    let lineLimit: Int = 3
    @Binding var truncated: Bool

    var body: some View {
        if truncated {
            Text(attributedTruncatedText)
                .tokenFont(.Body_Inter_Medium_14)
                .lineLimit(lineLimit)
        } else {
            Text(fullText)
                .tokenFont(.Body_Inter_Medium_14)
                .lineLimit(lineLimit)
        }
    }

    private var attributedTruncatedText: AttributedString {
        let approximateCharsPerLine = 45
        let approximateTextLength = approximateCharsPerLine * lineLimit
        
        // Vérifier d'abord les sauts de ligne explicites
        let lines = fullText.components(separatedBy: "\n")
        
        // Calculer le texte tronqué
        let visibleText: String
        
        if lines.count > lineLimit {
            // S'il y a plus de sauts de ligne que la limite
            let truncatedLines = Array(lines.prefix(lineLimit))
            visibleText = truncatedLines.joined(separator: "\n") + " ... "
        } else if fullText.count > approximateTextLength {
            // S'il y a trop de caractères
            let index = fullText.index(
                fullText.startIndex,
                offsetBy: min(approximateTextLength - 10, fullText.count))
            visibleText = String(fullText[..<index]) + " ... "
        } else {
            // Le texte est suffisamment court
            visibleText = fullText + " "
        }
        
        // Créer l'AttributedString
        var attributedString = AttributedString(visibleText)
        
        // Ajouter le "Voir plus" avec sa couleur
        var seeMoreString = AttributedString("Voir plus")
        seeMoreString.foregroundColor = .gray
        
        attributedString.append(seeMoreString)
        
        return attributedString
    }
}

#Preview {
    VStack {
        DescriptionTurnCardFeedPreviewView(turn: Turn(uid: "", titleEvent: "", date: nil, pictureURLString: "", admin: "", description: "Charles Calvignac on test la taille du text pour voir si ca rentre correctement ? Tant que le text ne dépasse pas 3 lignes on ne voit  pour voir si ca rentre correctement  ", invited: [""], participants: [""], mood: [0], messagerieUUID: "", placeTitle: "", placeAdresse: "", placeLatitude: 0, placeLongitude: 0))
    }
    .background(.black)
    .padding(.horizontal, 12)
}
