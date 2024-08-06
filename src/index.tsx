import { NativeModules, Platform } from 'react-native';

const LINKING_ERROR =
  `The package 'react-native-crop-shot' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo Go\n';

const CropShot = NativeModules.CropShot
  ? NativeModules.CropShot
  : new Proxy(
      {},
      {
        get() {
          throw new Error(LINKING_ERROR);
        },
      }
    );

export function captureScreenshot(
  x: number,
  y: number,
  width: number,
  height: number
): Promise<number> {
  return CropShot.captureScreenshot(x, y, width, height);
}

export function captureScreenshotWithRef(reactRef: number): Promise<number> {
  return CropShot.captureScreenshotWithRef(reactRef);
}
