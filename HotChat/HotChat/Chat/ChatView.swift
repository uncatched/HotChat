//
//  ChatView.swift
//  HotChat
//
//  Created by Denys Litvinskyi on 15.02.2023.
//

import SwiftUI

struct ChatView: View {
    let currentUser:  String
    @ObservedObject var channel: Channel

    @FocusState private var textFocused
    @State private var text: String = ""

    var body: some View {
        VStack {
            messages
            textField
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(channel.title)
        .onChange(of: text) { newValue in
            channel.update(isTyping: !newValue.isEmpty)
        }
        .onAppear {
            channel.loadPreviousMessages()
            channel.listenIncomingMessages()
            textFocused = true
        }
        .onDisappear {
            channel.removeListeners()
        }
    }

    private var messages: some View {
        ScrollView {
            LazyVStack {
                ForEach(Array(channel.messages.reversed()), id: \.id) { message in
                    MessageView(text: message.message, isIncoming: message.sender?.userId == currentUser)
                }
            }
        }
        .upsideDown()
    }

    private var textField: some View {
        HStack {
            TextField("Message...", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .padding(.bottom, 8)
                .focused($textFocused)
            Button {
                channel.send(message: text)
                text = ""
            } label: {
                Image(systemName: "paperplane.fill")
                    .resizable()
                    .foregroundColor(.accentColor)
                    .frame(width: 30, height: 30)
            }
            .padding(.trailing)
            .disabled(text.isEmpty)
        }
    }
}
