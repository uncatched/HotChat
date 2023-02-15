//
//  GroupChannelDelegate+Wrapper.swift
//  HotChat
//
//  Created by Denys Litvinskyi on 15.02.2023.
//

import Foundation
import SendbirdChatSDK
import Combine

final class GroupChannelDelegateWrapper: GroupChannelDelegate {
    private let channelDelegateIdentifier = UUID().uuidString
    private let userDelegateIdentifier = UUID().uuidString

    private let newMessageSubject = PassthroughSubject<BaseMessage, Never>()
    var newMessagePublisher: AnyPublisher<BaseMessage, Never> {
        newMessageSubject.eraseToAnyPublisher()
    }

    private let typingSubject = PassthroughSubject<Bool, Never>()
    var typingPublisher: AnyPublisher<Bool, Never> {
        typingSubject.eraseToAnyPublisher()
    }

    private let currentChannel: GroupChannel

    init(currentChannel: GroupChannel) {
        self.currentChannel = currentChannel
    }

    deinit {
        newMessageSubject.send(completion: .finished)
        typingSubject.send(completion: .finished)
    }

    @discardableResult
    func connect() -> Self {
        SendbirdChat.addChannelDelegate(self, identifier: channelDelegateIdentifier)
        return self
    }

    func channel(_ channel: BaseChannel, didReceive message: BaseMessage) {
        guard currentChannel == channel else { return }

        newMessageSubject.send(message)
    }

    func channelDidUpdateTypingStatus(_ channel: GroupChannel) {
        guard currentChannel == channel else { return }

        typingSubject.send(channel.isTyping())
    }
}
