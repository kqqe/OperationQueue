//
//  ImageDownload.swift
//  ExampleOperationQueue
//
//  Created by Anatoliy on 08.07.2022.
//

import Foundation
import UIKit


class ImageDownloader: Operation {
    
    let imageRecord: ImageRecord
    
    init(_ imageRecord: ImageRecord) {
        self.imageRecord = imageRecord
    }
    
    override func main() {
        if isCancelled {
            return
        }
        guard let url = URL(string: imageRecord.image) else { return }
        guard let imageData = try? Data(contentsOf: url) else { return }
        
        if isCancelled {
            return
        }
        
        if !imageData.isEmpty {
            imageRecord.uiImage = UIImage(data: imageData)
            imageRecord.state = .downloaded
        } else {
            imageRecord.state = .failed
            imageRecord.uiImage = UIImage(named: "cat")
        }
    }
}
