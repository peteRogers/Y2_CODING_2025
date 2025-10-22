//
//  SImpleContentView.swift
//  AudioKit_Sampler
//
//  Created by Peter Rogers on 21/10/2025.
//
import SwiftUI

struct SimpleContentView: View{
    @State private var simpleAudio = SimpleAudioControl()
    
    var body: some View {
        VStack(spacing: 20){
            Text("simple audio player")
                .font(.title)
            Button("Stop") {
                print("dpkdpk")
                simpleAudio.stop()
            }
            Button("Play") {
                simpleAudio.play()
            }
            
        }.onAppear {
            print("starere")
            simpleAudio.setup()
       
        }
    }
    
    
}

#Preview {
    SimpleContentView()
}

