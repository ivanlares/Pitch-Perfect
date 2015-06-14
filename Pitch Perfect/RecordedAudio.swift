//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by ivan lares on 11/26/14.
//  Copyright (c) 2014 ivan. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject{
    var filePathUrl:NSURL
    var title: String
    
    init(filePathUrl:NSURL, title: String){
        self.filePathUrl = filePathUrl
        self.title = title
        
        super.init()

    }
}