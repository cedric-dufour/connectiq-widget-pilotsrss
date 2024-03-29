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
using Toybox.Position as Pos;
using Toybox.WatchUi as Ui;

// NOTE: Since Ui.Confirmation does not allow to pre-select "Yes" as an answer,
//       let's us our own "confirmation" menu and save one key press
class MenuLocationEditFromGPS extends Ui.Menu {

  //
  // FUNCTIONS: Ui.Menu (override/implement)
  //

  function initialize() {
    Menu.initialize();
    Menu.setTitle(Ui.loadResource(Rez.Strings.titleConfirm) as String);
    Menu.addItem(format("$1$ ?", [Ui.loadResource(Rez.Strings.titleLocationFromGPS)]), :confirm);
  }

}

class MenuLocationEditFromGPSDelegate extends Ui.MenuInputDelegate {

  //
  // FUNCTIONS: Ui.MenuInputDelegate (override/implement)
  //

  function initialize() {
    MenuInputDelegate.initialize();
  }

  function onMenuItem(item) {
    if (item == :confirm and $.oMyPositionLocation != null) {
      // Update location (dictionary) with current location
      var adLocation = ($.oMyPositionLocation as Pos.Location).toDegrees();
      var dictLocation = App.Storage.getValue("storLocPreset") as Dictionary?;
      if(dictLocation == null) {
        dictLocation = {"name" => "----", "latitude" => 0.0d, "longitude" => 0.0d};
      }
      dictLocation["name"] = Ui.loadResource(Rez.Strings.valueLocationGPS) as String;
      dictLocation["latitude"] = adLocation[0];
      dictLocation["longitude"] = adLocation[1];
      App.Storage.setValue("storLocPreset", dictLocation as App.PropertyValueType);
    }
  }

}
