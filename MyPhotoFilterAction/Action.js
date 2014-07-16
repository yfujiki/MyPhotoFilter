//
//  Action.js
//  MyPhotoFilterAction
//
//  Created by Yuichi Fujiki on 7/16/14.
//  Copyright (c) 2014 Yuichi Fujiki. All rights reserved.
//

var Action = function() {};

Action.prototype = {
    run: function(arguments) {
        var imageUrl = document.body.children[0].getAttribute("src")
        arguments.completionFunction({ "imageURL" : imageUrl})
    },

    finalize: function(arguments) {
        var newImageURL = arguments["encodedImageURL"]
        var oldImg = document.body.children[0]
        var newImg = document.createElement('img')
        newImg.src = newImageURL
        document.body.replaceChild(newImg, oldImg)
    }
};

var ExtensionPreprocessingJS = new Action
