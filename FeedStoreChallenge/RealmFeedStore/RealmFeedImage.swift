//
//  RealmFeedImage.swift
//  FeedStoreChallenge
//
//  Created by Angel Vázquez on 09/11/20.
//  Copyright © 2020 Essential Developer. All rights reserved.
//

import Foundation
import RealmSwift

internal class RealmFeedImage: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var imageDescription: String? = nil
    @objc dynamic var location: String? = nil
    @objc dynamic var url: String = ""
    
    convenience init(id: String, imageDescription: String?, location: String?, url: String) {
        self.init()
        self.id = id
        self.imageDescription = imageDescription
        self.location = location
        self.url = url
    }
}
