//
//  GroupChannelListQuery+Wrapper.swift
//  HotChat
//
//  Created by Denys Litvinskyi on 15.02.2023.
//

import SendbirdChatSDK
import Combine

extension GroupChannelListQuery {

    func loadNextPage() -> AnyPublisher<[GroupChannel], Error> {
        let params = GroupChannelListQueryParams()
        params.includeEmptyChannel = true
        params.order = .latestLastMessage
        params.limit = 15

        return Deferred {
            Future { promise in
                self.loadNextPage { channels, error in
                    if let error {
                        promise(.failure(error))
                    } else {
                        promise(.success(channels ?? []))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
