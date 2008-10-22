unit MainUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, Gauges, IpHlpApi, IpTypes, IpIfConst,
  inifiles, registry, FileCtrl, XPMan, ShellApi;

type
  TSystemInfoForm = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Button1: TButton;
    Image1: TImage;
    Bevel1: TBevel;
    Label1: TLabel;
    TabSheet2: TTabSheet;
    Label2: TLabel;
    TotalPhys: TLabel;
    Label3: TLabel;
    TotalPage: TLabel;
    Label4: TLabel;
    AvailPhys: TLabel;
    Label6: TLabel;
    AvailPage: TLabel;
    Image2: TImage;
    Bevel2: TBevel;
    Label8: TLabel;
    Bevel3: TBevel;
    Label5: TLabel;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    Label14: TLabel;
    Label15: TLabel;
    HostNameLabel: TLabel;
    Label16: TLabel;
    NodeTypeLabel: TLabel;
    Label17: TLabel;
    NetBIOSScopeLabel: TLabel;
    Label18: TLabel;
    IPRoutingLabel: TLabel;
    Label19: TLabel;
    WINSProxyLabel: TLabel;
    Label20: TLabel;
    NetBIOSResolutionLabel: TLabel;
    DNSListBox: TListBox;
    Image3: TImage;
    Label13: TLabel;
    Bevel4: TBevel;
    Image4: TImage;
    Label21: TLabel;
    Bevel5: TBevel;
    AdapterCB: TComboBox;
    ScrollBox1: TScrollBox;
    Label22: TLabel;
    Label23: TLabel;
    DescriptionLabel: TLabel;
    PhysicaladdressLabel: TLabel;
    Label24: TLabel;
    AdapterTypeLabel: TLabel;
    AdapterNameLabel: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    DHCPLabel: TLabel;
    Label27: TLabel;
    GatewayLabel: TLabel;
    DHCPServerLabel: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    PrimaryWINSLabel: TLabel;
    SecondaryWINSLabel: TLabel;
    Label30: TLabel;
    IPListView: TListView;
    Label31: TLabel;
    Label32: TLabel;
    ComputerLabel: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    ProcessorLabel: TLabel;
    MMXIdentifierLabel: TLabel;
    VendorIdentifierLabel: TLabel;
    TabSheet5: TTabSheet;
    Label12: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    Label36: TLabel;
    Label37: TLabel;
    Label39: TLabel;
    Label40: TLabel;
    Label46: TLabel;
    Image5: TImage;
    Label7: TLabel;
    Bevel6: TBevel;
    OSNameLabel: TLabel;
    VersionLabel: TLabel;
    VersionNumberLabel: TLabel;
    RegisteredOrganizationLabel: TLabel;
    RegisteredOwnerLabel: TLabel;
    SerNumberEdit: TLabel;
    WindowsDirLabel: TLabel;
    TempDir: TLabel;
    TabSheet6: TTabSheet;
    Label35: TLabel;
    Label38: TLabel;
    Label41: TLabel;
    Label42: TLabel;
    Label43: TLabel;
    Image6: TImage;
    Label44: TLabel;
    Bevel7: TBevel;
    VolumeName: TLabel;
    VolumeSerial: TLabel;
    FileSystemName: TLabel;
    SectorsPerCluster: TLabel;
    DriveComboBox1: TDriveComboBox;
    BytesPerSector: TLabel;
    XPManifest1: TXPManifest;
    TabSheet7: TTabSheet;
    Button2: TButton;
    Image7: TImage;
    Label45: TLabel;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure AdapterCBChange(Sender: TObject);
    procedure DriveComboBox1Change(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
    procedure GetMemoryInfo;
    procedure GetCompInfo;
    procedure GetIPInfo;
    procedure GetAdapterInfo;
    procedure UpdateDisk;
  public
    { Public declarations }
  end;

var
  SystemInfoForm: TSystemInfoForm;

implementation

{$R *.dfm}

procedure TSystemInfoForm.Button1Click(Sender: TObject);
begin
 Close;
end;

procedure TSystemInfoForm.FormShow(Sender: TObject);
begin
 PageControl1.ActivePageIndex:=0;
 GetMemoryInfo;
 GetCompInfo;
 GetIPInfo;
 GetAdapterInfo;
 UpdateDisk;
end;

procedure TSystemInfoForm.GetAdapterInfo;
var
 Err, AdapterInfoSize:DWORD;
 pAdapterInfo, pAdapt:PIP_ADAPTER_INFO;
 Str:String;
 i:Integer;
 pAddrStr:PIP_ADDR_STRING;
begin
 AdapterTypeLabel.Caption:='';
 AdapterNameLabel.Caption:='';
 DescriptionLabel.Caption:='';
 PhysicaladdressLabel.Caption:='';
 IPListView.Clear;
 GatewayLabel.Caption:='';
 DHCPLabel.Caption:='';
 DHCPServerLabel.Caption:='';
 SecondaryWINSLabel.Caption:='';
 PrimaryWINSLabel.Caption:='';

 AdapterInfoSize:=0;
 Err:=GetAdaptersInfo(nil, AdapterInfoSize);

 if (Err<>0) and (Err<>ERROR_BUFFER_OVERFLOW) then
  begin
   AdapterCB.Items.Add('Error');
   exit;
  end;

 pAdapterInfo := PIP_ADAPTER_INFO(GlobalAlloc(GPTR, AdapterInfoSize));
 GetAdaptersInfo(pAdapterInfo, AdapterInfoSize);
 pAdapt := pAdapterInfo;

 while pAdapt<>nil do
  begin
   case pAdapt.Type_ of
    MIB_IF_TYPE_ETHERNET:
     Str:='Ethernet adapter ';
    MIB_IF_TYPE_TOKENRING:
     Str:='Token Ring adapter ';
    MIB_IF_TYPE_FDDI:
     Str:='FDDI adapter ';
    MIB_IF_TYPE_PPP:
     Str:='PPP adapter ';
    MIB_IF_TYPE_LOOPBACK:
     Str:='Loopback adapter ';
    MIB_IF_TYPE_SLIP:
     Str:='Slip adapter ';
    MIB_IF_TYPE_OTHER:
     Str:='Other adapter ';
   end;

   if Str+pAdapt.AdapterName<>AdapterCB.Text then
    begin
     pAdapt := pAdapt.Next;
     Continue;
    end;

    AdapterTypeLabel.Caption:=Str;
    AdapterNameLabel.Caption:=AdapterCB.Text;
    DescriptionLabel.Caption:=pAdapt.Description;

    Str:='';
    for i:=0 to pAdapt.AddressLength-1 do
     begin
      Str:=Str+IntToHex(pAdapt.Address[i],2);
      if i<>Integer(pAdapt.AddressLength-1) then
       Str:=Str+'-';
     end;
    PhysicaladdressLabel.Caption:=Str;

    pAddrStr:=@pAdapt.IpAddressList;
    while pAddrStr<>nil do
     begin
      with IPListView.Items.Add do
       begin
        Caption:=pAddrStr.IpAddress.S;
        SubItems.Add(pAddrStr.IpMask.S);
       end;
      pAddrStr := pAddrStr.Next;
     end;

    if pAdapt.DhcpEnabled=0 then
     DHCPLabel.Caption:='no'
    else
     DHCPLabel.Caption:='yes';

    DHCPServerLabel.Caption:=pAdapt.DhcpServer.IpAddress.S;
    PrimaryWINSLabel.Caption:=pAdapt.PrimaryWinsServer.IpAddress.S;
    SecondaryWINSLabel.Caption:=pAdapt.SecondaryWinsServer.IpAddress.S;
    GatewayLabel.Caption:=pAdapt.GatewayList.IpAddress.S;
    break;
  end;
 GlobalFree(Cardinal(pAdapterInfo));
end;

procedure TSystemInfoForm.GetCompInfo;
var
 SystemIniFile:TIniFile;
 RegFile:TRegIniFile;
 PathArray : array [0..255] of char;
 OSVersion: TOSVersionInfo;
begin
 //Computer
 SystemIniFile:=TIniFile.Create('System.ini');
 ComputerLabel.Caption:=SystemIniFile.ReadString('boot.description', 'system.drv', 'Unknown');
 SystemIniFile.Free;

 RegFile:=TRegIniFile.Create('Software');
 RegFile.RootKey:=HKEY_LOCAL_MACHINE;
 RegFile.OpenKey('hardware',false);
 RegFile.OpenKey('DESCRIPTION',false);
 RegFile.OpenKey('System',false);
 RegFile.OpenKey('CentralProcessor',false);
 ProcessorLabel.Caption:=RegFile.ReadString('0','Identifier','Unknown');
 MMXIdentifierLabel.Caption:=RegFile.ReadString('0','MMXIdentifier','Unknown');
 VendorIdentifierLabel.Caption:=RegFile.ReadString('0','VendorIdentifier','Unknown');

//OS
 OSVersion.dwOSVersionInfoSize := SizeOf(OSVersion);

 if GetVersionEx(OSVersion) then
  begin
   VersionLabel.Caption:= Format('%d.%d (%d.%s)',[OSVersion.dwMajorVersion, OSVersion.dwMinorVersion,(OSVersion.dwBuildNumber and $FFFF), OSVersion.szCSDVersion]);
   case OSVersion.dwPlatformID of
    VER_PLATFORM_WIN32s:        VersionNumberLabel.Caption := 'Windows 3.1';
    VER_PLATFORM_WIN32_WINDOWS: VersionNumberLabel.Caption := 'Windows 95';
    VER_PLATFORM_WIN32_NT:      VersionNumberLabel.Caption := 'Windows NT';
   else                        VersionNumberLabel.Caption := '';
   end;  //of case
  end; //of if

 RegFile.CloseKey;
 RegFile.OpenKey('SOFTWARE',false);
 RegFile.OpenKey('Microsoft',false);
 RegFile.OpenKey('Windows NT',false);
 OSNameLabel.Caption:=RegFile.ReadString('CurrentVersion','ProductName','Unknown');
 RegisteredOrganizationLabel.Caption:=RegFile.ReadString('CurrentVersion','RegisteredOrganization','Unknown');
 RegisteredOwnerLabel.Caption:=RegFile.ReadString('CurrentVersion','RegisteredOwner','Unknown');
 SerNumberEdit.Caption:=RegFile.ReadString('CurrentVersion','ProductId','Unknown');
 RegFile.Free;

 FillChar(PathArray, SizeOf(PathArray), #0);
 GetWindowsDirectory(PathArray,255);
 WindowsDirLabel.Caption:= Format('%s',[PathArray]);

 FillChar(PathArray, SizeOf(PathArray), #0);
 ExpandEnvironmentStrings('%TEMP%', PathArray, 255);
 TempDir.Caption:=Format('%s',[PathArray]);
end;

procedure TSystemInfoForm.GetIPInfo;
var
 FixedInfoSize, Err, AdapterInfoSize:DWORD;
 pFixedInfo:PFIXED_INFO;
 pAdapterInfo, pAdapt:PIP_ADAPTER_INFO;
 pAddrStr:PIP_ADDR_STRING;
begin
 FixedInfoSize:=0;
 Err:=GetNetworkParams(nil, FixedInfoSize);

 if (Err<>0) and (Err<>ERROR_BUFFER_OVERFLOW) then
  begin
   HostNameLabel.Caption:='Error';
   exit;
  end;

 pFixedInfo:=PFIXED_INFO(GlobalAlloc(GPTR, FixedInfoSize));
 GetNetworkParams(pFixedInfo, FixedInfoSize);

 HostNameLabel.Caption:=StrPas(pFixedInfo.HostName);

 DNSListBox.Items.Clear;
 DNSListBox.Items.Add(StrPas(pFixedInfo.DnsServerList.IpAddress.S));

 pAddrStr:=pFixedInfo.DnsServerList.Next;

 while (pAddrStr<>nil) do
  begin
    DNSListBox.Items.Add(StrPas(pAddrStr.IpAddress.S));
   pAddrStr:=pAddrStr.Next;
  end;

 case pFixedInfo.NodeType of
  1: NodeTypeLabel.Caption:='Broadcast';
  2: NodeTypeLabel.Caption:='Peer to peer';
  4: NodeTypeLabel.Caption:='Mixed';
  8: NodeTypeLabel.Caption:='Hybrid';
 end;

 NetBIOSScopeLabel.Caption:=pFixedInfo.ScopeId;

 if pFixedInfo.EnableRouting>0 then
  IPRoutingLabel.Caption:='Yes'
 else
  IPRoutingLabel.Caption:='No';

 if pFixedInfo.EnableProxy>0 then
  WINSProxyLabel.Caption:='Yes'
 else
  WINSProxyLabel.Caption:='No';

 if pFixedInfo.EnableDns>0 then
  NetBIOSResolutionLabel.Caption:='Yes'
 else
  NetBIOSResolutionLabel.Caption:='No';

 //Get Adapter Info
 AdapterCB.Items.Clear;
 AdapterInfoSize:=0;
 Err:=GetAdaptersInfo(nil, AdapterInfoSize);

 if (Err<>0) and (Err<>ERROR_BUFFER_OVERFLOW) then
  begin
   AdapterCB.Items.Add('Error');
   exit;
  end;

 pAdapterInfo := PIP_ADAPTER_INFO(GlobalAlloc(GPTR, AdapterInfoSize));
 GetAdaptersInfo(pAdapterInfo, AdapterInfoSize);
 pAdapt := pAdapterInfo;

 while pAdapt<>nil do
  begin
   case pAdapt.Type_ of
    MIB_IF_TYPE_ETHERNET:
     AdapterCB.Items.Add('Ethernet adapter '+pAdapt.AdapterName);
    MIB_IF_TYPE_TOKENRING:
     AdapterCB.Items.Add('Token Ring adapter '+pAdapt.AdapterName);
    MIB_IF_TYPE_FDDI:
     AdapterCB.Items.Add('FDDI adapter '+pAdapt.AdapterName);
    MIB_IF_TYPE_PPP:
     AdapterCB.Items.Add('PPP adapter '+pAdapt.AdapterName);
    MIB_IF_TYPE_LOOPBACK:
     AdapterCB.Items.Add('Loopback adapter '+pAdapt.AdapterName);
    MIB_IF_TYPE_SLIP:
     AdapterCB.Items.Add('Slip adapter '+pAdapt.AdapterName);
    MIB_IF_TYPE_OTHER:
     AdapterCB.Items.Add('Other adapter '+pAdapt.AdapterName);
   end;
   pAdapt := pAdapt.Next;
  end;
 GlobalFree(Cardinal(pFixedInfo));
end;

procedure TSystemInfoForm.GetMemoryInfo;
var
 MemInfo : TMemoryStatus;
begin
 MemInfo.dwLength := Sizeof (MemInfo);
 GlobalMemoryStatus (MemInfo);

 TotalPhys.caption:=inttostr(MemInfo.dwTotalPhys div 1024) + ' K';
 AvailPhys.caption:=inttostr(MemInfo.dwAvailPhys div 1024) + ' K';

 TotalPage.caption:=inttostr(MemInfo.dwTotalPageFile div 1024) + ' K';
 AvailPage.caption:=inttostr(MemInfo.dwAvailPageFile div 1024) + ' K';

// RamGauge.Progress := MemInfo.dwAvailPhys div (MemInfo.dwTotalPhys div 100);
// VirtualGauge.Progress := MemInfo.dwAvailPageFile div (MemInfo.dwTotalPageFile div 100);

 {если значение слишком маленькое, то меняем цвет на красный}
// if (RamGauge.Progress < 5) then RamGauge.ForeColor := clRed
// else RamGauge.ForeColor := clActiveCaption;

// if (VirtualGauge.Progress < 20) then VirtualGauge.ForeColor := clRed
// else VirtualGauge.ForeColor := clActiveCaption;
end;

procedure TSystemInfoForm.AdapterCBChange(Sender: TObject);
begin
 GetAdapterInfo;
end;

procedure TSystemInfoForm.UpdateDisk;
var
 lpRootPathName           : PChar;
 lpVolumeNameBuffer       : PChar;
 nVolumeNameSize          : DWORD;
 lpVolumeSerialNumber     : DWORD;
 lpMaximumComponentLength : DWORD;
 lpFileSystemFlags        : DWORD;
 lpFileSystemNameBuffer   : PChar;
 nFileSystemNameSize      : DWORD;

 FSectorsPerCluster: DWORD;
 FBytesPerSector   : DWORD;
 FFreeClusters     : DWORD;
 FTotalClusters    : DWORD;
begin
 lpVolumeNameBuffer      := '';
 lpVolumeSerialNumber    := 0;
 lpMaximumComponentLength:= 0;
 lpFileSystemFlags       := 0;
 lpFileSystemNameBuffer  := '';

 try
  GetMem(lpVolumeNameBuffer, MAX_PATH + 1);
  GetMem(lpFileSystemNameBuffer, MAX_PATH + 1);
  nVolumeNameSize := MAX_PATH + 1;
  nFileSystemNameSize := MAX_PATH + 1;

  lpRootPathName := PChar(DriveComboBox1.Drive+':\');
  if GetVolumeInformation( lpRootPathName, lpVolumeNameBuffer,
      nVolumeNameSize, @lpVolumeSerialNumber, lpMaximumComponentLength,
      lpFileSystemFlags, lpFileSystemNameBuffer, nFileSystemNameSize )
   then
     begin
      VolumeName.Caption    := lpVolumeNameBuffer;
      VolumeSerial.Caption  := IntToHex(HIWord(lpVolumeSerialNumber), 4) + '-' + IntToHex(LOWord(lpVolumeSerialNumber), 4);
      FileSystemName.Caption:= lpFileSystemNameBuffer;
      GetDiskFreeSpace( PChar(DriveComboBox1.Drive+':\'), FSectorsPerCluster, FBytesPerSector,  FFreeClusters, FTotalClusters);
     end;
 finally
  FreeMem(lpVolumeNameBuffer);
  FreeMem(lpFileSystemNameBuffer);
  end;
 SectorsPerCluster.Caption:=IntToStr(FSectorsPerCluster);
 BytesPerSector.Caption:=IntToStr(FBytesPerSector);
end;

procedure TSystemInfoForm.DriveComboBox1Change(Sender: TObject);
begin
 UpdateDisk;
end;

procedure TSystemInfoForm.Button2Click(Sender: TObject);
begin
ShellExecute(0,
'open',
'Project1.exe',
nil,
nil,
SW_SHOWNORMAL);

end;

procedure TSystemInfoForm.Button3Click(Sender: TObject);
begin
ShellExecute(0,
'open',
'DisplayInfoProject.exe',
nil,
nil,
SW_SHOWNORMAL);
end;

end.
