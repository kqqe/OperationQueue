//
//  OperationImage.swift
//  ExampleOperationQueue
//
//  Created by Anatoliy on 08.07.2022.
//

import Foundation
import UIKit

enum ImageRecordState {
    case downloaded, failed
}

class ImageRecord: Decodable {
    let name: String
    var image: String
    var state: ImageRecordState = .downloaded
    var uiImage = UIImage(named: "Placeholder")
    
    
    enum CodingKeys: String, CodingKey {
        case name, image
    }
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}

class PendingOperations {
    var downloadsInProgress: [IndexPath: Operation] = [:]
    var downloadQueue: OperationQueue = {
    var queue = OperationQueue()
    queue.name = "Download queue"
    /// для наглядности
    //queue.maxConcurrentOperationCount = 1
    return queue
  }()
  
}
