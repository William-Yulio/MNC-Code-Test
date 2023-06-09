//
//  ViewModel.swift
//  UserApp
//
//  Created by William Yulio on 06/06/23.
//

import SwiftUI

class ViewModel: ObservableObject {
    @Published var fetchedUserData: [Datum] = []
    @Published var calculatedData: [CalculatedAgeData] = []
    var a = 0
    var b = 0
    var c = 0
    var d = 0
    var maxAge = 0
    
    func fetchUserData() {
        
        
        guard let url = URL(string: "https://interview.klaklik.com/data-member") else { return }
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
                let result = try JSONDecoder().decode(User.self, from: data)
                DispatchQueue.main.async {
                    if self.fetchedUserData.isEmpty{
                        self.fetchedUserData = result.data
                        self.calculateAge()
//                        print(self.fetchedUserData)
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
    
    func calculateAge(){
        let todayDate = Date()
        let calendar = Calendar.current
        
        for data in fetchedUserData {

            var dob = data.dob.getDate(format: "yyyy-MM-dd")
            let components = calendar.dateComponents([.year, .month, .day], from: dob, to: todayDate)
            let ageYears = components.year
            
            if 0 ... 10 ~= ageYears ?? 0{
                a+=1
            }
            else if 11 ... 20 ~= ageYears ?? 0{
                b+=1
            }
            else if 21 ... 30 ~= ageYears ?? 0{
                c+=1
            }
            else{
                d+=1
            }

            let temp = CalculatedAgeData(dob: data.dob, firstName: data.firstName, lastName: data.lastName, memberID: data.memberID, age: ageYears ?? 0)
            
            self.calculatedData.append(temp)
//            print(calculatedData)
        }
        
        maxAge = calculatedData.max { $0.age < $1.age }?.age ?? 0
        
        
    }
    
}


    


