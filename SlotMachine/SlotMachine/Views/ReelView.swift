//
//  ReelView.swift
//  SlotMachine
//
//  Created by user219285 on 4/2/23.
//

import SwiftUI

struct ReelView: View {
    var body: some View {
        Image(imageReel)
            .resizable()
            .modifier(ImageModifier())
    }
}

struct ReelView_Previews: PreviewProvider {
    static var previews: some View {
        ReelView()
    }
}
