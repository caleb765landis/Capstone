//
//  URLImage.swift
//  Collectathon
//
//  Created by Caleb Landis on 4/27/23.
//

import SwiftUI

struct URLImage: View {
    let urlString: String
    
    @State var data: Data?
    
    var body: some View {
        ZStack {
            if let data = data, let uiimage = UIImage(data: data) {
                Image(uiImage: uiimage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .background(Color.gray)
                    .frame(maxWidth: 100)
            } else {
                Image("")
                    .resizable()
                //                .aspectRatio(contentMode: .fill)
                    .background(Color.gray)
                    .frame(maxWidth: 100, maxHeight: 130)
                    .onAppear {
                        fetchData()
                    }
            } // end if
        } // end ZStack
        .onAppear {
            fetchData()
        }
    } // end Body
    
    private func fetchData() {
        guard let url = URL(string: urlString) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            self.data = data
        }
        task.resume()
    }
    
} // end URLImage View

struct URLImage_Previews: PreviewProvider {
    static var previews: some View {
        URLImage(urlString: "//images.igdb.com/igdb/image/upload/t_thumb/co2r2r.jpg")
    }
}
