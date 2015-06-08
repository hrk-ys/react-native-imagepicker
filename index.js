'use strict';

var ImagePickerManager = require('NativeModules').RNImagePickerManager;

var ImagePicker = {
  show(sourceKey) {
    console.log("ImagePicker index.js show");
    return new Promise((resolve, reject) => {
      console.log("ImagePicker index.js promise func");
      ImagePickerManager.showWithSourceType(sourceKey, (error, ret) => {
        if (error) {
          console.log("ImagePicker index.js promise error");
          reject(error);
        } else {
          console.log("ImagePicker index.js promise resolve");
          resolve(ret);
        }
      });
    });
  },
};

module.exports = ImagePicker;
