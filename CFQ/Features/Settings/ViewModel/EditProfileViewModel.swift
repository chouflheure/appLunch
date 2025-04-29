
import Foundation
import SwiftUI
import PhotosUI

class EditProfileViewModel: ObservableObject {

    @Published var name: String = ""
    @Published var pseudo: String = ""
    @Published var firstName: String = ""
    @Published var localisation: String = ""
    
    @State var avatarPhotoItem: PhotosPickerItem?
    @State var selectedImage: UIImage?
    @State var isPhotoPickerPresented = false

    var picture = UIImage()

    private var profilePictureUrl: String = ""
    private var firebaseService = FirebaseService()

    @Published var user: User

    init(user: User) {
        self.user = user
    }
    
    // func edit profile
    func editProfileOnDB(userUUID: String) {
        var editDate = [String: Any]()
        
        if !name.isEmpty {
            editDate = ["name": name]
        }
        
        if !pseudo.isEmpty {
            editDate = ["pseudo": pseudo]
        }
        
        if !firstName.isEmpty {
            editDate = ["firstName": firstName]
        }

        if !localisation.isEmpty {
            editDate = ["localisation": localisation]
        }
        
        print("@@@ !localisation.isEmpty: \(!localisation.isEmpty)")
        print("@@@ localisation: \(localisation)")
        print("@@@ editDate: \(editDate)")

        if !editDate.isEmpty {
            firebaseService.updateDataByID(
                data: editDate,
                to: .users,
                at: userUUID
            )
        }
    }
    
    func showPhotoPicker() {
        isPhotoPickerPresented = true
    }
}
