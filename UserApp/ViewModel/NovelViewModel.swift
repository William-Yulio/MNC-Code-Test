//
//  NovelViewModel.swift
//  UserApp
//
//  Created by William Yulio on 07/06/23.
//

import SwiftUI
import Combine

class NovelViewModel: ObservableObject {
    @Published var fetchedNovelData: [Novel] = []
    @Published var fetchedGenreData: [Genres] = []
    @Published var isRequestFailed = false
    
    private var limit: Int = 5
    private var offset: Int = 0
    
    var pageStatus = PageStatus.ready(nextPage: 0)
    @Published var endOfList = false
    
    var cancellable : Set<AnyCancellable> = Set()
    
    init(){
        getNovel()
        fetchGenreData()
    }
    
    func shouldLoadMore(novel : Novel) -> Bool{
            
        if let lastId = fetchedNovelData.last?.id{
                if novel.id == lastId{
                    return true
                }
                else{
                    return false
                }
            }
            
            return false
        }
    
    func getNovels(limit: Int = 5, offset: Int = 0) -> AnyPublisher<ListNovel, Error> {
        // 2
        let url = URL(string: "https://interview.klaklik.com/my-list-novel")
        var request = URLRequest(url: url!)
        let parameters: [String: Any] = ["limit": limit, "offset": offset]
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField:"Content-Type")
        request.setValue("interviewtoken", forHTTPHeaderField: "APPTOKEN")
        
        do {
            // convert parameters to Data and assign dictionary to httpBody of request
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
          } catch let error {
            print(error.localizedDescription)
          }
        // 4
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: ListNovel.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func getNovel() {
            // 3
        guard case let .ready(page) = pageStatus else { return }
        pageStatus = .loading(page: page)
        
        getNovels(limit: limit,offset: page)
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    switch completion {
                    case .failure(let error):
                        // 4
//                        self.isRequestFailed = true
                        self.endOfList = true
                        self.pageStatus = .done
                        print(error)
                    case .finished:
                        print("finished")
                        break

                    }
                } receiveValue: { novel in
                    // 5
                    if novel.data.count == 0{
                        self.pageStatus = .done
                    }else{
                        self.pageStatus = .ready(nextPage: page + 5)
                        self.fetchedNovelData.append(contentsOf: novel.data)
                        print(novel.data)
//                        self.offset += 5
                        
                    }
                }
                .store(in: &cancellable)
            
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
                        print(self.fetchedGenreData)
                        print(result.status)
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
    
}
