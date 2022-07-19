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
        service.loadJson { [weak self] collectionImage in
            self?.arrayImages = collectionImage
            self?.tableView.reloadData()
        }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayImages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? TableViewCell  else { return UITableViewCell() }
        let imageRecord = arrayImages[indexPath.row]
        
            cell.labelOne.text = imageRecord.name
            cell.lableTwo.text = imageRecord.name
            cell.labelThree.text = imageRecord.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let myCell = cell as? TableViewCell else { return }
        
        let imageRecord = arrayImages[indexPath.row]
        
        switch imageRecord.state {
        case .new:
            print("CASE willDisplay: ", indexPath.row, ".new")
            let downloader = ImageDownloader(imageRecord)
            
            
            downloader.dataTaskCompletion = {
              if downloader.isCancelled {
                return
              }
                print("CASE image Downloaded at ", indexPath.row)
                DispatchQueue.main.async {
                  self.tableView.beginUpdates()
                  self.tableView.reloadRows(at: [indexPath], with: .none)
                  self.tableView.endUpdates()
                }
            }
            imageRecord.operation = downloader
            pendingOperations.downloadQueue.addOperation(downloader)

        case .downloaded:
            myCell.imageViewOne.image = imageRecord.uiImage
            myCell.imageViewTwo.image = imageRecord.uiImage
            myCell.imageViewThree.image = imageRecord.uiImage
            
            print("CASE willDisplay : ", indexPath.row, ".downloaded")
            
        case .failed:
            /// всталяем failed
            myCell.imageViewOne.image = imageRecord.uiImage
            myCell.imageViewTwo.image = imageRecord.uiImage
            myCell.imageViewThree.image = imageRecord.uiImage
            print("CASE willDisplay: ", indexPath.row, ".failed")

        case .loading:
            print("CASE willDisplay: ", indexPath.row, ".loading")
        case .suspend:
            imageRecord.operation?.dataTaskStart()
            print("CASE willDisplay: ", indexPath.row, ".suspend")

        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let imageRecord = arrayImages[indexPath.row]
        
        switch imageRecord.state {
        case .new:
            print("CASE didEndDisplaying: ", indexPath.row, ".new")
        case .loading:
            print("CASE didEndDisplaying: ", indexPath.row, ".loading")
            imageRecord.operation?.dataTaskSuspend()
        case .downloaded:
            print("CASE didEndDisplaying: ", indexPath.row, ".downloaded")
        case .failed:
            print("CASE didEndDisplaying: ", indexPath.row, ".failed")
        case .suspend:
            print("CASE didEndDisplaying: ", indexPath.row, ".suspend")
        }
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
