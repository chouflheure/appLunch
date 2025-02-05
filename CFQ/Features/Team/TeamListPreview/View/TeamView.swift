
import SwiftUI

struct TeamView: View {
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Text("MES TEAMs")
                    .foregroundColor(.white)
                    .font(.custom("GigalypseTrial-Regular", size: 35))
                
            }.padding(.top, 70)
            
            Button(action: {print("@@@")}) {
                Image(.iconPlus)
                    .resizable()
                    .scaledToFill()
                    .foregroundColor(.white)
                    .padding(.vertical, 16)
                    .frame(width: 40, height: 40)
            }.padding(.vertical, 30)

            ScrollView(.vertical, showsIndicators: false) {
                ForEach(0..<3, id: \.self) { _ in
                    CellTeamView()
                        .padding(.bottom, 16)
                        .onTapGesture {
                            print("@@@ CellTeamView tapped")
                        }
                }
            }
            .padding(.horizontal, 12)
        }
    }
}


struct CellTeamView: View {
    var body: some View {
        
        HStack(alignment: .center) {
            CirclePicture()
                .frame(width: 50, height: 50)
            VStack(alignment: .leading, spacing: 10) {
                Text("CELL TEAM")
                    .foregroundColor(.white)
                    .bold()
                PreviewParticipants(pictures: [.header])
                    .frame(height: 24)
            }.padding(.horizontal, 16)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.white, lineWidth: 1)
        )
    }
}

#Preview {
    ZStack {
        NeonBackgroundImage()
        TeamView()
    }.ignoresSafeArea()
}
