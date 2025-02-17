
import SwiftUI

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
        .onAppear {
            // Exemple d'utilisation
            let newUser = User(uid: "@123", username: "", profilePictureUrl: "", location: [], birthDate: nil, isActive: true, favorite: [], friends: [], invitedCfqs: [], invitedTurns: [], notificationsChannelId: "", postedCfqs: [], postedTurns: [], teams: [], tokenFCM: "", unreadNotificationsCount: 2)
         
            let firebaseService = FirebaseService()

            // Appel de la méthode générique pour ajouter un utilisateur dans la collection 'users'
            firebaseService.addData(data: newUser, to: .users)

            firebaseService.getAllData(from: .users) { (result: Result<[User], Error>) in
                switch result {
                case .success(let users):
                    print("Utilisateurs récupérés : \(users[0].uid)")
                case .failure(let error):
                    print("Erreur lors de la récupération des utilisateurs : \(error.localizedDescription)")
                }
            }
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
