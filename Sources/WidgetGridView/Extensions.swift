//
//  File.swift
//  File
//
//  Created by Alejandro Bacelis on 20/07/21.
//

import SwiftUI

// MARK: Frame
extension View {
    func frame(_ cgSize: CGSize) -> some View {
        return self.frame(width: cgSize.width, height: cgSize.height)
    }
    
    func frame(_ size: WGSize) -> some View {
        return self.frame(size.getSize())
    }
}

extension View {
    func padding(_ cord: WGCoordinate, with config: WGSize) -> some View {
        let size = WGSize(cord.width + 1, cord.height + 1, with: config)
        return self
            .padding(.top, size.getSize().height - size.getSize(for: 1).height)
            .padding(.leading, size.getSize().width - size.getSize(for: 1).width)
    }
}
