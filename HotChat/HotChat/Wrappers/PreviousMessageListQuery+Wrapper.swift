//
//  PreviousMessageListQuery+Wrapper.swift
//  HotChat
//
//  Created by Denys Litvinskyi on 15.02.2023.
//

import SendbirdChatSDK
import Combine

extension PreviousMessageListQuery {

    func loadNextPage() -> AnyPublisher<[BaseMessage], Error> {
        Deferred {
            Future { promise in
                self.loadNextPage { messages, error in
                    if let error {
                        promise(.failure(error))
                    } else {
                        promise(.success(messages ?? []))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
