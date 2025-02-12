
import SwiftUI

struct DatePickerMainInformations: View {
    @State private var date = Date.now
    @State private var showPicker = false
    @State private var showPicker2 = false
    @State private var hasCompleted = false
    @State var hours: Int = 0

    @StateObject var viewModel: TurnCardViewModel

    var body: some View {
        HStack {
            HStack {
                Image(systemName: "calendar")
                    .foregroundColor(hasCompleted ? .white : .gray)
                Text(hasCompleted ? viewModel.textFormattedLongFormat() : "choisir une date")
                    .foregroundColor(hasCompleted ? .white : .gray)
                    .onTapGesture {
                        showPicker = true
                    }
                
                Text("|")
                    .foregroundColor(.white)
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

            HStack {
                Text(hasCompleted ? viewModel.textFormattedLongFormat() : "choisir une date")
                    .foregroundColor(hasCompleted ? .white : .gray)
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
        }
    }
}

#Preview {
    ZStack {
        Color.blue.ignoresSafeArea()
        DatePickerMainInformations(viewModel: TurnCardViewModel())
    }
}
