import SwiftUI

struct FriendSignUpScreen: View {
    @ObservedObject var viewModel: SignUpPageViewModel
    var coordinator: Coordinator
    @State private var toast: Toast? = nil
    var onDismiss: () -> Void

    var body: some View {
        ZStack {
            NeonBackgroundImage()

            VStack {
                ProgressBar(index: $viewModel.index)
                    .padding(.vertical, 50)

                ScrollView {
                    VStack {
                        Text(StringsToken.Sign.TitleFindYourFriends)
                            .tokenFont(.Title_Gigalypse_24)
                            .textCase(.uppercase)
                            .padding(.bottom, 50)

                        
                        ForEach(viewModel.contacts, id: \.self) { contact in
                            HStack {
                                FriendSignUpCell(pseudo: contact.pseudo, name: contact.name, firstName: contact.firstName)
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .init(horizontal: .center, vertical: .top))
                .background(.clear)

                Spacer()

                // TODO: - Edit le success et l'erreur 
                VStack {
                    LargeButtonView(
                        action: {
                            viewModel.addUserDataOnDataBase(coordinator: coordinator) { success, message in
                                if success {
                                } else {
                                    toast = Toast(
                                        style: .error, message: message)
                                }
                                
                            }
                        },
                        title: StringsToken.Sign.WelcomeToCFQ,
                        largeButtonType: .signNext
                    ).padding(.horizontal, 20)

                    LargeButtonView(
                        action: { viewModel.goBack() },
                        title: StringsToken.Sign.TitleBackStep,
                        largeButtonType: .signBack
                    ).padding(.horizontal, 20)
                }
                .padding(.bottom, 100)
            }
        }
        .toastView(toast: $toast)
        .onAppear {
            // viewModel.fetchContacts()
        }
    }
}

#Preview {
    // FriendSignUpScreen(viewModel: .init(uidUser: ""))
}


struct FriendSignUpCell: View {
    
    let pseudo: String
    let name: String
    let firstName: String
    @State var isSelected: Bool = false

    var body: some View {
        HStack(spacing: 15) {
            CirclePicture()
                .frame(width: 40, height: 40)
            Text(pseudo)
                .tokenFont(.Body_Inter_Medium_16)
            Text("~ " + name + " " + firstName.first!.uppercased() + ".")
                .tokenFont(.Placeholder_Inter_Regular_16)

            Spacer()
            
            Button(action: {
                withAnimation {
                    isSelected.toggle()
                }
                if isSelected {
                    Logger.log("Demande d'ajout d'ami lors de l'inscription", level: .info)
                } else {
                    Logger.log("Annulation de la demande d'ami", level: .info)
                }
            }) {
                if isSelected {
                    Text("Annuler")
                        .foregroundColor(.red)
                } else {
                    Image(.iconAdduser)
                        .foregroundColor(.white)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .init(horizontal: .leading, vertical: .top))
        .padding(.horizontal, 16)
    }
}

#Preview {
    ZStack {
        NeonBackgroundImage()
        FriendSignUpCell(pseudo: "merou", name: "Meredith", firstName: "VVVVVV")
    }
}
