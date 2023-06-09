//
//  AddNovelViewModel.swift
//  UserApp
//
//  Created by William Yulio on 08/06/23.
//

import Foundation
import SwiftUI

class AddNovelViewModel: ObservableObject {
    @Published var fetchedGenreData: [Genres] = []
    @Published var imageData: String = ""
//    @Published var isSuccess = false
    
    init(){
        self.fetchGenreData()
    }
    
    func uploadImage(_ image: UIImage, title: String, desc: String, genre: [Int]) {
        guard let url = URL(string: "https://interview.klaklik.com/store-image") else {
            return
        }
        
        var imageData = image.jpegData(compressionQuality: 0.8)!
        
        let boundary = "Boundary-\(UUID().uuidString)"
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField:"Content-Type")
        request.setValue("interviewtoken", forHTTPHeaderField: "APPTOKEN")
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        
        let body = NSMutableData()
        
        body.appendString("--\(boundary)\r\n")
        body.appendString("Content-Disposition: form-data; name=\"thumbnail\"; filename=\"thumbnail.jpg\"\r\n")
        body.appendString("Content-Type: image/jpeg\r\n\r\n")
        body.append(imageData)
        body.appendString("\r\n")
        body.appendString("--\(boundary)--\r\n")
        
        request.httpBody = body as Data
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            // Handle response
            print(response)
            if error == nil, let data = data, let response = response as? HTTPURLResponse {
                let jsonData = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)

                let decoder = JSONDecoder()
                do {
                    let dataImage = try decoder.decode(UploadResponse.self, from: data)
                    // Now you have the decoded person object
                    if response.statusCode == 200{
                        self.uploadNewNovel(title: title, desc: desc, images_novel: dataImage.data, genre: genre)
                    }
//                    print(dataImage)
                } catch {
                    print("Error decoding JSON: \(error.localizedDescription)")
                }
                
//                if let json = jsonData as? [String: Any] {
//                    print(json)
//                }
                
//                print(String(data: data, encoding: .utf8))
                
            }
        }.resume()
    }
    
    
    func fetchGenreData() {
        
        
        guard let url = URL(string: "https://interview.klaklik.com/genre-list") else { return }
        var request = URLRequest(url: url)

        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField:"Content-Type")
        request.setValue("interviewtoken", forHTTPHeaderField: "APPTOKEN")

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest) { data, response, error in

            guard let data = data, error == nil else {
                print("Error when try to get the data")
                return
            }

            do {
                let result = try JSONDecoder().decode(RealGenre.self, from: data)
                
                DispatchQueue.main.async {
                    if self.fetchedGenreData.isEmpty{
                        self.fetchedGenreData = result.data
//                        print(self.fetchedGenreData)
//                        print(result.status)
                    }
                }
//                completionHandler(result)
            } catch {
                print("ERROR \(error)")
            }

            //        })
        }


        dataTask.resume()
    }
    
    func uploadNewNovel(title: String, desc: String, images_novel: String, genre: [Int]) {
        
        guard let url = URL(string: "https://interview.klaklik.com/add-novel") else { return }
        var request = URLRequest(url: url)
        
        let data = [
            "title": title,
            "desc": desc,
            "images_novel": images_novel,
            "genre": genre
        ] as [String : Any]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: data) else {
            print("Error serializing data")
            return
        }
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField:"Content-Type")
        request.setValue("interviewtoken", forHTTPHeaderField: "APPTOKEN")
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            print("-----> data: \(data)")
            print("-----> error: \(error)")
            
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            
//            if let response = response as? HTTPURLResponse{
//                if response.statusCode == 201{
//                    DispatchQueue.main.async {
//                        self.isSuccess = true
//                    }
//                }
//            }
            
            
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            print("-----1> responseJSON: \(responseJSON)")
            if let responseJSON = responseJSON as? [String: Any] {
                print("-----2> responseJSON: \(responseJSON)")
            }
        }
        
        task.resume()
    }

}
