import Contacts
import Foundation
import SwiftUI

class ContactViewModel: ObservableObject {
    @Published var contacts: [Contact] = []

    init() {
        fetchContacts()
    }

    // Récupérer la liste des contacts
    func fetchContacts() {
        let store = CNContactStore()

        // Demander l'autorisation d'accéder aux contacts
        store.requestAccess(for: .contacts) {
            [weak self] (isAuthorized, error) in
            if isAuthorized {
                // Accéder aux contacts si l'autorisation est donnée
                let keysToFetch: [CNKeyDescriptor] = [
                    CNContactGivenNameKey as CNKeyDescriptor,
                    CNContactFamilyNameKey as CNKeyDescriptor,
                    CNContactPhoneNumbersKey as CNKeyDescriptor,
                ]
                let fetchRequest = CNContactFetchRequest(
                    keysToFetch: keysToFetch)

                var contactList: [Contact] = []

                do {
                    try store.enumerateContacts(with: fetchRequest) {
                        (contact, stop) in
                        if let phoneNumber = contact.phoneNumbers.first?.value
                            .stringValue
                        {
                            let contactData = Contact(
                                id: contact.identifier,
                                name: contact.givenName + " "
                                    + contact.familyName,
                                phoneNumber: phoneNumber)
                            contactList.append(contactData)
                        }
                    }
                    DispatchQueue.main.async {
                        self?.contacts = contactList
                    }
                } catch {
                    print("Error fetching contacts: \(error)")
                }
            } else {
                print("Access denied to contacts.")
            }
        }
    }
}

struct ContactListView: View {
    @ObservedObject var viewModel = ContactViewModel()

    var body: some View {
        List(viewModel.contacts) { contact in
            HStack {
                Text(contact.name)
            }
        }
    }
}

struct ContactListView_Previews: PreviewProvider {
    static var previews: some View {
        ContactListView()
    }
}
