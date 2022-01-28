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

(:memory_large)
class PickerLocationSave extends Ui.Picker {

  //
  // FUNCTIONS: Ui.Picker (override/implement)
  //

  function initialize() {
    // Location memory
    var aiMemoryKeys = new Array<Number>[$.MY_STORAGE_SLOTS];
    var asMemoryValues = new Array<String>[$.MY_STORAGE_SLOTS];
    for(var n=0; n<$.MY_STORAGE_SLOTS; n++) {
      aiMemoryKeys[n] = n;
      var s = n.format("%02d");
      var dictLocation = App.Storage.getValue("storLoc"+s) as Dictionary?;
      if(dictLocation != null) {
        asMemoryValues[n] = format("[$1$]\n$2$", [s, dictLocation["name"]]);
      }
      else {
        asMemoryValues[n] = format("[$1$]\n----", [s]);
      }
    }

    // Initialize picker
    Picker.initialize({
        :title => new Ui.Text({
            :text => Ui.loadResource(Rez.Strings.titleLocationSave) as String,
            :font => Gfx.FONT_TINY,
            :locX=>Ui.LAYOUT_HALIGN_CENTER,
            :locY=>Ui.LAYOUT_VALIGN_BOTTOM,
            :color => Gfx.COLOR_BLUE}),
        :pattern => [new PickerFactoryDictionary(aiMemoryKeys, asMemoryValues, {:font => Gfx.FONT_TINY})]});
  }

}

(:memory_large)
class PickerLocationSaveDelegate extends Ui.PickerDelegate {

  //
  // FUNCTIONS: Ui.PickerDelegate (override/implement)
  //

  function initialize() {
    PickerDelegate.initialize();
  }

  function onAccept(_amValues) {
    // Save location
    var dictLocation = App.Storage.getValue("storLocPreset") as Dictionary?;
    if(dictLocation != null) {
      // Set property (location memory)
      // WARNING: We MUST store a new (different) dictionary instance (deep copy)!
      var s = (_amValues[0] as Number).format("%02d");
      App.Storage.setValue("storLoc"+s, LangUtils.copy(dictLocation) as App.PropertyValueType);
    }

    // Exit
    Ui.popView(Ui.SLIDE_IMMEDIATE);
    return true;
  }

  function onCancel() {
    // Exit
    Ui.popView(Ui.SLIDE_IMMEDIATE);
    return true;
  }

}
