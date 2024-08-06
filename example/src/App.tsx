import { useRef, useState } from 'react';
import {
  StyleSheet,
  View,
  Text,
  Pressable,
  Dimensions,
  Image,
  findNodeHandle,
  SafeAreaView,
  StatusBar,
} from 'react-native';
import {
  captureScreenshot,
  captureScreenshotWithRef,
} from 'react-native-crop-shot';

const { width, height } = Dimensions.get('window');
export default function App() {
  const [result, setResult] = useState<string | undefined>();
  const screenShotRef = useRef(null);
  const takeCroppedShot = async () => {
    try {
      const base64Image = await captureScreenshot(0, 0, width, height);
      // const base64Image = await captureScreenshot(0, 0, width, 300);
      setResult(`data:image/png;base64,${base64Image}`);
    } catch (e) {
      console.log('Crop Error!!');
    }
  };
  const takeCroppedShotWithRef = async (ref) => {
    try {
      const nodeHandle = findNodeHandle(ref.current);
      if (!nodeHandle) return;
      const base64Image = await captureScreenshotWithRef(nodeHandle);
      setResult(`data:image/png;base64,${base64Image}`);
    } catch (e) {
      console.log('Ref Crop Error!!', e);
    }
  };
  return (
    <>
      {/* <View style={{ width: width, height: 150 }} /> */}
      <SafeAreaView style={styles.container}>
        <StatusBar barStyle={'dark-content'} translucent={true} backgroundColor={'transparent'} />

        <Pressable
          onPress={() => {
            takeCroppedShot();
          }}
          style={styles.button}
        >
          <Text>Take Cropped Shot</Text>
        </Pressable>
        <Pressable
          onPress={() => {
            if (!screenShotRef) return;
            console.log('Pressed');
            takeCroppedShotWithRef(screenShotRef);
          }}
          style={styles.button}
        >
          <Text>Take Cropped Shot With Ref</Text>
        </Pressable>
        {/* <View
        style={{
          width: '100%',
          height: 200,
          backgroundColor: 'purple',
          marginBottom: 20,
        }}
      /> */}
        <View style={{ position: 'absolute', top: 0 }}>
          <View
            pointerEvents="none"
            ref={screenShotRef}
            style={styles.refContainer}
          ></View>
        </View>
        {result && (
          <Image
            resizeMode="contain"
            style={styles.image}
            source={{ uri: result }}
          />
        )}
      </SafeAreaView>
    </>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'space-between',
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
    // left: 0,
    width: Dimensions.get('window').width,
    height: 200,
    borderWidth: 1,
    borderColor: 'red',
    backgroundColor: 'pink',
  },
  refContainer: {
    // position: 'absolute',
    // top: 300,
    width: Dimensions.get('window').width,
    height: 300,
    borderColor: 'purple',
    borderWidth: 1,
  },
  refInnerContainer: {
    width: '50%',
    height: '50%',
  },
  scrollViewItem: {
    width: '100%',
    height: 50,
    justifyContent: 'center',
    alignItems: 'center',
    borderWidth: 0.5,
  },
});
