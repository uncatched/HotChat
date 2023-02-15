//
//  HotChatApp.swift
//  HotChat
//
//  Created by Denys Litvinskyi on 15.02.2023.
//

import SwiftUI
import SendbirdChatSDK

@main
struct HotChatApp: App {
    init() {
        let params = InitParams(applicationId: "CDE74D25-C4A2-4762-AB6C-8B6B84099447")
        SendbirdChat.initialize(params: params)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
