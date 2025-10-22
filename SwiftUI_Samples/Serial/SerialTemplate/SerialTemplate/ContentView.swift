//
//  ContentView.swift
//  SerialTemplate
//
//  Created by Peter Rogers on 20/10/2025.
//

import SwiftUI

struct ContentView: View {
    var serial: SerialManager

    var body: some View {
        ZStack{
            // Map value from 0–1023 to brightness 0–1
            let brightness = (serial.latestValuesFromArduino[0] ?? 0) / 1023.0
            Color(hue: 0.6, saturation: 0.5, brightness: Double(brightness))
                .edgesIgnoringSafeArea(.all)
            VStack {
                Text(serial.lastLine)
                    .font(.largeTitle)
                    .padding(.bottom, 20)
                    .foregroundStyle(.white)
                
                
                HStack {
                    Gauge(
                        value: serial.latestValuesFromArduino[1] ?? 0,
                        in: 0...1023
                    ) {
                        EmptyView()
                    }
                    .gaugeStyle(.accessoryCircularCapacity)
                    .tint(.white)
                    .scaleEffect(5.0)  // Makes it much larger
                    .frame(width: 400, height: 400) // Enforces size
                    
                }
                .padding()
            }
        }
    }
}

#Preview {
   // let mock = MockSerialManager()
    ContentView(serial: SerialManager())

}
