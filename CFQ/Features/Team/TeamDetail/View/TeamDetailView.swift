
import SwiftUI

struct TeamDetailView: View {
    var title = "GIRLS ONLY"
    var body: some View {
        VStack {
            HStack {
                Button(action: {print("@@@ back button click")}) {
                    Image(.iconArrow)
                        .foregroundColor(.white)
                        .frame(width: 24, height: 24)
                        .padding(.leading, 16)
                }
                Text(title)
                    .foregroundColor(.white)
                    .padding(.trailing, 40)
                    .font(.custom("GigalypseTrial-Regular", size: 35))
                    .frame(maxWidth: .infinity, alignment: .center)
                
            }
            .padding(.top, 70)

            Button(action: {print("@@@")}) {
                Image(.header)
                    .resizable()
                    .scaledToFill()
                    .foregroundColor(.white)
                    .frame(width: 90, height: 90)
                    .clipShape(Circle())
            }
            .padding(.vertical, 16)
            .padding(.bottom, 16)

            HStack {
                Button(action: {}) {
                    VStack {
                        Image(.iconAdduser)
                            .frame(width: 24, height: 24)
                            .foregroundColor(.white)
                        Text("Ajouter")
                            .foregroundColor(.white)
                    }
                }
                
                Button(action: {}) {
                    ZStack {
                        Circle()
                            .fill(LinearGradient(
                                colors: [Color(hex: "8A5BD0"), Color(hex: "5E44A7")],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                            .frame(width: 53, height: 53)
                        Text("TURN")
                            .tokenFont(.Label_Gigalypse_12)
                    }
                }.padding(.horizontal, 36)
                
                Button(action: {
                    Logger.log("Click button quitter", level: .info)
                }) {
                    VStack {
                        Image(.iconDoor)
                            .frame(width: 24, height: 24)
                            .foregroundColor(.white)
                        Text("Quitter")
                            .foregroundColor(.white)
                    }
                }
            }
            .padding(.bottom, 16)
            
            Divider()
                .overlay(.white)
                .frame(height: 3)
            


            ScrollView(.vertical, showsIndicators: false) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(0..<3, id: \.self) { _ in
                            VStack {
                                CirclePicture()
                                    .frame(width: 56, height: 56)
                                    .onTapGesture {
                                        print("@@@ CellTeamView tapped")
                                    }
                                Text("Name")
                                    .foregroundColor(.white)
                            }.padding(.leading, 16)
                        }
                    }
                }
                .padding(.vertical, 16)
                
                Divider()
                    .overlay(.whitePrimary)
                    .frame(height: 3)
                
                
                CFQCollectionView()
                    .padding(.vertical, 16)
                
                Divider()
                    .overlay(.whiteSecondary)
                    .frame(height: 3)
                
                ForEach(0..<3, id: \.self) { _ in
                    CellTeamView()
                        .padding(.bottom, 16)
                        .padding(.horizontal, 12)
                        .onTapGesture {
                            print("@@@ CellTeamView tapped")
                        }
                }
            }
        }
    }
}

#Preview {
    ZStack {
        NeonBackgroundImage()
        TeamDetailView()
    }.ignoresSafeArea()
}
