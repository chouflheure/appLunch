
import SwiftUI

struct CFQMolecule: View {
    @State var uid: String
    @State var name: String
    @State var title: String
    @State var image: String
    
    let gradientBackground = LinearGradient(
        gradient: Gradient(
            colors: [
                Color(hex: "C6E7FF").opacity(0.3),
                Color(hex: "A7A9E5").opacity(0.3)
            ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    var body: some View {
        ZStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 5) {
                Text(name)
                    .tokenFont(.Body_Inter_Regular_10_white_secondary)
                    .textCase(.lowercase)
                    .padding(.leading, 55)

                Text(title)
                    .tokenFont(.Body_Inter_Medium_14)
                    .frame(height: 30)
                    .padding(.leading, 55)
                    .padding(.trailing, 15)
                    .foregroundColor(.white)
                    .background(gradientBackground)
                    .cornerRadius(20)
                    .padding(.bottom, 5)
            }
            .padding(.leading, 10)

            CachedAsyncImageView(
                urlString: image,
                designType: .scaledToFill_Circle_CFQFeed
            ).frame(width: 60, height: 60)
        }
    }
}


#Preview {
    ZStack {
        NeonBackgroundImage()
        VStack {
            CFQMolecule(uid: "1", name: "Charlou", title: "CFQ FÊTE MUSIQUE ?", image: "")
            CFQMoleculeMessage(uid: "1", name: "Charlou", title: "CFQ FÊTE MUSIQUE ?", image: "")
        }
    }.ignoresSafeArea()
}


struct CFQMoleculeMessage: View {
    
    @State var uid: String
    @State var name: String
    @State var title: String
    @State var image: String
    
    let gradientBackground = LinearGradient(
        gradient: Gradient(
            colors: [
                Color(hex: "C6E7FF").opacity(0.3),
                Color(hex: "A7A9E5").opacity(0.3)
            ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    var body: some View {
        
        ZStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 5) {
                Text(name)
                    .tokenFont(.Body_Inter_Regular_10_white_secondary)
                    .textCase(.lowercase)
                    .padding(.leading, 35)
                
                Text(title)
                    .tokenFont(.Body_Inter_Medium_12)
                    .frame(height: 20)
                    .padding(.leading, 35)
                    .padding(.trailing, 15)
                    .foregroundColor(.white)
                    .background(gradientBackground)
                    .cornerRadius(20)
                    .padding(.bottom, 5)
            }
            .padding(.leading, 10)
            
            ModernCachedAsyncImage(url: "https://firebasestorage.googleapis.com/v0/b/cfq-prod-51399.firebasestorage.app/o/profile%2F0idNvmRG7zdeNC8b8GTb6cVZJ6k1_thumb.jpg?alt=media&token=db460d5a-8d81-49d0-bdb2-74300e1ed087", placeholder: Image(systemName: "photo.fill"))
                .scaledToFill()
                .clipShape(Circle())
                .frame(width: 40, height: 40)
        }
    }
}
