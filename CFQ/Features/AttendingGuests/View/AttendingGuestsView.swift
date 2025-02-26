
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
            
            PageViewTest()
        }
    }
}


#Preview {
    ZStack {
        NeonBackgroundImage()
        AttendingGuestsView()
    }.ignoresSafeArea()
    
}




struct PageViewTest: View {
    @State private var selectedIndex = 0
    let titles = ["✨tous", "👍", "🤔", "👎"]

    var body: some View {
        VStack {
            HStack {
                ForEach(0..<titles.count, id: \.self) { index in
                    VStack {
                        Text(titles[index])
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(selectedIndex == index ? .white : .gray)

                        Rectangle()
                            .frame(height: 3)
                            .foregroundColor(selectedIndex == index ? .white : .clear)
                            .padding(.horizontal, 10)
                    }
                    .frame(maxWidth: .infinity)
                    .onTapGesture {
                        withAnimation {
                            selectedIndex = index
                        }
                    }
                }
            }
            .padding(.top, 20)

            // PageView avec TabView
            TabView(selection: $selectedIndex) {
                CollectionViewParticipant(viewModel: TurnCardViewModel())
                    .tag(0)
                CollectionViewParticipant(viewModel: TurnCardViewModel())
                    .tag(1)
                CollectionViewParticipant(viewModel: TurnCardViewModel())
                    .tag(2)
                CollectionViewParticipant(viewModel: TurnCardViewModel())
                    .tag(3)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)) // Mode Page sans dots
        }
    }
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
    }

    private func toggleSelection(of item: String) {
        selectedItems = item
        viewModel.starthours = item
    }
}

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
