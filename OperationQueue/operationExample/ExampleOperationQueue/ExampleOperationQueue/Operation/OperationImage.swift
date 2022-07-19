//
//  OperationImage.swift
//  ExampleOperationQueue
//
//  Created by Anatoliy on 08.07.2022.
//

import Foundation
import UIKit

enum ImageRecordState {
    case new, loading, downloaded, failed, suspend
}

class ImageRecord: Decodable {
    let name: String
    var image: String
    weak var operation: ImageDownloader?
    var state: ImageRecordState = .new
    var uiImage = UIImage(named: "Cat")
    
    
    enum CodingKeys: String, CodingKey {
        case name, image
    }
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}

class PendingOperations {
    var downloadQueue: OperationQueue = {
    var queue = OperationQueue()
    queue.name = "Download queue"
    /// для наглядности
    //queue.maxConcurrentOperationCount = 4
    return queue
  }()
  
}
