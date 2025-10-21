//
//  SkyDomeView.swift
//  RealityView
//
//  Created by Peter Rogers on 21/10/2025.
//

import SwiftUI
import RealityKit

struct SkyDomeView: View {
    var body: some View {
        RealityView { content in
            let mesh = MeshResource.generateSphere(radius: 50)
            var mat = UnlitMaterial()
            if let tex = try? await TextureResource(named: "sky.exr") {
                mat.color = .init(texture: .init(tex))
            }
            mat.faceCulling = .front
            let dome = ModelEntity(mesh: mesh, materials: [mat])
            content.add(dome)
        }
        .realityViewCameraControls(.orbit)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
    }
}

#Preview { SkyDomeView() }
