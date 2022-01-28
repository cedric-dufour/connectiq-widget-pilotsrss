// -*- mode:java; tab-width:2; c-basic-offset:2; intent-tabs-mode:nil; -*- ex: set tabstop=2 expandtab:

// Pilot SR/SS/Twilight Hours (PilotSRSS)
// Copyright (C) 2018-2022 Cedric Dufour <http://cedric.dufour.name>
//
// Pilot SR/SS/Twilight Hours (PilotSRSS) is free software:
// you can redistribute it and/or modify it under the terms of the GNU General
// Public License as published by the Free Software Foundation, Version 3.
//
// Pilot SR/SS/Twilight Hours (PilotSRSS) is distributed in the hope that it
// will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
//
// See the GNU General Public License for more details.
//
// SPDX-License-Identifier: GPL-3.0
// License-Filename: LICENSE/GPL-3.0.txt

import Toybox.Lang;
using Toybox.Application as App;
using Toybox.Graphics as Gfx;
using Toybox.WatchUi as Ui;

class PickerLocationEditLatitude extends PickerGenericLatitude {

  //
  // FUNCTIONS: PickerGenericLatitude (override/implement)
  //

  function initialize() {
    var dictLocation = App.Storage.getValue("storLocPreset") as Dictionary?;
    var dLatitude = dictLocation != null ? dictLocation["latitude"] as Double : 0.0d;
    PickerGenericLatitude.initialize(Ui.loadResource(Rez.Strings.titleLocationLatitude) as String, dLatitude);
  }

}

class PickerLocationEditLatitudeDelegate extends Ui.PickerDelegate {

  //
  // FUNCTIONS: Ui.PickerDelegate (override/implement)
  //

  function initialize() {
    PickerDelegate.initialize();
  }

  function onAccept(_amValues) {
    // Assemble components
    var dLatitude = PickerGenericLatitude.getValue(_amValues);

    // Update/create location (dictionary)
    var dictLocation = App.Storage.getValue("storLocPreset") as Dictionary?;
    if(dictLocation != null) {
      dictLocation["latitude"] = dLatitude;
    }
    else {
      dictLocation = {"name" => "----", "latitude" => dLatitude, "longitude" => 0.0d};
    }

    // Set property and exit
    App.Storage.setValue("storLocPreset", dictLocation as App.PropertyValueType);
    Ui.popView(Ui.SLIDE_IMMEDIATE);
    return true;
  }

  function onCancel() {
    // Exit
    Ui.popView(Ui.SLIDE_IMMEDIATE);
    return true;
  }

}
