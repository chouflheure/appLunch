
import SwiftUI

struct CFQCollectionView: View {
    var arrayCFQ: [CFQMolecule] = [CFQMolecule(name: "Charles", title: "CFQ SAMEDI ?"), CFQMolecule(name: "Lisa", title: "CFQ DEMAIN SOIR ?"), CFQMolecule(name: "Luis", title: "CFQ CE SOIR ?")]
    var body: some View {
        VStack(alignment: .leading) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 30) {
                    ForEach(arrayCFQ.indices, id: \.self) { index in
                        if index == 0 {
                            Button(
                                action: {},
                                label: {
                                    Image(.iconPlus)
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                }
                            ).padding(.leading, 20)
                        }
                        arrayCFQ[index]
                    }
                }
            }
            .padding(.horizontal, 12)
        }
    }
}

#Preview {
    ZStack {
        Image(.backgroundNeon)
            .resizable()
        CFQCollectionView(arrayCFQ: [CFQMolecule(name: "Charles", title: "CFQ SAMEDI ?"), CFQMolecule(name: "Lisa", title: "CFQ DEMAIN SOIR ?"), CFQMolecule(name: "Luis", title: "CFQ CE SOIR ?")])
    }.ignoresSafeArea()
}
