//
//  TableViewCell.swift
//  ExampleOperationQueue
//
//  Created by Anatoliy on 04.07.2022.
//

import Foundation
import UIKit

final class TableViewCell: UITableViewCell {
    
    lazy var imageViewOne: UIImageView = {
        let imag = UIImage(named: "cat.jpeg")
        let imageView = UIImageView(image: imag)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    lazy var labelOne: UILabel = {
        let nameLabel = UILabel()
        nameLabel.text = "labelOne"
        nameLabel.textColor = .white
        nameLabel.font = UIFont(name: "Helvetica Neue", size: 15)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        return nameLabel
    }()
    
    private let stackViewOne: UIStackView = {
       let stackViewImage = UIStackView()
        stackViewImage.axis = .vertical
        stackViewImage.distribution = .fill
        stackViewImage.spacing = 4
        stackViewImage.translatesAutoresizingMaskIntoConstraints = false
        return stackViewImage
    }()
    
    lazy var imageViewTwo: UIImageView = {
        let imag = UIImage(named: "cat.jpeg")
        let imageView = UIImageView(image: imag)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    lazy var lableTwo: UILabel = {
        let nameLabel = UILabel()
        nameLabel.text = "lableTwo"
        nameLabel.textColor = .white
        nameLabel.font = UIFont(name: "Helvetica Neue", size: 15)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        return nameLabel
    }()
    private let stackViewTwo: UIStackView = {
       let stackViewImage = UIStackView()
        stackViewImage.axis = .vertical
        stackViewImage.distribution = .fill
        stackViewImage.spacing = 4
        stackViewImage.translatesAutoresizingMaskIntoConstraints = false
        return stackViewImage
    }()
    
    lazy var imageViewThree: UIImageView = {
        let imag = UIImage(named: "cat.jpeg")
        let imageView = UIImageView(image: imag)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    lazy var labelThree: UILabel = {
        let nameLabel = UILabel()
        nameLabel.text = "labelThree"
        nameLabel.textColor = .white
        nameLabel.font = UIFont(name: "Helvetica Neue", size: 15)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        return nameLabel
    }()
    
    private let stackViewThree: UIStackView = {
       let stackViewImage = UIStackView()
        stackViewImage.axis = .vertical
        stackViewImage.distribution = .fill
        stackViewImage.spacing = 4
        stackViewImage.translatesAutoresizingMaskIntoConstraints = false
        return stackViewImage
    }()
    
    private let stackViewMain: UIStackView = {
       let stackViewImage = UIStackView()
        stackViewImage.axis = .horizontal
        stackViewImage.distribution = .fillEqually
        stackViewImage.spacing = 4
        stackViewImage.translatesAutoresizingMaskIntoConstraints = false
        return stackViewImage
    }()
    
    override func prepareForReuse() {
        labelOne.text = nil
        lableTwo.text = nil
        labelThree.text = nil
        imageViewOne.image = nil
        imageViewTwo.image = nil
        imageViewThree.image = nil
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



private extension TableViewCell {
    func addStackView() {
        stackViewOne.addArrangedSubview(imageViewOne)
        stackViewOne.addArrangedSubview(labelOne)
        stackViewTwo.addArrangedSubview(imageViewTwo)
        stackViewTwo.addArrangedSubview(lableTwo)
        stackViewThree.addArrangedSubview(imageViewThree)
        stackViewThree.addArrangedSubview(labelThree)
        stackViewMain.addArrangedSubview(stackViewOne)
        stackViewMain.addArrangedSubview(stackViewTwo)
        stackViewMain.addArrangedSubview(stackViewThree)
        
    }
    
    func setupView() {
        addStackView()
        contentView.addSubview(stackViewMain)
        contentView.backgroundColor = .darkGray
        contentView.layer.cornerRadius = 10
        setupConstraints()
        imageConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            
            stackViewMain.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stackViewMain.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            stackViewMain.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8),
            stackViewMain.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8)
        ])
    }
    func imageConstraints() {
        NSLayoutConstraint.activate([
            imageViewOne.heightAnchor.constraint(equalToConstant: 50),
            imageViewOne.widthAnchor.constraint(equalToConstant: 50),
            imageViewTwo.heightAnchor.constraint(equalToConstant: 50),
            imageViewTwo.widthAnchor.constraint(equalToConstant: 50),
            imageViewThree.heightAnchor.constraint(equalToConstant: 50),
            imageViewThree.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
}
