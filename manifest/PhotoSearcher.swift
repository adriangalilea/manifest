//
//  PhotoSearcher.swift
//  manifest
//
//  Created by Adrian on 29/5/23.
//

import Foundation
import AppKit

struct UnsplashResponse: Codable {
    struct Result: Codable {
        struct Urls: Codable {
            let raw: String
            let full: String
            let regular: String
            let small: String
            let thumb: String
        }
        
        let id: String
        let urls: Urls
    }
    
    let total: Int
    let total_pages: Int
    let results: [Result]
}

class PhotoSearcher: ObservableObject {
    // Define a typealias for the completion handler
    typealias ImageLoadingCompletion = (Bool) -> Void
    
    @Published var isImageLoaded = false
    
    func searchAndLoadPhoto(query: String, completion: @escaping ImageLoadingCompletion) {
        let apiKey = "your_api_key"
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://api.unsplash.com/search/photos?page=1&query=\(encodedQuery)&client_id=\(apiKey)"
        guard let url = URL(string: urlString) else {
            print("Invalid URL: \(urlString)")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print("Failed to fetch data: \(error)")
                return
            }
            
            guard let data = data else {
                print("No data returned")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(UnsplashResponse.self, from: data)
                
                if let firstPhoto = response.results.first {
                    if let imageURL = URL(string: firstPhoto.urls.full) {
                        self.loadImageIntoClipboard(from: imageURL) { isLoaded in
                            DispatchQueue.main.async {
                                self.isImageLoaded = isLoaded
                                completion(isLoaded)
                            }
                        }
                    } else {
                        print("Invalid image URL")
                    }
                } else {
                    print("No photos found for query")
                }
            } catch {
                print("Failed to decode data: \(error)")
            }
        }
        task.resume()
    }
    
    private func loadImageIntoClipboard(from url: URL, completion: @escaping ImageLoadingCompletion) {
        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print("Failed to download image: \(error)")
                return
            }
            
            guard let data = data else {
                print("No image data returned")
                return
            }
            
            if let image = NSImage(data: data) {
                DispatchQueue.main.async {
                    let pasteboard = NSPasteboard.general
                    pasteboard.clearContents()
                    pasteboard.writeObjects([image])
                    print("Image loaded into clipboard")
                    completion(true)
                }
            } else {
                print("Failed to create image from data")
                completion(false)
            }
        }
        task.resume()
    }
}
