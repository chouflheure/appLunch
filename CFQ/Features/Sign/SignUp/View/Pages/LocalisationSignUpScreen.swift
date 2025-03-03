
import SwiftUI

struct LocalisationSignUpScreen: View {
    @ObservedObject var viewModel: SignUpPageViewModel
    @State var selectedItems: String = ""

    var body: some View {
        ZStack {
            NeonBackgroundImage()

            VStack {
                ProgressBar(index: $viewModel.index)
                    .padding(.vertical, 50)

                VStack {
                    Text(StringsToken.Sign.TitleWhichIsYourLocalisation)
                        .tokenFont(.Title_Gigalypse_24)
                        .textCase(.uppercase)
                        .padding(.bottom, 20)

                    CollectionViewLocalisations(selectedItems: viewModel.locations)
                }

                Spacer()

                VStack {
                    LargeButtonView(
                        action: {viewModel.goNext()},
                        title: StringsToken.Sign.CheckConfirmCode,
                        largeButtonType: .signNext,
                        isDisabled: viewModel.locations.isEmpty
                    ).padding(.horizontal, 20)

                    LargeButtonView(
                        action: {viewModel.goBack()},
                        title: StringsToken.Sign.TitleBackStep,
                        largeButtonType: .signBack
                    ).padding(.horizontal, 20)
                }
                .padding(.bottom, 100)
            }
        }
    }
}

#Preview {
    LocalisationSignUpScreen(viewModel: .init(uidUser: ""))
}
