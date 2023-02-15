//
//  ContentViewModel.swift
//  HotChat
//
//  Created by Denys Litvinskyi on 15.02.2023.
//

import Foundation
import Combine
import SendbirdChatSDK

final class ContentViewModel: ObservableObject {
    @Published private(set) var state: ContentViewModel.State = .loading

    private var cancellables: [AnyCancellable] = []

    func logIn(userId: String) {
        SendbirdChat.connect(userId: userId)
            .map { State.loaded(currentUser: $0.userId) }
            .replaceError(with: .failed)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.state = $0
            }
            .store(in: &cancellables)
    }
}

extension ContentViewModel {
    enum State {
        case loading
        case loaded(currentUser: String)
        case failed
    }
}
