/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 */
'use strict';

var React = require('react-native');
var {
  AppRegistry,
  Image,
  StyleSheet,
  Text,
  View,
  DeviceEventEmitter,
} = React;


var ImagePicker = require('react-native-imagepicker');

var ImagePickerExample = React.createClass({

  getInitialState() {
    return { image: null };
  },



  showImagePicker(srcType) {
    var self = this;

    ImagePicker.show(srcType, false)
      .then( (image) => {

        console.log('success:' + image);
        if (image) {
          self.setState({ image: { uri: image }});
        }

      }).catch( (error) => {

        console.log('error:' + error);

      });

  },
  render: function() {
    var imageView = this.state.image ? (
      <Image
        source={ this.state.image }
        style={{ height: 100, width: 100}}
        />
    ) : <View />;

    return (
      <View style={styles.container}>
        <Text onPress={() => this.showImagePicker(ImagePicker.SourceType.PhotoLibrary)}>
          画像を選択(PhotoLibrary)
        </Text>
        <Text onPress={() => this.showImagePicker(ImagePicker.SourceType.Camera)}>
          画像を選択(Camera)
        </Text>
        <Text onPress={() => this.showImagePicker(ImagePicker.SourceType.SavedPhotosAlbum)}>
          画像を選択(SavedPhotosAlbum)
        </Text>
        { imageView }
      </View>
    );
  }
});

var styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },
  welcome: {
    fontSize: 20,
    textAlign: 'center',
    margin: 10,
  },
  instructions: {
    textAlign: 'center',
    color: '#333333',
    marginBottom: 5,
  },
});

AppRegistry.registerComponent('ImagePickerExample', () => ImagePickerExample);
