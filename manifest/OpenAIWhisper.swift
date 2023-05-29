//
//  OpenAIWhisper.swift
//  manifest
//
//  Created by Adrian on 28/5/23.
//

import Foundation

enum TranscriptionError: Error {
    case invalidResponse
}

class OpenAIWhisper {
    private let apiKey = "your_api_key"
    
    func translate(fileURL: URL, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: "https://api.openai.com/v1/audio/translations") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("multipart/form-data", forHTTPHeaderField: "Content-Type")

        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var data = Data()
        data.append("--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"model\"\r\n\r\n".data(using: .utf8)!)
        data.append("whisper-1".data(using: .utf8)!)

        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(fileURL.lastPathComponent)\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: audio/mpeg\r\n\r\n".data(using: .utf8)!)

        do {
            let audioData = try Data(contentsOf: fileURL)
            data.append(audioData)
            data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        } catch {
            print("Could not read audio file")
            return
        }

        let task = URLSession.shared.uploadTask(with: request, from: data) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                do {
                    if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        print("JSON Response: \(jsonResponse)")
                        
                        if let transcription = jsonResponse["text"] as? String {
                            completion(.success(transcription))
                        } else {
                            completion(.failure(TranscriptionError.invalidResponse))
                        }
                    } else {
                        completion(.failure(TranscriptionError.invalidResponse))
                    }
                } catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }

    
    func transcribe(fileURL: URL, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: "https://api.openai.com/v1/audio/transcriptions") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("multipart/form-data", forHTTPHeaderField: "Content-Type")

        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var data = Data()
        data.append("--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"model\"\r\n\r\n".data(using: .utf8)!)
        data.append("whisper-1".data(using: .utf8)!)
        
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(fileURL.lastPathComponent)\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: audio/mpeg\r\n\r\n".data(using: .utf8)!)

        do {
            let audioData = try Data(contentsOf: fileURL)
            data.append(audioData)
            data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        } catch {
            print("Could not read audio file")
            return
        }

        let task = URLSession.shared.uploadTask(with: request, from: data) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                do {
                    if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        print("JSON Response: \(jsonResponse)")
                        
                        if let transcription = jsonResponse["text"] as? String {
                            completion(.success(transcription))
                        } else {
                            completion(.failure(TranscriptionError.invalidResponse))
                        }
                    } else {
                        completion(.failure(TranscriptionError.invalidResponse))
                    }
                } catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()

    }
}
