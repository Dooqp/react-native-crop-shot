import { useState } from 'react';
import {
  StyleSheet,
  View,
  Text,
  Pressable,
  Dimensions,
  Image,
} from 'react-native';
import { captureScreenshot } from 'react-native-crop-shot';

const { width, height } = Dimensions.get('window');
export default function App() {
  const [result, setResult] = useState<string | undefined>();

  const takeCroppedShot = async () => {
    try {
      const base64Image = await captureScreenshot(0, 0, width, height);
      setResult(`data:image/png;base64,${base64Image}`);
    } catch (e) {
      console.log('Crop Error!!');
    }
  };
  return (
    <View style={styles.container}>
      <Pressable
        onPress={() => {
          takeCroppedShot();
        }}
        style={styles.button}
      >
        <Text>Take Cropped Shot</Text>
      </Pressable>
      {result && (
        <Image
          resizeMode="contain"
          style={styles.image}
          source={{ uri: result }}
        />
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  box: {
    width: 60,
    height: 60,
    marginVertical: 20,
  },
  button: {
    padding: 20,
    borderRadius: 10,
    borderWidth: 1,
    borderColor: 'black',
  },
  image: {
    position: 'absolute',
    bottom: 0,
    left: 0,
    width: Dimensions.get('window').width,
    height: 200,
    borderWidth: 2,
    borderColor: 'red',
  },
});
