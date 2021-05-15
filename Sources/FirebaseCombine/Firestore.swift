//
//  Firestore.swift
//  
//
//  Created by George Markham on 15/05/2021.
//

import Foundation
import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift

extension Firestore {
    func publisher<DataType: Codable>(forCollection collection: String) -> AnyPublisher<[DataType], Error> {
        Future { promise in
            let db = Firestore.firestore()
            
            db.collection(collection)
                .addSnapshotListener { (querySnapshot, error) in
                    guard let documents = querySnapshot?.documents else { return }
                    
                    if let error = error {
                        return promise(.failure(error))
                    }
                    
                    return promise(
                        .success(
                            documents
                                .compactMap { queryDocumentSnapshot in
                                    try? queryDocumentSnapshot
                                        .data(as: DataType.self)
                                }
                        )
                    )
                }
        }
        .eraseToAnyPublisher()
    }
    
//    func publisher(forDocument document: String, inCollection collection: String) {
//    }
}
