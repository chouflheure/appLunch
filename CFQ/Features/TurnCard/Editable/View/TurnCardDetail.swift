
import SwiftUI
import Lottie

struct TurnCardDetailsView: View {
    @ObservedObject var viewModel: TurnCardViewModel
    @State private var toast: Toast? = nil
    var parentDismiss: DismissAction
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            GradientCardDetailView()
            ScrollView(showsIndicators: false) {
                VStack {
                    // Header ( Date / Picture / TURN )
                    HeaderCardViewDetail(viewModel: viewModel)
                        .padding(.bottom, 15)
                        .frame(height: 200)

                    // Title ( Title / Guest )
                    TitleTurnCardDetailView(viewModel: viewModel)
                        .padding(.horizontal, 16)
                        .zIndex(2)

                    // Informations ( Mood / Date / Loc )
                    MainInformationsDetailView(viewModel: viewModel)
                        .padding(.horizontal, 16)

                    // Description ( Bio event )
                    DescriptionTurnCardDetailView(viewModel: viewModel)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 50)
                    
                    Spacer()
                    
                    
                        
                }
            }
            
            if viewModel.isEditing {
                VStack {
                    Spacer()
                    HStack(spacing: 30) {
                        Button(
                            action: {
                                viewModel.showDetailTurnCard = false
                            },
                            label: {
                                HStack {
                                    Image(.iconCross)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 30)
                                        .foregroundColor(.white)
                                        .padding(.leading, 15)
                                        .padding(.vertical, 10)
                                        .font(.system(size: 10, weight: .bold))
                                    
                                    Text("Annuler")
                                        .tokenFont(.Body_Inter_Medium_14)
                                        .padding(.trailing, 15)
                                        .padding(.vertical, 10)
                                        .font(.system(size: 15, weight: .bold))
                                }
                            }
                        )
                        .frame(width: 150)
                        .background(.black)
                        .cornerRadius(10)
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(style: StrokeStyle(lineWidth: 1))
                                .foregroundColor(.white)
                                .background(.clear)
                        }
                        
                        
                        Button(
                            action: {
                                
                                viewModel.updateTurn { success, message in
                                    print("@@@ success = \(success)")
                                    if success {
                                        dismiss()
                                        parentDismiss()
                                    } else {
                                        toast = Toast(
                                            style: .error,
                                            message: message
                                        )
                                    }
                                }
                            },
                            label: {
                                HStack {
                                    Image(.iconSend)
                                        .foregroundColor(.white).opacity(!viewModel.isEnableButton ? 0.5 : 1)
                                        .padding(.leading, 15)
                                        .padding(.vertical, 10)
                                    
                                    Text("Publier")
                                        .tokenFont(!viewModel.isEnableButton ? .Placeholder_Gigalypse_14 : .Body_Inter_Medium_14)
                                        .padding(.trailing, 15)
                                        .padding(.vertical, 10)
                                        .bold()
                                }
                            }
                        )
                        .frame(width: 150)
                        .background(Color(hex: "B098E6").opacity(!viewModel.isEnableButton ? 0.5 : 1))
                        .disabled(!viewModel.isEnableButton)
                        .cornerRadius(10)
                    }
                    Spacer()
                        .frame(height: 30)
                }
            }
            
            if viewModel.isLoading {
                ZStack {
                    LottieView(
                        animation: .named(StringsToken.Animation.loaderCircle)
                    )
                    .playing()
                    .looping()
                    .frame(width: 150, height: 150)
                }
                .zIndex(3)
            }
        }
        .toastView(toast: $toast)
        .blur(radius: viewModel.isLoading ? 10 : 0)
        .allowsHitTesting(!viewModel.isLoading)
        .ignoresSafeArea(edges: .top)
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
        .scrollDismissesKeyboard(.interactively)
    }
}
