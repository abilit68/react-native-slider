/**
 * MIT License
 *
 * Copyright (C) 2023 Huawei Device Co., Ltd.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

import {
  Descriptor,
  RNOHContext,
  ViewBaseProps,
  RNViewBase,
  ColorSegments,
  ViewRawProps,
  RNComponentContext,
  RNOHLogger
} from '@rnoh/react-native-openharmony'
import { SliderDescriptorWrapper } from './SliderDescriptorWrapper'
import { RNC } from './generated/ts'
// import Logger from './Logger'

// const TAG: string = "[RNOH] RNCSlider"
//
// export const SLIDER_TYPE: string = "RNCSlider"

const DEFAULT_LIMIT_VALUE = -9007199254740991;
const DEFAULT_MAX_VALUE = 9007199254740991;
const LIMIT_MIN_VALUE = Number.MIN_VALUE;
const LIMIT_MAX_VALUE = Number.MAX_VALUE;


export interface SliderProps extends ViewBaseProps {
  thumbImage?: string
  maximumTrackTintColor?: ColorSegments
  minimumTrackTintColor?: ColorSegments
  thumbTintColor?: ColorSegments
}

export interface SliderSate {}

export interface SliderRawProps extends ViewRawProps {
  disabled?: boolean
  inverted?: boolean
  vertical?: boolean
  tapToSeek?: boolean
  testID?: string
  maximumValue?: number
  minimumValue?: number
  step?: number
  value?: number
  lowerLimit?: number
  upperLimit?: number
}

export type SliderDescriptor = Descriptor<"RNCSlider", SliderProps, SliderSate, SliderRawProps>
export const SLIDER_TYPE: string = RNC.RNCSlider.NAME

@Component
export struct RNCSlider {
  // ctx!: RNOHContext
  ctx!: RNComponentContext
  tag: number = 0
  // @State descriptor: SliderDescriptor = {} as SliderDescriptor
  // @State private descriptorWrapper: SliderDescriptorWrapper | undefined = undefined
  // private unregisterDescriptorChangesListener?: ()=> void = undefined
  @State private descriptor: RNC.RNCSlider.DescriptorWrapper = {} as RNC.RNCSlider.DescriptorWrapper
  @State SliderValue: number = 0
  private lowerLimit = 0
  private upperLimit = 0
  private logger: RNOHLogger | null = null;
  // 存储需要在组件卸载时清理的回调函数
  private cleanUpCallbacks: (() => void)[] = []
  private eventEmitter: RNC.RNCSlider.EventEmitter | undefined = undefined

  aboutToAppear() {
    // this.descriptor = this.ctx.descriptorRegistry.getDescriptor<SliderDescriptor>(this.tag);
    // this.descriptorWrapper = new SliderDescriptorWrapper(this.descriptor);
    // this.unregisterDescriptorChangesListener = this.ctx.descriptorRegistry.subscribeToDescriptorChanges(this.tag,
    //   (newDescriptor) => {
    //     this.descriptor = (newDescriptor as SliderDescriptor)
    //     this.descriptorWrapper = new SliderDescriptorWrapper(this.descriptor);
    //     let value = this.descriptorWrapper.value;
    //     if (value < this.lowerLimit) {
    //       value = this.lowerLimit;
    //     } else if (value > this.upperLimit) {
    //       value = this.upperLimit;
    //     }
    //     this.SliderValue = value;
    //   }
    // );
    // 创建EventEmitter实例，用于处理事件的订阅和触发
    this.eventEmitter = new RNC.RNCSlider.EventEmitter(this.ctx.rnInstance, this.tag)
    // 处理组件初始状态
    this.onDescriptorWrapperChange(this.ctx.descriptorRegistry.findDescriptorWrapperByTag<RNC.RNCSlider.DescriptorWrapper>(this.tag)!)
    this.logger = this.ctx?.logger.clone(RNC.RNCSlider.NAME);
    this.SliderValue = this.descriptor.props.value;
    this.upperLimit = this.descriptor.props.upperLimit ?? this.descriptor.props.maximumValue
    this.lowerLimit = this.descriptor.props.lowerLimit;
    // Logger.info(TAG, `descriptor props: ${JSON.stringify(this.descriptor.rawProps)}`)
    // 订阅组件状态的变化，然后放入cleanUpCallbacks等待清理
    this.cleanUpCallbacks.push( this.ctx.descriptorRegistry.subscribeToDescriptorChanges(this.tag,
      (_descriptor, newDescriptorWrapper) => {
        // 更新组件状态
        this.onDescriptorWrapperChange(newDescriptorWrapper! as RNC.RNCSlider.DescriptorWrapper)
      }
    ))
  }

  aboutToDisappear() {
    // this.unregisterDescriptorChangesListener?.()
    // 执行所有清理回调
    this.cleanUpCallbacks.forEach(cb => cb())
  }
  // 更新组件状态
  private onDescriptorWrapperChange(descriptorWrapper: RNC.RNCSlider.DescriptorWrapper) {
    this.logger?.info(`onDescriptorWrapperChange`)
    this.descriptor = descriptorWrapper
  }

  onSliderChange(value: number, mode: SliderChangeMode) {
    // Logger.debug(TAG, `onSliderChange: ${value}, ${mode}`)
    if (value < this.lowerLimit) {
      value = this.lowerLimit;
    } else if (value > this.upperLimit) {
      value = this.upperLimit;
    }
    this.SliderValue = value
    if (mode === 0) {
      // this.ctx.rnInstance.emitComponentEvent(
      //   this.descriptor.tag,
      //   SLIDER_TYPE,
      //   {
      //     type: "SliderSlidingStart",
      //     value: value,
      //     // fromUser: true
      //   }
      // );
      this.eventEmitter!.emit("rNCSliderSlidingStart", { value: value });
    } else if (mode === 1) {
      // this.ctx.rnInstance.emitComponentEvent(
      //   this.descriptor.tag,
      //   SLIDER_TYPE,
      //   {
      //     type: "SliderValueChange",
      //     value: value,
      //     // fromUser: true
      //   }
      // );
      this.eventEmitter!.emit("change", { value: value });
    } else if (mode === 2) {
      // this.ctx.rnInstance.emitComponentEvent(
      //   this.descriptor.tag,
      //   SLIDER_TYPE,
      //   {
      //     type: "SliderSlidingComplete",
      //     value: value,
      //     // fromUser: true
      //   }
      // );
      this.eventEmitter!.emit("rNCSliderSlidingComplete", { value: value });
    } else if (mode === 3) {
      // this.ctx.rnInstance.emitComponentEvent(
      //   this.descriptor.tag,
      //   SLIDER_TYPE,
      //   {
      //     type: "SliderValueChange",
      //     value: value,
      //     // fromUser: true
      //   }
      // );
      this.eventEmitter!.emit("rNCSliderValueChange", { value: value });
    }
  }
  public get source(): Resource {
    if (this.descriptor.props.thumbImage?.startsWith("asset://")) {
      return $rawfile(this.descriptor.props.thumbImage?.replace("asset://", "assets/"));
    }
    if (this.descriptor.props.thumbImage?.startsWith("file://assets/src/assets/")) {
      return $rawfile(this.descriptor.props.thumbImage?.replace("file://assets/src/assets/", "assets/"));
    }
    return $rawfile(this.descriptor.props.thumbImage);
  }
  public get BlockStyle(): SliderBlockStyle {
    if (this.descriptor.props.thumbImage) {
      return {
        type: SliderBlockType.IMAGE,
        image: this.source
      };
    }
    return { type: SliderBlockType.DEFAULT };
  }

  build() {
    RNViewBase({ ctx: this.ctx, tag: this.tag }) {
      Slider({
        value: this.SliderValue,
        step: this.descriptor.props.step,
        min: this.descriptor.props?.minimumValue,
        max: this.descriptor.props?.maximumValue,
        direction: (this.descriptor.props.vertical ? Axis.Vertical : Axis.Horizontal),
        reverse: (this.descriptor.props.inverted ? true : false),
        style: SliderStyle.OutSet
      })
        .width("100%")
        .height("100%")
        .enabled(this.descriptor.props.disabled ? false : true)
        .blockColor(this.descriptor.props.thumbTintColor?.toRGBAString())
        .trackColor(this.descriptor.props.maximumTrackTintColor?.toRGBAString())
        .selectedColor(this.descriptor.props.minimumTrackTintColor?.toRGBAString())
        .showSteps(false)
        .blockStyle(this.BlockStyle)
        .onChange((value: number, mode: SliderChangeMode) => this.onSliderChange(value, mode))
        .slideRange({
          from: this.lowerLimit === DEFAULT_LIMIT_VALUE ? this.descriptor.props.minimumValue ?? LIMIT_MIN_VALUE : this.lowerLimit,
          to: this.upperLimit === DEFAULT_MAX_VALUE ? this.descriptor.props.maximumValue ?? LIMIT_MAX_VALUE : this.upperLimit
        })
    }
  }
}