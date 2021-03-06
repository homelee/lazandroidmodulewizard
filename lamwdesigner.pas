unit LamwDesigner;

{$mode objfpc}{$h+}

interface

uses
  Classes, SysUtils, Graphics, Controls, FormEditingIntf, PropEdits,
  ComponentEditors, AndroidWidget;

type
  TDraftWidget = class;

  jVisualControlClass = class of jVisualControl;
  TDraftWidgetClass = class of TDraftWidget;

  { TDraftControlHash }

  TDraftControlHash = class
  private
    FFreeLeft: Integer;
    FItems: array of record
      VisualControl: jVisualControlClass;
      Draft: TDraftWidgetClass;
    end;
    function Hash1(c: TClass): PtrUInt; inline;
    function Hash2(i: PtrUInt): PtrUInt; inline;
  public
    constructor Create(MaxCapacity: Integer);
    procedure Add(VisualControlClass: jVisualControlClass; DraftWidgetClass: TDraftWidgetClass);
    function Find(VisualControlClass: TClass): TDraftWidgetClass;
  end;

  { TAndroidWidgetMediator :: thanks to x2nie !}

  TAndroidWidgetMediator = class(TDesignerMediator,IAndroidWidgetDesigner)
  private
    FDefaultBrushColor: TColor;
    FDefaultPenColor: TColor;
    FDefaultFontColor: TColor;
    FSizing: Boolean;
    FStarted, FDone: TFPList;
    FLastSelectedContainer: jVisualControl;
    FSelection: TFPList;
    function GetAndroidForm: jForm;
  protected
    procedure OnDesignerModified(Sender: TObject);
    procedure OnPersistentAdded(APersistent: TPersistent; Select: boolean);
    procedure OnSetSelection(const ASelection: TPersistentSelectionList);
  public
    //needed by the lazarus form editor
    class function CreateMediator(TheOwner, TheForm: TComponent): TDesignerMediator; override;
    class function FormClass: TComponentClass; override;

    procedure GetBounds(AComponent: TComponent; out CurBounds: TRect); override;
    procedure SetBounds(AComponent: TComponent; NewBounds: TRect); override;
    procedure GetClientArea(AComponent: TComponent; out CurClientArea: TRect; out ScrollOffset: TPoint); override;
    procedure InitComponent(AComponent, NewParent: TComponent; NewBounds: TRect); override;
    procedure Paint; override;
    function ComponentIsIcon(AComponent: TComponent): boolean; override;
    function ParentAcceptsChild(Parent: TComponent; Child: TComponentClass): boolean; override;

    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; p: TPoint; var Handled: boolean); override;
    //procedure MouseMove(Shift: TShiftState; p: TPoint; var Handled: boolean); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; p: TPoint; var Handled: boolean); override;
  public
    // needed by TAndroidWidget
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure InvalidateRect(Sender: TObject; ARect: TRect; Erase: boolean);
    property AndroidForm: jForm read GetAndroidForm;
  public
    procedure GetObjInspNodeImageIndex(APersistent: TPersistent; var AIndex: integer); override;
  end;


  { TDraftWidget }

  TDraftWidget = class
  private
    FColor: TARGBColorBridge;
    FFontColor: TARGBColorBridge;
    procedure SetColor(color: TARGBColorBridge);
    procedure SetFontColor(color: TARGBColorBridge);
    function Designer: TAndroidWidgetMediator;
  protected
    FAndroidWidget: TAndroidWidget;      // original
    FCanvas: TCanvas;                    // canvas to draw onto
    FnewW, FnewH, FnewL, FnewT: Integer; // layout
    FminW, FminH: Integer;
  public
    BackGroundColor: TColor;
    TextColor: TColor;
    MarginBottom: integer;
    MarginLeft: integer;
    MarginRight: integer;
    MarginTop: integer;
    Height: integer;
    Width: integer;
    constructor Create(AWidget: TAndroidWidget; Canvas: TCanvas); virtual;
    procedure Draw; virtual; abstract;
    procedure UpdateLayout; virtual;
    property Color: TARGBColorBridge read FColor write SetColor;
    property FontColor: TARGBColorBridge read FFontColor write SetFontColor;
  end;

  { TDraftTextView }

  TDraftTextView = class(TDraftWidget)
  public
    constructor Create(AWidget: TAndroidWidget; Canvas: TCanvas); override;
    procedure Draw; override;
    procedure UpdateLayout; override;
  end;

  { TDraftEditText }

  TDraftEditText = class(TDraftWidget)
  public
    constructor Create(AWidget: TAndroidWidget; Canvas: TCanvas); override;
    procedure Draw; override;
    procedure UpdateLayout; override;
  end;

  { TDraftButton }

  TDraftButton = class(TDraftWidget)
  public
    constructor Create(AWidget: TAndroidWidget; Canvas: TCanvas); override;
    procedure Draw; override;
    procedure UpdateLayout; override;
  end;

  { TDraftCheckBox }

  TDraftCheckBox = class(TDraftWidget)
  public
    constructor Create(AWidget: TAndroidWidget; Canvas: TCanvas); override;
    procedure Draw; override;
    procedure UpdateLayout; override;
  end;

  { TDraftRadioButton }

  TDraftRadioButton = class(TDraftWidget)
  public
    constructor Create(AWidget: TAndroidWidget; Canvas: TCanvas); override;
    procedure Draw; override;
    procedure UpdateLayout; override;
  end;

  { TDraftProgressBar }

  TDraftProgressBar = class(TDraftWidget)
  public
    constructor Create(AWidget: TAndroidWidget; Canvas: TCanvas); override;
    procedure Draw; override;
    procedure UpdateLayout; override;
  end;

  { TDraftListView }

  TDraftListView = class(TDraftWidget)
  public
    constructor Create(AWidget: TAndroidWidget; Canvas: TCanvas); override;
    procedure Draw; override;
  end;

  { TDraftImageBtn }

  TDraftImageBtn = class(TDraftWidget)
  public
    constructor Create(AWidget: TAndroidWidget; Canvas: TCanvas); override;
    procedure Draw; override;
  end;

  { TDraftSpinner }

  TDraftSpinner = class(TDraftWidget)
  private
    FDropListTextColor: TARGBColorBridge;
    DropListFontColor: TColor;

    FDropListBackgroundColor: TARGBColorBridge;
    DropListColor: TColor;

    FSelectedFontColor: TARGBColorBridge;
    SelectedTextColor: TColor;

    procedure SetDropListTextColor(Acolor: TARGBColorBridge);
    procedure SetDropListBackgroundColor(Acolor: TARGBColorBridge);
    procedure SetSelectedFontColor(Acolor: TARGBColorBridge);

  public
     constructor Create(AWidget: TAndroidWidget; Canvas: TCanvas); override;
     procedure Draw; override;

     property DropListTextColor: TARGBColorBridge read FDropListTextColor write SetDropListTextColor;
     property DropListBackgroundColor: TARGBColorBridge  read FDropListBackgroundColor write SetDropListBackgroundColor;
     property SelectedFontColor: TARGBColorBridge  read FSelectedFontColor write SetSelectedFontColor;
  end;

  { TDraftWebView }

  TDraftWebView = class(TDraftWidget)
  public
     constructor Create(AWidget: TAndroidWidget; Canvas: TCanvas); override;
     procedure Draw; override;
  end;

  { TDraftScrollView }

  TDraftScrollView = class(TDraftWidget)
  public
     constructor Create(AWidget: TAndroidWidget; Canvas: TCanvas); override;
     procedure Draw; override;
  end;

  { TDraftToggleButton }

  TDraftToggleButton = class(TDraftWidget)
  public
     OnOff: boolean;
     constructor Create(AWidget: TAndroidWidget; Canvas: TCanvas); override;
     procedure Draw; override;
  end;

  { TDraftSwitchButton }

  TDraftSwitchButton = class(TDraftWidget)
  public
    procedure Draw; override;
    procedure UpdateLayout; override;
  end;

  { TDraftGridView }

  TDraftGridView = class(TDraftWidget)
  public
     constructor Create(AWidget: TAndroidWidget; Canvas: TCanvas); override;
     procedure Draw; override;
  end;

  { TDraftPanel }

  TDraftPanel = class(TDraftWidget)
  public
    procedure Draw; override;
    procedure UpdateLayout; override;
  end;

  { TARGBColorBridgePropertyEditor }

  TARGBColorBridgePropertyEditor = class(TEnumPropertyEditor)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure ListDrawValue(const CurValue: ansistring; Index: integer;
      ACanvas: TCanvas; const ARect:TRect; AState: TPropEditDrawState); override;
    procedure PropDrawValue(ACanvas: TCanvas; const ARect: TRect;
      {%H-}AState: TPropEditDrawState); override;
  end;

  { TAnchorPropertyEditor }

  TAnchorPropertyEditor = class(TComponentOneFormPropertyEditor)
  public
    procedure GetValues(Proc: TGetStrProc); override;
  end;

  { TAndroidFormComponentEditor }

  TAndroidFormComponentEditor = class(TDefaultComponentEditor)
  private
    procedure ChangeSize(AWidth, AHeight: Integer);
    procedure ShowSelectSizeDialog;
  public
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;

implementation

uses
  LCLIntf, LCLType, ObjInspStrConsts, FPimage, typinfo, Laz_And_Controls,
  customdialog, togglebutton, switchbutton, Laz_And_GLESv1_Canvas,
  Laz_And_GLESv2_Canvas, gridview, Spinner, uFormSizeSelect;

var
  DraftClassesMap: TDraftControlHash;

procedure GetRedGreenBlue(rgb: longInt; out Red, Green, Blue: word); inline;
begin
  Red   := ( (rgb and $ff0000)  shr 16);
  Red   := Red shl 8 or Red;
  Green := ( (rgb and $ff00  )  shr  8);
  Green := Green shl 8 or Green;
  Blue  := ( (rgb and $ff)            );
  Blue  := Blue shl 8 or Blue;
end;

function ToTFPColor(colbrColor: TARGBColorBridge):  TFPColor;
var
    index: integer;
    red, green, blue: word;
begin
    index:= (Ord(colbrColor));
    GetRedGreenBlue(TFPColorBridgeArray[index], red, green, blue);
    Result.Red:=   red;
    Result.Green:= green;
    Result.Blue:=  blue;
    Result.Alpha:= AlphaOpaque;
end;

function AndroidToLCLFontSize(asize: DWord; Default: Integer): Integer; inline;
begin
  case asize of
  0: Result := Default;
  1: Result := 1;
  else Result := asize * 3 div 4;
  end;
end;

function BlendColors(c: TColor; alpha: Double; r, g, b: Byte): TColor; inline;
var
  r1, g1, b1: Byte;
begin
  RedGreenBlue(c, r1, g1, b1);
  Result := RGBToColor(Byte(Trunc(r1 * alpha + r * (1 - alpha))),
                       Byte(Trunc(g1 * alpha + g * (1 - alpha))),
                       Byte(Trunc(b1 * alpha + b * (1 - alpha))));
end;

procedure RegisterAndroidWidgetDraftClass(AWidgetClass: jVisualControlClass;
  ADraftClass: TDraftWidgetClass);
begin
  DraftClassesMap.Add(AWidgetClass, ADraftClass);
end;

{ TAndroidFormComponentEditor }

procedure TAndroidFormComponentEditor.ChangeSize(AWidth, AHeight: Integer);
begin
  with jForm(Component) do
  begin
    if Assigned(Designer) then
      with Designer as TAndroidWidgetMediator, LCLForm do
        SetBounds(Left, Top, AWidth, AHeight);
    SetBounds(Left, Top, AWidth, AHeight);
  end;
end;

procedure TAndroidFormComponentEditor.ShowSelectSizeDialog;
begin
  with TfrmFormSizeSelect.Create(nil) do
  try
    with jForm(Component) do
      SetInitSize(Width, Height);
    if ShowModal = mrOk then
      ChangeSize(seWidth.Value, seHeight.Value);
  finally
    Free
  end;
end;

procedure TAndroidFormComponentEditor.ExecuteVerb(Index: Integer);
begin
  case Index of
  0: // Rotate
    with jForm(Component) do
      ChangeSize(Height, Width);
  1: ShowSelectSizeDialog; // Select size
  else
    inherited ExecuteVerb(Index);
  end;
end;

function TAndroidFormComponentEditor.GetVerb(Index: Integer): string;
begin
  case Index of
  0: Result := 'Rotate';
  1: Result := 'Select size...';
  else
    Result := inherited;
  end
end;

function TAndroidFormComponentEditor.GetVerbCount: Integer;
begin
  Result := 2;
end;

{ TAnchorPropertyEditor }

procedure TAnchorPropertyEditor.GetValues(Proc: TGetStrProc);
var
  i, j: Integer;
  p: TAndroidWidget;
  sl: TStringList;
begin
  Proc(oisNone);
  p := jVisualControl(GetComponent(0)).Parent;
  for i := 1 to PropCount - 1 do
    if jVisualControl(GetComponent(i)).Parent <> p then
      Exit;
  sl := TStringList.Create;
  try
    for i := 0 to p.ChildCount - 1 do
      sl.Add(p.Children[i].Name);
    sl.Sorted := True;
    for i := 0 to PropCount - 1 do
    begin
      j := sl.IndexOf(TComponent(GetComponent(i)).Name);
      if j >= 0 then sl.Delete(j);
    end;
    for i := 0 to sl.Count - 1 do
      Proc(sl[i]);
  finally
    sl.Free;
  end;
end;

{ TDraftPanel }

procedure TDraftPanel.Draw;
begin
  with Fcanvas do
  begin
    if jPanel(FAndroidWidget).BackgroundColor <> colbrDefault then
      Brush.Color := FPColorToTColor(ToTFPColor(jPanel(FAndroidWidget).BackgroundColor))
    else begin
      Brush.Color:= clNone;
      Brush.Style:= bsClear;
    end;
    Rectangle(0, 0, FAndroidWidget.Width, FAndroidWidget.Height);    // outer frame
  end;
end;

procedure TDraftPanel.UpdateLayout;
var
  maxH, i, t: Integer;
begin
  with FAndroidWidget do
    if ChildCount > 0 then
    begin
      with Children[0] do
        maxH := Top + Height;
      for i := 1 to ChildCount - 1 do
        with Children[i] do
        begin
          t := Top + Height;
          if t > maxH then maxH := t;
        end;
      FnewH := maxH;
    end;
  inherited UpdateLayout;
end;

{ TDraftControlHash }

function TDraftControlHash.Hash1(c: TClass): PtrUInt;
begin
  Result := ({%H-}PtrUInt(c) + {%H-}PtrUInt(c) shr 7) mod PtrUInt(Length(FItems));
end;

function TDraftControlHash.Hash2(i: PtrUInt): PtrUInt;
begin
  Result := (i + 7) mod PtrUInt(Length(FItems));
end;

constructor TDraftControlHash.Create(MaxCapacity: Integer);
begin
  SetLength(FItems, MaxCapacity);
  FFreeLeft := MaxCapacity;
end;

procedure TDraftControlHash.Add(VisualControlClass: jVisualControlClass;
  DraftWidgetClass: TDraftWidgetClass);
var
  i: PtrUInt;
begin
  if FFreeLeft = 0 then
    raise Exception.Create('[DraftControlHash] Overfull!');
  i := Hash1(VisualControlClass);
  while FItems[i].VisualControl <> nil do
    i := Hash2(i);
  with FItems[i] do
  begin
    VisualControl := VisualControlClass;
    Draft := DraftWidgetClass;
  end;
  Dec(FFreeLeft);
end;

function TDraftControlHash.Find(VisualControlClass: TClass): TDraftWidgetClass;
var i: PtrUInt;
begin
  Result := nil;
  i := Hash1(VisualControlClass);
  if FItems[i].VisualControl = nil then Exit;
  while FItems[i].VisualControl <> VisualControlClass do
  begin
    i := Hash2(i);
    if FItems[i].VisualControl = nil then Exit;
  end;
  Result := FItems[i].Draft;
end;

{ TARGBColorBridgePropertyEditor }

function TARGBColorBridgePropertyEditor.GetAttributes: TPropertyAttributes;
begin
  Result := [paMultiSelect,paValueList,paCustomDrawn];
end;

procedure TARGBColorBridgePropertyEditor.ListDrawValue(const CurValue: ansistring;
  Index: integer; ACanvas: TCanvas; const ARect: TRect;
  AState: TPropEditDrawState);
var
  h: Integer;
  r: TRect;
  bc: TColor;
begin
  h := ARect.Bottom - ARect.Top;
  with ACanvas do
  begin
    FillRect(ARect);
    bc := Pen.Color;
    Pen.Color := clBlack;
    r := ARect;
    r.Right := r.Left + h;
    InflateRect(r, -2, -2);
    Rectangle(r);
    if (TARGBColorBridge(Index) in [colbrDefault, colbrCustom]) then
    begin
      InflateRect(r, -1, -1);
      MoveTo(r.Left, r.Top); LineTo(r.Right, r.Bottom);
      MoveTo(r.Right - 1, r.Top); LineTo(r.Left - 1, r.Bottom);
      Pen.Color := bc;
    end else begin
      Pen.Color := bc;
      bc := Brush.Color;
      Brush.Color := FPColorToTColor(ToTFPColor(TARGBColorBridge(Index)));
      InflateRect(r, -1, -1);
      FillRect(r);
      Brush.Color := bc;
    end;
  end;
  r := ARect;
  r.Left := r.Left + h + 2;
  inherited ListDrawValue(CurValue, Index, ACanvas, r, AState);
end;

procedure TARGBColorBridgePropertyEditor.PropDrawValue(ACanvas: TCanvas;
  const ARect: TRect; AState: TPropEditDrawState);
var
  s: string;
  i: Integer;
begin
  s := GetVisualValue;
  for i := 0 to Ord(High(TARGBColorBridge)) do
    if GetEnumName(TypeInfo(TARGBColorBridge), i) = s then
    begin
      ListDrawValue(s, i, ACanvas, ARect, [pedsInEdit]);
      Exit;
    end;
end;

{ TAndroidWidgetMediator }

constructor TAndroidWidgetMediator.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDefaultBrushColor:= clForm;
  FDefaultPenColor:= clMedGray;
  FDefaultFontColor:= clMedGray;
  GlobalDesignHook.AddHandlerModified(@OnDesignerModified);
  GlobalDesignHook.AddHandlerPersistentAdded(@OnPersistentAdded);
  GlobalDesignHook.AddHandlerSetSelection(@OnSetSelection);
  FStarted := TFPList.Create;
  FDone := TFPList.Create;
  FSelection := TFPList.Create;
end;

destructor TAndroidWidgetMediator.Destroy;
begin
  if Assigned(AndroidForm) then
    AndroidForm.Designer := nil;
  FSelection.Free;
  FStarted.Free;
  FDone.Free;
  if GlobalDesignHook <> nil then
    GlobalDesignHook.RemoveAllHandlersForObject(Self);
  inherited Destroy;
end;

procedure TAndroidWidgetMediator.OnDesignerModified(Sender: TObject);
var
  Instance: TPersistent;
  InvalidateNeeded: Boolean;
  i: Integer;
begin
  if not (Sender is TPropertyEditor) or (LCLForm = nil) then Exit;
  InvalidateNeeded := False;
  for i := 0 to TPropertyEditor(Sender).PropCount - 1 do
  begin
    Instance := TPropertyEditor(Sender).GetComponent(i);
    if (Instance is jVisualControl)
    and (jVisualControl(Instance).Owner = AndroidForm) then
    begin
      InvalidateNeeded := True;
      Break;
    end;
  end;
  if InvalidateNeeded then
    LCLForm.Invalidate;
end;

procedure TAndroidWidgetMediator.OnPersistentAdded(APersistent: TPersistent;
  Select: boolean);
begin
  if (APersistent is jVisualControl)
  and (jVisualControl(APersistent).Parent = nil)
  and (jVisualControl(APersistent).Owner = AndroidForm)
  then
    if Assigned(FLastSelectedContainer) then
      jVisualControl(APersistent).Parent := FLastSelectedContainer
    else
      jVisualControl(APersistent).Parent := AndroidForm;
end;

procedure TAndroidWidgetMediator.OnSetSelection(const ASelection: TPersistentSelectionList);
var
  i: Integer;
begin
  FLastSelectedContainer := nil;
  if (ASelection.Count = 1) and (ASelection[0] is jVisualControl) then
    with jVisualControl(ASelection[0]) do
      if (Owner = AndroidForm) and AcceptChildrenAtDesignTime then
        FLastSelectedContainer := jVisualControl(ASelection[0]);
  FSelection.Clear;
  for i := 0 to ASelection.Count - 1 do
    FSelection.Add(ASelection[i]);
end;

function TAndroidWidgetMediator.GetAndroidForm: jForm;
begin
  Result := jForm(Root);
end;

class function TAndroidWidgetMediator.CreateMediator(TheOwner, TheForm: TComponent): TDesignerMediator;
var
  Mediator: TAndroidWidgetMediator;
begin
  Result:=inherited CreateMediator(TheOwner,nil);

  Mediator:= TAndroidWidgetMediator(Result);
  Mediator.Root := TheForm;

  Mediator.FDefaultBrushColor:= clForm;
  Mediator.FDefaultPenColor:= clMedGray;
  Mediator.FDefaultFontColor:= clMedGray;

  Mediator.AndroidForm.Designer:= Mediator;
end;

class function TAndroidWidgetMediator.FormClass: TComponentClass;
begin
  Result:=TAndroidForm;
end;

procedure TAndroidWidgetMediator.GetBounds(AComponent: TComponent; out CurBounds: TRect);
var
  w: TAndroidWidget;
begin
  if AComponent is TAndroidWidget then
  begin
    w:=TAndroidWidget(AComponent);
    CurBounds:=Bounds(w.Left,w.Top,w.Width,w.Height);
  end else inherited GetBounds(AComponent,CurBounds);
end;

procedure TAndroidWidgetMediator.InvalidateRect(Sender: TObject; ARect: TRect; Erase: boolean);
begin
  if (LCLForm=nil) or (not LCLForm.HandleAllocated) then exit;
  LCLIntf.InvalidateRect(LCLForm.Handle,@ARect,Erase);
end;

procedure TAndroidWidgetMediator.GetObjInspNodeImageIndex(APersistent: TPersistent; var AIndex: integer);
begin
  if Assigned(APersistent) then
  begin
    if (APersistent is TAndroidWidget) and (TAndroidWidget(APersistent).AcceptChildrenAtDesignTime) then
      AIndex:= FormEditingHook.GetCurrentObjectInspector.ComponentTree.ImgIndexBox
    else if (APersistent is TAndroidWidget) then
      AIndex:= FormEditingHook.GetCurrentObjectInspector.ComponentTree.ImgIndexControl
    else
      inherited GetObjInspNodeImageIndex(APersistent, AIndex);
  end
end;

procedure TAndroidWidgetMediator.SetBounds(AComponent: TComponent; NewBounds: TRect);
begin
  if AComponent is TAndroidWidget then
  begin
    TAndroidWidget(AComponent).SetBounds(NewBounds.Left,NewBounds.Top,
      NewBounds.Right-NewBounds.Left,NewBounds.Bottom-NewBounds.Top);
  end else inherited SetBounds(AComponent,NewBounds);
end;

procedure TAndroidWidgetMediator.GetClientArea(AComponent: TComponent; out
  CurClientArea: TRect; out ScrollOffset: TPoint);
var
  Widget: TAndroidWidget;
begin
  if AComponent is TAndroidWidget then
  begin
    Widget:=TAndroidWidget(AComponent);
    CurClientArea:=Rect(0, 0, Widget.Width, Widget.Height);
    ScrollOffset:=Point(0, 0);
  end
  else inherited GetClientArea(AComponent, CurClientArea, ScrollOffset);
end;

procedure TAndroidWidgetMediator.InitComponent(AComponent, NewParent: TComponent;
  NewBounds: TRect);
begin
  if AComponent <> AndroidForm then // to preserve jForm size
  begin
    if AComponent is TAndroidWidget then
      with NewBounds do
        if (Right - Left = 50) and (Bottom - Top = 50) then // ugly check, but IDE makes 50x50 default size for non TControl
        begin
          // restore default size
          Right := Left + TAndroidWidget(AComponent).Width;
          Bottom := Top + TAndroidWidget(AComponent).Height
        end;
    inherited InitComponent(AComponent, NewParent, NewBounds);
    if (AComponent is jVisualControl)
    and Assigned(jVisualControl(AComponent).Parent) then
      with jVisualControl(AComponent) do
      begin
        if not (LayoutParamWidth in [lpWrapContent]) then
          LayoutParamWidth := GetDesignerLayoutByWH(Width, Parent.Width);
        if not (LayoutParamHeight in [lpWrapContent]) then
          LayoutParamHeight := GetDesignerLayoutByWH(Height, Parent.Height);
      end;
  end;
end;

procedure TAndroidWidgetMediator.Paint;

  procedure PaintWidget(AWidget: TAndroidWidget);
  var
    i: Integer;
    Child: TAndroidWidget;
    fpcolor: TFPColor;
    fWidget: TDraftWidget;
    fWidgetClass: TDraftWidgetClass;
  begin
    if FDone.IndexOf(AWidget) >= 0 then Exit;
    if FStarted.IndexOf(AWidget) >= 0 then
    begin
      jVisualControl(AWidget).Anchor := nil;
      MessageBox(0, 'Circular dependency detected!', '[Lamw] Designer', MB_ICONERROR);
      Abort;
    end;
    FStarted.Add(AWidget);

    with LCLForm.Canvas do begin
      //fill background

      Brush.Style:= bsSolid;
      Brush.Color:= Self.FDefaultBrushColor;
      Pen.Color:= Self.FDefaultPenColor;      //MedGray...
      Font.Color:= Self.FDefaultFontColor;

      if AWidget is jVisualControl then
        with jVisualControl(AWidget) do
          if Assigned(Anchor) then
          begin
            RestoreHandleState;
            SaveHandleState;
            MoveWindowOrgEx(Handle, Anchor.Left, Anchor.Top);
            IntersectClipRect(Handle, 0, 0, Anchor.Width, Anchor.Height);
            PaintWidget(Anchor); // needed for update its layout
            RestoreHandleState;
            SaveHandleState;
            MoveWindowOrgEx(Handle, AWidget.Left, AWidget.Top);
          end;

      if (AWidget is jForm) then
      begin
        if (AWidget as jForm).BackgroundColor <> colbrDefault then
        begin
          fpcolor:= ToTFPColor((AWidget as jForm).BackgroundColor);
          Brush.Color:= FPColorToTColor(fpcolor);
          Rectangle(0,0,AWidget.Width,AWidget.Height); // outer frame
        end
        else
        begin
          Brush.Color := clWhite;
          GradientFill(Rect(0,0,AWidget.Width,AWidget.Height),
            RGBToColor($EC,$EC,$EC), clWhite, gdVertical);
        end;
      end else
      if (AWidget is jCustomDialog) then
      begin
        if (AWidget as jCustomDialog).BackgroundColor <> colbrDefault then
        begin
          fpcolor:= ToTFPColor((AWidget as jCustomDialog).BackgroundColor);
          Brush.Color:= FPColorToTColor(fpcolor);
        end;
        {
        else
        begin
          Brush.Color:= clNone;
          Brush.Style:= bsClear;
        end;
        }
        Rectangle(0,0,AWidget.Width,AWidget.Height);    // outer frame
        Font.Color:= clMedGray;
        TextOut(6,4,(AWidget as jVisualControl).Text);

      end else
      if (AWidget is jScrollView)  then
      begin
        fWidget:= TDraftScrollView.Create(AWidget, LCLForm.Canvas);
        fWidget.Height:= AWidget.Height;
        fWidget.Width:= AWidget.Width;
        fWidget.MarginLeft:= AWidget.MarginLeft;
        fWidget.MarginTop:= AWidget.MarginTop;
        fWidget.MarginRight:= AWidget.MarginRight;
        fWidget.MarginBottom:= AWidget.MarginBottom;
        fWidget.Color:= (AWidget as jScrollView).BackgroundColor;

         if (AWidget as jScrollView).Parent is jPanel  then
         begin
           if (AWidget as jScrollView).BackgroundColor = colbrDefault then
              fWidget.Color:= ((AWidget as jScrollView).Parent as jPanel).BackgroundColor;
         end;

        if (AWidget as jScrollView).Parent is jCustomDialog  then
        begin
          if (AWidget as jScrollView).BackgroundColor = colbrDefault then
             fWidget.Color:= ((AWidget as jScrollView).Parent as jCustomDialog).BackgroundColor;
        end;
        fWidget.Draw;
        fWidget.Free;
      end else
      if (AWidget is jToggleButton) then
      begin
        fWidget:= TDraftToggleButton.Create(AWidget, LCLForm.Canvas);
        fWidget.Height:= AWidget.Height;
        fWidget.Width:= AWidget.Width;
        fWidget.MarginLeft:= AWidget.MarginLeft;
        fWidget.MarginTop:= AWidget.MarginTop;
        fWidget.MarginRight:= AWidget.MarginRight;
        fWidget.MarginBottom:= AWidget.MarginBottom;
        fWidget.Color:= (AWidget as jToggleButton).BackgroundColor;
        fWidget.FontColor:= colbrGray;

        if (AWidget as jToggleButton).State = tsOff then
          TDraftToggleButton(fWidget).OnOff := False
        else
          TDraftToggleButton(fWidget).OnOff := True;
        fWidget.Draw;
        fWidget.Free;
      end else
      if (AWidget is jView) then
      begin
        if (AWidget as jView).BackgroundColor <> colbrDefault then
        begin
          fpcolor:= ToTFPColor((AWidget as jView).BackgroundColor);
          Brush.Color:= FPColorToTColor(fpcolor);
        end
        else
        begin
          Brush.Color:= clNone; //clMoneyGreen;
          Brush.Style:= bsClear;
        end;
        Pen.Color:= clMedGray;
        //FillRect(0,0,AWidget.Width,AWidget.Height);
        Rectangle(0,0,AWidget.Width,AWidget.Height); // outer frame
        //Font.Color:= clMedGray;
        //TextOut(5,4,(AWidget as jVisualControl).Text);
      end else
      if (AWidget is jWebView) then
      begin
        fWidget:= TDraftWebView.Create(AWidget, LCLForm.Canvas);
        fWidget.Height:= AWidget.Height;
        fWidget.Width:= AWidget.Width;
        fWidget.MarginLeft:= AWidget.MarginLeft;
        fWidget.MarginTop:= AWidget.MarginTop;
        fWidget.MarginRight:= AWidget.MarginRight;
        fWidget.MarginBottom:= AWidget.MarginBottom;
        fWidget.Color:= (AWidget as jWebView).BackgroundColor;
        //fWidget.FontColor:= (AWidget as jVisualControl).FFontColor;
        fWidget.Draw;
        fWidget.Free;
      end else
      if (AWidget is jImageView) then
      begin
        if (AWidget as jImageView).BackgroundColor <> colbrDefault then
        begin
          fpcolor:= ToTFPColor((AWidget as jImageView).BackgroundColor);
          Brush.Color:= FPColorToTColor(fpcolor)
        end
        else
        begin
          Brush.Color:= clNone; //clMoneyGreen;
          Brush.Style:= bsClear;
        end;
        Pen.Color:= clMedGray;
        Rectangle(0,0,AWidget.Width,AWidget.Height); // outer frame
        //Font.Color:= clMedGray;
        //TextOut(5,4,(AWidget as jVisualControl).Text);
      end else
      if (AWidget is jCanvasES1) then
      begin
        Brush.Color:= clMoneyGreen; //clNone;
        Brush.Style:= bsClear;
        Pen.Color:= clMedGray;
        Rectangle(0,0,AWidget.Width,AWidget.Height); // outer frame
        //Font.Color:= clMedGray;
        //TextOut(5,4,(AWidget as jVisualControl).Text);

      end else
      if (AWidget is jCanvasES2) then
      begin
         Brush.Color:= clMoneyGreen;//clNone;
         Brush.Style:= bsClear;
         Pen.Color:= clMedGray;
         Rectangle(0,0,AWidget.Width,AWidget.Height); // outer frame
         //Font.Color:= clMedGray;
         //TextOut(5,4,(AWidget as jVisualControl).Text);
      end else
      if (AWidget is jImageBtn) then
      begin
        fWidget:= TDraftImageBtn.Create(AWidget, LCLForm.Canvas);
        fWidget.Height:= AWidget.Height;
        fWidget.Width:= AWidget.Width;
        fWidget.MarginLeft:= AWidget.MarginLeft;
        fWidget.MarginTop:= AWidget.MarginTop;
        fWidget.MarginRight:= AWidget.MarginRight;
        fWidget.MarginBottom:= AWidget.MarginBottom;
        fWidget.Color:= (AWidget as jImageBtn).BackgroundColor;
        fWidget.FontColor:= colbrGray;
        fWidget.Draw;
        fWidget.Free;
      end else
      if (AWidget is jListView)  then
      begin
         fWidget:= TDraftListView.Create(AWidget, LCLForm.Canvas);
         fWidget.Height:= AWidget.Height;
         fWidget.Width:= AWidget.Width;
         fWidget.MarginLeft:= AWidget.MarginLeft;
         fWidget.MarginTop:= AWidget.MarginTop;
         fWidget.MarginRight:= AWidget.MarginRight;
         fWidget.MarginBottom:= AWidget.MarginBottom;

         fWidget.Color:= (AWidget as jListView).BackgroundColor;
         fWidget.FontColor:= (AWidget as jListView).FontColor;
         if (AWidget as jListView).Parent is jPanel  then
         begin
           if (AWidget as jListView).BackgroundColor = colbrDefault then
              fWidget.Color:= ((AWidget as jListView).Parent as jPanel).BackgroundColor;
         end;
         if (AWidget as jListView).Parent is jCustomDialog  then
         begin
          if (AWidget as jListView).BackgroundColor = colbrDefault then
             fWidget.Color:= ((AWidget as jListView).Parent as jCustomDialog).BackgroundColor;
         end;
         fWidget.Draw;
         fWidget.Free;
      end else
      if (AWidget is jGridView)  then
      begin
         fWidget:= TDraftGridView.Create(AWidget, LCLForm.Canvas);
         fWidget.Height:= AWidget.Height;
         fWidget.Width:= AWidget.Width;
         fWidget.MarginLeft:= AWidget.MarginLeft;
         fWidget.MarginTop:= AWidget.MarginTop;
         fWidget.MarginRight:= AWidget.MarginRight;
         fWidget.MarginBottom:= AWidget.MarginBottom;

         fWidget.Color:= (AWidget as jGridView).BackgroundColor;
         //fWidget.FontColor:= (AWidget as jGridView).FontColor;

         if (AWidget as jGridView).Parent is jPanel  then
         begin
           if (AWidget as jGridView).BackgroundColor = colbrDefault then
              fWidget.Color:= ((AWidget as jGridView).Parent as jPanel).BackgroundColor;
         end;
         if (AWidget as jGridView).Parent is jCustomDialog  then
         begin
          if (AWidget as jGridView).BackgroundColor = colbrDefault then
             fWidget.Color:= ((AWidget as jGridView).Parent as jCustomDialog).BackgroundColor;
         end;
         fWidget.Draw;
         fWidget.Free;
      end else
      if (AWidget is jSpinner) then
      begin
         fWidget:= TDraftSpinner.Create(AWidget, LCLForm.Canvas);
         fWidget.Height:= AWidget.Height;
         fWidget.Width:= AWidget.Width;
         fWidget.MarginLeft:= AWidget.MarginLeft;
         fWidget.MarginTop:= AWidget.MarginTop;
         fWidget.MarginRight:= AWidget.MarginRight;
         fWidget.MarginBottom:= AWidget.MarginBottom;

        (fWidget as TDraftSpinner).Color:= (AWidget as jSpinner).BackgroundColor;
        (fWidget as TDraftSpinner).FontColor:= (AWidget as jSpinner).DropListBackgroundColor;
        (fWidget as TDraftSpinner).DropListTextColor:= (AWidget as jSpinner).DropListTextColor;
        (fWidget as TDraftSpinner).DropListBackgroundColor:= (AWidget as jSpinner).DropListBackgroundColor;
        (fWidget as TDraftSpinner).SelectedFontColor:= (AWidget as jSpinner).SelectedFontColor;

         if (AWidget as jSpinner).Parent is jPanel  then
         begin
           if (AWidget as jSpinner).BackgroundColor = colbrDefault then
              fWidget.Color:= ((AWidget as jSpinner).Parent as jPanel).BackgroundColor;
         end;

        if (AWidget as jSpinner).Parent is jCustomDialog  then
        begin
          if (AWidget as jSpinner).BackgroundColor = colbrDefault then
             fWidget.Color:= ((AWidget as jSpinner).Parent as jCustomDialog).BackgroundColor;
        end;

         fWidget.Draw;
         fWidget.Free;
      end else
      begin
        // generic
        fWidgetClass := DraftClassesMap.Find(AWidget.ClassType);
        if Assigned(fWidgetClass) then
        begin
          fWidget := fWidgetClass.Create(AWidget, LCLForm.Canvas);
          if not FSizing or (FSelection.IndexOf(AWidget) < 0) then
            fWidget.UpdateLayout;
          fWidget.Draw;
          fWidget.Free;
        end
        else if (AWidget is jVisualControl) then     ////generic
        begin
          Brush.Color:= Self.FDefaultBrushColor;
          FillRect(0,0,AWidget.Width,AWidget.Height);
          Rectangle(0,0,AWidget.Width,AWidget.Height);    // outer frame
          //generic
          Font.Color:= clMedGray;
          TextOut(5,4,(AWidget as TAndroidWidget).Text);
        end;
      end;

      if AWidget.AcceptChildrenAtDesignTime then
      begin       //inner rect...
        if (AWidget is jCustomDialog) then
        begin
          Pen.Color:= clSilver; //clWhite;
          Frame(4,4,AWidget.Width-4,AWidget.Height-4); // inner frame
        end
        else
        if not (AWidget is jForm) then
        begin
          Pen.Color:= clSilver;
          Frame(2, 2, AWidget.Width - 2, AWidget.Height - 2); // inner frame
        end;
      end;

      // children
      if AWidget.ChildCount>0 then
      begin
        SaveHandleState;
        // clip client area
        if IntersectClipRect(Handle, 0, 0, AWidget.Width, AWidget.Height)<>NullRegion then
        begin
          for i:=0 to AWidget.ChildCount-1 do
          begin
            SaveHandleState;
            Child:=AWidget.Children[i];
            // clip child area
            MoveWindowOrgEx(Handle,Child.Left,Child.Top);
            if IntersectClipRect(Handle,0,0,Child.Width,Child.Height)<>NullRegion then
               PaintWidget(Child);
            RestoreHandleState;
          end;
        end;
        RestoreHandleState;
      end;
    end;
    FStarted.Remove(AWidget);
    FDone.Add(AWidget);
  end;

begin
  FStarted.Clear;
  FDone.Clear;
  PaintWidget(AndroidForm);
  inherited Paint;
end;

function TAndroidWidgetMediator.ComponentIsIcon(AComponent: TComponent): boolean;
begin
  Result:=not (AComponent is TAndroidWidget);
end;

function TAndroidWidgetMediator.ParentAcceptsChild(Parent: TComponent; Child: TComponentClass): boolean;
begin
  Result:=(Parent is TAndroidWidget) and
          (Child.InheritsFrom(TAndroidWidget)) and
          (TAndroidWidget(Parent).AcceptChildrenAtDesignTime);
end;

procedure TAndroidWidgetMediator.MouseDown(Button: TMouseButton;
  Shift: TShiftState; p: TPoint; var Handled: boolean);
begin
  FSizing := True;
  inherited MouseDown(Button, Shift, p, Handled);
end;

procedure TAndroidWidgetMediator.MouseUp(Button: TMouseButton;
  Shift: TShiftState; p: TPoint; var Handled: boolean);
begin
  inherited MouseUp(Button, Shift, p, Handled);
  FSizing := False;
  LCLForm.Invalidate;
end;

{ TDraftWidget }

constructor TDraftWidget.Create(AWidget: TAndroidWidget; Canvas: TCanvas);
begin
  TextColor:= clNone;
  BackGroundColor:= clNone;
  FAndroidWidget := AWidget;
  FCanvas := Canvas;

  with jVisualControl(FAndroidWidget) do
  begin
    FnewW := Width;
    FnewH := Height;
    FnewL := Left;
    FnewT := Top;
    with Designer do
      if FSizing and (FSelection.IndexOf(AWidget) >= 0)
      and (Parent <> nil) then
      begin
        if not (LayoutParamWidth in [lpWrapContent]) then
          LayoutParamWidth := GetDesignerLayoutByWH(Width, Parent.Width);
        if not (LayoutParamHeight in [lpWrapContent]) then
          LayoutParamHeight := GetDesignerLayoutByWH(Height, Parent.Height);
      end;
  end;
end;

procedure TDraftWidget.UpdateLayout;
begin
  with jVisualControl(FAndroidWidget) do
  begin
    if Assigned(Parent) then
    begin
      if LayoutParamWidth = lpMatchParent then
        FnewW := Parent.Width - MarginLeft - MarginRight
      else
      if LayoutParamWidth <> lpWrapContent then
        FnewW := GetLayoutParamsByParent(Parent, LayoutParamWidth, sdW);
      if LayoutParamHeight = lpMatchParent then
        FnewH := Parent.Height - MarginTop - MarginBottom
      else
      if LayoutParamHeight <> lpWrapContent then
        FnewH := GetLayoutParamsByParent(Parent, LayoutParamHeight, sdH);
      if FnewW < FminW then FnewW := FminW;
      if FnewH < FminH then FnewH := FminH;
      if (PosRelativeToParent <> []) or (PosRelativeToAnchor <> []) then
      begin
        FnewL := MarginLeft;
        FnewT := MarginTop;
      end;
      if rpCenterHorizontal in PosRelativeToParent then
        FnewL := (Parent.Width - FnewW) div 2;
      if rpCenterVertical in PosRelativeToParent then
        FnewT := (Parent.Height - FnewH) div 2;
      if rpCenterInParent in PosRelativeToParent then
      begin
        FnewL := (Parent.Width - FnewW) div 2;
        FnewT := (Parent.Height - FnewH) div 2;
      end;
      if rpRight in PosRelativeToParent then
        if not (rpLeft in PosRelativeToParent) then
          FnewL := Parent.Width - Width - MarginRight
        else begin
          FnewL := MarginRight;
          FnewW := Parent.Width - MarginRight - MarginLeft;
        end
      else
      if rpLeft in PosRelativeToParent then
        FnewL := MarginLeft;
      if rpTop in PosRelativeToParent then
        if not (rpBottom in PosRelativeToParent) then
          FnewT := MarginTop
        else begin
          FnewT := MarginTop;
          FnewH := Parent.Height - MarginTop - MarginBottom;
        end
      else
      if rpBottom in PosRelativeToParent then
        FnewT := Parent.Height - MarginBottom - Height;
      { TODO: rpStart, rpEnd }
    end;
    if Anchor <> nil then
    begin
      if raBelow in PosRelativeToAnchor then
        FnewT := Anchor.Top + Anchor.Height + Anchor.MarginBottom + MarginTop;
      if raAbove in PosRelativeToAnchor then
        FnewT := Anchor.Top - Height - MarginBottom - Anchor.MarginTop;
      if raToRightOf in PosRelativeToAnchor then
        FnewL := Anchor.Left + Anchor.Width + Anchor.MarginRight + MarginLeft;
      if raAlignBaseline in PosRelativeToAnchor then
        FnewT := Anchor.Top + (Anchor.Height - Height) div 2;
      if raAlignLeft in PosRelativeToAnchor then
        FnewL := Anchor.Left + MarginLeft;
      if raToEndOf in PosRelativeToAnchor then
        FnewL := Anchor.Left + Anchor.Width + Anchor.MarginRight + MarginLeft;
      { TODO: other combinations }
    end;
    SetBounds(FnewL, FnewT, FnewW, FnewH);
  end;
end;

procedure TDraftWidget.SetColor(color: TARGBColorBridge);
begin
  FColor:= color;
  if color <> colbrDefault then
    BackGroundColor:= FPColorToTColor(ToTFPColor(color))
  else
    BackGroundColor:= clNone;
end;

procedure TDraftWidget.SetFontColor(color: TARGBColorBridge);
begin
  FFontColor:= color;
  if color <> colbrDefault then
  begin
    TextColor:= FPColorToTColor(ToTFPColor(color));
  end
  else TextColor:= clNone;
end;

function TDraftWidget.Designer: TAndroidWidgetMediator;
var
  t: TAndroidWidget;
begin
  Result := nil;
  if FAndroidWidget = nil then Exit;
  t := FAndroidWidget;
  while Assigned(t.Parent) do t := t.Parent;
  if t is TAndroidForm then
    Result := TAndroidForm(t).Designer as TAndroidWidgetMediator;
end;

{ TDraftButton }

constructor TDraftButton.Create(AWidget: TAndroidWidget; Canvas: TCanvas);
begin
  inherited;
  Height := AWidget.Height;
  Width := AWidget.Width;
  MarginLeft := AWidget.MarginLeft;
  MarginTop := AWidget.MarginTop;
  MarginRight := AWidget.MarginRight;
  MarginBottom := AWidget.MarginBottom;
  FontColor := jButton(AWidget).FontColor;
  Color := jButton(AWidget).BackgroundColor;

  if AWidget.Parent is jPanel then
  begin
    if jButton(AWidget).BackgroundColor = colbrDefault then
      Color := jPanel(AWidget.Parent).BackgroundColor;
  end else
  if AWidget.Parent is jCustomDialog then
  begin
    if jButton(AWidget).BackgroundColor = colbrDefault then
      Color := jCustomDialog(AWidget.Parent).BackgroundColor;
  end;
end;

procedure TDraftButton.Draw;
var
  r: TRect;
  ts: TTextStyle;
  lastFontSize: Integer;
begin
  with Fcanvas do
  begin
    Brush.Color := BackGroundColor;
    Pen.Color := clForm;
    Font.Color := TextColor;

    if BackGroundColor = clNone then
      Brush.Color := RGBToColor($cc, $cc, $cc);

    if TextColor = clNone then
      Font.Color:= clBlack;
    lastFontSize := Font.Size;
    Font.Size := AndroidToLCLFontSize(jButton(FAndroidWidget).FontSize, 13);

    r := Rect(0, 0, Self.Width, Self.Height);
    FillRect(r);
    //outer frame
    Rectangle(r);

    Pen.Color := clMedGray;
    Brush.Style := bsClear;
    InflateRect(r, -1, -1);
    Rectangle(r);

    ts := TextStyle;
    ts.Layout := tlCenter;
    ts.Alignment := Classes.taCenter;
    TextRect(r, r.Left, r.Top, FAndroidWidget.Text, ts);
    Font.Size := lastFontSize;
  end;
end;

procedure TDraftButton.UpdateLayout;
begin
  with jButton(FAndroidWidget) do
    if LayoutParamHeight = lpWrapContent then
    begin
      FnewH := 14 + AndroidToLCLFontSize(jButton(FAndroidWidget).FontSize, 13) + 13;
      if FnewH < 40 then FnewH := 40;
    end;
  inherited UpdateLayout;
end;

{ TDraftTextView }

constructor TDraftTextView.Create(AWidget: TAndroidWidget; Canvas: TCanvas);
begin
  inherited;
  BackGroundColor := clNone;
  Height := AWidget.Height;
  Width := AWidget.Width;
  MarginLeft := AWidget.MarginLeft;
  MarginTop := AWidget.MarginTop;
  MarginRight := AWidget.MarginRight;
  MarginBottom := AWidget.MarginBottom;
  Color := jTextView(AWidget).BackgroundColor;
  FontColor := jTextView(AWidget).FontColor;
end;

procedure TDraftTextView.Draw;
var
  lastSize, ps: Integer;
begin
  with Fcanvas do
  begin
    ps := AndroidToLCLFontSize(jTextView(FAndroidWidget).FontSize, 10);
    lastSize := Font.Size;
    Font.Size := ps;

    Brush.Color := BackGroundColor;
    Pen.Color := TextColor;
    if BackGroundColor <> clNone then
      FillRect(0, 0, FAndroidWidget.Width, FAndroidWidget.Height)
    else
      Brush.Style := bsClear;

    if TextColor = clNone then
      Font.Color := RGBToColor($3A,$3A,$3A)
    else
      Font.Color := TextColor;

    TextOut(0, (ps + 5) div 10, FAndroidWidget.Text);
    Font.Size := lastSize;
  end;
end;

procedure TDraftTextView.UpdateLayout;
var
  ps, lastSize: Integer;
begin
  with jTextView(FAndroidWidget), FCanvas do
    if (LayoutParamWidth = lpWrapContent)
    or (LayoutParamHeight = lpWrapContent) then
    begin
      lastSize := Font.Size;
      ps := AndroidToLCLFontSize(FontSize, 10);
      Font.Size := ps;
      with TextExtent(Text) do
      begin
        if LayoutParamWidth = lpWrapContent then
          FnewW := cx;
        if LayoutParamHeight = lpWrapContent then
          FnewH := cy + 2 + (ps + 5) div 10;
      end;
      Font.Size := lastSize;
    end;
  inherited UpdateLayout;
end;

{ TDraftEditText }

constructor TDraftEditText.Create(AWidget: TAndroidWidget; Canvas: TCanvas);
begin
  inherited;
  Color := jEditText(AWidget).BackgroundColor;
  FontColor := jEditText(AWidget).FontColor;
end;

procedure TDraftEditText.Draw;
var
  ls: Integer;
begin
  with FCanvas do
  begin
    if BackgroundColor <> clNone then
    begin
      Brush.Color := BackGroundColor;
      FillRect(0, 0, FAndroidWidget.Width, FAndroidWidget.Height);
    end else
      Brush.Style := bsClear;
    if TextColor = clNone then
      Font.Color := clBlack
    else
      Font.Color := TextColor;
    ls := Font.Size;
    Font.Size := AndroidToLCLFontSize(jEditText(FAndroidWidget).FontSize, 13);
    TextOut(12, 9, jEditText(FAndroidWidget).Text);
    Font.Size := ls;
    if BackgroundColor = clNone then
    begin
      Pen.Color := RGBToColor(175,175,175);
      with FAndroidWidget do
      begin
        MoveTo(4, Height - 8);
        Lineto(4, Height - 5);
        Lineto(Width - 4, Height - 5);
        Lineto(Width - 4, Height - 8);
      end;
    end;
  end;
end;

procedure TDraftEditText.UpdateLayout;
var
  fs: Integer;
begin
  with jEditText(FAndroidWidget) do
    if LayoutParamHeight = lpWrapContent then
    begin
      fs := FontSize;
      if fs = 0 then fs := 18;
      FnewH := 29 + (fs - 10) * 4 div 3; // todo: multile
    end;
  inherited UpdateLayout;
end;

{ TDraftCheckBox }

constructor TDraftCheckBox.Create(AWidget: TAndroidWidget; Canvas: TCanvas);
begin
  inherited;
  BackGroundColor:= clNone; //clActiveCaption;
  Height:= AWidget.Height;
  Width:= AWidget.Width;
  MarginLeft:= AWidget.MarginLeft;
  MarginTop:= AWidget.MarginTop;
  MarginRight:= AWidget.MarginRight;
  MarginBottom:= AWidget.MarginBottom;
  Color:= jCheckBox(AWidget).BackgroundColor;
  FontColor:= jCheckBox(AWidget).FontColor;
end;

procedure TDraftCheckBox.Draw;
var
  lastSize, ps: Integer;
begin
  with Fcanvas do
  begin
    Brush.Color := Self.BackGroundColor;
    if BackGroundColor <> clNone then
      FillRect(0, 0, Self.Width, Self.Height)
    else
      Brush.Style := bsClear;

    if TextColor = clNone then
      Font.Color := clBlack
    else
      Font.Color := TextColor;

    lastSize := Font.Size;
    ps := AndroidToLCLFontSize(jCheckBox(FAndroidWidget).FontSize, 12);
    Font.Size := ps;
    TextOut(32, 14 - Abs(Font.Height) div 2, FAndroidWidget.Text);
    Font.Size := lastSize;

    Brush.Color := clWhite;
    Brush.Style := bsClear;
    Pen.Color := RGBToColor($A1,$A1,$A1);
    Rectangle(8, 8, 24, 24);
    if jCheckBox(FAndroidWidget).Checked then
    begin
      lastSize := Pen.Width;
      Pen.Width := 4;
      Pen.Color := RGBToColor($44,$B3,$DD);
      MoveTo(12, 13);
      LineTo(16, 18);
      LineTo(26, 7);
      Pen.Width := lastSize;
    end;
  end;
end;

procedure TDraftCheckBox.UpdateLayout;
var
 ls,  ps: Integer;
begin
  with jCheckBox(FAndroidWidget) do
  begin
    if LayoutParamHeight = lpWrapContent then
      FnewH := 32;
    if LayoutParamWidth = lpWrapContent then
    begin
      ps := AndroidToLCLFontSize(FontSize, 12);
      ls := FCanvas.Font.Size;
      FCanvas.Font.Size := ps;
      FnewW := 33 + FCanvas.TextWidth(Text);
      FCanvas.Font.Size := ls;
    end;
  end;
  inherited UpdateLayout;
end;

{ TDraftRadioButton }

constructor TDraftRadioButton.Create(AWidget: TAndroidWidget; Canvas: TCanvas);
begin
  inherited;
  BackGroundColor := clNone;
  Height := AWidget.Height;
  Width := AWidget.Width;
  MarginLeft := AWidget.MarginLeft;
  MarginTop := AWidget.MarginTop;
  MarginRight := AWidget.MarginRight;
  MarginBottom := AWidget.MarginBottom;
  Color := jRadioButton(AWidget).BackgroundColor;
  FontColor := jRadioButton(AWidget).FontColor;
end;

procedure TDraftRadioButton.Draw;
var
  lastSize: Integer;
begin
  with Fcanvas do
  begin
    Brush.Color := BackGroundColor;
    Font.Color := Self.TextColor;
    if BackGroundColor <> clNone then
      FillRect(0, 0, Self.Width, Self.Height)
    else
      Brush.Style := bsClear;

    if TextColor = clNone then
      Font.Color := clBlack;

    lastSize := Font.Size;

    lastSize := Font.Size;
    Font.Size := AndroidToLCLFontSize(jCheckBox(FAndroidWidget).FontSize, 12);
    TextOut(32, 14 - Abs(Font.Height) div 2, FAndroidWidget.Text);
    Font.Size := lastSize;

    Brush.Style := bsClear;
    Pen.Color := RGBToColor(155,155,155);
    Ellipse(7, 6, 25, 24);

    if jRadioButton(FAndroidWidget).Checked then
    begin
      Brush.Color := RGBToColor(0,$99,$CC);
      Ellipse(7+3, 6+3, 25-3, 24-3);
    end;
  end;
end;

procedure TDraftRadioButton.UpdateLayout;
var
  ps, ls: Integer;
begin
  with jRadioButton(FAndroidWidget) do
  begin
    if LayoutParamHeight = lpWrapContent then
      FnewH := 32;
    if LayoutParamWidth = lpWrapContent then
    begin
      ps := AndroidToLCLFontSize(FontSize, 12);
      ls := FCanvas.Font.Size;
      FCanvas.Font.Size := ps;
      FnewW := 33 + FCanvas.TextWidth(Text);
      FCanvas.Font.Size := ls;
    end;
  end;
  inherited UpdateLayout;
end;

{ TDraftProgressBar }

constructor TDraftProgressBar.Create(AWidget: TAndroidWidget; Canvas: TCanvas);
begin
  inherited;
  Height := AWidget.Height;
  Width := AWidget.Width;
  MarginLeft := AWidget.MarginLeft;
  MarginTop := AWidget.MarginTop;
  MarginRight := AWidget.MarginRight;
  MarginBottom := AWidget.MarginBottom;
  Color := jProgressBar(AWidget).BackgroundColor;
  FontColor := colbrBlack;

  if AWidget.Parent is jPanel then
  begin
    if jProgressBar(AWidget).BackgroundColor = colbrDefault then
      Color := jPanel(AWidget.Parent).BackgroundColor;
  end else
  if AWidget.Parent is jCustomDialog then
  begin
    if jProgressBar(AWidget).BackgroundColor = colbrDefault then
      Color := jCustomDialog(AWidget.Parent).BackgroundColor;
  end;
end;

procedure TDraftProgressBar.Draw;
var
  x: integer;
  r: TRect;
begin
  with Fcanvas do
  begin
    Brush.Color := RGBToColor($ad,$ad,$ad);
    r := Rect(0, 10, Self.Width, 13);
    FillRect(r);
    Brush.Color := RGBToColor($44,$B3,$DD);
    r.Top := 9;
    r.Bottom := 12;
    if jProgressBar(FAndroidWidget).Max <= 0 then
      jProgressBar(FAndroidWidget).Max := 100;
    x := Self.Width * jProgressBar(FAndroidWidget).Progress
         div jProgressBar(FAndroidWidget).Max;
    { "inverse" does not work... yet?
    if not (jProgressBar(FAndroidWidget).Style
            in [cjProgressBarStyleInverse, cjProgressBarStyleLargeInverse])
    then}
      r.Right := x
    {else begin
      r.Right := Self.Width;
      r.Left := Self.Width - x;
    end};
    FillRect(r);
  end;
end;

procedure TDraftProgressBar.UpdateLayout;
begin
  with jProgressBar(FAndroidWidget) do
    if LayoutParamHeight = lpWrapContent then
      FnewH := 23;
  inherited UpdateLayout;
end;

{ TDraftListView }

constructor TDraftListView.Create(AWidget: TAndroidWidget; Canvas: TCanvas);
begin
  inherited;
end;

procedure TDraftListView.Draw;
var
  i, k: integer;
begin
  Fcanvas.Brush.Color:= Self.BackGroundColor;
  Fcanvas.Pen.Color:= clActiveCaption;

  if  Self.BackGroundColor = clNone then Fcanvas.Brush.Style:= bsClear;

  Fcanvas.FillRect(0,0,Self.Width,Self.Height);
      // outer frame
  Fcanvas.Rectangle(0,0,Self.Width,Self.Height);

  Fcanvas.Brush.Style:= bsSolid;

  Fcanvas.Pen.Color:= clSilver;
  k:= Trunc(Self.Height/20);
  for i:= 1 to k-1 do
  begin
    Fcanvas.MoveTo(Self.Width-Self.MarginRight+10, {x2}
    Self.MarginTop+i*20); {y1}
    Fcanvas.LineTo(Self.MarginLeft-10,Self.MarginTop+i*20);  {x1, y1}
  end;

  //canvas.Brush.Style:= bsClear;
  //canvas.Font.Color:= Self.TextColor;
  //canvas.TextOut(5,4, txt);
end;

{ TDraftImageBtn }

constructor TDraftImageBtn.Create(AWidget: TAndroidWidget; Canvas: TCanvas);
begin
  inherited;
  BackGroundColor:= clActiveCaption; //clMenuHighlight;
end;

procedure TDraftImageBtn.Draw;
begin
  Fcanvas.Brush.Color:= Self.BackGroundColor;
  Fcanvas.Pen.Color:= clWhite;
  Fcanvas.Font.Color:= Self.TextColor;

  if Self.BackGroundColor = clNone then
     Fcanvas.Brush.Color:= clSilver; //clMedGray;

  if Self.TextColor = clNone then
      Fcanvas.Font.Color:= clBlack;

  Fcanvas.FillRect(0,0,Self.Width,Self.Height);
      // outer frame
  Fcanvas.Rectangle(0,0,Self.Width,Self.Height);

  Fcanvas.Pen.Color:= clWindowFrame;
  Fcanvas.Line(Self.Width-Self.MarginRight+3, {x2}
             Self.MarginTop-3,  {y1}
             Self.Width-Self.MarginRight+3,  {x2}
             Self.Height-Self.MarginBottom+3); {y2}

  Fcanvas.Line(Self.Width-Self.MarginRight+3, {x2}
             Self.Height-Self.MarginBottom+3,{y2}
             Self.MarginLeft-4,                {x1}
             Self.Height-Self.MarginBottom+3);  {y2}

  Fcanvas.Font.Color:= Self.TextColor;
  //canvas.TextOut(5,4,txt);
end;

{ TDraftSpinner }

constructor TDraftSpinner.Create(AWidget: TAndroidWidget; Canvas: TCanvas);
begin
  inherited;
  //BackGroundColor:= clInactiveBorder; //clActiveCaption;
end;

procedure TDraftSpinner.SetDropListBackgroundColor(Acolor: TARGBColorBridge);
begin
  FDropListBackgroundColor:= Acolor;
  if Acolor <> colbrDefault then
    DropListColor:= FPColorToTColor(ToTFPColor(Acolor))
  else
    DropListColor:= clNone;
end;

procedure TDraftSpinner.SetDropListTextColor(Acolor: TARGBColorBridge);
var
  fpColor: TFPColor;
begin
  FDropListTextColor:= Acolor;
  if Acolor <> colbrDefault then
  begin
    fpColor:= ToTFPColor(Acolor);
    DropListFontColor:= FPColorToTColor(fpColor);
  end
  else DropListFontColor:= clNone;
end;

procedure TDraftSpinner.SetSelectedFontColor(Acolor: TARGBColorBridge);
var
  fpColor: TFPColor;
begin
  FSelectedFontColor:= Acolor;
  if Acolor <> colbrDefault then
  begin
    fpColor:= ToTFPColor(Acolor);
    SelectedTextColor:= FPColorToTColor(fpColor);
  end
  else SelectedTextColor:= clNone;
end;

procedure TDraftSpinner.Draw;
var
  saveColor: TColor;
begin
  Fcanvas.Brush.Color:= Self.BackGroundColor;
  Fcanvas.Pen.Color:= Self.DropListColor;

  if DropListColor = clNone then
     Fcanvas.Pen.Color:= clMedGray;

  if BackGroundColor = clNone then
     Fcanvas.Brush.Color:= clWhite;

  Fcanvas.FillRect(0,0,Self.Width,Self.Height);
      // outer frame
  Fcanvas.Rectangle(0,0,Self.Width,Self.Height);

  Fcanvas.Brush.Color:= Self.DropListColor; //clActiveCaption;

  if DropListColor = clNone then
     Fcanvas.Brush.Color:= clSilver;

  Fcanvas.Rectangle(Self.Width-47,0+7,Self.Width-7,Self.Height-7);
  saveColor:= Fcanvas.Brush.Color;

  Fcanvas.Brush.Style:= bsClear;
  Fcanvas.Pen.Color:= clWhite;
  Fcanvas.Rectangle(Self.Width-48,0+6,Self.Width-6,Self.Height-6);


  Fcanvas.Pen.Color:= Self.DropListFontColor;

  if saveColor <> clBlack then
     Fcanvas.Pen.Color:= clBlack
  else
     Fcanvas.Pen.Color:= clSilver;

  Fcanvas.Line(Self.Width-42, 12,Self.Width-11, 12);
  Fcanvas.Line(Self.Width-42-1, 12,Self.Width-42+Trunc(31/2), Self.Height-12);
  Fcanvas.Line(Self.Width-42+Trunc(31/2),Self.Height-12,Self.Width-11,12);

  Fcanvas.Font.Color:= Self.SelectedTextColor;
  if SelectedTextColor = clNone then
     Fcanvas.Font.Color:= clMedGray;

  //Fcanvas.TextOut(5,4,txt);
end;

{ TDraftWebView }

constructor TDraftWebView.Create(AWidget: TAndroidWidget; Canvas: TCanvas);
begin
  inherited;
  BackGroundColor:= clWhite; //clMoneyGreen; //clInactiveBorder; //clActiveCaption;
end;

procedure TDraftWebView.Draw;
begin
  Fcanvas.Brush.Color:= Self.BackGroundColor;
  Fcanvas.Pen.Color:= clTeal; //clGreen;//clActiveCaption;
  Fcanvas.FillRect(0,0,Self.Width,Self.Height);
  Fcanvas.Rectangle(0,0,Self.Width,Self.Height);  // outer frame
  //----
  Fcanvas.Brush.Color:= clWhite;
  Fcanvas.Pen.Color:= clMoneyGreen;//clActiveCaption;

  Fcanvas.FillRect(5,5,Self.Width-5,25);
  Fcanvas.Rectangle(5,5,Self.Width-5,25);

  Fcanvas.FillRect (5,30,Trunc(Self.Width/2)-5,Self.Height-5);
  Fcanvas.Rectangle(5,30,Trunc(Self.Width/2)-5,Self.Height-5);

  Fcanvas.FillRect (Trunc(Self.Width/2),30,Self.Width-5,Trunc(0.5*Self.Height));
  Fcanvas.Rectangle(Trunc(Self.Width/2),30,Self.Width-5,Trunc(0.5*Self.Height));

  Fcanvas.FillRect (Trunc(Self.Width/2),Trunc(0.5*Self.Height)+5,Self.Width-5,Self.Height-5);
  Fcanvas.Rectangle(Trunc(Self.Width/2),Trunc(0.5*Self.Height)+5,Self.Width-5,Self.Height-5);
 //-----

 //Fcanvas.Font.Color:= Self.FontColor;

 //Fcanvas.TextOut(10,6,txt);
end;

{ TDraftScrollView }

constructor TDraftScrollView.Create(AWidget: TAndroidWidget; Canvas: TCanvas);
begin
  inherited;
end;

procedure TDraftScrollView.Draw;
begin
  Fcanvas.Brush.Color:= Self.BackGroundColor;
  Fcanvas.Pen.Color:= clMedGray; //clGreen;//clActiveCaption;

  if Self.BackGroundColor = clNone then Fcanvas.Brush.Style:= bsClear;

  Fcanvas.FillRect(0,0,Self.Width,Self.Height);
  Fcanvas.Rectangle(0,0,Self.Width,Self.Height);  // outer frame

  Fcanvas.Brush.Style:= bsSolid;
  Fcanvas.Brush.Color:= clWhite;
  Fcanvas.FillRect(Self.Width-20,5,Self.Width-5,Self.Height-5);

  Fcanvas.Brush.Color:= clMedGray; //Self.BackGroundColor;
  Fcanvas.FillRect(Self.Width-20+5,5+25,Self.Width-5-5,Self.Height-5-25);

  Fcanvas.Pen.Color:= clMedGray; //clGreen;//clActiveCaption;
  Fcanvas.Frame(Self.Width-20,5,Self.Width-5,Self.Height-5);

  Fcanvas.Pen.Color:= clBlack; //clGreen;//clActiveCaption;
  Fcanvas.MoveTo(Self.Width-5-1,5+1);
  Fcanvas.LineTo(Self.Width-20+1,5+1);
  Fcanvas.LineTo(Self.Width-20+1,Self.Height-5-1);

  Fcanvas.Pen.Color:= clWindowFrame; //clGreen;//clActiveCaption;
  Fcanvas.MoveTo(Self.Width-5-5,5+25+1);
  Fcanvas.LineTo(Self.Width-5-5,Self.Height-5-25);
  Fcanvas.LineTo(Self.Width-20+5,Self.Height-5-25);

  //-----
  //Fcanvas.Brush.Style:= bsClear;
 // Fcanvas.TextOut(10,6,txt);
end;

{ TDraftToggleButton }

constructor TDraftToggleButton.Create(AWidget: TAndroidWidget; Canvas: TCanvas);
begin
  inherited;
  BackGroundColor:= clActiveCaption;; //clMenuHighlight;
end;

procedure TDraftToggleButton.Draw;
begin
  Fcanvas.Brush.Color:= Self.BackGroundColor;
  Fcanvas.Pen.Color:= clWhite;
  Fcanvas.Font.Color:= Self.TextColor;

  if Self.BackGroundColor = clNone then
     Fcanvas.Brush.Color:= clSilver; //clMedGray;

  if Self.TextColor = clNone then
      Fcanvas.Font.Color:= clBlack;

  Fcanvas.FillRect(0,0,Self.Width,Self.Height);
      // outer frame
  Fcanvas.Rectangle(0,0,Self.Width,Self.Height);

  Fcanvas.Pen.Color:= clWindowFrame;
  if Self.OnOff = True then  //on
  begin

    Fcanvas.Brush.Style:= bsSolid;
    Fcanvas.Brush.Color:= clSkyBlue;
    Fcanvas.FillRect(Self.MarginRight-4,
                    Self.MarginTop-3,
                    Self.Width-Self.MarginLeft+2,
                    Self.Height-Self.MarginBottom+3);

    Fcanvas.Brush.Style:= bsClear;
    Fcanvas.Pen.Color:= clWindowFrame;

     Fcanvas.Line(Self.Width-Self.MarginRight+3, {x2}
             Self.MarginTop-3,  {y1}
             Self.Width-Self.MarginRight+3,  {x2}
             Self.Height-Self.MarginBottom+3); {y2}

     Fcanvas.Line(Self.Width-Self.MarginRight+3, {x2}
             Self.Height-Self.MarginBottom+3,{y2}
             Self.MarginLeft-4,                {x1}
             Self.Height-Self.MarginBottom+3);  {y2}


     Fcanvas.Pen.Color:= clWhite;
     Fcanvas.Line(Self.MarginLeft-4, {x1}
                   Self.MarginTop-3,  {y1}
                   Self.MarginLeft-4, {x1}
                   Self.Height-Self.MarginBottom+3); {y2}

     Fcanvas.Line(Self.Width-Self.MarginRight+3, {x2}
                Self.MarginTop-3,  {y1}
                Self.MarginLeft-4, {x1}
                Self.MarginTop-3);{y1}
  end
  else  //off
  begin

    (*
    Fcanvas.Brush.Style:= bsSolid;
    Fcanvas.Brush.Color:= clSkyBlue;
    Fcanvas.FillRect(Self.MarginRight-4,
                    Self.MarginTop-3,
                    Self.Width-Self.MarginLeft+2,
                    Self.Height-Self.MarginBottom+3);

    *)
    Fcanvas.Brush.Style:= bsClear;
    Fcanvas.Pen.Color:= clWindowFrame;

    //V
    Fcanvas.Line(Self.MarginLeft-4, {x1}
               Self.MarginTop-3,  {y1}
               Self.MarginLeft-4, {x1}
               Self.Height-Self.MarginBottom+3); {y2}

     //H
    Fcanvas.Line(Self.Width-Self.MarginRight+3, {x2}
            Self.MarginTop-3,  {y1}
            Self.MarginLeft-4, {x1}
            Self.MarginTop-3);{y1}

    Fcanvas.Pen.Color:= clWhite;
    Fcanvas.Line(Self.Width-Self.MarginRight+3, {x2}
            Self.MarginTop-3,  {y1}
            Self.Width-Self.MarginRight+3,  {x2}
            Self.Height-Self.MarginBottom+3); {y2}

    Fcanvas.Line(Self.Width-Self.MarginRight+3, {x2}
            Self.Height-Self.MarginBottom+3,{y2}
            Self.MarginLeft-4,                {x1}
            Self.Height-Self.MarginBottom+3);  {y2}


  end;
  //Fcanvas.Font.Color:= Self.TextColor;
  //Fcanvas.TextOut(5,4,txt);
end;

{ TDraftSwitchButton }

procedure TDraftSwitchButton.Draw;
var
  x, y, z, i, ps: Integer;
  r, rb: TRect;
  ts: TTextStyle;
  s: string;
begin
  with FCanvas do
  begin
    Color := jSwitchButton(FAndroidWidget).BackgroundColor;
    if BackGroundColor = clNone then
      BackGroundColor := clWhite
    else begin
      Brush.Color := BackGroundColor;
      FillRect(0, 0, FAndroidWidget.Width, FAndroidWidget.Height);
    end;
    x := FAndroidWidget.Height div 2 - 12;
    Brush.Color := BlendColors(BackGroundColor, 0.7, 153,153,153);
    ps := Font.Size;
    Font.Size := 10;
    with jSwitchButton(FAndroidWidget) do
    begin
      y := TextWidth(TextOn);
      z := TextWidth(TextOff);
      if y < z then y := z;
      y := y + 22; // button width

      i := 2 * (y + 2);
      if i < 92 then i := 92;
      z := FAndroidWidget.Width - 2 - i;
      rb := Rect(z, x, z + i, x + 24);

      FillRect(rb);
      if State = tsOff then
      begin
        z := rb.Left + 1;
        Brush.Color := BlendColors(Self.BackgroundColor, 0.414, 153,153,153);
        Font.Color := RGBToColor(234,234,234);
        s := TextOff;
      end else begin
        z := rb.Right - 1 - y;
        Brush.Color := BlendColors(Self.BackgroundColor, 0.14, 11,153,200);
        Font.Color := clWhite;
        s := TextOn;
      end;
    end;
    r := Rect(z, x + 1, z + y, x + 23);
    FillRect(r);
    ts := TextStyle;
    ts.Layout := tlCenter;
    ts.Alignment := Classes.taCenter;
    TextRect(r, 0, 0, s, ts);
    Font.Size := ps;
  end;
end;

procedure TDraftSwitchButton.UpdateLayout;
var
  ps, x, y: Integer;
begin
  FminH := 28;
  with jSwitchButton(FAndroidWidget) do
  begin
    if LayoutParamWidth = lpWrapContent then
      with FCanvas do
      begin
        ps := Font.Size;
        Font.Size := 10;
        x := TextWidth(TextOn);
        y := TextWidth(TextOff);
        if y > x then x := y;
        x := 2 * (x + 22 + 2);
        if x < 92 then x := 92;
        x := x + 4;
        FnewW := x;
        Font.Size := ps;
      end;
    if LayoutParamHeight = lpWrapContent then
      FnewH := 28
  end;
  inherited;
end;

{TDraftGridView}

constructor TDraftGridView.Create(AWidget: TAndroidWidget; Canvas: TCanvas);
begin
  inherited;
end;

procedure TDraftGridView.Draw;
var
  i, k: integer;
begin
  Fcanvas.Brush.Color:= Self.BackGroundColor;
  Fcanvas.Pen.Color:= clActiveCaption;

  if  Self.BackGroundColor = clNone then Fcanvas.Brush.Style:= bsClear;

  Fcanvas.FillRect(0,0,Self.Width,Self.Height);
  // outer frame
  Fcanvas.Rectangle(0,0,Self.Width,Self.Height);

  Fcanvas.Brush.Style:= bsSolid;

  Fcanvas.Pen.Color:= clSilver;

  //H lines
  k:= Trunc((Self.Height-Self.MarginTop-Self.MarginBottom)/70);
  for i:= 1 to k do
  begin
    Fcanvas.MoveTo(Self.Width-Self.MarginRight+10, {x2} Self.MarginTop+i*70); {y1}
    Fcanvas.LineTo(Self.MarginLeft-10,Self.MarginTop+i*70);  {x1, y1}
  end;

  //V  lines
  k:= Trunc((Self.Width-Self.MarginLeft-Self.MarginRight)/70);
  for i:= 1 to k do
  begin
    Fcanvas.MoveTo((Self.MarginLeft-10)+i*70, Self.MarginTop-10);  {x1, y1}
    Fcanvas.LineTo((Self.MarginLeft-10)+i*70, Self.Height); {y1}
  end;

  //Fcanvas.Brush.Style:= bs
  //Fcanvas.Font.Color:= Self.TextColor;
  //Fcanvas.TextOut(5,4, txt);
end;

initialization
  DraftClassesMap := TDraftControlHash.Create(64); // power of 2 for efficiency
  RegisterPropertyEditor(TypeInfo(TARGBColorBridge), nil, '', TARGBColorBridgePropertyEditor);
  RegisterPropertyEditor(TypeInfo(jVisualControl), jVisualControl, 'Anchor', TAnchorPropertyEditor);
  RegisterComponentEditor(jForm, TAndroidFormComponentEditor);

  // DraftClasses registeration:
  RegisterAndroidWidgetDraftClass(jProgressBar, TDraftProgressBar);
  RegisterAndroidWidgetDraftClass(jButton, TDraftButton);
  RegisterAndroidWidgetDraftClass(jCheckBox, TDraftCheckBox);
  RegisterAndroidWidgetDraftClass(jRadioButton, TDraftRadioButton);
  RegisterAndroidWidgetDraftClass(jTextView, TDraftTextView);
  RegisterAndroidWidgetDraftClass(jPanel, TDraftPanel);
  RegisterAndroidWidgetDraftClass(jEditText, TDraftEditText);
  RegisterAndroidWidgetDraftClass(jSwitchButton, TDraftSwitchButton);

finalization
  DraftClassesMap.Free;
end.

