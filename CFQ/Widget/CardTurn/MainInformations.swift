
import SwiftUI

struct MainInformationsView: View {
    @State private var showMoods = false
    @StateObject var viewModel: TurnCardViewModel

    var body: some View {
            VStack(alignment: .leading, spacing: 20) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        if viewModel.moods.isEmpty {
                            MoodDataTemplate()
                        } else {
                            ForEach(Array(viewModel.moods), id: \.self) { mood in
                                Mood().data(for: mood)
                                    
                            }
                        }
                    }
                }.onTapGesture {
                    showMoods.toggle()
                }
                .padding(.horizontal, 12)
                .sheet(isPresented: $showMoods) {
                    ZStack {
                        NeonBackgroundImage()

                        VStack {
                            CollectionViewMoods(viewModel: viewModel)
                            Button(
                                action: {showMoods = false},
                                label: {
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
                    .presentationDragIndicator(.visible)
                    .presentationDetents([.height(500)])
                }

                DatePickerMainInformations(viewModel: viewModel)
                    .padding(.horizontal, 12)


                HStack(alignment: .top) {
                        Image(systemName: "mappin")
                            .foregroundColor(.white)
                        Text("Chez moi")
                            .foregroundColor(.white)
                        Text("|")
                        Text("92240 Malakoff ")
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 12)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 15)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(.white, lineWidth: 0.8)
            )
        }
    
}

#Preview {
    ZStack {
        Color.blue.edgesIgnoringSafeArea(.all)
        MainInformationsView(viewModel: TurnCardViewModel())
    }
}
