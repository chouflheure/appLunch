//

import SwiftUI

struct DescriptionTurnCardFeedPreviewView: View {
    var turn: Turn

    init(turn: Turn) {
        self.turn = turn
    }

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

// Structure pour le texte tronqué
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

        var attributedString = AttributedString(visibleText)

        var seeMoreString = AttributedString("Voir plus")
        seeMoreString.foregroundColor = .gray

        attributedString.append(seeMoreString)

        return attributedString
    }
}
