//
//  SettingsView.swift
//  Animate Transition
//
//  Created by Aashish Bansal on 28/02/23.
//

/*
 Here, we can set the time and volume for the alarm clock.
 */

import SwiftUI

struct SettingsView: View {
    
    // Creating Properties to Bind to the Controls
    @State private var selection: Int = 1
    @State private var setDate = Date()
    @State private var timeZoneOverride = true
    @State private var volume: Double = 25.0
    @Binding var show: Bool
    
    var body: some View {
        // We will create a ListView to set all the controls.
        ZStack{
            NavigationView{
                List{
                    // Adding the Date Picker
                    Section(header: Text("Date and Time")){
                        DatePicker(selection: $setDate, label: {/// We will add an Image of a small calender
                            Image(systemName: "calendar.circle")
                        }).foregroundColor(.black)
                    }.listRowBackground(Color(.orange))
                    
                    // Adding a Toggle Switch
                    /// TIme Zone Override
                    Section(header: Text("Time Zone Override")){
                        Toggle(isOn: $timeZoneOverride, label: {
                            HStack{
                                Image(systemName: "timer")
                                Text("Override")
                            }.foregroundColor(.black)
                        })
                    }.listRowBackground(Color(.orange))
                    
                    // Alarm Volume
                    /// Using a Slider
                    Section(header: Text("Alarm Volume")){
                        Text("Volume \(String(format: "%.0f", volume as Double)) Decibels").foregroundColor(.black)
                        Slider(value: $volume, in: 0...100){ _ in
                            // Code to run when the slider is moved
                        }
                    }.listRowBackground(Color(.orange))
                    
                    // Repeat Alarm Picker
                    /// Added as a ListRow
                    Section(header: Text("Repeat Text")){
                        Picker(selection: $selection, label: Text("Repeat Alarm")){
                            Text("No Repeat").tag(1)
                            Text("Repeat Once").tag(2)
                            Text("Repeat Twice").tag(3)
                        }.foregroundColor(.black)
                    }.listRowBackground(Color(.orange))
                    
                    // Save Button
                    /// Dismiss the SettingsView
                    Button(action: {
                        withAnimation(.easeInOut(duration: 1.0)){
                            self.show = false
                        } /// ending the Animation
                    }){
                        HStack{
                            Spacer()
                            Text("Save")
                            Spacer()
                        }
                    }.listRowBackground(Color.green) /// end of Button
                }
                .foregroundColor(.white)
                .listStyle(InsetGroupedListStyle()) // Adding the GroupStyle for the ListView which groups all the Controls together
            }.frame(width: 350, height: 625).cornerRadius(20)
            
            Text("Settings")
                .offset(y: -250)
                .foregroundColor(.black)
                .font(.title)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(show: .constant(false))
    }
}
