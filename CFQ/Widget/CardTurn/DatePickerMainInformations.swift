
import SwiftUI

struct DatePickerMainInformations: View {
    @State private var date = Date.now
    @State private var showPickerStartEvent = false
    @State private var showPickerEndEvent = false
    @State var hours: Int = 0
    var isPreviewCard: Bool? = false

    @ObservedObject var viewModel: TurnCardViewModel

    
    @State private var showDatePicker = false

    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(.iconDate)
                    .foregroundColor(viewModel.textFormattedLongFormatStartEvent.isEmpty ? .gray : .white)
                
                Text(viewModel.textFormattedLongFormatStartEvent.isEmpty ? "Quand ?" : viewModel.textFormattedLongFormatStartEvent)
                    .tokenFont(viewModel.textFormattedLongFormatStartEvent.isEmpty ? .Placeholder_Inter_Regular_16 : .Body_Inter_Medium_16)
                    .onTapGesture {
                        showPickerStartEvent = true
                    }

                Text(" | ")
                    .foregroundColor(.white)
                
                Text(viewModel.textFormattedHoursStartEvent.isEmpty ? "Quelle heure ?" : viewModel.textFormattedHoursStartEvent)
                    .tokenFont(.Placeholder_Inter_Regular_16)
                    .onTapGesture {
                        showPickerStartEvent = true
                    }
            }
            .sheet(isPresented: $showPickerStartEvent) {
                ZStack {
                    NeonBackgroundImage()
                    SheetDatePicker(dateEvent: $viewModel.dateEventStart, hoursEvent: $viewModel.startHours, onClose: {
                        showPickerStartEvent = false
                    })
                }
                .presentationDragIndicator(.visible)
                .presentationDetents([.height(500)])
            }
            
            HStack {

                Text(viewModel.textFormattedLongFormatEndEvent.isEmpty ? "Date de fin ( optionnelle )" : viewModel.textFormattedLongFormatEndEvent)
                    .tokenFont(viewModel.textFormattedLongFormatEndEvent.isEmpty ? .Placeholder_Inter_Regular_16 : .Body_Inter_Medium_16)
                    .onTapGesture {
                        showPickerEndEvent = true
                    }

                Text(" | ")
                    .foregroundColor(.white)
                
                Text(viewModel.textFormattedHoursEndEvent.isEmpty ? "Heure de fin ( optionnelle )" : viewModel.textFormattedHoursEndEvent)
                    .tokenFont(.Placeholder_Inter_Regular_16)
                    .onTapGesture {
                        showPickerEndEvent = true
                    }
            }
            .padding(.leading, 32)
            .sheet(isPresented: $showPickerEndEvent) {
                ZStack {
                    NeonBackgroundImage()
                    SheetDatePicker(dateEvent: $viewModel.dateEventEnd, hoursEvent: $viewModel.endHours, limiteDate: viewModel.dateEventStart, onClose: {
                        showPickerEndEvent = false
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
        // DatePickerMainInformations(viewModel: TurnCardViewModel())
    }
}
