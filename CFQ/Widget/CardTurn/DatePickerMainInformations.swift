//
//  DatePicker.swift
//  CFQ
//
//  Created by Calvignac Charles on 26/01/2025.
//

import SwiftUI

struct DatePickerMainInformations: View {
    @State private var date = Date.now
    @State private var showPicker = false
    @State private var hasCompleted = false
    @StateObject var viewModel: TurnCardViewModel

    var body: some View {
        HStack {
            Image(systemName: "calendar")
                .foregroundColor(hasCompleted ? .white : .gray)
            Text(hasCompleted ? viewModel.textFormattedLongFormat() : "choisir une date")
                .foregroundColor(hasCompleted ? .white : .gray)
                .onTapGesture {
                    showPicker = true
                }
        }
        .sheet(isPresented: $showPicker) {
            ZStack {
                Image(.backgroundNeon)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
                VStack {
                    DatePicker("", selection: $viewModel.date, in: Date.now..., displayedComponents: .date)
                        .datePickerStyle(GraphicalDatePickerStyle())
                        .environment(\.locale, Locale.init(identifier: "fr_FR"))
                        .tint(.white)
                        .colorScheme(.dark)
                    Button(action: {showPicker = false; hasCompleted = true}, label: {
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

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d  MMMM"
        formatter.locale = Locale(identifier: "fr_FR")
        return formatter.string(from: date).capitalized
    }
}

#Preview {
    ZStack {
        Color.blue.ignoresSafeArea()
        DatePickerMainInformations(viewModel: TurnCardViewModel())
    }
}
