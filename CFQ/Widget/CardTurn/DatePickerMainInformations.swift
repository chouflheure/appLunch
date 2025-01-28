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
                
                /*
                DatePicker(
                            "",
                            selection: $date,
                            displayedComponents: .hourAndMinute
                )
                .tint(.white)
                .colorScheme(.dark)
                .onChange(of: date) { newDate in
                            let calendar = Calendar.current
                            let hour = calendar.component(.hour, from: newDate)
                            var minute = calendar.component(.minute, from: newDate)
                            let roundedMinute = Int(round(Double(minute) / 15.0)) * 15
                            
                            minute = roundedMinute
                            date = calendar.date(bySettingHour: hour, minute: minute, second: 0, of: newDate) ?? date
                        }
                
                Text("-")
                    .foregroundColor(.white)
                DatePicker(
                            "",
                            selection: $date,
                            displayedComponents: .hourAndMinute
                )
                .tint(.white)
                .colorScheme(.dark)
                .onChange(of: date) { newDate in
                            let calendar = Calendar.current
                            let hour = calendar.component(.hour, from: newDate)
                            var minute = calendar.component(.minute, from: newDate)
                            let roundedMinute = Int(round(Double(minute) / 15.0)) * 15
                            
                            minute = roundedMinute
                            date = calendar.date(bySettingHour: hour, minute: minute, second: 0, of: newDate) ?? date
                        }
                */
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
