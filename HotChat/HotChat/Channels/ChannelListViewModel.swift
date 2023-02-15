//
//  ChannelListViewModel.swift
//  HotChat
//
//  Created by Denys Litvinskyi on 15.02.2023.
//

import Foundation
import SendbirdChatSDK
import Combine

final class ChannelListViewModel: ObservableObject {
    @Published private(set) var channels: [GroupChannel] = []

    private var cancellables: [AnyCancellable] = []

    init() {
        loadChannels()
    }

    func createChat(name: String, invite userId: String) {
        GroupChannel
            .createChannel(name: name, isPublic: true, userIds: [userId])
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] channel in
                    self?.channels.append(channel)
                }
            )
            .store(in: &cancellables)
    }

    private func loadChannels() {
        GroupChannel
            .createMyGroupChannelListQuery()
            .loadNextPage()
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.channels = $0
            }
            .store(in: &cancellables)
    }
}

