//
//  Auth.swift
//  FirebaseCombine
//
//  Created by George Markham on 21/01/2021.
//

import Foundation
import Combine
import Firebase

public extension Auth {
    /// Publishes changes to the logged in user.
    /// - Returns: Publisher that emits an optional user or an error.
    func userPublisher() -> AnyPublisher<User?, Error> {
        let passthroughSubject: PassthroughSubject<User?, Error> = .init()
        
        let handler = addStateDidChangeListener { _, user in
            passthroughSubject.send(user)
        }
        
        return passthroughSubject
            .handleEvents(
                receiveCompletion: {[weak self] _ in
                    self?.removeStateDidChangeListener(handler)
                }
            )
            .eraseToAnyPublisher()
    }
    
    func signInAnonymously() -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { future in
            self.signInAnonymously { authResult, error in
                if let error = error {
                    future(.failure(error))
                }
                
                if authResult?.user != nil {
                    future(.success(()))
                }
            }
        }.eraseToAnyPublisher()
    }
}
