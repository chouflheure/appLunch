import SwiftUI

private enum Field {
    case name
    // case firstName
    case pseudo
}

struct NameSignUpScreen: View {
    @State private var index = 0
    @ObservedObject var viewModel: SignUpPageViewModel
    @FocusState private var focusedField: Field?
    var onDismiss: () -> Void

    var body: some View {
        VStack {
            ProgressBar(index: $viewModel.index)
                .padding(.bottom, 30)

            VStack {
                Text(StringsToken.Sign.TitleWhichIsYourIdentifier)
                    .tokenFont(.Title_Gigalypse_24)
                    .textCase(.uppercase)
                    .padding(.bottom, 50)

                /*
                CustomTextField(
                    text: $viewModel.user.firstName,
                    keyBoardType: .default,
                    placeHolder: "Prenom",
                    textFieldType: .signUp
                )
                .focused($focusedField, equals: .name)
                .submitLabel(.next)
                .padding(.bottom, 20)
                .padding(.horizontal, 20)
                 */

                CustomTextField(
                    text: $viewModel.user.name,
                    keyBoardType: .default,
                    placeHolder: "Prenom",
                    textFieldType: .signUp
                )
                .focused($focusedField, equals: .name)
                .submitLabel(.next)
                .padding(.bottom, 20)
                .padding(.horizontal, 20)

                CustomTextField(
                    text: $viewModel.user.pseudo,
                    keyBoardType: .default,
                    placeHolder: "Pseudo",
                    textFieldType: .signUp
                )
                .focused($focusedField, equals: .pseudo)
                .submitLabel(.return)
                .padding(.bottom, 20)
                .padding(.horizontal, 20)
            }
            .onSubmit {
                switch focusedField {
                case .name:
                    focusedField = .pseudo
                    // focusedField = .firstName
                // case .firstName:
                    // focusedField = .pseudo
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
                    title: StringsToken.Sign.ItsGood,
                    largeButtonType: .signNext,
                    isDisabled: viewModel.user.name.isEmpty
                        || viewModel.user.pseudo.isEmpty
                        // || viewModel.user.firstName.isEmpty
                ).padding(.horizontal, 20)

                LargeButtonView(
                    action: { onDismiss() },
                    title: StringsToken.Sign.BackToSign,
                    largeButtonType: .signBack
                ).padding(.horizontal, 20)
            }
        }
        .fullBackground(imageName: StringsToken.Image.fullBackground)
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
    }
}

#Preview {
    NameSignUpScreen(viewModel: SignUpPageViewModel(uidUser: "", phoneNumber: "")) {}
}
