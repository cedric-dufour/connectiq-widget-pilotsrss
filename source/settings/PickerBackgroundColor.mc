// -*- mode:java; tab-width:2; c-basic-offset:2; intent-tabs-mode:nil; -*- ex: set tabstop=2 expandtab:

// Pilot SR/SS/Twilight Hours (PilotSRSS)
// Copyright (C) 2018-2021 Cedric Dufour <http://cedric.dufour.name>
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

class PickerBackgroundColor extends Ui.Picker {

  //
  // FUNCTIONS: Ui.Picker (override/implement)
  //

  function initialize() {
    // Get property
    var iColor = $.oMySettings.loadBackgroundColor();

    // Initialize picker
    var oFactory = new PickerFactoryDictionary([Gfx.COLOR_WHITE, Gfx.COLOR_BLACK],
                                               [Ui.loadResource(Rez.Strings.valueColorWhite), Ui.loadResource(Rez.Strings.valueColorBlack)],
                                               null);
    Picker.initialize({
        :title => new Ui.Text({
            :text => Ui.loadResource(Rez.Strings.titleBackgroundColor) as String,
            :font => Gfx.FONT_TINY,
            :locX=>Ui.LAYOUT_HALIGN_CENTER,
            :locY=>Ui.LAYOUT_VALIGN_BOTTOM,
            :color => Gfx.COLOR_BLUE}),
        :pattern => [oFactory],
        :defaults => [oFactory.indexOfKey(iColor)]});
  }

}

class PickerBackgroundColorDelegate extends Ui.PickerDelegate {

  //
  // FUNCTIONS: Ui.PickerDelegate (override/implement)
  //

  function initialize() {
    PickerDelegate.initialize();
  }

  function onAccept(_amValues) {
    // Set property and exit
    $.oMySettings.saveBackgroundColor(_amValues[0] as Number);
    Ui.popView(Ui.SLIDE_IMMEDIATE);
    return true;
  }

  function onCancel() {
    // Exit
    Ui.popView(Ui.SLIDE_IMMEDIATE);
    return true;
  }

}
