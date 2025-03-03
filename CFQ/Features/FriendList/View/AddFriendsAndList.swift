//
//  AddFriendsAndList.swift
//  CFQ
//
//  Created by Calvignac Charles on 05/02/2025.
//

import SwiftUI

struct Bazar: View {
    var arrayPicture = [CirclePicture(), CirclePicture(), CirclePicture(), CirclePicture(), CirclePicture(), CirclePicture(), CirclePicture(), CirclePicture()]

    var arrayFriends = [CellFriendsAdd(), CellFriendsAdd(), CellFriendsAdd(), CellFriendsAdd(), CellFriendsAdd(), CellFriendsAdd(), CellFriendsAdd(), CellFriendsAdd()]
    
    var body: some View {
        // Recherche bar
        VStack(alignment: .leading) {
            HStack {
                Text("Invités")
                    .foregroundColor(.white)
                Text("(\(arrayPicture.count))")
                    .foregroundColor(.white)
            }.padding(.horizontal, 16)
            
            VStack(alignment: .leading) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack() {
                        ForEach(arrayPicture.indices, id: \.self) { index in
                            ZStack {
                                arrayPicture[index]
                                    .frame(width: 48, height: 48)
                                    .padding(.leading, 17)
                                Button(action: {
                                    print("Bouton fermé")
                                }) {
                                    Image(systemName: "xmark")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 8, height: 8)
                                        .foregroundColor(.black)
                                        .padding(6)
                                        .background(Color.white)
                                        .clipShape(Circle())
                                }
                                .offset(x: 35, y: -20)
                            }.frame(height: 100)
                        }
                    }
                }
            }
            Divider()
                .background(.white)
            
            VStack {
                ScrollView(.vertical) {
                    ForEach(arrayPicture.indices, id: \.self) { index in
                        ZStack {
                            arrayFriends[index]
                                .padding(.top, 30)
                        }
                    }
                }
            }
        }
    }
}


#Preview {
    ZStack {
        NeonBackgroundImage()
        Bazar()
    }.ignoresSafeArea()
}
