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
    
}
