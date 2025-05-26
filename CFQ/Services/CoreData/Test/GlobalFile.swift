import SwiftUI
import CoreData

// MARK: - Configuration du modèle CoreData

// 1. CRÉEZ LE FICHIER MODÈLE CORRECTEMENT:
// - Dans Xcode, allez à File > New > File...
// - Sélectionnez "Data Model" dans la section "Core Data"
// - Nommez-le EXACTEMENT "FruitsContainer"
// - Ajoutez-le à votre cible (target)

// 2. DANS L'ÉDITEUR DE MODÈLE:
// - Cliquez sur "Add Entity" (bouton + en bas)
// - Nommez cette entité EXACTEMENT "FruitEntity"
// - Ajoutez un attribut avec le nom "name" de type String
// - Ajoutez également un attribut avec le nom "id" de type UUID et marquez-le comme "Unique"

// 3. CONFIGUREZ LA GÉNÉRATION DE CODE:
// - Sélectionnez l'entité FruitEntity dans l'éditeur
// - Dans l'inspecteur à droite, définissez:
//   * Codegen: Class Definition (ou bien Category/Extension)
//   * Module: Current Product Module (ou le nom de votre module)

// ⚠️ N'UTILISEZ PAS LA CLASSE MANUELLE FREECODED CI-DESSOUS ⚠️
// Laissez CoreData générer la classe pour vous!
// La classe sera générée automatiquement lors de la compilation

// MARK: - ViewModel pour CoreData

class CoreDataViewModel: ObservableObject {
    
    let container: NSPersistentContainer
    @Published var fruits: [NSManagedObject] = []

    init() {
        // Assurez-vous que ce nom correspond EXACTEMENT au nom du fichier .xcdatamodeld
        container = NSPersistentContainer(name: "FruitsContainer")
        container.loadPersistentStores { description, error in
            if let error = error {
                print("❌ Erreur de chargement CoreData: \(error)")
            } else {
                print("✅ CoreData chargé avec succès")
                self.fetchFruits()
            }
        }
    }
    
    func fetchFruits() {
        let context = container.viewContext
        
        // Spécifiez le nom EXACT de l'entité tel qu'il apparaît dans le modèle
        let request = NSFetchRequest<NSManagedObject>(entityName: "FruitEntity")
        
        do {
            fruits = try context.fetch(request)
            print("📊 \(fruits.count) fruits récupérés")
        } catch {
            print("❌ Erreur lors de la récupération des fruits: \(error)")
        }
    }
    
    func addFruit(name: String) {
        let context = container.viewContext
        
        // Créez l'entité en utilisant son nom exact dans le modèle
        guard NSEntityDescription.entity(forEntityName: "FruitEntity", in: context) != nil else {
            print("❌ Entité FruitEntity introuvable dans le modèle")
            return
        }
        
        // let fruit = NSManagedObject(entity: entity, insertInto: context)
        let fruit = FruitEntity(context: container.viewContext)
        fruit.name = name
        // fruit.setValue(name, forKey: "name")
        // fruit.setValue(UUID(), forKey: "id")
        
        saveData()
    }
    
    func saveData() {
        let context = container.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
                print("✅ Données sauvegardées avec succès")
                fetchFruits()
            } catch {
                print("❌ Erreur lors de la sauvegarde: \(error)")
            }
        }
    }
    
    func deleteFruit(at index: Int) {
        let context = container.viewContext
        context.delete(fruits[index])
        saveData()
    }
}

// MARK: - Vue SwiftUI

struct CoreDataTest: View {
    @StateObject var vm = CoreDataViewModel()
    @State var textFieldText = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                TextField("Ajouter un fruit", text: $textFieldText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                Button(action: {
                    guard !textFieldText.isEmpty else { return }
                    vm.addFruit(name: textFieldText)
                    textFieldText = "" // Effacer le champ après ajout
                }, label: {
                    Text("Ajouter")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                })
                
                List {
                    ForEach(0..<vm.fruits.count, id: \.self) { index in
                        Text(vm.fruits[index].value(forKey: "name") as? String ?? "Sans nom")
                    }
                    .onDelete { indexSet in
                        for index in indexSet {
                            vm.deleteFruit(at: index)
                        }
                    }
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("Mes Fruits")
            .onAppear {
                vm.fetchFruits()
            }
        }
    }
}

// MARK: - Point d'entrée de l'application
