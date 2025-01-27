
class UserDataProfile: Identifiable {
    let id: Int
    let name: String
    let firstName: String
    let pseudo: String
    let birthday: String
    let picture: String
    let friends: [String]
    
    init(id: Int, name: String, firstName: String, pseudo: String, birthday: String, picture: String, friends: [String]) {
        self.id = id
        self.name = name
        self.firstName = firstName
        self.pseudo = pseudo
        self.birthday = birthday
        self.picture = picture
        self.friends = friends
    }
}
