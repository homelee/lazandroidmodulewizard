unit Laz_And_Controls_Events;    //by jmpessoa

{$mode delphi}

interface

uses
   Classes, SysUtils, And_jni;

   procedure Java_Event_pOnBluetoothEnabled(env: PJNIEnv; this: jobject; Obj: TObject);
   procedure Java_Event_pOnBluetoothDisabled(env: PJNIEnv; this: jobject; Obj: TObject);
   procedure Java_Event_pOnBluetoothDeviceFound(env: PJNIEnv; this: jobject; Obj: TObject; deviceName: JString; deviceAddress: JString );
   procedure Java_Event_pOnBluetoothDiscoveryStarted(env: PJNIEnv; this: jobject; Obj: TObject);
   procedure Java_Event_pOnBluetoothDiscoveryFinished(env: PJNIEnv; this: jobject; Obj: TObject; countFoundedDevices: integer; countPairedDevices: integer);
   procedure Java_Event_pOnBluetoothDeviceBondStateChanged(env: PJNIEnv; this: jobject; Obj: TObject; state: integer; deviceName: JString; deviceAddress: JString);

   procedure Java_Event_pOnBluetoothClientSocketConnected(env: PJNIEnv; this: jobject; Obj: TObject; deviceName: JString; deviceAddress: JString);
   procedure Java_Event_pOnBluetoothClientSocketIncomingMessage(env: PJNIEnv; this: jobject; Obj: TObject; messageText: JString);
   procedure Java_Event_pOnBluetoothClientSocketWritingMessage(env: PJNIEnv; this: jobject; Obj: TObject);

   procedure Java_Event_pOnBluetoothServerSocketConnected(env: PJNIEnv; this: jobject; Obj: TObject; deviceName: JString; deviceAddress: JString);
   procedure Java_Event_pOnBluetoothServerSocketIncomingMessage(env: PJNIEnv; this: jobject; Obj: TObject; messageText: JString);
   procedure Java_Event_pOnBluetoothServerSocketWritingMessage(env: PJNIEnv; this: jobject; Obj: TObject);
   procedure Java_Event_pOnBluetoothServerSocketListen(env: PJNIEnv; this: jobject; Obj: TObject; deviceName: JString; deviceAddress: JString);
   procedure Java_Event_pOnBluetoothServerSocketAccept(env: PJNIEnv; this: jobject; Obj: TObject; deviceName: JString; deviceAddress: JString);
   procedure Java_Event_pOnSpinnerItemSeleceted(env: PJNIEnv; this: jobject; Obj: TObject; position: integer; caption: JString);

   procedure Java_Event_pOnLocationChanged(env: PJNIEnv; this: jobject; Obj: TObject; latitude: JDouble; longitude: JDouble; altitude: JDouble; address: JString);
   procedure Java_Event_pOnLocationStatusChanged(env: PJNIEnv; this: jobject; Obj: TObject; status: integer; provider: JString; msgStatus: JString);
   procedure Java_Event_pOnLocationProviderEnabled(env: PJNIEnv; this: jobject; Obj: TObject; provider:JString);
   procedure Java_Event_pOnLocationProviderDisabled(env: PJNIEnv; this: jobject; Obj: TObject; provider: JString);

   Procedure Java_Event_pOnActionBarTabSelected(env: PJNIEnv; this: jobject; Obj: TObject; view: jObject; title: jString);
   Procedure Java_Event_pOnActionBarTabUnSelected(env: PJNIEnv; this: jobject; Obj: TObject; view:jObject; title: jString);
   Procedure Java_Event_pOnCustomDialogShow(env: PJNIEnv; this: jobject; Obj: TObject; dialog:jObject; title: jString);

   Procedure Java_Event_pOnClickToggleButton(env: PJNIEnv; this: jobject; Obj: TObject; state: boolean);

   Procedure Java_Event_pOnChangeSwitchButton(env: PJNIEnv; this: jobject; Obj: TObject; state: boolean);
   Procedure Java_Event_pOnClickGridItem(env: PJNIEnv; this: jobject; Obj: TObject; position: integer; caption: JString);

   Procedure Java_Event_pOnChangedSensor(env: PJNIEnv; this: jobject; Obj: TObject; sensor: JObject; sensorType: integer; values: JObject; timestamp: jLong);
   Procedure Java_Event_pOnListeningSensor(env: PJNIEnv; this: jobject; Obj: TObject; sensor: jObject; sensorType: integer);

   Procedure Java_Event_pOnUnregisterListeningSensor(env: PJNIEnv; this: jobject; Obj: TObject; sensorType: integer; sensorName: JString);
   Procedure Java_Event_pOnBroadcastReceiver(env: PJNIEnv; this: jobject; Obj: TObject; intent:jObject);

   Procedure Java_Event_pOnTimePicker(env: PJNIEnv; this: jobject; Obj: TObject; hourOfDay: integer; minute: integer);
   Procedure Java_Event_pOnDatePicker(env: PJNIEnv; this: jobject; Obj: TObject; year: integer; monthOfYear: integer; dayOfMonth: integer);

   Procedure Java_Event_pOnShellCommandExecuted(env: PJNIEnv; this: jobject; Obj: TObject; cmdResult: jString);
   Procedure Java_Event_pOnTCPSocketClientMessageReceived(env: PJNIEnv; this: jobject; Obj: TObject; messagesReceived: JStringArray);
   Procedure Java_Event_pOnTCPSocketClientConnected(env: PJNIEnv; this: jobject; Obj: TObject);

implementation

uses

   AndroidWidget, bluetooth, bluetoothclientsocket, bluetoothserversocket,
   spinner, location, actionbartab, customdialog, togglebutton, switchbutton, gridview,
   sensormanager, broadcastreceiver, datepickerdialog, timepickerdialog, shellcommand, tcpsocketclient;

procedure Java_Event_pOnBluetoothEnabled(env: PJNIEnv; this: jobject; Obj: TObject);
begin
  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;
  if Obj is jBluetooth then
  begin
    jForm(jBluetooth(Obj).Owner).UpdateJNI(gApp);
    jBluetooth(Obj).GenEvent_OnBluetoothEnabled(Obj);
  end;
end;

procedure Java_Event_pOnBluetoothDisabled(env: PJNIEnv; this: jobject; Obj: TObject);
begin
  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;
  if Obj is jBluetooth then
  begin
    jForm(jBluetooth(Obj).Owner).UpdateJNI(gApp);
    jBluetooth(Obj).GenEvent_OnBluetoothDisabled(Obj);
  end;
end;

Procedure Java_Event_pOnBluetoothDeviceFound(env: PJNIEnv; this: jobject; Obj: TObject; deviceName: JString; deviceAddress: JString );
var
 pasStrName, pasStrAddress: string;
 _jBoolean: JBoolean;
begin
  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;

  if Obj is jBluetooth then
  begin
    jForm(jBluetooth(Obj).Owner).UpdateJNI(gApp);
    pasStrName := '';
    if deviceName <> nil then
    begin
      _jBoolean:= JNI_False;
      pasStrName:= string( env^.GetStringUTFChars(Env,deviceName,@_jBoolean) );
    end;
    pasStrAddress := '';
    if deviceAddress <> nil then
    begin
      _jBoolean := JNI_False;
      pasStrAddress:= string( env^.GetStringUTFChars(Env,deviceAddress,@_jBoolean) );
    end;
    jBluetooth(Obj).GenEvent_OnBluetoothDeviceFound(Obj, pasStrName, pasStrAddress);
  end;

end;

procedure Java_Event_pOnBluetoothDiscoveryStarted(env: PJNIEnv; this: jobject; Obj: TObject);
begin
  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;
  if Obj is jBluetooth then
  begin
    jForm(jBluetooth(Obj).Owner).UpdateJNI(gApp);
    jBluetooth(Obj).GenEvent_OnBluetoothDiscoveryStarted(Obj);
  end;
end;

procedure Java_Event_pOnBluetoothDiscoveryFinished(env: PJNIEnv; this: jobject; Obj: TObject; countFoundedDevices: integer; countPairedDevices: integer);
begin
  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;
  if Obj is jBluetooth then
  begin
    jForm(jBluetooth(Obj).Owner).UpdateJNI(gApp);
    jBluetooth(Obj).GenEvent_OnBluetoothDiscoveryFinished(Obj, countFoundedDevices, countPairedDevices);
  end;
end;

procedure Java_Event_pOnBluetoothDeviceBondStateChanged(env: PJNIEnv; this: jobject; Obj: TObject; state: integer; deviceName: JString; deviceAddress: JString);
var
 pasStrName, pasStrAddress: string;
 _jBoolean: JBoolean;
begin
  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;

  if Obj is jBluetooth then
  begin
    jForm(jBluetooth(Obj).Owner).UpdateJNI(gApp);
    pasStrName := '';
    if deviceName <> nil then
    begin
      _jBoolean:= JNI_False;
      pasStrName:= string( env^.GetStringUTFChars(Env,deviceName,@_jBoolean) );
    end;
    pasStrAddress := '';
    if deviceAddress <> nil then
    begin
      _jBoolean := JNI_False;
      pasStrAddress:= string( env^.GetStringUTFChars(Env,deviceAddress,@_jBoolean) );
    end;
    jBluetooth(Obj).GenEvent_OnBluetoothDeviceBondStateChanged(Obj, state, pasStrName, pasStrAddress);
  end;

end;

procedure Java_Event_pOnBluetoothClientSocketIncomingMessage(env: PJNIEnv; this: jobject; Obj: TObject; messageText: JString);
var
  pasStrText: string;
  _jBoolean: JBoolean;
begin
  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;
  if Obj is jBluetoothClientSocket then
  begin
    jForm(jBluetoothClientSocket(Obj).Owner).UpdateJNI(gApp);
    pasStrText := '';
    if messageText <> nil then
    begin
      _jBoolean:= JNI_False;
      pasStrText:= string( env^.GetStringUTFChars(Env,messageText,@_jBoolean) );
    end;
    jBluetoothClientSocket(Obj).GenEvent_OnBluetoothClientSocketIncomingMessage(Obj,pasStrText);
  end;
end;

procedure Java_Event_pOnBluetoothClientSocketWritingMessage(env: PJNIEnv; this: jobject; Obj: TObject);
begin
  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;
  if Obj is jBluetoothClientSocket then
  begin
    jForm(jBluetoothClientSocket(Obj).Owner).UpdateJNI(gApp);
    jBluetoothClientSocket(Obj).GenEvent_OnBluetoothClientSocketWritingMessage(Obj);;
  end;
end;

procedure Java_Event_pOnBluetoothClientSocketConnected(env: PJNIEnv; this: jobject; Obj: TObject; deviceName: JString; deviceAddress: JString);
var
 pasStrName, pasStrAddress: string;
 _jBoolean: JBoolean;
begin
  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;

  if Obj is jBluetoothClientSocket then
  begin
    jForm(jBluetoothClientSocket(Obj).Owner).UpdateJNI(gApp);
    pasStrName := '';
    if deviceName <> nil then
    begin
      _jBoolean:= JNI_False;
      pasStrName:= string( env^.GetStringUTFChars(Env,deviceName,@_jBoolean) );
    end;
    pasStrAddress := '';
    if deviceAddress <> nil then
    begin
      _jBoolean := JNI_False;
      pasStrAddress:= string( env^.GetStringUTFChars(Env,deviceAddress,@_jBoolean) );
    end;
    jBluetoothClientSocket(Obj).GenEvent_OnBluetoothClientSocketConnected(Obj, pasStrName, pasStrAddress);
  end;

end;

procedure Java_Event_pOnBluetoothServerSocketConnected(env: PJNIEnv; this: jobject; Obj: TObject; deviceName: JString; deviceAddress: JString);
var
 pasStrName, pasStrAddress: string;
 _jBoolean: JBoolean;
begin
  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;

  if Obj is jBluetoothServerSocket then
  begin
    jForm(jBluetoothServerSocket(Obj).Owner).UpdateJNI(gApp);
    pasStrName := '';
    if deviceName <> nil then
    begin
      _jBoolean:= JNI_False;
      pasStrName:= string( env^.GetStringUTFChars(Env,deviceName,@_jBoolean) );
    end;
    pasStrAddress := '';
    if deviceAddress <> nil then
    begin
      _jBoolean := JNI_False;
      pasStrAddress:= string( env^.GetStringUTFChars(Env,deviceAddress,@_jBoolean) );
    end;
    jBluetoothServerSocket(Obj).GenEvent_OnBluetoothServerSocketConnected(Obj, pasStrName, pasStrAddress);
  end;

end;


procedure Java_Event_pOnBluetoothServerSocketIncomingMessage(env: PJNIEnv; this: jobject; Obj: TObject; messageText: JString);
var
  pasStrText: string;
  _jBoolean: JBoolean;
begin
  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;
  if Obj is jBluetoothServerSocket then
  begin
    jForm(jBluetoothServerSocket(Obj).Owner).UpdateJNI(gApp);
    pasStrText := '';
    if messageText <> nil then
    begin
      _jBoolean:= JNI_False;
      pasStrText:= string( env^.GetStringUTFChars(Env,messageText,@_jBoolean) );
    end;
    jBluetoothServerSocket(Obj).GenEvent_OnBluetoothServerSocketIncomingMessage(Obj,pasStrText);
  end;
end;

procedure Java_Event_pOnBluetoothServerSocketWritingMessage(env: PJNIEnv; this: jobject; Obj: TObject);
begin
  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;
  if Obj is jBluetoothServerSocket then
  begin
    jForm(jBluetoothServerSocket(Obj).Owner).UpdateJNI(gApp);
    jBluetoothServerSocket(Obj).GenEvent_OnBluetoothServerSocketWritingMessage(Obj);;
  end;
end;

procedure Java_Event_pOnBluetoothServerSocketListen(env: PJNIEnv; this: jobject; Obj: TObject; deviceName: JString; deviceAddress: JString);
var
 pasStrName, pasStrAddress: string;
 _jBoolean: JBoolean;
begin
  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;

  if Obj is jBluetoothServerSocket then
  begin
    jForm(jBluetoothServerSocket(Obj).Owner).UpdateJNI(gApp);
    pasStrName := '';
    if deviceName <> nil then
    begin
      _jBoolean:= JNI_False;
      pasStrName:= string( env^.GetStringUTFChars(Env,deviceName,@_jBoolean) );
    end;
    pasStrAddress := '';
    if deviceAddress <> nil then
    begin
      _jBoolean := JNI_False;
      pasStrAddress:= string( env^.GetStringUTFChars(Env,deviceAddress,@_jBoolean) );
    end;
    jBluetoothServerSocket(Obj).GenEvent_OnBluetoothServerSocketListen(Obj, pasStrName, pasStrAddress);
  end;
end;

procedure Java_Event_pOnBluetoothServerSocketAccept(env: PJNIEnv; this: jobject; Obj: TObject; deviceName: JString; deviceAddress: JString);
var
 pasStrName, pasStrAddress: string;
 _jBoolean: JBoolean;
begin
  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;

  if Obj is jBluetoothServerSocket then
  begin
    jForm(jBluetoothServerSocket(Obj).Owner).UpdateJNI(gApp);
    pasStrName := '';
    if deviceName <> nil then
    begin
      _jBoolean:= JNI_False;
      pasStrName:= string( env^.GetStringUTFChars(Env,deviceName,@_jBoolean) );
    end;
    pasStrAddress := '';
    if deviceAddress <> nil then
    begin
      _jBoolean := JNI_False;
      pasStrAddress:= string( env^.GetStringUTFChars(Env,deviceAddress,@_jBoolean) );
    end;
    jBluetoothServerSocket(Obj).GenEvent_OnBluetoothServerSocketAccept(Obj, pasStrName, pasStrAddress);
  end;
end;

procedure Java_Event_pOnSpinnerItemSeleceted(env: PJNIEnv; this: jobject; Obj: TObject; position: integer; caption: JString);
var
 pasCaption: string;
 _jBoolean: JBoolean;
begin
  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;

  if Obj is jSpinner then
  begin
    jForm(jSpinner(Obj).Owner).UpdateJNI(gApp);
    pasCaption := '';
    if caption <> nil then
    begin
      _jBoolean:= JNI_False;
      pasCaption:= string( env^.GetStringUTFChars(Env,caption,@_jBoolean) );
    end;
    jSpinner(Obj).GenEvent_OnSpinnerItemSeleceted(Obj, pasCaption, position);
  end;
end;

procedure Java_Event_pOnLocationChanged(env: PJNIEnv; this: jobject; Obj: TObject; latitude: JDouble; longitude: JDouble; altitude: JDouble; address: JString);
var
  pasaddress: string;
 _jBoolean: JBoolean;
begin
  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;

  if Obj is jLocation then
  begin
    jForm(jLocation(Obj).Owner).UpdateJNI(gApp);
    pasaddress:='';

    if address <> nil then
    begin
      _jBoolean:= JNI_False;
      pasaddress:= string( env^.GetStringUTFChars(Env,address,@_jBoolean) );
    end;

    jLocation(Obj).GenEvent_OnLocationChanged(Obj, latitude, longitude, altitude, pasaddress);
  end;
end;

procedure Java_Event_pOnLocationStatusChanged(env: PJNIEnv; this: jobject; Obj: TObject; status: integer; provider: JString; msgStatus: JString);
var
 pasmsgStatus, pasprovider: string;
 _jBoolean: JBoolean;
begin
  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;

  if Obj is jLocation then
  begin
    jForm(jLocation(Obj).Owner).UpdateJNI(gApp);
    pasmsgStatus:= '';
    pasprovider:= '';
    if provider <> nil then
    begin
      _jBoolean:= JNI_False;
      pasprovider:= string( env^.GetStringUTFChars(Env,provider,@_jBoolean) );
    end;

    if msgStatus <> nil then
    begin
      _jBoolean:= JNI_False;
      pasmsgStatus:= string( env^.GetStringUTFChars(Env,msgStatus,@_jBoolean) );
    end;

    jLocation(Obj).GenEvent_OnLocationStatusChanged(Obj, status, pasprovider, pasmsgStatus);
  end;
end;

procedure Java_Event_pOnLocationProviderEnabled(env: PJNIEnv; this: jobject; Obj: TObject; provider:JString);
var
 pasprovider: string;
 _jBoolean: JBoolean;
begin
  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;

  if Obj is jLocation then
  begin
    jForm(jLocation(Obj).Owner).UpdateJNI(gApp);
    pasprovider := '';
    if provider <> nil then
    begin
      _jBoolean:= JNI_False;
      pasprovider:= string( env^.GetStringUTFChars(Env,provider,@_jBoolean) );
    end;
    jLocation(Obj).GenEvent_OnLocationProviderEnabled(Obj, pasprovider);
  end;
end;

procedure Java_Event_pOnLocationProviderDisabled(env: PJNIEnv; this: jobject; Obj: TObject; provider: JString);
var
 pasprovider: string;
 _jBoolean: JBoolean;
begin
  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;

  if Obj is jLocation then
  begin
    jForm(jLocation(Obj).Owner).UpdateJNI(gApp);
    pasprovider := '';
    if provider <> nil then
    begin
      _jBoolean:= JNI_False;
      pasprovider:= string( env^.GetStringUTFChars(Env,provider,@_jBoolean) );
    end;
    jLocation(Obj).GenEvent_OnLocationProviderDisabled(Obj, pasprovider);
  end;
end;

Procedure Java_Event_pOnActionBarTabSelected(env: PJNIEnv; this: jobject; Obj: TObject; view: jObject; title: jString);
var
  pastitle: string;
  _jBoolean: JBoolean;
begin
  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;
  if Obj is jActionBarTab then
  begin
    jForm(jActionBarTab(Obj).Owner).UpdateJNI(gApp);
    pastitle:= '';
    if title <> nil then
    begin
      _jBoolean:= JNI_False;
      pastitle:= string( env^.GetStringUTFChars(Env, title,@_jBoolean) );
    end;
    jActionBarTab(Obj).GenEvent_OnActionBarTabSelected(Obj, view, pastitle);
  end;
end;

Procedure Java_Event_pOnActionBarTabUnSelected(env: PJNIEnv; this: jobject; Obj: TObject; view:jObject; title: jString);
var
   pastitle: string;
  _jBoolean: JBoolean;
begin
  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;
  if Obj is jActionBarTab then
  begin
    jForm(jActionBarTab(Obj).Owner).UpdateJNI(gApp);
    pastitle:= '';
    if title <> nil then
    begin
      _jBoolean:= JNI_False;
      pastitle:= string(env^.GetStringUTFChars(Env, title,@_jBoolean) );
    end;
    jActionBarTab(Obj).GenEvent_OnActionBarTabUnSelected(Obj, view, pastitle);
  end;
end;

Procedure Java_Event_pOnCustomDialogShow(env: PJNIEnv; this: jobject; Obj: TObject; dialog:jObject; title: jString);
var
   pastitle: string;
  _jBoolean: JBoolean;
begin
  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;
  if Obj is jCustomDialog then
  begin
    jForm(jCustomDialog(Obj).Owner).UpdateJNI(gApp);
    pastitle:= '';
    if title <> nil then
    begin
      _jBoolean:= JNI_False;
      pastitle:= string(env^.GetStringUTFChars(Env, title,@_jBoolean) );
    end;
    jCustomDialog(Obj).GenEvent_OnCustomDialogShow(Obj, dialog, pastitle);
  end;
end;

Procedure Java_Event_pOnClickToggleButton(env: PJNIEnv; this: jobject; Obj: TObject; state: boolean);
begin
  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;
  if Obj is jToggleButton then
  begin
    jForm(jLocation(Obj).Owner).UpdateJNI(gApp);
    jToggleButton(Obj).GenEvent_OnClickToggleButton(Obj, state);
  end;
end;

Procedure Java_Event_pOnChangeSwitchButton(env: PJNIEnv; this: jobject; Obj: TObject; state: boolean);
begin
  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;
  if Obj is jSwitchButton then
  begin
    jForm(jLocation(Obj).Owner).UpdateJNI(gApp);
    jSwitchButton(Obj).GenEvent_OnChangeSwitchButton(Obj, state);
  end;
end;

Procedure Java_Event_pOnClickGridItem(env: PJNIEnv; this: jobject; Obj: TObject; position: integer; caption: JString);
var
   pasCaption: string;
  _jBoolean: JBoolean;
begin
  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;
  if Obj is jGridView then
  begin
    jForm(jLocation(Obj).Owner).UpdateJNI(gApp);
    pasCaption:= '';
    if caption <> nil then
    begin
      _jBoolean:= JNI_False;
      pasCaption:= string(env^.GetStringUTFChars(Env, caption,@_jBoolean) );
    end;
    jGridView(Obj).GenEvent_OnClickGridItem(Obj, position, pasCaption);
  end;
end;


Procedure Java_Event_pOnChangedSensor(env: PJNIEnv; this: jobject; Obj: TObject; sensor: JObject; sensorType: integer; values: JObject; timestamp: jLong);
var
  sizeArray: integer;
  arrayResult: array of single;
begin

  sizeArray:=  env^.GetArrayLength(env, values);
  SetLength(arrayResult, sizeArray);
  env^.GetFloatArrayRegion(env, values, 0, sizeArray, @arrayResult[0] {target});

  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;
  if Obj is jSensorManager then
  begin
    jForm(jLocation(Obj).Owner).UpdateJNI(gApp);
    jSensorManager(Obj).GenEvent_OnChangedSensor(Obj, sensor, sensorType, arrayResult, timestamp{sizeArray});
  end;

end;

Procedure Java_Event_pOnListeningSensor(env: PJNIEnv; this: jobject; Obj: TObject; sensor: jObject; sensorType: integer);
begin
  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;
  if Obj is jSensorManager then
  begin
    jForm(jLocation(Obj).Owner).UpdateJNI(gApp);
    jSensorManager(Obj).GenEvent_OnListeningSensor(Obj, sensor, sensorType);
  end;
end;

Procedure Java_Event_pOnUnregisterListeningSensor(env: PJNIEnv; this: jobject; Obj: TObject; sensorType: integer; sensorName: JString);
var
   pasSensorName: string;
  _jBoolean: JBoolean;
begin
  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;
  if Obj is jSensorManager then
  begin
    jForm(jLocation(Obj).Owner).UpdateJNI(gApp);
    pasSensorName:= '';
    if sensorName <> nil then
    begin
      _jBoolean:= JNI_False;
      pasSensorName:= string(env^.GetStringUTFChars(Env, sensorName,@_jBoolean) );
    end;
    jSensorManager(Obj).GenEvent_OnUnregisterListeningSensor(Obj, sensorType, pasSensorName);
  end;
end;

Procedure Java_Event_pOnBroadcastReceiver(env: PJNIEnv; this: jobject; Obj: TObject; intent:jObject);
begin
  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;
  if Obj is jBroadcastReceiver then
  begin
    jForm(jBroadcastReceiver(Obj).Owner).UpdateJNI(gApp);
    jBroadcastReceiver(Obj).GenEvent_OnBroadcastReceiver(Obj,  intent);
  end;
end;


Procedure Java_Event_pOnTimePicker(env: PJNIEnv; this: jobject; Obj: TObject; hourOfDay: integer; minute: integer);
begin
  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;
  if Obj is jTimePickerDialog then
  begin
    jForm(jTimePickerDialog(Obj).Owner).UpdateJNI(gApp);
    jTimePickerDialog(Obj).GenEvent_OnTimePicker(Obj, hourOfDay, minute);
  end;
end;

Procedure Java_Event_pOnDatePicker(env: PJNIEnv; this: jobject; Obj: TObject; year: integer; monthOfYear: integer; dayOfMonth: integer);
begin
  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;
  if Obj is jDatePickerDialog then
  begin
    jForm(jDatePickerDialog(Obj).Owner).UpdateJNI(gApp);
    jDatePickerDialog(Obj).GenEvent_OnDatePicker(Obj,  year, monthOfYear, dayOfMonth);
  end;
end;

Procedure Java_Event_pOnShellCommandExecuted(env: PJNIEnv; this: jobject; Obj: TObject; cmdResult: jString);
var
   pascmdResult: string;
  _jBoolean: JBoolean;
begin
  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;
  if Obj is jShellCommand then
  begin
    jForm(jShellCommand(Obj).Owner).UpdateJNI(gApp);
    pascmdResult:= '';
    if cmdResult <> nil then
    begin
      _jBoolean:= JNI_False;
      pascmdResult:= string(env^.GetStringUTFChars(Env, cmdResult,@_jBoolean) );
    end;
    jShellCommand(Obj).GenEvent_OnShellCommandExecuted(Obj, pascmdResult);
  end;
end;

Procedure Java_Event_pOnTCPSocketClientMessageReceived(env: PJNIEnv; this: jobject; Obj: TObject; messagesReceived: JStringArray);
var
   pasmessagesReceived: array of string;
   i, messageSize: integer;
   jStr: jObject;
   jBoo: jBoolean;
begin
  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;
  if Obj is jTCPSocketClient then
  begin
    jForm(jTCPSocketClient(Obj).Owner).UpdateJNI(gApp);
    if messagesReceived <> nil then
    begin
      messageSize:= env^.GetArrayLength(env, messagesReceived);
      SetLength(pasmessagesReceived, messageSize);
      for i:= 0 to messageSize - 1 do
      begin
        jStr:= env^.GetObjectArrayElement(env, messagesReceived, i);
        case jStr = nil of
           True : pasmessagesReceived[i]:= '';
           False: begin
                    jBoo:= JNI_False;
                    pasmessagesReceived[i]:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
                   end;
        end;
      end;
    end;
    jTCPSocketClient(Obj).GenEvent_OnTCPSocketClientMessagesReceived(Obj, pasmessagesReceived);
  end;
end;


Procedure Java_Event_pOnTCPSocketClientConnected(env: PJNIEnv; this: jobject; Obj: TObject);
begin
  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;
  if Obj is jTCPSocketClient then
  begin
    jForm(jBluetooth(Obj).Owner).UpdateJNI(gApp);
    jTCPSocketClient(Obj).GenEvent_OnTCPSocketClientConnected(Obj);
  end;
end;


end.

