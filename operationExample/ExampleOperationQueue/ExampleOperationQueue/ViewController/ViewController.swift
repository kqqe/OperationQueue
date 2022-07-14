//
//  ViewController.swift
//  ExampleOperationQueue
//
//  Created by Anatoliy on 04.07.2022.
//

import UIKit

class ViewController: UIViewController {

    let service = ServiceApi()
    let pendingOperations = PendingOperations()
    var arrayImages: [ImageRecord] = []

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = UITableView.automaticDimension
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "Cell")
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        service.loadJson { collectionImage in
            self.arrayImages = collectionImage
        }
        tableView.reloadData()
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayImages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? TableViewCell  else { return UITableViewCell() }

        cell.labelOne.text = arrayImages[indexPath.row].name
        cell.imageViewOne.image = arrayImages[indexPath.row].uiImage
        cell.lableTwo.text = arrayImages[indexPath.row].name
        cell.imageViewTwo.image = arrayImages[indexPath.row].uiImage
        cell.labelThree.text = arrayImages[indexPath.row].name
        cell.imageViewThree.image = arrayImages[indexPath.row].uiImage
        
        switch (arrayImages[indexPath.row].state) {
        case .failed:
            cell.textLabel?.text = "Failed to load"
        case .downloaded:
            if !tableView.isDragging && !tableView.isDecelerating {
                startDownload(for: arrayImages[indexPath.row], at: indexPath)
            }
        }

        return cell
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        suspendAllOperations()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            loadImagesForOnscreenCells()
            resumeAllOperations()
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        loadImagesForOnscreenCells()
        resumeAllOperations()
    }
}

private extension ViewController {
    func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16)
        ])
    }
    
    func setupView(){
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        setupConstraints()
    }
}

// MARK: Method Operation
extension ViewController {
    
    func startDownload(for imageRecord: ImageRecord, at indexPath: IndexPath) {
      guard pendingOperations.downloadsInProgress[indexPath] == nil else {
        return
      }
          
      let downloader = ImageDownloader(imageRecord)
      
      downloader.completionBlock = {
        if downloader.isCancelled {
          return
        }

        DispatchQueue.main.async {
          self.pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
          self.tableView.reloadRows(at: [indexPath], with: .none)
        }
      }
      
      pendingOperations.downloadsInProgress[indexPath] = downloader
      pendingOperations.downloadQueue.addOperation(downloader)
    }

    func suspendAllOperations() {
        pendingOperations.downloadQueue.isSuspended = true
    }

    func resumeAllOperations() {
        pendingOperations.downloadQueue.isSuspended = false
    }

    func loadImagesForOnscreenCells() {
      if let pathsArray = tableView.indexPathsForVisibleRows {
        let allPendingOperations = Set(pendingOperations.downloadsInProgress.keys)
          
        var toBeCancelled = allPendingOperations
        let visiblePaths = Set(pathsArray)
        toBeCancelled.subtract(visiblePaths)
          
        var toBeStarted = visiblePaths
        toBeStarted.subtract(allPendingOperations)
          
        for indexPath in toBeCancelled {
          if let pendingDownload = pendingOperations.downloadsInProgress[indexPath] {
            pendingDownload.cancel()
          }
          pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)

        }
          
        for indexPath in toBeStarted {
          let recordToProcess = arrayImages[indexPath.row]
            startDownload(for: recordToProcess, at: indexPath)
        }
      }
    }
}
