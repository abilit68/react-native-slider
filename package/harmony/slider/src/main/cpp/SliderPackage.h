/*
 * Copyright (c) 2024 Huawei Device Co., Ltd. All rights reserved
 * Use of this source code is governed by a MIT license that can be
 * found in the LICENSE file.
 */

#pragma once

#include "generated/RNOH/generated/BaseSliderPackage.h"

namespace rnoh {
class SliderPackage : public BaseSliderPackage {
    using Super = SliderPackage;
//     using Super::Super;
public:
    SliderPackage(Package::Context ctx) : Super(ctx) {}
};
} // namespace rnoh