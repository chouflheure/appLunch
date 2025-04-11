
import SwiftUI
import FirebaseFirestore

struct CFQCollectionView: View {
    @State private var user: User?
    @ObservedObject var coordinator: Coordinator

    var arrayCFQ: [CFQMolecule] = [
        CFQMolecule(name: "Charles", title: "CFQ SAMEDI ?"),
        CFQMolecule(name: "Lisa", title: "CFQ DEMAIN SOIR ?"),
        CFQMolecule(name: "Luis", title: "CFQ CE SOIR ?")
    ]

    var body: some View {
        VStack(alignment: .leading) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 30) {
                    Button(
                        action: {
                            withAnimation {
                                coordinator.showCFQScreen = true
                            }
                            Logger.log("Click on Add CFQ", level: .action)
                        },
                        label: {
                            Image("icon-plus")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.white)
                        }
                    ).padding(.leading, 20)

                    ForEach(arrayCFQ.indices, id: \.self) { index in
                        VStack {
                            arrayCFQ[index]
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
        CFQCollectionView(coordinator: Coordinator(), arrayCFQ: [CFQMolecule(name: "Charles", title: "CFQ SAMEDI ?"), CFQMolecule(name: "Lisa", title: "CFQ DEMAIN SOIR ?"), CFQMolecule(name: "Luis", title: "CFQ CE SOIR ?")])
    }.ignoresSafeArea()
}
