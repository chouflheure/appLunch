
import SwiftUI
import FirebaseFirestore
import Lottie

struct CFQCollectionView: View {
    @ObservedObject var coordinator: Coordinator

    var body: some View {
        VStack(alignment: .leading) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 30) {
                    Button(
                        action: {
                            withAnimation {
                                coordinator.showCFQForm = true
                            }
                            Logger.log("Click on Add CFQ", level: .action)
                        },
                        label: {
                            Image(.iconPlus)
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.white)
                        }
                    ).padding(.leading, 20)
                    ForEach(coordinator.userCFQ, id: \.self) { cfq in
                        if let pseudoUser = coordinator.userFriends.first(where: { $0.uid == cfq.admin })?.pseudo {
                            CFQMolecule(name: pseudoUser, title: cfq.title)
                        }
                    }
                }
            }
        }
        .onAppear {}
    }
}


#Preview {
    ZStack {
        NeonBackgroundImage()
        // CFQCollectionView(coordinator: Coordinator())
    }.ignoresSafeArea()
}
