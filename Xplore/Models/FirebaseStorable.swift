//
//  FirebaseStorable.swift
//  Xplore
//
//  Created by Jack Knight on 2/6/19.
//  Copyright © 2019 Jack Knight. All rights reserved.
//

import Foundation
import FirebaseStorage

protocol FirebaseStorage {
    var data: Data {get}
    var uuid: String {get}
    static var CollectionName: String {get}
}

extension FirebaseStorage {
    var storageReference: StorageReference {
        return Storage.storage().reference().child(Self.CollectionName)
    }
}
