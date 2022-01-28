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
class PickerLocationDelete extends Ui.Picker {

  //
  // FUNCTIONS: Ui.Picker (override/implement)
  //

  function initialize() {
    // Location memory
    var aiMemoryKeys = new Array<Number>[$.MY_STORAGE_SLOTS];
    var asMemoryValues = new Array<String>[$.MY_STORAGE_SLOTS];
    var iMemoryUsed = 0;
    for(var n=0; n<$.MY_STORAGE_SLOTS; n++) {
      var s = n.format("%02d");
      var dictLocation = App.Storage.getValue("storLoc"+s) as Dictionary?;
      if(dictLocation != null) {
        aiMemoryKeys[iMemoryUsed] = n;
        asMemoryValues[iMemoryUsed] = format("[$1$]\n$2$", [s, dictLocation["name"]]);
        iMemoryUsed++;
      }
    }

    // Initialize picker
    var oPattern;
    if(iMemoryUsed > 0) {
      aiMemoryKeys = aiMemoryKeys.slice(0, iMemoryUsed);
      asMemoryValues = asMemoryValues.slice(0, iMemoryUsed);
      oPattern = new PickerFactoryDictionary(aiMemoryKeys, asMemoryValues, {:font => Gfx.FONT_TINY});
    }
    else {
      oPattern = new PickerFactoryDictionary([null], ["-"], {:color => Gfx.COLOR_DK_GRAY});
    }
    Picker.initialize({
        :title => new Ui.Text({
            :text => Ui.loadResource(Rez.Strings.titleLocationDelete) as String,
            :font => Gfx.FONT_TINY,
            :locX=>Ui.LAYOUT_HALIGN_CENTER,
            :locY=>Ui.LAYOUT_VALIGN_BOTTOM,
            :color => Gfx.COLOR_BLUE}),
        :pattern => [oPattern]});
  }

}

(:memory_large)
class PickerLocationDeleteDelegate extends Ui.PickerDelegate {

  //
  // FUNCTIONS: Ui.PickerDelegate (override/implement)
  //

  function initialize() {
    PickerDelegate.initialize();
  }

  function onAccept(_amValues) {
    // Delete property (location memory)
    if(_amValues[0] != null) {
      var s = (_amValues[0] as Number).format("%02d");
      App.Storage.deleteValue("storLoc"+s);
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
