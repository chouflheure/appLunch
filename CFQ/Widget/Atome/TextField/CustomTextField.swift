import SwiftUI

enum TextFieldType {
    case sign
    case turn
    case cfq
    case editProfile
    case searchBar
    
    var data: TextFieldData {
        switch self {
        case .sign, .cfq, .editProfile:
            return TextFieldData(
                background: .black,
                foregroundColor: .white,
                hasStoke: true,
                titleCase: .lowercase,
                titleCaseFunc: { $0.lowercased() },
                cornerRadius: 8,
                leadingPadding: 5
            )
        case .turn:
            return TextFieldData(
                background: .clear,
                foregroundColor: .purple,
                hasStoke: false,
                titleCase: .uppercase,
                titleCaseFunc: { $0.uppercased() },
                cornerRadius: 0,
                leadingPadding: 0
            )
        case .searchBar:
            return TextFieldData(
                background: .clear,
                foregroundColor: .white,
                hasStoke: true,
                titleCase: .lowercase,
                titleCaseFunc: { $0.lowercased() },
                iconResearch: "magnifyingglass",
                iconCross: "xmark.circle",
                cornerRadius: 30,
                leadingPadding: 10
            )
        }
    }
}

struct TextFieldData {
    let background: Color
    let foregroundColor: Color
    let hasStoke: Bool
    let titleCase: Text.Case
    let titleCaseFunc: (String) -> String
    let iconResearch: String?
    let iconCross: String?
    let cornerRadius: CGFloat
    let leadingPadding: CGFloat
    
    init(
        background: Color,
        foregroundColor: Color,
        hasStoke: Bool,
        titleCase: Text.Case,
        titleCaseFunc: @escaping (String) -> String,
        iconResearch: String? = nil,
        iconCross: String? = nil,
        cornerRadius: CGFloat,
        leadingPadding: CGFloat
    ) {
        self.background = background
        self.foregroundColor = foregroundColor
        self.hasStoke = hasStoke
        self.titleCase = titleCase
        self.titleCaseFunc = titleCaseFunc
        self.iconResearch = iconResearch
        self.iconCross = iconCross
        self.cornerRadius = cornerRadius
        self.leadingPadding = leadingPadding
    }
}

struct CustomTextField: View {
    @Binding var text: String
    let keyBoardType: UIKeyboardType
    let placeHolder: String
    let textFieldType: TextFieldType
    var onRemoveText: (() -> Void)?
    var onTapResearch: (() -> Void)?

    var body: some View {
        HStack {
            Image(systemName: textFieldType.data.iconResearch ?? "")
                .padding(.leading, 8)
                .foregroundColor(.white)
                .padding(.leading, textFieldType.data.leadingPadding)
            
            TextField("", text: $text)
                .placeholder(when: text.isEmpty) {
                    HStack {
                        Text(placeHolder)
                            .foregroundColor(.gray)
                            .textCase(textFieldType.data.titleCase)
                    }
            }.onChange(of: text) { newValue in
                text = textFieldType.data.titleCaseFunc(newValue)
                if textFieldType == .searchBar {
                    onTapResearch?()
                }
            }
            .foregroundColor(.white)
            .padding(.all, textFieldType.data.hasStoke ? 10 : 5)
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
        .clipShape(RoundedRectangle(cornerRadius: textFieldType.data.cornerRadius))
        .overlay(
            RoundedRectangle(cornerRadius: textFieldType.data.cornerRadius)
                .stroke(.white, lineWidth: textFieldType.data.hasStoke ? 0.5 : 0)
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
                    placeHolder: "test",
                    textFieldType: .sign
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
