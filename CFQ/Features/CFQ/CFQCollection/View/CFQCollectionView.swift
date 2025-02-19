
import SwiftUI
import FirebaseFirestore

struct CFQCollectionView: View {
    @State private var user: User?
    
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
                            Logger.log("Click on Add CFQ", level: .action)
                        },
                        label: {
                            Image(systemName: "plus.circle.fill")
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
        CFQCollectionView(arrayCFQ: [CFQMolecule(name: "Charles", title: "CFQ SAMEDI ?"), CFQMolecule(name: "Lisa", title: "CFQ DEMAIN SOIR ?"), CFQMolecule(name: "Luis", title: "CFQ CE SOIR ?")])
    }.ignoresSafeArea()
}
