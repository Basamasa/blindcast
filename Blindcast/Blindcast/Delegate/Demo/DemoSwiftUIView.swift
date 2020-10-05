//
//  DemoSwiftUIView.swift
//  Blindcast
//
//  Created by Jan Anstipp on 14.12.19.
//  Copyright © 2019 handycap. All rights reserved.
//

import SwiftUI
extension Int {
    var toString: String {
        return "\(self)"
    }
}
extension Double {
    var toString: String {
        return "\(self)"
    }
}
extension Bool {
    var toString: String {
        return "\(self)"
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        DemoPodcastView()
    }
}

struct DemoView: View{
    var body: some View{
        DemoPodcastView()
    }
}

fileprivate struct DemoPodcastView: View {
    
    @ObservedObject var model: DemoModel = DemoModel()
    @State private var pageSelection: Int = 1
    let path = RealmDatabase.getPath()
    var body: some View {
        
        TabView(selection: $pageSelection) {
            NavigationView{
                List{
                    Text("Device \(path?.device ?? "nil")")
                    Text("Aplication \(path?.apllication ?? "nil")")
                }.navigationBarTitle("Realm")
            }.tabItem({ Text("Realm") })
            NavigationView{
                List{
                    TextField("Search", text: $model.search)
                    ForEach(model.podcast){ x in
                        NavigationLink(destination: DemoDetailView(media: x)){ Text("\(x.trackName ?? "")") }
                    }
                }.navigationBarTitle("Search podcast")
            }.tabItem { Text("Podcast") }.tag(1)
            NavigationView{
                List{
                    TextField("Search Title", text: $model.searchTitle)
                    ForEach(model.podcastTitle){ x in
                        NavigationLink(destination: DemoDetailView(media: x)){ Text("\(x.trackName ?? "")") }
                    }
                }.navigationBarTitle("Search podcast by title")
            }.tabItem { Text("Title") }.tag(2)
            
            NavigationView{
                List{
                    TextField("Search genre", text: $model.searchGenre)
                    ForEach(model.podcastGenre){ x in
                        NavigationLink(destination: DemoDetailView(media: x)){ Text("\(x.trackName ?? "")") }
                    }
                }.navigationBarTitle("Search podcast by gerne")
            
            }.tabItem { Text("Genre") }.tag(3)
            NavigationView{
                List{
                    TextField("Search Author", text: $model.searchAuthor)
                    ForEach(model.podcastAuthor){ x in
                        NavigationLink(destination: DemoDetailView(media: x)){  Text("\(x.trackName ?? "")") }
                    }
                }.navigationBarTitle("Search podcast by Author")
            }.tabItem { Text("Author") }.tag(4)
        }
    }
}

fileprivate struct DemoDetailView: View{
    
    var media: Media
    var body: some View{
        
        ScrollView{
            VStack{
            Group{
                DemoItemView(value: media.wrapperType, valueTitle: "wrapperType")
                DemoItemView(value: media.kind, valueTitle: "kind")
                DemoItemView(value: media.artistID?.toString, valueTitle: "artistID")
                DemoItemView(value: media.collectionID?.toString, valueTitle: "collectionID")
                DemoItemView(value: media.trackID?.toString, valueTitle: "trackID")
                DemoItemView(value: media.artistName, valueTitle: "artistName")
                DemoItemView(value: media.collectionName, valueTitle: "collectionName")
                DemoItemView(value: media.trackName, valueTitle: "trackName")
                DemoItemView(value: media.collectionCensoredName, valueTitle: "collectionCensoredName")
                }
            Group{
                DemoItemView(value:media.trackCensoredName, valueTitle: "trackCensoredName")
                DemoUrlView(value: media.artistViewUrl, valueTitle: "artistViewUrl")
                DemoUrlView(value: media.collectionViewUrl, valueTitle: "collectionViewUrl")
                DemoUrlView(value: media.trackViewUrl, valueTitle: "trackViewUrl")
                DemoUrlView(value: media.previewUrl, valueTitle: "previewUrl")
                DemoImageLinkView(value: media.artworkUrl30, valueTitle: "artworkUrl30")
                DemoImageLinkView(value: media.artworkUrl60, valueTitle: "artworkUrl60")
                DemoImageLinkView(value: media.artworkUrl100, valueTitle: "artworkUrl100")
                DemoItemView(value: media.collectionPrice?.toString , valueTitle: "collectionPrice")
                DemoItemView(value: media.trackPrice?.toString , valueTitle: "trackPrice")
                }
            Group{
                DemoItemView(value: media.releaseDate, valueTitle: "releaseDate")
                DemoItemView(value: media.collectionExplicitness, valueTitle: "collectionExplicitness")
                DemoItemView(value: media.trackExplicitness, valueTitle: "trackExplicitness")
                DemoItemView(value: media.discCount?.toString, valueTitle: "discCount")
                DemoItemView(value: media.discNumber?.toString, valueTitle: "discNumber")
                DemoItemView(value: media.trackCount?.toString, valueTitle: "trackCount")
                DemoItemView(value: media.trackNumber?.toString, valueTitle: "trackNumber")
                DemoItemView(value: media.trackTimeMillis?.toString, valueTitle: "trackTimeMillis")
                DemoItemView(value: media.country, valueTitle: "country")
                DemoItemView(value: media.currency, valueTitle: "currency")
            }
            Group{
                DemoItemView(value: media.primaryGenreName, valueTitle: "primaryGenreName")
                DemoItemView(value: media.isStreamable?.toString, valueTitle: "isStreamable")
                DemoItemView(value: media.collectionHDPrice?.toString, valueTitle: "collectionHDPrice")
                DemoItemView(value: media.trackHDPrice?.toString, valueTitle: "trackHDPrice")
                DemoItemView(value: media.contentAdvisoryRating, valueTitle: "contentAdvisoryRating")
                DemoItemView(value: media.shortDescription, valueTitle: "shortDescription")
                DemoItemView(value: media.longDescription, valueTitle: "longDescription")
                DemoItemView(value: media.collectionArtistName, valueTitle: "collectionArtistName")
                DemoItemView(value: media.collectionArtistID?.toString, valueTitle: "collectionArtistID")
                DemoUrlView(value: media.collectionArtistViewURL , valueTitle: "collectionArtistViewUR")
                }
            }
        }
    }
}

fileprivate struct DemoItemView: View{
    var value: String?
    var valueTitle: String
    var body: some View{
        HStack{
            Text(valueTitle)
            Spacer()
            Text(value ?? "nil").lineLimit(1)
        }.padding(.bottom,10)
    }
}

fileprivate struct DemoUrlView: View{
    var value: String?
    var valueTitle: String
    var body: some View {
        DemoItemView(value: value ?? "nil", valueTitle: valueTitle)
            .onTapGesture {
                guard let value = self.value, let url = URL(string: value) else { return }
                print("<Open \(url)>")
                UIApplication.shared.open(url)
        }
    }
}

fileprivate struct DemoImageLinkView: View{
    var value: String?
    var valueTitle: String
    var body: some View{
        NavigationLink(destination: DemoURLImage(url: value)){
            DemoItemView(value: value ?? "nil", valueTitle: valueTitle)
        }
    }
}

fileprivate struct DemoURLImage : View {
    var url: String?
    @ObservedObject var imageLoader: DemoImageLoader = DemoImageLoader()
    
    var body: some View {
        imageLoader.image.onTapGesture {
            if let url = self.url{
                self.imageLoader.load(url: url)
                print("<Succes Ta Gesture Image> \(url)")
            }else {
                print("<Fail nil URL link>")
            }
            
        }
    }
}

fileprivate class DemoImageLoader : ObservableObject {
    
    @Published var image: Image? = Image(systemName: "photo")
    
    func load(url: String){
        if let imageUrl = URL(string: url){
            ITunesSearchAPI.fetchImage(url: imageUrl){ uiImage in
                DispatchQueue.main.async {
                    self.image = Image(uiImage: uiImage)
                }
            }
        }
        
    }
    
}



//
//wrapperType
//kind
//artistID
//collectionID
//trackID
//artistName
//collectionName
//trackName
//collectionCensoredName
//trackCensoredName
//artistViewUrl
//collectionViewUrl
//trackViewUrl
//previewUrl
//artworkUrl30
//artworkUrl60
//artworkUrl100
//collectionPrice
//trackPrice
//releaseDate
//collectionExplicitness
//trackExplicitness
//discCount
//discNumber
//trackCount
//trackNumber
//trackTimeMillis
//country
//currency
//primaryGenreName
//isStreamable
//collectionHDPrice
//trackHDPrice
//contentAdvisoryRating
//shortDescription
//longDescription
//collectionArtistName
//collectionArtistID
//collectionArtistViewURL
