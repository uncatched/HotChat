//
//  ChannelListView.swift
//  HotChat
//
//  Created by Denys Litvinskyi on 15.02.2023.
//

import SwiftUI

struct ChannelListView: View {
    @StateObject private var viewModel = ChannelListViewModel()
    @State private var isCreteChannelPresented = false
    @State private var chatName = ""
    @State private var inviteUserId = ""

    let user: String

    var body: some View {
        List(viewModel.channels, id: \.id) { channel in
            NavigationLink {
                ChatView(
                    currentUser: user,
                    channel: Channel(groupChannel: channel)
                )
            } label: {
                Text(channel.name)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Channels")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button {
                    isCreteChannelPresented = true
                } label: {
                    Image(systemName: "plus")
                        .foregroundColor(.accentColor)
                }

            }
        }
        .alert("Create Chat", isPresented: $isCreteChannelPresented) {
            TextField("Chat Name", text: $chatName)
                .textInputAutocapitalization(.never)

            TextField("Invite user id", text: $inviteUserId)
                .textInputAutocapitalization(.never)

            Button("Create") {
                viewModel.createChat(name: chatName, invite: inviteUserId)
            }
        } message: {
            Text("Enter new chat name")
        }
    }
}

struct ChannelListView_Previews: PreviewProvider {
    static var previews: some View {
        ChannelListView(user: "Denys")
    }
}
