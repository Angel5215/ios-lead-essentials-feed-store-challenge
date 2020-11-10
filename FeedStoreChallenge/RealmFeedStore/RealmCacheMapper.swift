//
//  RealmCacheMapper.swift
//  FeedStoreChallenge
//
//  Created by Angel Vázquez on 09/11/20.
//  Copyright © 2020 Essential Developer. All rights reserved.
//

import Foundation

internal class RealmCacheMapper {
    static func realmCache(for localFeedImage: [LocalFeedImage], timestamp: Date) -> RealmCache {
        let realmFeed = localFeedImage.map {
            RealmFeedImage(id: $0.id.uuidString, imageDescription: $0.description, location: $0.location, url: $0.url.absoluteString)
        }
        return RealmCache(realmFeed: realmFeed, timestamp: timestamp)
    }
    
    static func transform(realmCache: RealmCache) -> (feed: [LocalFeedImage], timestamp: Date) {
        let feed: [LocalFeedImage] = realmCache.imageList.compactMap {
            guard let id = UUID(uuidString: $0.id), let url = URL(string: $0.url) else { return nil }
            return LocalFeedImage(id: id, description: $0.imageDescription, location: $0.location, url: url)
        }
        return (feed, realmCache.timestamp)
    }
}
