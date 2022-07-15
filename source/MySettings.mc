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
using Toybox.System as Sys;

(:glance)
class MySettings {

  //
  // VARIABLES
  //

  // Settings
  public var bLocationAuto as Boolean = false;
  public var fLocationHeight as Float = 0.0f;
  public var bDateAuto as Boolean = true;
  public var bTimeUTC as Boolean = false;
  public var iBackgroundColor as Number = Gfx.COLOR_BLACK;
  // ... device
  public var iUnitElevation as Number = -1;

  // Units
  public var sUnitTime as String = "LT";
  // ... device
  public var sUnitElevation as String = "m";

  // Units conversion constants
  // ... device
  public var fUnitElevationConstant as Float = 1.0f;


  //
  // FUNCTIONS: self
  //

  function load() as Void {
    // Settings
    self.setLocationAuto(self.loadLocationAuto());
    self.setLocationHeight(self.loadLocationHeight());
    self.setDateAuto(self.loadDateAuto());
    self.setTimeUTC(self.loadTimeUTC());
    self.setBackgroundColor(self.loadBackgroundColor());
    // ... device
    self.setUnitElevation();
  }

  // WARNING: Make sure to cast the properties values to the expected type!
  // REF: https://forums.garmin.com/developer/connect-iq/w/wiki/4/new-developer-faq#settings-crash
  // ACKNOWLEDGMENT: Yannick Dutertre for the heads up and pointer

  function loadLocationAuto() as Boolean {
    return LangUtils.asBoolean(App.Properties.getValue("userLocationAuto"), false);
  }
  function saveLocationAuto(_bValue as Boolean) as Void {
    App.Properties.setValue("userLocationAuto", _bValue as App.PropertyValueType);
  }
  function setLocationAuto(_bValue as Boolean) as Void {
    self.bLocationAuto = _bValue;
  }

  function loadLocationHeight() as Float {
    return LangUtils.asFloat(App.Properties.getValue("userLocationHeight"), 0.0f);
  }
  function saveLocationHeight(_fValue as Float) as Void {
    App.Properties.setValue("userLocationHeight", _fValue as App.PropertyValueType);
  }
  function setLocationHeight(_fValue as Float) as Void {
    if(_fValue > 9999.0f) {
      _fValue = 9999.0f;
    }
    else if(_fValue < 0.0f) {
      _fValue = 0.0f;
    }
    self.fLocationHeight = _fValue;
  }

  function loadDateAuto() as Boolean {
    return LangUtils.asBoolean(App.Properties.getValue("userDateAuto"), true);
  }
  function saveDateAuto(_bValue as Boolean) as Void {
    App.Properties.setValue("userDateAuto", _bValue as App.PropertyValueType);
  }
  function setDateAuto(_bValue as Boolean) as Void {
    self.bDateAuto = _bValue;
  }

  function loadTimeUTC() as Boolean {
    return LangUtils.asBoolean(App.Properties.getValue("userTimeUTC"), false);
  }
  function saveTimeUTC(_bValue as Boolean) as Void {
    App.Properties.setValue("userTimeUTC", _bValue as App.PropertyValueType);
  }
  function setTimeUTC(_bValue as Boolean) as Void {
    if(_bValue) {
      self.bTimeUTC = true;
      self.sUnitTime = "Z";
    }
    else {
      self.bTimeUTC = false;
      self.sUnitTime = "LT";
    }
  }

  function loadBackgroundColor() as Number {
    return LangUtils.asNumber(App.Properties.getValue("userBackgroundColor"), Gfx.COLOR_BLACK);
  }
  function saveBackgroundColor(_iValue as Number) as Void {
    App.Properties.setValue("userBackgroundColor", _iValue as App.PropertyValueType);
  }
  function setBackgroundColor(_iValue as Number) as Void {
    self.iBackgroundColor = _iValue;
  }

  function setUnitElevation() as Void {
    var oDeviceSettings = Sys.getDeviceSettings();
    if(oDeviceSettings has :elevationUnits and oDeviceSettings.elevationUnits != null) {
      self.iUnitElevation = oDeviceSettings.elevationUnits as Number;
    }
    else {
      self.iUnitElevation = Sys.UNIT_METRIC;
    }
    if(self.iUnitElevation == Sys.UNIT_STATUTE) {  // ... statute
      // ... [ft]
      self.sUnitElevation = "ft";
      self.fUnitElevationConstant = 3.280839895f;  // ... m -> ft
    }
    else {  // ... metric
      // ... [m]
      self.sUnitElevation = "m";
      self.fUnitElevationConstant = 1.0f;  // ... m -> m
    }
  }

}
