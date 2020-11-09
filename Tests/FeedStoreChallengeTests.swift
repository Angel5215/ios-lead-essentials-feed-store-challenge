//
//  Copyright © 2019 Essential Developer. All rights reserved.
//

import XCTest
import FeedStoreChallenge
import RealmSwift

class RealmCache: Object {
    let imageList = List<RealmFeedImage>()
    @objc dynamic var timestamp: Date = Date()
    
    convenience init(realmFeed: [RealmFeedImage], timestamp: Date) {
        self.init()
        self.imageList.append(objectsIn: realmFeed)
        self.timestamp = timestamp
    }
}

class RealmFeedImage: Object {
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

class RealmFeedMapper {
    static func transform(localFeedImage: [LocalFeedImage]) -> [RealmFeedImage] {
        return localFeedImage.map {
            RealmFeedImage(id: $0.id.uuidString, imageDescription: $0.description, location: $0.location, url: $0.url.absoluteString)
        }
    }
    
    static func transform(realmFeed: List<RealmFeedImage>) -> [LocalFeedImage] {
        return realmFeed.compactMap {
            guard let id = UUID(uuidString: $0.id), let url = URL(string: $0.url) else { return nil }
            return LocalFeedImage(id: id, description: $0.imageDescription, location: $0.location, url: url)
        }
    }
}

class RealmFeedStore: FeedStore {
    
    typealias Configuration = Realm.Configuration
    
    // MARK: - Properties
    private let realm: Realm
    
    // MARK: - Initializers
    
    init(configuration: Configuration) {
        self.realm = try! Realm(configuration: configuration)
    }
    
    // MARK: - FeedStore
    
    func retrieve(completion: @escaping RetrievalCompletion) {
        guard let cache = realm.objects(RealmCache.self).first else {
            return completion(.empty)
        }
        
        let feed = RealmFeedMapper.transform(realmFeed: cache.imageList)
        let timestamp = cache.timestamp
        
        completion(.found(feed: feed, timestamp: timestamp))
    }
    
    func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
        try! realm.write() {
            let realmFeed = RealmFeedMapper.transform(localFeedImage: feed)
            let value = RealmCache(realmFeed: realmFeed, timestamp: timestamp)
            realm.create(RealmCache.self, value: value)
            completion(nil)
        }
    }
    
    func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        
    }
}

class FeedStoreChallengeTests: XCTestCase, FeedStoreSpecs {
	
    //  ***********************
    //
    //  Follow the TDD process:
    //
    //  1. Uncomment and run one test at a time (run tests with CMD+U).
    //  2. Do the minimum to make the test pass and commit.
    //  3. Refactor if needed and commit again.
    //
    //  Repeat this process until all tests are passing.
    //
    //  ***********************
    
    override func setUp() {
        super.setUp()
        try? FileManager.default.removeItem(at: testStoreURL())
    }
    
    override func tearDown() {
        super.tearDown()
        try? FileManager.default.removeItem(at: testStoreURL())
    }

	func test_retrieve_deliversEmptyOnEmptyCache() {
		let sut = makeSUT()

		assertThatRetrieveDeliversEmptyOnEmptyCache(on: sut)
	}

	func test_retrieve_hasNoSideEffectsOnEmptyCache() {
		let sut = makeSUT()

		assertThatRetrieveHasNoSideEffectsOnEmptyCache(on: sut)
	}

	func test_retrieve_deliversFoundValuesOnNonEmptyCache() {
		let sut = makeSUT()

		assertThatRetrieveDeliversFoundValuesOnNonEmptyCache(on: sut)
	}

	func test_retrieve_hasNoSideEffectsOnNonEmptyCache() {
		let sut = makeSUT()

		assertThatRetrieveHasNoSideEffectsOnNonEmptyCache(on: sut)
	}

	func test_insert_deliversNoErrorOnEmptyCache() {
//		let sut = makeSUT()
//
//		assertThatInsertDeliversNoErrorOnEmptyCache(on: sut)
	}

	func test_insert_deliversNoErrorOnNonEmptyCache() {
//		let sut = makeSUT()
//
//		assertThatInsertDeliversNoErrorOnNonEmptyCache(on: sut)
	}

	func test_insert_overridesPreviouslyInsertedCacheValues() {
//		let sut = makeSUT()
//
//		assertThatInsertOverridesPreviouslyInsertedCacheValues(on: sut)
	}

	func test_delete_deliversNoErrorOnEmptyCache() {
//		let sut = makeSUT()
//
//		assertThatDeleteDeliversNoErrorOnEmptyCache(on: sut)
	}

	func test_delete_hasNoSideEffectsOnEmptyCache() {
//		let sut = makeSUT()
//
//		assertThatDeleteHasNoSideEffectsOnEmptyCache(on: sut)
	}

	func test_delete_deliversNoErrorOnNonEmptyCache() {
//		let sut = makeSUT()
//
//		assertThatDeleteDeliversNoErrorOnNonEmptyCache(on: sut)
	}

	func test_delete_emptiesPreviouslyInsertedCache() {
//		let sut = makeSUT()
//
//		assertThatDeleteEmptiesPreviouslyInsertedCache(on: sut)
	}

	func test_storeSideEffects_runSerially() {
//		let sut = makeSUT()
//
//		assertThatSideEffectsRunSerially(on: sut)
	}
	
	// - MARK: Helpers
	
    private func makeSUT() -> FeedStore {
        return RealmFeedStore(configuration: makeConfiguration())
	}
    
    private func makeConfiguration() -> RealmFeedStore.Configuration {
        var configuration = RealmFeedStore.Configuration()
        configuration.fileURL = testStoreURL()
        
        return configuration
    }
	
    private func cachesURL() -> URL {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
    }
    
    private func testStoreURL() -> URL {
        return cachesURL().appendingPathComponent("\(type(of: self))Tests").appendingPathExtension("realm")
    }
}

//  ***********************
//
//  Uncomment the following tests if your implementation has failable operations.
//
//  Otherwise, delete the commented out code!
//
//  ***********************

//extension FeedStoreChallengeTests: FailableRetrieveFeedStoreSpecs {
//
//	func test_retrieve_deliversFailureOnRetrievalError() {
////		let sut = makeSUT()
////
////		assertThatRetrieveDeliversFailureOnRetrievalError(on: sut)
//	}
//
//	func test_retrieve_hasNoSideEffectsOnFailure() {
////		let sut = makeSUT()
////
////		assertThatRetrieveHasNoSideEffectsOnFailure(on: sut)
//	}
//
//}

//extension FeedStoreChallengeTests: FailableInsertFeedStoreSpecs {
//
//	func test_insert_deliversErrorOnInsertionError() {
////		let sut = makeSUT()
////
////		assertThatInsertDeliversErrorOnInsertionError(on: sut)
//	}
//
//	func test_insert_hasNoSideEffectsOnInsertionError() {
////		let sut = makeSUT()
////
////		assertThatInsertHasNoSideEffectsOnInsertionError(on: sut)
//	}
//
//}

//extension FeedStoreChallengeTests: FailableDeleteFeedStoreSpecs {
//
//	func test_delete_deliversErrorOnDeletionError() {
////		let sut = makeSUT()
////
////		assertThatDeleteDeliversErrorOnDeletionError(on: sut)
//	}
//
//	func test_delete_hasNoSideEffectsOnDeletionError() {
////		let sut = makeSUT()
////
////		assertThatDeleteHasNoSideEffectsOnDeletionError(on: sut)
//	}
//
//}
