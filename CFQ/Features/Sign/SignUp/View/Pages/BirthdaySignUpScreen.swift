import SwiftUI

struct BirthdaySignUpScreen: View {
    @ObservedObject var viewModel: SignUpPageViewModel
    @State var showPicker = false
    
    var body: some View {

        VStack {
            ProgressBar(index: $viewModel.index)
                .padding(.bottom, 30)

            VStack {
                Text(StringsToken.Sign.TitleWhichIsYourBirthday)
                    .tokenFont(.Title_Gigalypse_24)
                    .textCase(.uppercase)
                    .padding(.bottom, 50)

                Button(action: {
                    showPicker = true
                }) {
                    HStack {
                        Text(viewModel.formattedDate().titleButton)
                            .tokenFont(viewModel.formattedDate().isPlaceholder ?
                                .Placeholder_Inter_Regular_14 : .Body_Inter_Regular_14
                            )
                            .padding(.leading, 15)
                            
                        Spacer()
                    }
                    .frame(width: UIScreen.main.bounds.width - 40, height: 40)
                    .background(.black)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.white, lineWidth: 0.5)
                    )
                    .padding(.all, 10)
                }
            }

            Spacer()

            VStack {
                LargeButtonView(
                    action: { viewModel.goNext() },
                    title: StringsToken.Sign.NextStep,
                    largeButtonType: .signNext
                ).padding(.horizontal, 20)

                LargeButtonView(
                    action: { viewModel.goBack() },
                    title: StringsToken.Sign.Back,
                    largeButtonType: .signBack
                ).padding(.horizontal, 20)
            }
        }
        .fullBackground(imageName: StringsToken.Image.fullBackground)
        .sheet(isPresented: $showPicker) {
            BirthdayPickerView(birthday: $viewModel.birthday, onClose: {
                showPicker = false
            })
            .presentationDragIndicator(.visible)
            .presentationDetents([.height(450)])
        }
    }
}

#Preview {
    ZStack {
        NeonBackgroundImage()
        BirthdaySignUpScreen(viewModel: .init(uidUser: "", phoneNumber: ""))
    }
}

private struct BirthdayPickerView: View {
    @Binding var birthday: Date
    var onClose: () -> Void
    var body: some View {
        
        Form {
            DatePicker(StringsToken.Sign.TitleWhichIsYourBirthday, selection: $birthday, displayedComponents: .date)
                .datePickerStyle(GraphicalDatePickerStyle())
            }
        .environment(\.locale, Locale.init(identifier: "fr_FR"))
        .tint(.white)
        .colorScheme(.dark)
        
        Button(action: onClose, label: {
            Text("Done")
                .foregroundColor(.white)
                .padding(.horizontal, 30)
                .padding(.vertical, 10)
                .background(.black)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.white, lineWidth: 0.5)
                )
            
        })
    }
}
