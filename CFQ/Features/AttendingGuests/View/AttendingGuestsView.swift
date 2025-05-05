
import SwiftUI

struct AttendingGuestsView: View {
    @State var selection = 1
    var body: some View {
        VStack {
            HStack {
                Button(action: {}) {
                    Image(.iconArrow)
                        .foregroundColor(.white)
                        .frame(width: 24, height: 24)
                        .padding(.leading, 16)
                }
                Spacer()
                Text("Invités")
                    .font(.custom("GigalypseTrial-Regular", size: 24))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.trailing, 40)
            }
            .padding(.top, 80)
            
            PageView(pageViewType: .attendingGuestsView)
        }
    }
}


#Preview {
    ZStack {
        NeonBackgroundImage()
        AttendingGuestsView()
    }.ignoresSafeArea()
    
}







struct CollectionViewParticipant: View {
    @State private var selectedItems = ""
    @StateObject var viewModel: TurnCardViewModel
    // let participant = []

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
                    ItemView(
                        participantPicture: time,
                        participantName: "",
                        isSelected: viewModel.starthours == time
                    )
                        .onTapGesture {
                            // TODO: Redirection profile
                            // toggleSelection(of: time)
                        }
                }
            }
            .padding()
        }.scrollIndicators(.hidden)
         */
    }

    private func toggleSelection(of item: String) {
        selectedItems = item
        // viewModel.starthours = item
    }
}

/*
private struct ItemView: View {
    let participantPicture: String
    let participantName: String
    let isSelected: Bool

    var body: some View {
        VStack {
            CirclePicture()
                .frame(width: 150)
            Text("Name")
                .foregroundColor(.white)
        }
    }
}
*/
