//
//  RealmCache.swift
//  FeedStoreChallenge
//
//  Created by Angel Vázquez on 09/11/20.
//  Copyright © 2020 Essential Developer. All rights reserved.
//

import Foundation
import RealmSwift

internal class RealmCache: Object {
    let imageList = List<RealmFeedImage>()
    @objc dynamic var timestamp: Date = Date()
    
    convenience init(realmFeed: [RealmFeedImage], timestamp: Date) {
        self.init()
        self.imageList.append(objectsIn: realmFeed)
        self.timestamp = timestamp
    }
}
