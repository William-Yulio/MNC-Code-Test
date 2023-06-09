//
//  ListNovelView.swift
//  UserApp
//
//  Created by William Yulio on 07/06/23.
//

import SwiftUI

struct ListNovelView: View {
    @StateObject var NovelVM = NovelViewModel()
    var body: some View {
        NavigationView{
            List(){
                ForEach(NovelVM.fetchedNovelData, id: \.id){ data in
                    HStack(){
                        if data.imagesNovel != ""{
                            AsyncImage(url: URL(string: data.imagesNovel ?? "")!,
                                       placeholder: { Text("Loading ...") },
                                       image: { Image(uiImage: $0).resizable() })
                            .frame(width: 120, height: 120 )
                            .cornerRadius(15)
                        }else{
                            Image(uiImage: UIImage(named: "imageNotAvail")!)
                                .resizable()
                                .frame(width: 120, height: 120)
                                .cornerRadius(15)
                        }
                        
                        Spacer()
                        
                        VStack(){
                            Text(data.title)
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            
                            ForEach(NovelVM.fetchedGenreData, id: \.id){ realGenre in
                                if ((data.genres?.firstIndex(where: { $0.id == realGenre.id})) != nil){
                                    Text(realGenre.name)
                                        .font(.subheadline)
                                    
                                }
                            }
                        }
                    }
                    
                    
                    .onAppear(){
                        if !self.NovelVM.endOfList{
                            if self.NovelVM.shouldLoadMore(novel : data){
                                self.NovelVM.getNovel()
                            }
                        }
                    }
                }
                
                .alert(isPresented: $NovelVM.endOfList) {
                    Alert(title: Text("No more data to load"), message: Text("You have reached the last data"), dismissButton: .default(Text("OK")))
                }
            }
            .navigationTitle("List All Novel")
        }
    }
}
