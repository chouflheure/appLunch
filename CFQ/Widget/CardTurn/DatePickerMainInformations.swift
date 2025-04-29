
import SwiftUI

struct DatePickerMainInformations: View {
    @State private var date = Date.now
    @State private var showPicker = false
    @State private var showPicker2 = false
    @State var hours: Int = 0
    var isPreviewCard: Bool? = false

    @ObservedObject var viewModel: TurnCardViewModel

    
    @State private var showDatePicker = false

    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "calendar")
                    .foregroundColor(viewModel.textFormattedLongFormat.isEmpty ? .gray : .white)
                
                Text(viewModel.textFormattedLongFormat.isEmpty ? "Date" : viewModel.textFormattedLongFormat)
                    .tokenFont(viewModel.textFormattedLongFormat.isEmpty ? .Placeholder_Inter_Regular_16 : .Body_Inter_Medium_16)
                    .onTapGesture {
                        showPicker = true
                    }

                Text(" | ")
                    .foregroundColor(.white)
                
                Text(viewModel.textFormattedHours.isEmpty ? "Heure de début" : viewModel.textFormattedHours)
                    .tokenFont(viewModel.textFormattedHours.isEmpty ? .Placeholder_Inter_Regular_16 : .Body_Inter_Medium_16)
                    .onTapGesture {
                        showPicker = true
                    }
            }
            .sheet(isPresented: $showPicker) {
                ZStack {
                    NeonBackgroundImage()
                    SheetDatePicker(viewModel: viewModel, onClose: {
                        showPicker = false
                    })
                }
                .presentationDragIndicator(.visible)
                .presentationDetents([.height(500)])
            }
        }
    }
}

#Preview {
    ZStack {
        Color.blue.ignoresSafeArea()
        DatePickerMainInformations(viewModel: TurnCardViewModel())
    }
}
