'use strict';

var ImagePickerManager = require('NativeModules').RNImagePickerManager;

var ImagePicker = {
  SourceType: ImagePickerManager.SourceType,

  show(sourceKey, allowEditing) {
    return new Promise((resolve, reject) => {
      ImagePickerManager.showWithSourceType(sourceKey, allowEditing, (error, ret) => {
        if (error) {
          reject(error);
        } else {
          resolve(ret);
        }
      });
    });
  },
};

module.exports = ImagePicker;
