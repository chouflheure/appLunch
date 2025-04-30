
import SwiftUI

struct LocalisationSignUpScreen: View {
    @ObservedObject var viewModel: SignUpPageViewModel
    @State var selectedItems: String = ""

    var body: some View {
        SafeAreaContainer {

            VStack {
                ProgressBar(index: $viewModel.index)
                    .padding(.bottom, 30)

                VStack {
                    Text(StringsToken.Sign.TitleWhichIsYourLocalisation)
                        .tokenFont(.Title_Gigalypse_24)
                        .textCase(.uppercase)
                        .padding(.bottom, 20)

                    CollectionViewLocalisations(selectedItem: $viewModel.user.location)
                }

                Spacer()

                VStack {
                    LargeButtonView(
                        action: {viewModel.goNext()},
                        title: StringsToken.Sign.AlmostThere,
                        largeButtonType: .signNext,
                        isDisabled: viewModel.user.location.isEmpty
                    ).padding(.horizontal, 20)

                    LargeButtonView(
                        action: {viewModel.goBack()},
                        title: StringsToken.Sign.TitleBackStep,
                        largeButtonType: .signBack
                    ).padding(.horizontal, 20)
                }
            }
        }
    }
}

#Preview {
    LocalisationSignUpScreen(viewModel: .init(uidUser: ""))
}
