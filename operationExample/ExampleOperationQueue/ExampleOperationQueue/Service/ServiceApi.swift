//
//  ServiceApi.swift
//  ExampleOperationQueue
//
//  Created by Anatoliy on 04.07.2022.
//

import Foundation

final class ServiceApi {

    func loadJson(complition: @escaping ([ImageRecord])->()) {
        guard
            let url = Bundle.main.url(forResource: "manyImages", withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let collection = try? JSONDecoder().decode([ImageRecord].self, from: data)
        else { return }
        complition(collection)
    }
}
