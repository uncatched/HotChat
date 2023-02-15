//
//  SendbirdChat+Wrapper.swift
//  HotChat
//
//  Created by Denys Litvinskyi on 15.02.2023.
//

import SendbirdChatSDK
import Combine

extension SendbirdChat {
    enum SendbirdChatError: Error {
        case userNotFound
    }

    static func connect(userId: String) -> AnyPublisher<User, Error> {
        Deferred {
            Future { promise in
                Self.connect(userId: userId) { user, error in
                    guard let user else {
                        promise(.failure(error ?? SendbirdChatError.userNotFound))
                        return
                    }

                    promise(.success(user))
                }
            }
        }.eraseToAnyPublisher()
    }
}
