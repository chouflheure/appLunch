
import SwiftUI

struct FeedView: View {
    @ObservedObject var coordinator: Coordinator
    @EnvironmentObject var user: User
    @StateObject var viewModel = FeedViewModel()

    init(coordinator: Coordinator) {
        self.coordinator = coordinator
    }

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    withAnimation {
                        coordinator.showFriendListScreen = true
                    }
                }) {
                    Image(.iconAddfriend)
                        .frame(width: 24, height: 24)
                        .foregroundColor(.white)
                }

                Spacer()

                NotificationButtonIcon(
                    numberNotificationUnRead: 0,
                    icon: .iconNotifs,
                    onTap: {
                    withAnimation {
                        coordinator.showNotificationScreen = true
                    }
                })

                NotificationButtonIcon(
                    numberNotificationUnRead: 10,
                    icon: .iconMessagerie,
                    onTap: {
                    withAnimation {
                        coordinator.showMessageScreen = true
                    }
                })
            }.padding(.horizontal, 12)

            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            SwitchStatusUserProfile(
                                viewModel: SwitchStatusUserProfileViewModel(user: user)
                            )
                            ForEach(coordinator.userFriends, id: \.self) { friend in
                                CirclePictureStatusAndPseudo(
                                    userPreview: friend,
                                    onClick: {
                                        withAnimation {
                                            coordinator.showProfileFriend = true
                                        }
                                    }
                                )
                                .frame(width: 60, height: 60)
                                .padding(.leading, 17)
                            }
                            .frame(height: 100)
                        }
                    }
                }
                
                ZStack {
                    Divider()
                        .background(.white)
                    
                    HStack {
                        Text("CFQ")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.gray)
                            .background(.black)
                            .padding(.leading, 20)

                        Spacer()
                    }
                }
                
                CFQCollectionView(coordinator: coordinator)
                
                ZStack {
                    Divider()
                        .background(.white)
                    
                    HStack {
                        Text("TURN")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.gray)
                            .background(.black)
                            .padding(.leading, 20)

                        Spacer()
                    }
                }

                LazyVStack(spacing: 20) {
                    ForEach(viewModel.turns, id: \.uid) { turn in
                       TurnCardFeedView(turn: turn)
                    }
                }
            }
        }.onAppear {
            // TestRef()
        }
    }
}

class TestObjet: Encodable, Decodable {
        
    let referenceUser: String
    
    init(referenceUser: String) {
        self.referenceUser = referenceUser
    }
    
    enum CodingKeys: CodingKey {
        case referenceUser

    }
    
    required init(from decoder:Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        referenceUser = try values.decode(String.self, forKey: .referenceUser)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(referenceUser, forKey: .referenceUser)
    }
}
import FirebaseFirestore
class TestRef {
    let firebaseService = FirebaseService()
    
    init() {
        // callRef()

        // Initialiser Firestore
        let db = Firestore.firestore()

        // Remplacer par l'ID du document que vous souhaitez récupérer
        let documentId = "vCTtPtE40aqfVTYPGwXK"

        // Récupérer le document pour obtenir la référence
        db.collection("testRef").document(documentId).getDocument { (document, error) in
            if let error = error {
                // Une erreur est survenue lors de la récupération du document initial
                print("&&& Error getting initial document: \(error)")
                return
            }

            guard let document = document, document.exists else {
                // Document initial n'existe pas
                print("&&& No such initial document!")
                return
            }

            // Document initial existe, vous pouvez accéder aux données avec document.data()
            if let documentData = document.data() {
                print("&&& Initial document data: \(documentData["referenceUser"])")
                // Récupérer la référence depuis les données du document
                if let referencePath = documentData["referenceUser"] as? String {
                    // Créer une référence au document référencé
                    print("&&& userRef = \(referencePath)")
                    let userRef = db.document(referencePath)

                    // Récupérer les données du document référencé
                    userRef.getDocument { (userDocument, userError) in
                        if let userError = userError {
                            // Une erreur est survenue lors de la récupération du document référencé
                            print("&&& Error getting referenced user document: \(userError)")
                            return
                        }

                        guard let userDocument = userDocument, userDocument.exists else {
                            // Document référencé n'existe pas
                            print("&&& No such referenced user document!")
                            return
                        }

                        // Document référencé existe, vous pouvez accéder aux données avec userDocument.data()
                        if let userData = userDocument.data() {
                            let user = userData as? User
                            print("&&& user = \(user?.printObject)")
                            print("&&& User data: \(userData)")
                            print("&&& User data: \(String(describing: userData["pseudo"] as? String))")
                            print("&&& User data: \(String(describing: userData["name"] as? String))")
                            print("&&& User data: \(String(describing: userData["isActive"] as? Bool))")
                            print("&&& User data: \(String(describing: userData["location"] as? String))")
                        }
                    }
                } else {
                    print("&&& No referenceUser field in document data")
                }
            } else {
                print("&&& No data in document")
            }
        }
        
        
/*
        // Remplacer par le chemin de votre référence
        let referencePath = "users/JtISdWec8JV4Od1WszEGXkqEVAI2"

        // Créer une référence au document
        let userRef = db.document(referencePath)

        // Récupérer les données du document référencé
        userRef.getDocument { (document, error) in
            if let document = document, document.exists {
                // Document existe, vous pouvez accéder aux données avec document.data()
                if let userData = document.data() {
                    print("&&& User data: \(userData)")
                    print("&&& User data: \(String(describing: userData["pseudo"] as? String))")
                    print("&&& User data: \(String(describing: userData["name"] as? String))")
                    print("&&& User data: \(String(describing: userData["isActive"] as? Bool))")
                    print("&&& User data: \(String(describing: userData["location"] as? String))")
                }
            } else {
                // Document n'existe pas
                print("&&& No such user document!")
            }

            if let error = error {
                // Une erreur est survenue
                print("&&& Error getting user document: \(error)")
            }
        }
 */
    }
    
    func callRef() {
        print("@@@ here")
        firebaseService.getDataByID(
            from: .testRef,
            with: "vCTtPtE40aqfVTYPGwXK"
        ) { (result: Result<TestObjet, Error>) in
            
            
            switch result {
            case .success(let user):
                // Stockez les turns récupérés
                DispatchQueue.main.async {
                    print("@@@ user fetched: \(user)")
                    print(user)
                    
                    
                }
            case .failure(let error):
                print("@@@ error")
                Logger.log(error.localizedDescription, level: .error)
            }
        }
    }
}


#Preview {
    ZStack {
        NeonBackgroundImage()
        FeedView(coordinator: .init())
    }.ignoresSafeArea()
}


struct NotificationButtonIcon: View {
    var numberNotificationUnRead: Int
    var icon: ImageResource
    var onTap: ( () -> Void )
    
    var body: some View {
        Button(action: {
            withAnimation {
                onTap()
            }
        }) {
            ZStack {
                Image(icon)
                    .frame(width: 24, height: 24)
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                
                if numberNotificationUnRead > 0 {
                    Circle()
                        .fill(Color.red)
                        .frame(width: 12, height: 12)
                        .offset(x: 12, y: -12)
                }
            }
        }
    }
}
