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

class MenuSettingsDateTime extends Ui.Menu {

  //
  // FUNCTIONS: Ui.Menu (override/implement)
  //

  function initialize() {
    Menu.initialize();
    Menu.setTitle(Ui.loadResource(Rez.Strings.titleSettingsDateTime) as String);
    Menu.addItem(Ui.loadResource(Rez.Strings.titleDateAuto) as String, :menuDateAuto);
    Menu.addItem(Ui.loadResource(Rez.Strings.titleDatePreset) as String, :menuDatePreset);
    Menu.addItem(Ui.loadResource(Rez.Strings.titleTimeUTC) as String, :menuTimeUTC);
  }

}

class MenuSettingsDateTimeDelegate extends Ui.MenuInputDelegate {

  //
  // FUNCTIONS: Ui.MenuInputDelegate (override/implement)
  //

  function initialize() {
    MenuInputDelegate.initialize();
  }

  function onMenuItem(item) {
    if (item == :menuDateAuto) {
      //Sys.println("DEBUG: MenuSettingsDateTimeDelegate.onMenuItem(:menuSettingsDateTime)");
      Ui.pushView(new PickerDateAuto(),
                  new PickerDateAutoDelegate(),
                  Ui.SLIDE_IMMEDIATE);
    }
    else if (item == :menuDatePreset) {
      //Sys.println("DEBUG: MenuSettingsDateTimeDelegate.onMenuItem(:menuDatePreset)");
      Ui.pushView(new PickerDatePreset(),
                  new PickerDatePresetDelegate(),
                  Ui.SLIDE_IMMEDIATE);
    }
    else if (item == :menuTimeUTC) {
      //Sys.println("DEBUG: MenuSettingsDateTimeDelegate.onMenuItem(:menuTimeUTC)");
      Ui.pushView(new PickerTimeUTC(),
                  new PickerTimeUTCDelegate(),
                  Ui.SLIDE_IMMEDIATE);
    }
  }

}
