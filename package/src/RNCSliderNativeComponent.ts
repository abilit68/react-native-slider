import type {ColorValue, HostComponent, ViewProps,ProcessedColorValue} from 'react-native';
import codegenNativeComponent from 'react-native/Libraries/Utilities/codegenNativeComponent';
//@ts-ignore
import type {ImageSource} from 'react-native/Libraries/Image/ImageSource';
import type {
  Float,
  WithDefault,
  DirectEventHandler,
  BubblingEventHandler,
} from 'react-native/Libraries/Types/CodegenTypes';

type Event = Readonly<{
  value: Float;
  fromUser?: boolean;
}>;

export interface NativeProps extends ViewProps {
  accessibilityUnits?: string;
  accessibilityIncrements?: ReadonlyArray<string>;
  disabled?: WithDefault<boolean, false>;
  inverted?: WithDefault<boolean, false>;
  vertical?: WithDefault<boolean, false>;
  tapToSeek?: WithDefault<boolean, false>;
  maximumTrackImage?: string;
  maximumTrackTintColor?: ProcessedColorValue;
  maximumValue?: Float;
  minimumTrackImage?: string;
  minimumTrackTintColor?: ProcessedColorValue;
  minimumValue?: Float;
  onChange?: BubblingEventHandler<Event>;
  onRNCSliderSlidingStart?: DirectEventHandler<Event>;
  onRNCSliderSlidingComplete?: DirectEventHandler<Event>;
  onRNCSliderValueChange?: BubblingEventHandler<Event>;
  step?: Float;
  testID?: string;
  thumbImage?: string;
  thumbTintColor?: ProcessedColorValue;
  trackImage?: string;
  value?: Float;
  lowerLimit?: Float;
  upperLimit?: Float;
}

export default codegenNativeComponent<NativeProps>(
  'RNCSlider',
) as HostComponent<NativeProps>;