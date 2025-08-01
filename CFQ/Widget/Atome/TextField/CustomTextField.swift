import SwiftUI

enum TextFieldType {
    case signUp
    case sign
    case turn
    case cfq
    case editProfile
    case searchBar

    var data: TextFieldData {
        switch self {
        case .sign:
            return TextFieldData(
                background: .clear,
                foregroundColor: .white,
                hasStoke: false,
                // titleCase: .lowercase,
                // titleCaseFunc: { $0.capitalized },
                cornerRadius: 0,
                leadingPadding: 5
            )
        case .signUp, .cfq, .editProfile:
            return TextFieldData(
                background: .black,
                foregroundColor: .white,
                hasStoke: true,
                // titleCase: .lowercase,
                // titleCaseFunc: { $0.capitalized() },
                cornerRadius: 8,
                leadingPadding: 5
            )
        case .turn:
            return TextFieldData(
                background: .clear,
                foregroundColor: .purple,
                hasStoke: false,
                // titleCase: .uppercase,
                // titleCaseFunc: { $0.uppercased() },
                cornerRadius: 0,
                leadingPadding: 0
            )
        case .searchBar:
            return TextFieldData(
                background: .clear,
                foregroundColor: .white,
                hasStoke: true,
                // titleCase: .lowercase,
                // titleCaseFunc: { $0.capitalized() },
                iconResearch: "magnifyingglass",
                iconCross: "xmark.circle",
                cornerRadius: 30,
                leadingPadding: 10
            )
        }
    }
}

private func uppercaseText(text: String) -> String {
    return text.uppercased()
}

struct TextFieldData {
    let background: Color
    let foregroundColor: Color
    let hasStoke: Bool
    // let titleCase: Text.Case
    // let titleCaseFunc: (String) -> String
    let iconResearch: String?
    let iconCross: String?
    let cornerRadius: CGFloat
    let leadingPadding: CGFloat

    init(
        background: Color,
        foregroundColor: Color,
        hasStoke: Bool,
        // titleCase: Text.Case,
        // titleCaseFunc: @escaping (String) -> String,
        iconResearch: String? = nil,
        iconCross: String? = nil,
        cornerRadius: CGFloat,
        leadingPadding: CGFloat
    ) {
        self.background = background
        self.foregroundColor = foregroundColor
        self.hasStoke = hasStoke
        // self.titleCase = titleCase
        // self.titleCaseFunc = titleCaseFunc
        self.iconResearch = iconResearch
        self.iconCross = iconCross
        self.cornerRadius = cornerRadius
        self.leadingPadding = leadingPadding
    }
}

extension View {
    func limitText(_ text: Binding<String>, to characterLimit: Int) -> some View
    {
        self
            .onChange(of: text.wrappedValue) { _ in
                text.wrappedValue = String(
                    text.wrappedValue.prefix(characterLimit)
                )
            }
    }
}

struct CustomTextField: View {
    @Binding var text: String
    let keyBoardType: UIKeyboardType
    let placeHolder: String
    let textFieldType: TextFieldType
    let characterLimit: Int
    var onRemoveText: (() -> Void)?
    var onTapResearch: (() -> Void)?

    init(
        text: Binding<String>,
        keyBoardType: UIKeyboardType,
        placeHolder: String,
        textFieldType: TextFieldType,
        characterLimit: Int = 20,
        onRemoveText: (() -> Void)? = nil,
        onTapResearch: (() -> Void)? = nil
    ) {

        self._text = text
        self.keyBoardType = keyBoardType
        self.placeHolder = placeHolder
        self.textFieldType = textFieldType
        self.characterLimit = characterLimit
        self.onRemoveText = onRemoveText
        self.onTapResearch = onTapResearch
    }

    var body: some View {
        HStack {

            if textFieldType == .searchBar {
                Image(systemName: textFieldType.data.iconResearch ?? "")
                    .padding(.leading, 8)
                    .foregroundColor(.white)
                    .padding(.leading, textFieldType.data.leadingPadding)
            }

            if textFieldType == .cfq {
                Text("CFQ")
                    .tokenFont(.Body_Inter_Medium_16)
                    .padding(.leading, 15)
            }

            TextField("", text: $text)
                .limitText($text, to: characterLimit)
                .multilineTextAlignment(
                    textFieldType == .sign ? .center : .leading
                )
                .placeholder(
                    when: text.isEmpty,
                    alignment: textFieldType == .sign ? .center : .leading
                ) {
                    HStack {
                        Text(placeHolder)
                            .foregroundColor(.gray)
                            // .textCase(textFieldType.data.titleCase)
                            .multilineTextAlignment(
                                textFieldType == .sign ? .center : .leading
                            )
                    }
                }.onChange(of: text) { newValue in

                    text = String(text.prefix(characterLimit))
                    // text = String(text.prefix(characterLimit))

                    if textFieldType == .cfq || textFieldType == .turn {
                        text = uppercaseText(text: newValue)
                    }

                    if textFieldType == .searchBar {
                        onTapResearch?()
                    }
                }
                .foregroundColor(.white)
                .padding(.all, textFieldType.data.hasStoke ? 10 : 5)
                .padding(.leading, textFieldType == .cfq ? -10 : 0)
                .keyboardType(keyBoardType)

            if textFieldType == .searchBar && !text.isEmpty {
                Button(action: {
                    onRemoveText?()
                }) {
                    Image(systemName: textFieldType.data.iconCross ?? "")
                        .padding(.leading, 8)
                        .foregroundColor(.white)
                        .padding(.trailing, 10)
                }
            }
        }
        .background(textFieldType.data.background)
        .clipShape(
            RoundedRectangle(cornerRadius: textFieldType.data.cornerRadius)
        )
        .overlay(
            RoundedRectangle(cornerRadius: textFieldType.data.cornerRadius)
                .stroke(
                    .white,
                    lineWidth: textFieldType.data.hasStoke ? 0.5 : 0
                )
        )
    }
}

#Preview {
    ParentView()
}

private struct ParentView: View {
    @State private var currentIndex = ""
    @State private var currentIndex2 = ""

    var body: some View {
        ZStack {
            NeonBackgroundImage()
            VStack {
                CustomTextField(
                    text: $currentIndex,
                    keyBoardType: .default,
                    placeHolder: "• • • • • • • • • ",
                    textFieldType: .sign
                )
                CustomTextField(
                    text: $currentIndex,
                    keyBoardType: .default,
                    placeHolder: "test",
                    textFieldType: .signUp
                )

                CustomTextField(
                    text: $currentIndex2,
                    keyBoardType: .default,
                    placeHolder: "test",
                    textFieldType: .turn
                )

                CustomTextField(
                    text: $currentIndex2,
                    keyBoardType: .default,
                    placeHolder: "test",
                    textFieldType: .searchBar
                )
            }
        }
    }
}
