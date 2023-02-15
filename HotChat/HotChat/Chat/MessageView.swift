//
//  MessageView.swift
//  HotChat
//
//  Created by Denys Litvinskyi on 15.02.2023.
//

import SwiftUI

struct MessageView: View {
    let text: String
    let isIncoming: Bool

    var body: some View {
        HStack {
            if isIncoming { Spacer(minLength: 16) }
            Text(text)
                .padding()
                .background(isIncoming ? Color.green : Color.blue)
                .cornerRadius(15)
                .foregroundColor(.white)
                .upsideDown()
            if !isIncoming { Spacer(minLength: 16) }
        }
        .padding(.horizontal)
    }
}

struct MessageView_Previews: PreviewProvider {
    static var previews: some View {
        MessageView(text: "Hello!", isIncoming: true)
    }
}
