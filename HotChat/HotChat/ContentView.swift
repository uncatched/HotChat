//
//  ContentView.swift
//  HotChat
//
//  Created by Denys Litvinskyi on 15.02.2023.
//

import SwiftUI

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()
    @State private var isUserAlertPresented = false
    @State private var userId = ""

    var body: some View {
        switch viewModel.state {
        case .loading:
            ProgressView()
                .onAppear {
                    isUserAlertPresented = true
                }
                .alert("Log In", isPresented: $isUserAlertPresented) {
                    TextField("User Id", text: $userId)
                        .textInputAutocapitalization(.never)
                    Button("Log In") {
                        viewModel.logIn(userId: userId)
                    }
                } message: {
                    Text("Please enter user id")
                }

        case .failed:
            Text("Failed to load")
        case let .loaded(currentUser):
            NavigationView {
                ChannelListView(user: currentUser)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
