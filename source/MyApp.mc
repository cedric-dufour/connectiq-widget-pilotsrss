// -*- mode:java; tab-width:2; c-basic-offset:2; intent-tabs-mode:nil; -*- ex: set tabstop=2 expandtab:

// Pilot SR/SS/Twilight Hours (PilotSRSS)
// Copyright (C) 2018 Cedric Dufour <http://cedric.dufour.name>
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

using Toybox.Application as App;
using Toybox.Position as Pos;
using Toybox.System as Sys;
using Toybox.Time;
using Toybox.Timer;
using Toybox.WatchUi as Ui;

//
// GLOBALS
//

// Application settings
var oMySettings = null;

// (Last) position location
var oMyPositionLocation = null;

// Almanac data
var oMyAlmanac = null;

// Current view
var oMyView = null;


//
// CONSTANTS
//

// Storage slots
const MY_STORAGE_SLOTS = 100;


//
// CLASS
//

class MyApp extends App.AppBase {

  //
  // VARIABLES
  //

  // UI update time
  private var oUpdateTimer;


  //
  // FUNCTIONS: App.AppBase (override/implement)
  //

  function initialize() {
    AppBase.initialize();

    // Application settings
    $.oMySettings = new MySettings();

    // Almanac data
    $.oMyAlmanac = new MyAlmanac();

    // UI update time
    self.oUpdateTimer = null;
  }

  function onStart(state) {
    //Sys.println("DEBUG: MyApp.onStart()");

    // Start UI update timer (every multiple of 60 seconds)
    self.oUpdateTimer = new Timer.Timer();
    var iUpdateTimerDelay = (60-Sys.getClockTime().sec)%60;
    if(iUpdateTimerDelay > 0) {
      self.oUpdateTimer.start(method(:onUpdateTimer_init), 1000*iUpdateTimerDelay, false);
    }
    else {
      self.oUpdateTimer.start(method(:onUpdateTimer), 60000, true);
    }
  }

  function onStop(state) {
    //Sys.println("DEBUG: MyApp.onStop()");

    // Stop UI update timer
    if(self.oUpdateTimer != null) {
      self.oUpdateTimer.stop();
      self.oUpdateTimer = null;
    }
  }

  function getInitialView() {
    //Sys.println("DEBUG: MyApp.getInitialView()");

    return [new MyView(), new MyViewDelegate()];
  }

  function onSettingsChanged() {
    //Sys.println("DEBUG: MyApp.onSettingsChanged()");
    self.updateApp();
  }


  //
  // FUNCTIONS: self
  //

  function updateApp() {
    //Sys.println("DEBUG: MyApp.updateApp()");

    // Load settings
    self.loadSettings();

    // Use GPS position
    if($.oMySettings.bLocationAuto) {
      Pos.enableLocationEvents(Pos.LOCATION_ONE_SHOT, method(:onLocationEvent));
    }
    else {
      var dictLocation = App.Storage.getValue("storLocPreset");
      var fLocationHeight = App.Properties.getValue("userLocationHeight");
      var iEpochDate = $.oMySettings.bDateAuto ? Time.today().value() : App.Storage.getValue("storDatePreset");
      var iEpochTime = $.oMySettings.bDateAuto ? Time.now().value() : null;
      self.computeAlmanac(dictLocation["name"], dictLocation["latitude"], dictLocation["longitude"], fLocationHeight, iEpochDate, iEpochTime);
    }

    // Update UI
    self.updateUi();
  }

  function loadSettings() {
    //Sys.println("DEBUG: MyApp.loadSettings()");

    // Load settings
    $.oMySettings.load();

    // ... location
    var dictLocation = App.Storage.getValue("storLocPreset");
    if(dictLocation == null) {
      // Sun Almanac was born in Switzerland; use "Old" Bern Observatory coordinates ;-)
      dictLocation = { "name" => "LSAS", "latitude" => 46.9524055555556d, "longitude" => 7.43958333333333d };
      App.Storage.setValue("storLocPreset", dictLocation);
    }

    // ... date
    var iEpochDate = App.Storage.getValue("storDatePreset");
    if(iEpochDate == null) {
      iEpochDate = Time.today().value();
      App.Storage.setValue("storDatePreset", iEpochDate);
    }
  }

  function computeAlmanac(_sLocationName, _fLocationLatitude, _fLocationLongitude, _fLocationHeight, _iEpochDate, _iEpochTime) {
    //Sys.println("DEBUG: MyApp.computeAlmanac()");

    // Compute almanac data
    $.oMyAlmanac.setLocation(_sLocationName, _fLocationLatitude, _fLocationLongitude, _fLocationHeight);
    $.oMyAlmanac.compute(_iEpochDate, _iEpochTime, true);
  }

  function onLocationEvent(_oInfo) {
    //Sys.println("DEBUG: MyApp.onLocationEvent()");
    if(!$.oMySettings.bLocationAuto) {
      return;  // should one have changed his mind while waiting for GPS fix
    }
    if(!(_oInfo has :position)) {
      return;
    }

    // Save position
    $.oMyPositionLocation = _oInfo.position;

    // Update almanac data
    var adLocation = _oInfo.position.toDegrees();
    var fLocationHeight = App.Properties.getValue("userLocationHeight");
    var iEpochDate = $.oMySettings.bDateAuto ? Time.today().value() : App.Storage.getValue("storDatePreset");
    var iEpochTime = $.oMySettings.bDateAuto ? Time.now().value() : null;
    self.computeAlmanac(Ui.loadResource(Rez.Strings.valueLocationGPS), adLocation[0], adLocation[1], fLocationHeight, iEpochDate, iEpochTime);

    // Update UI
    self.updateUi();
  }

  function onUpdateTimer_init() {
    //Sys.println("DEBUG: MyApp.onUpdateTimer_init()");
    self.onUpdateTimer();
    self.oUpdateTimer = new Timer.Timer();
    self.oUpdateTimer.start(method(:onUpdateTimer), 60000, true);
  }

  function onUpdateTimer() {
    //Sys.println("DEBUG: MyApp.onUpdateTimer()");
    self.updateUi();
  }

  function updateUi() {
    //Sys.println("DEBUG: MyApp.updateUi()");

    // Update UI
    if($.oMyView != null) {
      $.oMyView.updateUi();
    }
  }

}
