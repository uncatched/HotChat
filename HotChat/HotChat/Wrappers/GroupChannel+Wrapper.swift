//
//  GroupChannel+Wrapper.swift
//  HotChat
//
//  Created by Denys Litvinskyi on 15.02.2023.
//

import SendbirdChatSDK
import Combine

extension GroupChannel {

    enum GroupChannelError: Error {
        case channelNotFound
        case failedToSendMessage
    }

    static func createChannel(name: String, isPublic: Bool, userIds: [String]) -> AnyPublisher<GroupChannel, Error> {
        let params = GroupChannelCreateParams()
        params.name = name
        params.isPublic = isPublic
        params.userIds = userIds

        return Deferred {
            Future { promise in
                Self.createChannel(params: params) { channel, error in
                    guard let channel else {
                        promise(.failure(error ?? GroupChannelError.channelNotFound))
                        return
                    }

                    promise(.success(channel))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    static func getChannel(url: String) -> AnyPublisher<GroupChannel, Error> {
        Deferred {
            Future { promise in
                Self.getChannel(url: url) { channel, error in
                    guard let channel else {
                        promise(.failure(error ?? GroupChannelError.channelNotFound))
                        return
                    }

                    promise(.success(channel))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    func acceptInvitation() -> AnyPublisher<Void, Error> {
        Deferred {
            Future { promise in
                self.acceptInvitation { error in
                    if let error {
                        promise(.failure(error))
                    } else {
                        promise(.success(()))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }

    func join() -> AnyPublisher<Void, Error> {
        Deferred {
            Future { promise in
                self.join { error in
                    if let error {
                        promise(.failure(error))
                    } else {
                        promise(.success(()))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }

    func sendMessage(_ message: String) -> AnyPublisher<UserMessage, Error> {
        Deferred {
            Future { promise in
                self.sendUserMessage(message) { message, error in
                    guard let message else {
                        promise(.failure(error ?? GroupChannelError.failedToSendMessage))
                        return
                    }

                    promise(.success(message))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
