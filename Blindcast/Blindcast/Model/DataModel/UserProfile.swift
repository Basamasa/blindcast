//
//  UserProfile.swift
//  Blindcast
//
//  Created by Jan Anstipp on 09.02.20.
//  Copyright © 2020 handycap. All rights reserved.
//

import Foundation
import RealmSwift

class UserProfile: Object{
    @objc dynamic var isTutorialFinish: Bool = false
    let voice = List<VoiceSetting>()
}

class VoiceSetting: Object {
    dynamic var language = ""
    dynamic var identifier = ""
    dynamic var speed: Double = 0.5
}

extension RealmDatabase{
    
    static func fetchVoiceSetting(language: Language) -> VoiceSetting?{
        let profiles = fetchStoredObjects(obecjts: [UserProfile()])
        guard let profile = profiles.first else { return nil }
        guard let index = profile.voice.firstIndex(where: {$0.language.elementsEqual(language.rawValue)}) else { return nil }
        return profile.voice[index]
    }

    static func fetchUser() -> UserProfile?{
        let profiles = fetchStoredObjects(obecjts: [UserProfile()])
        guard let profile = profiles.first else { return nil }
        return profile
    }
    
    static func setDemo(isFinish: Bool){
        let profiles = fetchStoredObjects(obecjts: [UserProfile()])
        if let profile = profiles.first {
            profile.isTutorialFinish = isFinish
            deleteUser()
            savaRealmObjects(objects: [profile])
        }else {
           let newProfile = UserProfile()
            newProfile.isTutorialFinish = isFinish
            deleteUser()
            savaRealmObjects(objects: [newProfile])
        }
    }
    
    static func deleteUser(){
        let realm = try! Realm()
        let deletesObjects = realm.objects(UserProfile.self)
        try! realm.write {
            realm.delete(deletesObjects)
        }
    }
    
    
}

enum Language: String{
    case de = "de-DE"
    case en = "en-EN"
}
