//
//  Extensions.swift
//  SlotMachine
//
//  Created by user219285 on 4/2/23.
//

import Foundation
import SwiftUI

extension Text {
    func scoreLabelStyle() -> Text {
        self
            .foregroundColor(.white)
            .font(.system(size: 10, weight: .bold, design: .rounded))
    }
    
    func scoreNumberStyle() -> Text {
        self
            .foregroundColor(.white)
            .font(.system(.title, design: .rounded, weight: .heavy))
    }
}
