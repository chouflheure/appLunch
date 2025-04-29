
import SwiftUI

struct CollectionViewHours: View {
    @State private var selectedItems = ""
    @StateObject var viewModel: TurnCardViewModel
    
    let times: [String] = {
        var timeArray: [String] = []
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"

        var currentTime = Calendar.current.startOfDay(for: Date())
        let endOfDay = Calendar.current.date(bySettingHour: 23, minute: 30, second: 0, of: currentTime)!

        while currentTime <= endOfDay {
            timeArray.append(dateFormatter.string(from: currentTime))
            currentTime = Calendar.current.date(byAdding: .minute, value: 30, to: currentTime)!
        }
        
        return timeArray
    }()

    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        Text("")
        /*
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(times, id: \.self) { time in
                    ItemViewHours(hours: time, isSelected: viewModel.starthours == time)
                        .onTapGesture {
                            print("@@@ viewModel.starthours = \(viewModel.starthours)")
                            print("@@@ time = \(time)")
                            toggleSelection(of: time)
                        }
                }
            }
            .padding()
        }
         */
    }

    private func toggleSelection(of item: String) {
        selectedItems = item
        // viewModel.starthours = item
    }
}

struct CollectionViewHours_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            CollectionViewHours(viewModel: TurnCardViewModel())
        }
    }
}
