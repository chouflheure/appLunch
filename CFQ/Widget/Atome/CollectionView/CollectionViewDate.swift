
import SwiftUI

struct CollectionViewDate: View {
    @StateObject var viewModel: TurnCardViewModel
    var onClose: () -> Void

    var body: some View {
        VStack {
            DatePicker("", selection: $viewModel.date, in: Date.now..., displayedComponents: .date)
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
