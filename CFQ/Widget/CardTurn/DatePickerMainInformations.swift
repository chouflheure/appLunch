
import SwiftUI

struct DatePickerMainInformations: View {
    @State private var date = Date.now
    @State private var showPicker = false
    @State private var showPicker2 = false
    @State private var hasCompleted = false
    @State var hours: Int = 0
    var isPreviewCard: Bool? = false

    @ObservedObject var viewModel: TurnCardViewModel

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

                Text(viewModel.starthours.isEmpty ? "Debut" : viewModel.starthours)
                    .tokenFont(viewModel.starthours.isEmpty ? .Placeholder_Inter_Regular_16 : .Body_Inter_Medium_16)
                    .onTapGesture {
                        showPicker2 = true
                    }
                    .sheet(isPresented: $showPicker2) {
                        ZStack {
                            NeonBackgroundImage()
                            CollectionViewHours(viewModel: viewModel)
                                .presentationDragIndicator(.visible)
                                .presentationDetents([.height(500)])
                        }
                    }
                
                Text(" ~ ")
                    .foregroundColor(.white)
                
                Text(viewModel.endhours.isEmpty ? "Fin" : viewModel.endhours)
                    .tokenFont(viewModel.endhours.isEmpty ? .Placeholder_Inter_Regular_16 : .Body_Inter_Medium_16)
                    .onTapGesture {
                        showPicker2 = true
                    }
                    .sheet(isPresented: $showPicker2) {
                        ZStack {
                            NeonBackgroundImage()
                            CollectionViewHours(viewModel: viewModel)
                                .presentationDragIndicator(.visible)
                                .presentationDetents([.height(500)])
                        }
                    }
                
            }
            .sheet(isPresented: $showPicker) {
                ZStack {
                    NeonBackgroundImage()
                    SheetDatePicker(viewModel: viewModel, onClose: {
                        showPicker = false
                        hasCompleted = true
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
