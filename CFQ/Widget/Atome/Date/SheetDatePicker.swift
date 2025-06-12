
import SwiftUI

struct SheetDatePicker: View {
    // @ObservedObject var viewModel: TurnCardViewModel
    @Binding var dateEvent: Date?
    @Binding var hoursEvent: Date?
    var limiteDate: Date? = Date()

    var onClose: () -> Void
    
    var body: some View {
        VStack {
            DatePicker(
                "",
                selection: Binding(
                    get: { dateEvent ?? Date() },
                    set: { dateEvent = $0 }
                ),
                in: (limiteDate ?? Date())...,
                displayedComponents: .date
            )
            .datePickerStyle(GraphicalDatePickerStyle())
            .environment(\.locale, Locale.init(identifier: "fr_FR"))
            .tint(.white)
            .colorScheme(.dark)
            
            DatePicker(
                "",
                selection: Binding(
                    get: { hoursEvent ?? Date() },
                    set: { hoursEvent = $0 }
                ),
                // in: Date.now...,
                displayedComponents: .hourAndMinute
            )
            .datePickerStyle(GraphicalDatePickerStyle())
            .environment(\.locale, Locale.init(identifier: "fr_FR"))
            .tint(.white)
            .colorScheme(.dark)

            Button(action: onClose, label: {
                Text("Done")
                    .foregroundColor(.white)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 10)
                    .background(.black)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.white, lineWidth: 0.5)
                    )
                
            })
         }
    }
}

struct CollectionViewDate_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            // CollectionViewDate(viewModel: TurnCardViewModel())
        }
    }
}
