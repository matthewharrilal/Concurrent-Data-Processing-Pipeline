//
//  NetworkService.swift
//  Concurrency-Data-Processing-Pipeline
//
//  Created by Space Wizard on 9/6/24.
//

import Foundation
import UIKit

protocol NetworkProtocol {
    func downloadImage(for url: URL) async throws -> UIImage
}

class NetworkService: NetworkProtocol {
    
    enum NetworkError: Error {
        case invalidData
        case downloadError
    }
    
    func downloadImage(for url: URL) async throws -> UIImage {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let image = UIImage(data: data) else {
                throw NetworkError.invalidData
            }
            
            return image
        }
        catch {
            throw NetworkError.downloadError
        }
    }
}
