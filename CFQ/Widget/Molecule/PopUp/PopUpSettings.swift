
import SwiftUI

struct PopUpSettings: View {
    @Binding var showPopup: Bool
    var popupType: PopUpType

    var body: some View {
        ZStack() {
            
            VStack(spacing: 20) {
                Text(popupType.title)
                    .tokenFont(.Title_Gigalypse_20)
                    .padding(.top, 30)
                    .padding(.horizontal, 15)
                    .multilineTextAlignment(.center)
                
                HStack(alignment: .center) {
                    Button(action: {
                        withAnimation {
                            showPopup = false
                        }
                    }, label: {
                        Text(popupType.titleButtonNo)
                            .tokenFont(.Label_Gigalypse_12)
                            .overlay {
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(LinearGradient(colors: [.blue, .purple], startPoint: .leading, endPoint: .trailing), lineWidth: 5)
                                    .frame(width: 130, height: 40)
                            }
                    })
                    
                    Spacer()
                    
                    Button(action: {
                        withAnimation {
                            showPopup = false
                        }
                    }, label: {
                        Text(popupType.titleButtonYes)
                            .tokenFont(.Label_Gigalypse_12)
                    })
                }
                .padding(.horizontal, 35)
                .padding(.top, 20)
            }
            .frame(width: 300, height: 200)
            .background(.blackCard)
            .cornerRadius(12)
            .zIndex(2)

            ZStack {
                Circle()
                    .frame(width: 120, height: 120)
                    .foregroundColor(.purpleText)
                    .shadow(radius: 10)

                Image(popupType.image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120, height: 120)
                    .offset(x: popupType == .logout ? -10 : 0, y: popupType == .logout ? -10 : 0)
            }
            .offset(y: -110)
            .zIndex(3)
        }
    }
}
