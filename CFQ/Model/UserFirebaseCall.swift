//
//  UserFirebaseCall.swift
//  CFQ
//
//  Created by Calvignac Charles on 18/02/2025.
//

/*
 
 // Exemple d'utilisation
 let newUser = User(uid: "@123", username: "", profilePictureUrl: "", location: [], birthDate: nil, isActive: true, favorite: [], friends: [], invitedCfqs: [], invitedTurns: [], notificationsChannelId: "", postedCfqs: [], postedTurns: [], teams: [], tokenFCM: "", unreadNotificationsCount: 2)

 let firebaseService = FirebaseService()

 firebaseService.addData(data: newUser, to: .users)

 firebaseService.getAllData(from: .users) { (result: Result<[User], Error>) in
     switch result {
     case .success(let users):
         print("Utilisateurs récupérés : \(users[0].uid)")
     case .failure(let error):
         print("Erreur lors de la récupération des utilisateurs : \(error.localizedDescription)")
     }
 }

 firebaseService.getDataByID(from: .conversations, whith: "@123") { (result: Result<Turn, Error>) in
     switch result {
     case .success(let turn):
         print("Tour récupéré : \(turn)")
     case .failure(let error):
         print("Erreur lors de la récupération du tour : \(error.localizedDescription)")
     }
 }
 
 firebaseService.deleteDataByID(from: .users, with: "@123") { result in
     switch result {
     case .success:
         print("Utilisateur supprimé avec succès.")
     case .failure(let error):
         print("Erreur lors de la suppression de l'utilisateur : \(error.localizedDescription)")
     }
 }
 
 */
