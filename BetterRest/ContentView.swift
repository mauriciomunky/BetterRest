//
//  ContentView.swift
//  BetterRest
//
//  Created by Maurício Costa on 11/01/23.
//

import CoreML
import SwiftUI

struct ContentView: View {
    @State private var sleepAmount = 8.0
    @State private var wakeUp = Date.now
    @State private var coffeeAmount = 1
    func calculateBedtime() {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            let components = Calendar.current.dateComponents([.hour,.minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            let sleepTime = wakeUp - prediction.actualSleep
            alertTitle = "Sua hora ideal de sono é..."
            alertMessage = sleepTime.formatted(date: .omitted, time: .shortened)
        } catch {
            alertTitle = "Error"
            alertMessage = "Sorry, there was a problem calculating your bedtime."
        }
        showingAlert = true
    }
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    var body: some View {
        NavigationView {
            VStack {
                Text("Quando você quer acordar?").font(.headline)
                
                DatePicker("Por favor escolha um horário", selection: $wakeUp, displayedComponents: .hourAndMinute).labelsHidden()
                
                Text("Quantidade de sono desejada").font(.headline)
                
                Stepper("\(sleepAmount.formatted()) horas", value: $sleepAmount, in: 4...12, step: 0.25)
                
                Text("Quantidade diária de café").font(.headline)
                
                Stepper(coffeeAmount == 1 ? "1 chícara" : "\(coffeeAmount) chícaras", value: $coffeeAmount, in: 1...20)
            }        .toolbar {
                Button("Calcular", action: calculateBedtime)
        }.alert(alertTitle, isPresented: $showingAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
