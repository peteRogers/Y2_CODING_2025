//
//  SImpleContentView.swift
//  AudioKit_Sampler
//
//  Created by Peter Rogers on 21/10/2025.
//
import SwiftUI

struct SimpleContentView: View{
    @State private var simpleAudio = SimpleAudioControl()
    var serial:SerialManager
    @State var volume:Float = 0.5
    
    var body: some View {
        VStack(spacing: 50){
            
            Text("simple audio player")
                .font(.title)
            Button("Stop") {
                simpleAudio.stop()
            }.font(Font.largeTitle)
            
            Button("Play") {
                simpleAudio.play()
            }.font(Font.largeTitle)
            
            Slider(value: $volume, in: 0...1)
                .onChange(of: volume) { _, newValue in
                    simpleAudio.setVolume(from: newValue)
            }.padding(.horizontal, 200)
            
        }.onAppear {
            simpleAudio.setup()
        }
        .onChange(of: serial.latestValuesFromArduino[0]) { _, newValue in
            if let val = newValue{
                simpleAudio.setReverbMix(from: val)
            }
        }
    }
}

#Preview {
    SimpleContentView(serial: SerialManager())
}
