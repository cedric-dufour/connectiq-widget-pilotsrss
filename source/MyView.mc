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
using Toybox.Graphics as Gfx;
using Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.System as Sys;
using Toybox.WatchUi as Ui;

//
// GLOBALS
//

// Current view index
var iMyViewIndex = 0;


//
// CLASS
//

class MyView extends Ui.View {

  //
  // CONSTANTS
  //

  private const NOVALUE_BLANK = "";
  private const NOVALUE_LEN3 = "---";


  //
  // VARIABLES
  //

  // Display mode (internal)
  private var bShow;

  // Resources
  // ... drawable
  private var oRezDrawable;
  // ... header
  private var oRezValueDate;
  // ... label
  private var oRezLabelTop;
  // ... fields (2x2)
  private var oRezValueTopLeft;
  private var oRezValueTopRight;
  private var oRezValueBottomLeft;
  private var oRezValueBottomRight;
  // ... fields (4x1)
  private var oRezValueTopHigh;
  private var oRezValueTopLow;
  private var oRezValueBottomHigh;
  private var oRezValueBottomLow;
  // ... label
  private var oRezLabelBottom;
  // ... footer
  private var oRezValueTime;


  //
  // FUNCTIONS: Ui.View (override/implement)
  //

  function initialize() {
    View.initialize();

    // Display mode (internal)
    self.bShow = false;
  }

  function onLayout(_oDC) {
    View.setLayout(Rez.Layouts.MyLayout(_oDC));

    // Load resources
    // ... drawable
    self.oRezDrawable = View.findDrawableById("MyDrawable");
    // ... header
    self.oRezValueDate = View.findDrawableById("valueDate");
    // ... label
    self.oRezLabelTop = View.findDrawableById("labelTop");
    // ... fields (2x2)
    self.oRezValueTopLeft = View.findDrawableById("valueTopLeft");
    self.oRezValueTopRight = View.findDrawableById("valueTopRight");
    self.oRezValueBottomLeft = View.findDrawableById("valueBottomLeft");
    self.oRezValueBottomRight = View.findDrawableById("valueBottomRight");
    // ... fields (4x1)
    self.oRezValueTopHigh = View.findDrawableById("valueTopHigh");
    self.oRezValueTopLow = View.findDrawableById("valueTopLow");
    self.oRezValueBottomHigh = View.findDrawableById("valueBottomHigh");
    self.oRezValueBottomLow = View.findDrawableById("valueBottomLow");
    // ... label
    self.oRezLabelBottom = View.findDrawableById("labelBottom");
    // ... footer
    self.oRezValueTime = View.findDrawableById("valueTime");

    // Done
    return true;
  }

  function onShow() {
    //Sys.println("DEBUG: MyView.onShow()");

    // Reload settings (which may have been changed by user)
    self.reloadSettings();

    // Set colors
    var iColorText = $.oMySettings.iBackgroundColor ? Gfx.COLOR_BLACK : Gfx.COLOR_WHITE;
    // ... background
    self.oRezDrawable.setColorBackground($.oMySettings.iBackgroundColor);
    // ... date
    // -> depends on settings
    // ... fields (2x2)
    self.oRezValueTopLeft.setColor(iColorText);
    self.oRezValueTopRight.setColor(iColorText);
    self.oRezValueBottomLeft.setColor(iColorText);
    self.oRezValueBottomRight.setColor(iColorText);
    // ... fields (4x1)
    self.oRezValueTopHigh.setColor(iColorText);
    self.oRezValueTopLow.setColor(iColorText);
    self.oRezValueBottomHigh.setColor(iColorText);
    self.oRezValueBottomLow.setColor(iColorText);
    // ... time
    self.oRezValueTime.setColor(iColorText);

    // Done
    self.bShow = true;
    $.oMyView = self;
    return true;
  }

  function onUpdate(_oDC) {
    //Sys.println("DEBUG: MyView.onUpdate()");

    // Update layout
    self.updateLayout();
    View.onUpdate(_oDC);

    // Done
    return true;
  }

  function onHide() {
    //Sys.println("DEBUG: MyView.onHide()");
    $.oMyView = null;
    self.bShow = false;
  }


  //
  // FUNCTIONS: self
  //

  function reloadSettings() {
    //Sys.println("DEBUG: MyView.reloadSettings()");

    // Update application state
    App.getApp().updateApp();
  }

  function updateUi() {
    //Sys.println("DEBUG: MyView.updateUi()");

    // Request UI update
    if(self.bShow) {
      Ui.requestUpdate();
    }
  }

  function updateLayout() {
    //Sys.println("DEBUG: MyView.updateLayout()");

    // Set header/footer values
    var iColorText = $.oMySettings.iBackgroundColor ? Gfx.COLOR_BLACK : Gfx.COLOR_WHITE;

    // ... date
    self.oRezValueDate.setColor($.oMySettings.bDateAuto ? iColorText : Gfx.COLOR_LT_GRAY);
    if($.oMyAlmanac.iEpochCurrent != null) {
      var oDate = new Time.Moment($.oMyAlmanac.iEpochCurrent);
      var oDateInfo = $.oMySettings.bTimeUTC ? Gregorian.utcInfo(oDate, Time.FORMAT_MEDIUM) : Gregorian.info(oDate, Time.FORMAT_MEDIUM);
      self.oRezValueDate.setText(Lang.format("$1$ $2$", [oDateInfo.month, oDateInfo.day.format("%d")]));
    }
    else if($.oMyAlmanac.iEpochDate != null) {
      var oDateInfo = Gregorian.utcInfo(new Time.Moment($.oMyAlmanac.iEpochDate), Time.FORMAT_MEDIUM);
      self.oRezValueDate.setText(Lang.format("$1$ $2$", [oDateInfo.month, oDateInfo.day.format("%d")]));
    }
    else {
      self.oRezValueDate.setText(self.NOVALUE_LEN3);
    }

    // ... time
    var oTimeNow = Time.now();
    var oTimeInfo = $.oMySettings.bTimeUTC ? Gregorian.utcInfo(oTimeNow, Time.FORMAT_SHORT) : Gregorian.info(oTimeNow, Time.FORMAT_SHORT);
    self.oRezValueTime.setText(Lang.format("$1$:$2$ $3$", [oTimeInfo.hour.format("%02d"), oTimeInfo.min.format("%02d"), $.oMySettings.sUnitTime]));

    // Set field values
    if($.iMyViewIndex == 0) {
      self.oRezDrawable.setDividers(MyDrawable.DRAW_DIVIDER_HORIZONTAL | MyDrawable.DRAW_DIVIDER_VERTICAL_TOP | MyDrawable.DRAW_DIVIDER_VERTICAL_BOTTOM);
      // ... sunrise/sunset
      self.oRezLabelTop.setText(Ui.loadResource(Rez.Strings.labelSunriseSunset));
      if($.oMyAlmanac.iEpochSunrise != null and $.oMyAlmanac.iEpochSunset != null) {
        self.oRezValueTopLeft.setText(self.stringTime($.oMyAlmanac.iEpochSunrise, true));
        self.oRezValueTopRight.setText(self.stringTime($.oMyAlmanac.iEpochSunset, true));
      }
      else {
        self.oRezValueTopLeft.setText(self.NOVALUE_LEN3);
        self.oRezValueTopRight.setText(self.NOVALUE_LEN3);
      }
      // ... civil dawn/dusk
      self.oRezLabelBottom.setText(Ui.loadResource(Rez.Strings.labelCivilDawnDusk));
      if($.oMyAlmanac.iEpochCivilDawn != null and $.oMyAlmanac.iEpochCivilDusk != null) {
        self.oRezValueBottomLeft.setText(self.stringTime($.oMyAlmanac.iEpochCivilDawn, true));
        self.oRezValueBottomRight.setText(self.stringTime($.oMyAlmanac.iEpochCivilDusk, true));
      }
      else {
        self.oRezValueBottomLeft.setText(self.NOVALUE_LEN3);
        self.oRezValueBottomRight.setText(self.NOVALUE_LEN3);
      }
      // ... clear previous view fields
      self.oRezValueTopHigh.setText(self.NOVALUE_BLANK);
      self.oRezValueTopLow.setText(self.NOVALUE_BLANK);
      self.oRezValueBottomHigh.setText(self.NOVALUE_BLANK);
      self.oRezValueBottomLow.setText(self.NOVALUE_BLANK);
    }
    else if($.iMyViewIndex == 1) {
      self.oRezDrawable.setDividers(0);
      // ... location
      self.oRezLabelTop.setText(Ui.loadResource(Rez.Strings.labelLocation));
      if($.oMyAlmanac.sLocationName != null) {
        self.oRezValueTopHigh.setText($.oMyAlmanac.sLocationName);
      }
      else {
        self.oRezValueTopHigh.setText(self.NOVALUE_LEN3);
      }
      if($.oMyAlmanac.dLocationLatitude != null and $.oMyAlmanac.dLocationLongitude != null) {
        self.oRezValueTopLow.setText(self.stringLatitude($.oMyAlmanac.dLocationLatitude));
        self.oRezValueBottomHigh.setText(self.stringLongitude($.oMyAlmanac.dLocationLongitude));
      }
      else {
        self.oRezValueTopLow.setText(self.NOVALUE_BLANK);
        self.oRezValueBottomHigh.setText(self.NOVALUE_BLANK);
      }
      if($.oMyAlmanac.fLocationHeight != null) {
        self.oRezValueBottomLow.setText(self.stringHeight($.oMyAlmanac.fLocationHeight));
      }
      else {
        self.oRezValueBottomLow.setText(self.NOVALUE_LEN3);
      }
      self.oRezLabelBottom.setText(Ui.loadResource(Rez.Strings.labelHeight));
      // ... clear previous view fields
      self.oRezValueTopLeft.setText(self.NOVALUE_BLANK);
      self.oRezValueTopRight.setText(self.NOVALUE_BLANK);
      self.oRezValueBottomLeft.setText(self.NOVALUE_BLANK);
      self.oRezValueBottomRight.setText(self.NOVALUE_BLANK);
    }
  }

  function stringTime(_iEpochTimestamp, _bRoundUp) {
    // Components
    var oTime = new Time.Moment(_iEpochTimestamp);
    var oTimeInfo;
    if($.oMySettings.bTimeUTC) {
      oTimeInfo = Gregorian.utcInfo(oTime, Time.FORMAT_SHORT);
    }
    else {
      oTimeInfo = Gregorian.info(oTime, Time.FORMAT_SHORT);
    }
    var iTime_hour = oTimeInfo.hour;
    var iTime_min = oTimeInfo.min;
    // ... round minutes up
    if(_bRoundUp and oTimeInfo.sec >= 30) {
      iTime_min += 1;
      if(iTime_min >= 60) {
        iTime_min -= 60;
        iTime_hour += 1;
        if(iTime_hour >= 24) {
          iTime_hour -= 24;
        }
      }
    }

    // String
    return Lang.format("$1$:$2$", [iTime_hour.format("%d"), iTime_min.format("%02d")]);
  }

  function stringLatitude(_dLatitude) {
    // Split components
    var iLatitude_qua = _dLatitude < 0.0d ? -1 : 1;
    _dLatitude = _dLatitude.abs();
    var iLatitude_deg = _dLatitude.toNumber();
    _dLatitude = (_dLatitude - iLatitude_deg) * 60.0d;
    var iLatitude_min = _dLatitude.toNumber();
    _dLatitude = (_dLatitude - iLatitude_min) * 60.0d + 0.5d;
    var iLatitude_sec = _dLatitude.toNumber();
    if(iLatitude_sec >= 60) {
      iLatitude_sec = 59;
    }

    // String
    return Lang.format("$1$°$2$'$3$\" $4$", [iLatitude_deg.format("%d"), iLatitude_min.format("%02d"), iLatitude_sec.format("%02d"), iLatitude_qua < 0 ? "S" : "N"]);
  }

  function stringLongitude(_dLongitude) {
    // Split components
    var iLongitude_qua = _dLongitude < 0.0d ? -1 : 1;
    _dLongitude = _dLongitude.abs();
    var iLongitude_deg = _dLongitude.toNumber();
    _dLongitude = (_dLongitude - iLongitude_deg) * 60.0d;
    var iLongitude_min = _dLongitude.toNumber();
    _dLongitude = (_dLongitude - iLongitude_min) * 60.0d + 0.5d;
    var iLongitude_sec = _dLongitude.toNumber();
    if(iLongitude_sec >= 60) {
      iLongitude_sec = 59;
    }

    // String
    return Lang.format("$1$°$2$'$3$\" $4$", [iLongitude_deg.format("%d"), iLongitude_min.format("%02d"), iLongitude_sec.format("%02d"), iLongitude_qua < 0 ? "W" : "E"]);
  }

  function stringHeight(_fHeight) {
    var fValue = _fHeight * $.oMySettings.fUnitElevationConstant;
    return Lang.format("$1$ $2$", [fValue.format("%.0f"), $.oMySettings.sUnitElevation]);
  }

}

class MyViewDelegate extends Ui.BehaviorDelegate {

  function initialize() {
    BehaviorDelegate.initialize();
  }

  function onMenu() {
    //Sys.println("DEBUG: MyViewDelegate.onMenu()");
    Ui.pushView(new MenuSettings(), new MenuSettingsDelegate(), Ui.SLIDE_IMMEDIATE);
    return true;
  }

  function onSelect() {
    //Sys.println("DEBUG: MyViewDelegate.onSelect()");
    $.iMyViewIndex = ( $.iMyViewIndex + 1 ) % 2;
    Ui.requestUpdate();
    return true;
  }

}
