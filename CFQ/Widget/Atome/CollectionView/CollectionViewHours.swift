
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
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(times, id: \.self) { time in
                    ItemView(hours: time, isSelected: viewModel.starthours == time)
                        .onTapGesture {
                            print("@@@ viewModel.starthours = \(viewModel.starthours)")
                            print("@@@ time = \(time)")
                            toggleSelection(of: time)
                        }
                }
            }
            .padding()
        }
    }

    private func toggleSelection(of item: String) {
        selectedItems = item
        viewModel.starthours = item
    }
}

private struct ItemView: View {
    let hours: String
    let isSelected: Bool

    var body: some View {
        Text(hours)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .foregroundColor(.white)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white, lineWidth: isSelected ? 0.9 : 0.3)
                    .animation(.bouncy, value: isSelected)
                    .shadow(radius: isSelected ? 5 : 1)
                    .scaleEffect(isSelected ? 1.05 : 1.0)
            )
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
