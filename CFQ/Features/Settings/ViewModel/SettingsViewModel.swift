
import Foundation
import SwiftUI

class SettingsViewModel: ObservableObject {
    
    @Published var name: String = ""
    @Published var pseudo: String = ""
    @Published var firstName: String = ""
    @Published var picture = UIImage()
    @Published var localisation: [String] = []
    
    private var profilePictureUrl: String = ""
    private var firebase = FirebaseService()
    
    // func edit profile
    
    
}
