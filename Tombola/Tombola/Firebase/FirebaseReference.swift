//
//  FirebaseReference.swift
//  Tombola
//  Created by Chiara Tagani on 13/05/22.
//

import Firebase

enum FCollectionReference: String {
    case Game
}

func FirebaseReference(_ collectionReference: FCollectionReference) -> CollectionReference {
    return Firestore.firestore().collection(collectionReference.rawValue)
}
