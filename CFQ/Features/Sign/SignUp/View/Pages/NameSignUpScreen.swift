
import SwiftUI

private enum Field {
    case name
    case firstName
    case pseudo
}

struct NameSignUpScreen: View {
    @State private var index = 0
    @ObservedObject var viewModel: SignUpPageViewModel
    @FocusState private var focusedField: Field?
    var onDismiss: () -> Void

    var body: some View {
        ZStack {
            NeonBackgroundImage()

            VStack {
                ProgressBar(index: $viewModel.index)
                    .padding(.vertical, 50)

                VStack {
                    Text(StringsToken.Sign.TitleWhichIsYourIdentifier)
                        .tokenFont(.Title_Gigalypse_24)
                        .textCase(.uppercase)
                        .padding(.bottom, 50)

                    CustomTextField(
                        text: $viewModel.name,
                        keyBoardType: .default,
                        placeHolder: "Nom",
                        textFieldType: .sign
                    )
                    .focused($focusedField, equals: .name)
                    .submitLabel(.next)
                    .padding(.bottom, 20)
                    .padding(.horizontal, 20)

                    CustomTextField(
                        text: $viewModel.firstName,
                        keyBoardType: .default,
                        placeHolder: "Prenom",
                        textFieldType: .sign
                    )
                    .focused($focusedField, equals: .firstName)
                    .submitLabel(.next)
                    .padding(.bottom, 20)
                    .padding(.horizontal, 20)
                    
                    CustomTextField(
                        text: $viewModel.pseudo,
                        keyBoardType: .default,
                        placeHolder: "Pseudo",
                        textFieldType: .sign
                    )
                    .focused($focusedField, equals: .pseudo)
                    .submitLabel(.return)
                    .padding(.bottom, 20)
                    .padding(.horizontal, 20)
                }
                .onSubmit {
                    switch focusedField {
                    case .name:
                        focusedField = .firstName
                    case .firstName:
                        focusedField = .pseudo
                    case .pseudo:
                        focusedField = .none
                    case .none:
                        focusedField = .none
                    }
                }

                Spacer()

                VStack {
                    LargeButtonView(
                        action: {
                            viewModel.goNext()
                        },
                        title: StringsToken.Sign.Next,
                        largeButtonType: .signNext,
                        isDisabled: viewModel.name.isEmpty || viewModel.firstName.isEmpty || viewModel.pseudo.isEmpty
                    ).padding(.horizontal, 20)

                    LargeButtonView(
                        action: {onDismiss()},
                        title: StringsToken.Sign.BackToSign,
                        largeButtonType: .signBack
                    ).padding(.horizontal, 20)
                }
                .padding(.bottom, 100)
            }
        }
        .onTapGesture {
            UIApplication.shared.endEditing(true)
        }
    }
}
