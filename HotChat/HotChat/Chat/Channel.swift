//
//  Channel.swift
//  HotChat
//
//  Created by Denys Litvinskyi on 15.02.2023.
//

import Foundation
import SendbirdChatSDK
import Combine

final class Channel: ObservableObject {
    private let groupChannel: GroupChannel
    private var channelDelegate: GroupChannelDelegateWrapper

    @Published var title: String
    @Published private(set) var messages: [BaseMessage] = []

    private var cancellables: [AnyCancellable] = []

    init(groupChannel: GroupChannel) {
        self.groupChannel = groupChannel
        self.channelDelegate = GroupChannelDelegateWrapper(currentChannel: groupChannel)

        self.title = groupChannel.name
    }

    func loadPreviousMessages() {
        let params = PreviousMessageListQueryParams()
        params.limit = 100

        guard let listQuery = groupChannel.createPreviousMessageListQuery(params: params) else { return }

        listQuery
            .loadNextPage()
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .sink { [weak self] list in
                self?.messages = list
            }
            .store(in: &cancellables)
    }

    func update(isTyping: Bool) {
        isTyping ? groupChannel.startTyping() : groupChannel.endTyping()
    }

    func send(message: String) {
        groupChannel
            .sendMessage(message)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] message in
                    self?.messages.append(message)
                    self?.groupChannel.endTyping()
                }
            )
            .store(in: &cancellables)
    }

    func listenIncomingMessages() {
        channelDelegate.connect()
            .newMessagePublisher
            .sink { [weak self] message in
                self?.messages.append(message)
            }
            .store(in: &cancellables)

        channelDelegate
            .typingPublisher
            .sink { [weak self] isTyping in
                guard let self else { return }
                self.title = isTyping ? "Typing..." : self.groupChannel.name
            }
            .store(in: &cancellables)
    }

    func removeListeners() {
        cancellables.forEach { $0.cancel() }
    }
}
