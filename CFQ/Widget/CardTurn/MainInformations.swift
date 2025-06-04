
import SwiftUI

struct MainInformationsPreviewView: View {
    @ObservedObject var viewModel: TurnCardViewModel

    var body: some View {
            VStack(alignment: .leading, spacing: 20) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        if viewModel.moods.isEmpty {
                            MoodTemplateView()
                        } else {
                            ForEach(Array(viewModel.moods), id: \.self) { mood in
                                Mood().data(for: mood)
                                    
                            }
                        }
                    }
                }
                .padding(.horizontal, 12)
                
                HStack {

                    Image(.iconDate)
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(viewModel.textFormattedLongFormat.isEmpty ? .gray : .white)
                        .padding(.leading, 12)
                    
                    Text(viewModel.textFormattedLongFormat.isEmpty ? "Date" : viewModel.textFormattedLongFormat)
                        .tokenFont(viewModel.textFormattedLongFormat.isEmpty ? .Placeholder_Inter_Regular_16 : .Body_Inter_Medium_16)

                    Text(" | ")
                        .foregroundColor(.white)

                    Text(viewModel.textFormattedHours.isEmpty ? "Heure de début" : viewModel.textFormattedHours)
                        .tokenFont(.Placeholder_Inter_Regular_16)
                }

                HStack(alignment: .center) {
                    
                    Image(.iconLocation)
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(viewModel.placeTitle.isEmpty ? .gray : .white)
                    
                    Text(viewModel.placeTitle.isEmpty ? "Lieu" : viewModel.placeTitle)
                        .tokenFont(viewModel.placeTitle.isEmpty ? .Placeholder_Inter_Regular_14 : .Body_Inter_Medium_14)
                        .lineLimit(1)

                    Text("|")
                        .foregroundColor(.white)

                    Text(viewModel.placeAdresse.isEmpty ? "Adress" : viewModel.placeAdresse)
                        .tokenFont(.Placeholder_Inter_Regular_14)
                        .lineLimit(1)
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

struct MainInformationsDetailView: View {
    @State private var showMoods = false
    @ObservedObject var viewModel: TurnCardViewModel
    @State var isPresentedLocalisation = false

    var body: some View {
            VStack(alignment: .leading, spacing: 20) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        if viewModel.moods.isEmpty {
                            MoodTemplateView()
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

                DatePickerMainInformations(viewModel: viewModel)
                    .padding(.horizontal, 12)

                HStack(alignment: .top) {

                    Button(action: {
                        isPresentedLocalisation = true
                    }) {
                        Image(.iconLocation)
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.white)

                        Text(viewModel.placeTitle.isEmpty ? "Lieu" : viewModel.placeTitle)
                            .tokenFont(viewModel.placeTitle.isEmpty ? .Placeholder_Inter_Regular_16 : .Body_Inter_Medium_16)

                        Text("|")
                            .foregroundColor(.white)

                        Text(viewModel.placeAdresse.isEmpty ? "Adress" : viewModel.placeAdresse)
                            .tokenFont(.Placeholder_Inter_Regular_16)
                    }
                }
                .padding(.horizontal, 12)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 15)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(.white, lineWidth: 0.8)
            )
            .sheet(isPresented: $isPresentedLocalisation) {
                ContentView8(viewModel: viewModel, isPresented: $isPresentedLocalisation)
                    .presentationDragIndicator(.visible)
            }
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
        }
}

#Preview {
    ZStack {
        Color.blue.edgesIgnoringSafeArea(.all)
        // MainInformationsView(viewModel: TurnCardViewModel())
    }
}
