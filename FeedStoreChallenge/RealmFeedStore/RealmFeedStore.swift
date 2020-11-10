//
//  RealmFeedStore.swift
//  FeedStoreChallenge
//
//  Created by Angel Vázquez on 09/11/20.
//  Copyright © 2020 Essential Developer. All rights reserved.
//

import Foundation
import RealmSwift

public class RealmFeedStore: FeedStore {
    
    public typealias Configuration = Realm.Configuration
    
    // MARK: - Properties
    private let realm: Realm
    
    // MARK: - Initializers
    
    public init(configuration: Configuration) {
        self.realm = try! Realm(configuration: configuration)
    }
    
    // MARK: - FeedStore
    
    public func retrieve(completion: @escaping RetrievalCompletion) {
        guard let cache = realm.objects(RealmCache.self).first else {
            return completion(.empty)
        }
        
        let (feed, timestamp) = RealmCacheMapper.transform(realmCache: cache)
        completion(.found(feed: feed, timestamp: timestamp))
    }
    
    public func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
        do {
            try realm.write() {
                realm.deleteAll()
                let cache = RealmCacheMapper.realmCache(for: feed, timestamp: timestamp)
                realm.create(RealmCache.self, value: cache)
                completion(nil)
            }
        } catch {
            completion(error)
        }
    }
    
    public func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        do {
            try realm.write() {
                realm.deleteAll()
                completion(nil)
            }
        } catch {
            completion(error)
        }
    }
}
