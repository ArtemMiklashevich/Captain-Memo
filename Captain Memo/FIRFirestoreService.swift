//
//  FIRFirestoreService.swift
//  Captain Memo
//
//  Created by Artem Miklashevich on 12/15/17.
//  Copyright © 2017 Artem Miklashevych. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore

class FIRFirestoreService {
    
    private init() {}
    static let shared = FIRFirestoreService()
    
    func configure() {
        FirebaseApp.configure()
    }
    
/*    private func reference(to collectionReference: FIRCollectionReference) -> CollectionReference {
        return Firestore.firestore().collection(collectionReference.rawValue)
    }
    
    func creat<T: Encodable>(for encodableObject: T, in collectionReference: FIRCollectionReference) {
        do {
            let json = try encodableObject.toJson(excluding: ["id"])
            reference(to: collectionReference).addDocument(data: json)
            
        } catch {
            print(error)
        }
    }
    
    func read<T: Decodable>(from collectionReference: FIRCollectionReference, returning objectType: T.Type, completion: @escaping ([T]) -> Void) {
        
        reference(to: collectionReference).addSnapshotListener { (snapshot, _) in
            
            guard let snapshot = snapshot else { return }
            
            do {
                
                var objects = [T]()
                for document in snapshot.documents {
                    let object = try document.decode(as: objectType.self)
                    objects.append(object)
                }
                
                completion(objects)
                
            } catch {
                print(error)
            }
        }
    }
    
    func update<T: Encodable & Identifiable>(for encodableObject: T, in collectionReference: FIRCollectionReference) {
        
        do {

            let json = try encodableObject.toJson(excluding: ["id"])
            guard let id = encodableObject.id else { throw MyError.encodingError }
           reference(to: collectionReference).document(id).setData(json)
            
        } catch {
            print(error)
        }
    }
    
    func delete<T: Identifiable>(_ identifiableObject: T, in collectionReference: FIRCollectionReference) {
        
        do {
            guard let id = identifiableObject.id else { throw MyError.encodingError }
            reference(to: collectionReference).document(id).delete()
        } catch {
            print(error)
        }
        
    }
 */
}
