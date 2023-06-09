//
//  AddNovelView.swift
//  UserApp
//
//  Created by William Yulio on 08/06/23.
//

import SwiftUI
import PhotosUI

struct AddNovelView: View {
    @StateObject var addNovelVM = AddNovelViewModel()
    @State var selectedItems: [PhotosPickerItem] = []
    @State var data: Data?
    @State var selections: [Int] = []
    @State var title: String = ""
    @State var desc: String = ""
    var body: some View {
        NavigationView{
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 15){
                    PhotosPicker(selection: $selectedItems, maxSelectionCount: 1, matching: .images) {
                        
                        if let data = data, let image = UIImage(data: data){
                            Image(uiImage: image)
                                .resizable()
                                .frame(width: 200, height: 200)
                                .clipShape(Circle())
                        } else {
                            Image("imageNotAvail")
                                .resizable()
                                .frame(width: 200, height: 200)
                                .clipShape(Circle())
                        }
                        
                    }.onChange(of: selectedItems) { newValue in
                        guard let item = selectedItems.first else { return }
                        item.loadTransferable(type: Data.self) { result in
                            switch result {
                            case .success (let data):
                                if let data = data {
                                    self.data = data
                                    
                                }
                            case .failure (_):
                                return
                            }
                            
                        }
                    }
                    
                    Group {
                        
                        Text("Novel Title")
                            .fontWeight(.semibold)
                            .font(.system(size: 24))
                            .foregroundColor(.black)
                            .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                            .frame(maxWidth:.infinity, alignment: .leading)
                        
                        TextField("Novel Title", text: $title )
                            .padding(.leading)
                            .frame(width: 360, height: 58)
                            .foregroundColor(.black)
                            .background(Color.gray)
                            .cornerRadius(20)
                            .accentColor(.blue)
                    }
                    
                    Group {
                        
                        Text("Novel Description")
                            .fontWeight(.semibold)
                            .font(.system(size: 24))
                            .foregroundColor(.black)
                            .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                            .frame(maxWidth:.infinity, alignment: .leading)
                        
                        TextField("Novel Description", text: $desc )
                            .padding(.leading)
                            .frame(width: 360, height: 58)
                            .foregroundColor(.black)
                            .background(Color.gray)
                            .cornerRadius(20)
                            .accentColor(.blue)
                    }
                    
                    
                    Text("Genres")
                        .fontWeight(.semibold)
                        .font(.system(size: 24))
                        .foregroundColor(.black)
                        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                        .frame(maxWidth:.infinity, alignment: .leading)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            ForEach(addNovelVM.fetchedGenreData, id: \.id) { genre in
                                MultipleSelectionRowView(image: genre.images, isSelected: self.selections.contains(genre.id)) {
                                    if self.selections.contains(genre.id) {
                                        self.selections.removeAll(where: { $0 == genre.id })
                                    }
                                    else {
                                        self.selections.append(genre.id)
                                    }
                                }
                                .padding(.top)
                                .padding(.bottom)
                            }
                        }
                    }
                    
                    Button {
                        addNovelVM.uploadImage(UIImage(data: data!)!, title: title, desc: desc, genre: selections)
                        
                    } label: {
                        Text("Done")
                            .font(.system(size: 24))
                            .fontWeight(.semibold)
                            .frame(width: 360, height: 58)
                            .foregroundColor(.black)
                            .background(Color.green)
                            .cornerRadius(20)
                    }
//                    .alert(isPresented: $addNovelVM.isSuccess) {
//                        Alert(title: Text("Upload is success"), message: Text("You have upload new novel"), dismissButton: .default(Text("OK")))
//                    }
                }
                
            }
            .navigationTitle("Add New Novel")
        }
    }
}

