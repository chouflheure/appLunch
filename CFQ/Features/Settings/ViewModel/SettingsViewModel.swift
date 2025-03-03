
import Foundation
import SwiftUI

class SettingsViewModel: ObservableObject {
    
    @Published var name: String = ""
    @Published var pseudo: String = ""
    @Published var firstName: String = ""
    var picture = UIImage()
    @Published var localisation: Set<String> = []
    
    private var profilePictureUrl: String = ""
    private var firebase = FirebaseService()
    
    // func edit profile
    
    
}
