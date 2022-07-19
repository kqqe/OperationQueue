//
//  ImageDownload.swift
//  ExampleOperationQueue
//
//  Created by Anatoliy on 08.07.2022.
//

import Foundation
import UIKit


class ImageDownloader: Operation {
    
    var dataTask: URLSessionDataTask?
    
    var dataTaskCompletion: (() -> Void)?
    
    let imageRecord: ImageRecord
    
    
    init(_ imageRecord: ImageRecord) {
        self.imageRecord = imageRecord
    }
    
    
    override func main() {
        if isCancelled {
            return
        }
    
        guard let url = URL(string: imageRecord.image) else { return }
            self.dataTask = URLSession.shared.dataTask(with: url) {[weak self] data, _, error in
                guard let self = self else { return }
                if let error = error as? NSError {
                            self.imageRecord.state = .failed
                            self.imageRecord.uiImage = UIImage(named: "failed")
                        print("CASE ERROR", error)
                    } else {
                        self.imageRecord.uiImage = UIImage(data: data!)
                        self.imageRecord.state = .downloaded
                }
                self.dataTaskCompletion?()
    
            }
            self.dataTask?.resume()
        
    }
    func dataTaskSuspend() {
        dataTask?.suspend()
        imageRecord.state = .suspend
    }
    
    func dataTaskStart() {
        dataTask?.resume()
        imageRecord.state = .loading
    }
}
