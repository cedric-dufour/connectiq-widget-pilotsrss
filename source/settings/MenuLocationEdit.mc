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
using Toybox.System as Sys;
using Toybox.WatchUi as Ui;

class MenuLocationEdit extends Ui.Menu {

  //
  // FUNCTIONS: Ui.Menu (override/implement)
  //

  function initialize() {
    Menu.initialize();
    Menu.setTitle(Ui.loadResource(Rez.Strings.titleLocationEdit) as String);
    Menu.addItem(Ui.loadResource(Rez.Strings.titleLocationName) as String, :menuLocationName);
    Menu.addItem(Ui.loadResource(Rez.Strings.titleLocationLatitude) as String, :menuLocationLatitude);
    Menu.addItem(Ui.loadResource(Rez.Strings.titleLocationLongitude) as String, :menuLocationLongitude);
    if($.oMyPositionLocation != null) {
      Menu.addItem(Ui.loadResource(Rez.Strings.titleLocationFromGPS) as String, :menuLocationFromGPS);
    }
  }
}

class MenuLocationEditDelegate extends Ui.MenuInputDelegate {

  //
  // FUNCTIONS: Ui.MenuInputDelegate (override/implement)
  //

  function initialize() {
    MenuInputDelegate.initialize();
  }

  function onMenuItem(item) {
    if (item == :menuLocationName) {
      //Sys.println("DEBUG: MenuLocationEditDelegate.onMenuItem(:menuLocationName)");
      Ui.pushView(new PickerLocationEditName(),
                  new PickerLocationEditNameDelegate(),
                  Ui.SLIDE_IMMEDIATE);
    }
    else if (item == :menuLocationLatitude) {
      //Sys.println("DEBUG: MenuLocationEditDelegate.onMenuItem(:menuLocationLatitude)");
      Ui.pushView(new PickerLocationEditLatitude(),
                  new PickerLocationEditLatitudeDelegate(),
                  Ui.SLIDE_IMMEDIATE);
    }
    else if (item == :menuLocationLongitude) {
      //Sys.println("DEBUG: MenuLocationEditDelegate.onMenuItem(:menuLocationLongitude)");
      Ui.pushView(new PickerLocationEditLongitude(),
                  new PickerLocationEditLongitudeDelegate(),
                  Ui.SLIDE_IMMEDIATE);
    }
    else if (item == :menuLocationFromGPS) {
      //Sys.println("DEBUG: MenuLocationEditDelegate.onMenuItem(:menuLocationFromGPS)");
      Ui.pushView(new MenuLocationEditFromGPS(),
                  new MenuLocationEditFromGPSDelegate(),
                  Ui.SLIDE_IMMEDIATE);
    }
  }

}
