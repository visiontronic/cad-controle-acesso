unit IBEIntfEx;

interface

uses Windows;

const
  CM_PLUGIN_FORM_DESTROING = $2018;

  // Code Editor Object Properties
  ceopUnknown           = 0;
  ceopCode              = 1;
  ceopDescription       = 2;
  ceopDDL               = 3;
  ceopScript            = 4;

  
  // Tokens
  itkBOF                = 0;
  itkEOF                = 1;
  itkIdentifier         = 2;
  itkDoubleQuotedString = 3;
  itkSingleQuotedString = 4;
  itkMinus              = 5;
  itkPlus               = 6;
  itkLeftBracket        = 7;
  itkRightBracket       = 8;
  itkComma              = 9;
  itkColon              = 10;
  itkSemicolon          = 11;
  itkPoint              = 12;
  itkComment            = 13;
  itkAssign             = 14;
  itkSlash              = 15;
  itkUnknown            = 16;
  itkSpaceChars         = 17;
  itkSingleLineComment  = 18;
  itkLF                 = 19;
  itkName               = 20;
  itkCR                 = 21;

  //SQL types
  itSQL_VARYING                    =        448;
  itSQL_TEXT                       =        452;
  itSQL_DOUBLE                     =        480;
  itSQL_FLOAT                      =        482;
  itSQL_LONG                       =        496;
  itSQL_SHORT                      =        500;
  itSQL_TIMESTAMP                  =        510;
  itSQL_BLOB                       =        520;
  itSQL_D_FLOAT                    =        530;
  itSQL_ARRAY                      =        540;
  itSQL_QUAD                       =        550;
  itSQL_TYPE_TIME                  =        560;
  itSQL_TYPE_DATE                  =        570;
  itSQL_INT64                      =        580;
  itSQL_DATE                       =        510;
  itSQL_BOOLEAN                    =        590;

  // Connection protocols
  icpTCP     = 0;
  icpNetBEUI = 1;
  icpSPX     = 2;
  icpLocal   = 3;
  icpUnknown = 4;

  // Database object
  idoDomain = 0;
  idoTable  = 1;
  idoView   = 2;
  idoTrigger = 3;
  idoProcedure = 4;
  idoGenerator = 5;
  idoException = 6;
  idoUDF       = 7;
  idoRole      = 8;

  // Constraint types
  ictAll        = 0;
  ictPrimaryKey = 1;
  ictForeignKey = 2;
  ictCheck      = 3;
  ictUnique     = 4;

type

  hDB = pointer;                  // Database
  hDBOL = pointer;                // Database objects list
  hTFL = pointer;                 // Table fields list
  hTCL = pointer;                 // Table constraints list
  hTrgL = pointer;                // Triggers list
  hIndL = pointer;                // Indices list
  hVar = pointer;                 // Pointer to variant
  hField = pointer;               // Query field
  hParam = pointer;               // Query parameter
  hCodeEditor = pointer;          // Code editor
  hTokenList = pointer;           // Token list
  hTransaction = pointer;         // Transaction
  hQuery = pointer;               // Query

  PIBEPluginInfoEx = ^TIBEPluginInfoEx;
  TIBEPluginInfoEx = record
    PluginName  : PChar;
    Description : PChar;
    MenuStructure : PChar;
    PlaceMenu : PChar;
  end;

  { Error Information }
  PIBEErrorInfo = ^TIBEErrorInfo;
  TIBEErrorInfo = record
    ErrorType : integer;
    SQLCode : integer;
    Message : PChar;
  end;


  PibeiTokenInfo = ^TibeiTokenInfo;
  TibeiTokenInfo = record
    TokenKind : integer;
    Token : PChar;
  end;

  PibeiDatabaseInfo = ^TibeiDatabaseInfo;
  TibeiDatabaseInfo = record
    Alias : PChar;
    FileName : PChar;
    ConnectionString : PChar;
    Protocol : integer;
    ProtocolAsString : PChar;
    ServerName : PChar;

    UserName : PChar;
    Password : PChar;
    Role : PChar;
    ConnectionCharset : PChar;

    ParamsUserName : PChar;
    ParamsPassword : PChar;

    ISC4FileName : PChar;
    ISC4ConnectionString : PChar;

    DefaultCharset : PChar;
  end;

  PibeiDatabaseObjectInfo = ^TibeiDatabaseObjectInfo;
  TibeiDatabaseObjectInfo = record
    Name : PChar;
    Description : PChar;
    System : integer;
    ParentName : PChar;
  end;

  PibeiTriggerInfo = ^TibeiTriggerInfo;
  TibeiTriggerInfo = record
    TriggerName : PChar;
    TableName : PChar;
    TriggerType : integer;
    TriggerTypeAsString : PChar;
    Active : integer;
    Position : integer;
    IsSystem : integer;
    DDL : PChar;
    Description : PChar;
  end;

  { Information about field of table }
  PibeiFieldInfo = ^TibeiFieldInfo;
  TIBEIFieldInfo = record
    FieldName       : PChar;
    FieldDomain     : PChar;
    FieldPos        : WORD;
    FieldType       : WORD;
    FieldSubType    : integer; // for Blob fields
    FieldSegmentLen : WORD;    // for Blob fields
    FieldLen        : WORD;
    FieldScale      : integer; // <= 0
    CharacterLen    : integer;
    Dimensions      : PChar;   // as [a,b,c]
    NotNull         : boolean;
    DefaultSource   : PChar;
    ComputedSource  : PChar;
    CollationId     : integer;
    CharSetId       : integer;
    Collation       : PChar;
    CharSet         : PChar;
    FieldTypeAsString : PChar;
    Description : PChar;
  end;

  PibeiConstraintInfo = ^TibeiConstraintInfo;
  TibeiConstraintInfo = record
    ConstraintName : PChar;
    ConstraintType : integer;
    TableName : PChar;
    OnField : PChar;
    ForeignTable : PChar;
    ForeignField : PChar;
    UpdateRule : integer;
    UpdateRuleAsString : PChar;
    DeleteRule : integer;
    DeleteRuleAsString : PChar;
    CheckSource : PChar;
  end;

  PibeiIndexInfo = ^TibeiIndexInfo;
  TibeiIndexInfo = record
    IndexName : PChar;
    TableName : PChar;
    Fields : PChar;
    Active : integer;
    Descending : integer;
    Unique : integer;
    Statistics : double;
    DDL : PChar;
  end;


{=============================================================================}
  TDummyProc = procedure;

  TMainAPPHandle = function : longint;

  TGetListCount = function (AList : pointer) : integer;
  TGetLngString = function (Index : integer) : PChar;
  TGetLngStringDef = function (Index : integer; DefStr : PChar) : PChar;

  TCreateTokenList = function (AText : PChar) : hTokenList;
  TGetTokenInfo = function (TL : hTokenList; TokenIndex : integer) : PibeiTokenInfo;
  TFreeTokenList = function (TL : hTokenList) : integer;

  { Database functions }
  TDBCount = function : integer;
  TActiveDBCount = function : integer;

  TGetCurrentDB = function : hDB;
  TGetDBByName = function (DBName : PChar; CaseSensitive : integer) : hDB;
  TGetDBByAlias =  function (DBAlias : PChar; CaseSensitive : integer) : hDB;
  TGetDBByIndex = function(DBIndex : integer) : hDB;
  TIsDBActive = function (DB : hDB) : integer;
  TOpenDB = function (DB : hDB) : integer;
  TCloseDB = function (DB : hDB) : integer;


  TGetDBInfo = function (DB : hDB) : PibeiDatabaseInfo;
  TFreeDBInfo = procedure (DBInfo : PibeiDatabaseInfo);

  TCreateDBObjectsList = function (DB : hDB; ObjectType, IncludeSystem : integer) : hDBOL;
  TGetDBObjectInfo = function (ObjectsList : hDBOL; Index : integer) : PibeiDatabaseObjectInfo;
  TFreeDBObjectsList = procedure (ObjectsList : hDBOL);

  TCreateTableFieldsList = function (DB : hDB; TableName : PChar) : hTFL;
  TGetTableFieldInfo = function (FieldsList : hTFL; Index : integer) : PibeiFieldInfo;
  TFreeTableFieldsList = procedure (FieldsList : hTFL);

  TCreateConstraintsList = function (DB : hDB; TableName : PChar; ConstraintType : integer) : hTCL;
  TGetConstraintInfo = function (ConstraintsList : hTCL; Index : integer) : PibeiConstraintInfo;
  TFreeConstraintsList = function (ConstraintsList : hTCL) : integer;

  TCreateTriggersList = function (DB : hDB; TableName : PChar; WithSource : integer) : hTrgL;
  TGetTriggerInfo = function (TL : hTrgL; Index : integer) : PibeiTriggerInfo;
  TFreeTriggersList = function (TL : hTrgL) : integer;

  TCreateIndicesList = function (DB : hDB; TableName : PChar) : hIndL;
  TGetIndexInfo = function (IL : hIndL; Index : integer) : PibeiIndexInfo;
  TFreeIndicesList = function (IL : hIndL) : integer;

  TCreateDomain = function(DB : hDB; DomainName, DomainDDL : PChar) : integer;
  TDropDomain = function(DB : hDB; DomainName : PChar) : integer;
  TAlterDomain = function(DB : hDB; OldDomainName, NewDomainName, DomainDDL : PChar) : integer;

  TCreateTable = function(DB : hDB; TableName, TableDDL : PChar) : integer;
  TDropTable = function(DB : hDB; TableName : PChar) : integer;
  TAlterTable = function(DB : hDB; TableName, TableDDL : PChar) : integer;

  TCreateView = function(DB : hDB; ViewName, ViewDDL : PChar) : integer;
  TDropView = function(DB : hDB; ViewName : PChar) : integer;

  TCreateProcedure = function(DB : hDB; ProcName, ProcDDL : PChar) : integer;
  TDropProcedure = function(DB : hDB; ProcName : PChar) : integer;
  TAlterProcedure = function(DB : hDB; ProcName, ProcDDL : PChar) : integer;

  TCreateTrigger = function(DB : hDB; TrgName, TrgDDL : PChar) : integer;
  TDropTrigger = function(DB : hDB; TrgName : PChar) : integer;
  TAlterTrigger = function(DB : hDB; TrgName, TrgDDL : PChar) : integer;

  TCreateException = function(DB : hDB; ExcName, ExcText : PChar) : integer;
  TDropException = function(DB : hDB; ExcName : PChar) : integer;
  TAlterException = function(DB : hDB; ExcName, ExcText : PChar) : integer;

  TCreateGenerator = function(DB : hDB; GenName : PChar) : integer;
  TDropGenerator = function(DB : hDB; GenName : PChar) : integer;
  TSetGeneratorValue = function(DB : hDB; GenName : PChar; Value : Int64) : integer;

  TCreateUDF = function(DB : hDB; UDFName, UDFDDL : PChar) : integer;
  TDropUDF = function(DB : hDB; UDFName : PChar) : integer;

  { Transaction functions }
  TCreateTransaction2 = function(DB : hDB; Params : PChar) : hTransaction;
  TStartTransaction2 = function(Transaction : hTransaction) : integer;
  TCommitTransaction2 = function(Transaction : hTransaction) : integer;
  TRollbackTransaction2 = function(Transaction : hTransaction) : integer;
  TFreeTransaction2 = function(Transaction : hTransaction) : integer;

  TCreateQuery2 = function (DB : hDB; Transaction : hTransaction) : hQuery;
  TSetQuerySQL2 = function (Query : hQuery; SQL : PChar) : integer;
  TPrepareQuery2 = function (Query : hQuery) : integer;
  TGetQueryPlan = function (Query : hQuery) : PChar;
  TExecQuery2 = function (Query : hQuery) : integer;
  TQueryNext2 = function (Query : hQuery) : integer;
  TQueryEof2 = function (Query : hQuery) : integer;
  TGetQueryFieldByIndex = function (Query : hQuery; Index : integer) : hField;
  TGetQueryFieldByName = function (Query : hQuery; FieldName : PChar) : hField;
  TGetFieldName = function (Fld : hField) : PChar;
  TGetFieldSQLType = function (Fld : hField) : integer;
  TGetFieldValueAsString = function (Fld : hField) : PChar;
  TGetFieldValueAsInteger = function (Fld : hField) : integer;
  TGetFieldValueAsDouble = function (Fld : hField) : double;
  TGetFieldValueSize = function (Fld : hField) : integer;
  TGetFieldValueToBuffer = function (Fld : hField; Buffer:pointer; BufSize:Integer) : integer;

  TGetQueryParamByIndex = function (Query : hQuery; Index : integer) : hParam;
  TGetQueryParamByName = function (Query : hQuery; ParamName : PChar) : hParam;
  TSetParamAsString = function (Param : hParam; Value : PChar) : integer;
  TSetParamAsInteger = function (Param : hParam; Value : Integer) : integer;
  TSetParamAsDouble = function (Param : hParam; Value : Double) : integer;
  TSetParamAsNULL = function (Param : hParam) : integer;
  TSetQueryParamCheck = function (Query : hQuery; ParamCheck : integer) : integer;


  TFieldIsNull = function (Fld : hField) : integer;
  TFreeQuery2 = function (Query : hQuery) : integer;


  {----------------------------------------------------------------------}
  { Code Editor Functions                                                }
  {----------------------------------------------------------------------}

  TGetCurrentCodeEditor = function  : hCodeEditor;

  TGetCodeEditorKeywords = function (CE : hCodeEditor) : PChar;
  TCodeEditorAddKeyword = function (CE : hCodeEditor; KeyWord : PChar) : integer;

  TCodeEditorBeginUpdate = function (CE : hCodeEditor) : integer;
  TCodeEditorEndUpdate = function (CE : hCodeEditor) : integer;
  TGetCodeEditorText = function (CE : hCodeEditor) : PChar;
  TGetCodeEditorSelectedText = function (CE : hCodeEditor) : PChar;
  TSetCodeEditorSelectedText = function (CE : hCodeEditor; AText : PChar) : integer;
  TSetCodeEditorText = function (CE : hCodeEditor; AText : PChar) : integer;

  TGetCodeEditorLineCount = function (CE : hCodeEditor) : integer;
  TGetCodeEditorLine = function (CE : hCodeEditor; LineIndex : integer) : PChar;
  TSetCodeEditorLine = function (CE : hCodeEditor; LineIndex : integer; ALineText : PChar) : integer;

  TGetCodeEditorBlockBegin = function (CE : hCodeEditor) : TPoint;
  TGetCodeEditorBlockEnd = function (CE : hCodeEditor) : TPoint;
  TSetCodeEditorBlockBegin = function (CE : hCodeEditor; BlockBegin : TPoint) : integer;
  TSetCodeEditorBlockEnd = function (CE : hCodeEditor; BlockEnd : TPoint) : integer;

  TCreateCodeEditor = function (AOwner, AParent : pointer) : hCodeEditor;
  TFreeCodeEditor = function (CE : hCodeEditor) : integer;
  TGetCodeEditorWindowHandle = function (CE : hCodeEditor) : cardinal;
  TSetCodeEditorDatabase = function (CE : hCodeEditor; DB : HDB) : integer;

  TCreateMDIChildForm = function  : pointer;
  TSetPluginControlParent = function (PluginControl, ParentWindow : cardinal) : integer;


  TIBEInterfaceEx = record
    LastError : TIBEErrorInfo;
    MainApplication: pointer;
    MainImageList : longint;

    GetListCount : TGetListCount;
    GetLngString : TGetLngString;

    CreateTokenList : TCreateTokenList;
    GetTokenInfo : TGetTokenInfo;
    FreeTokenList : TFreeTokenList;

    DBCount : TDBCount;
    ActiveDBCount : TActiveDBCount;

    GetCurrentDB : TGetCurrentDB;
    GetDBByIndex : TGetDBByIndex;
    GetDBByName : TGetDBByName;
    GetDBByAlias : TGetDBByAlias;
    IsDBActive : TIsDBActive;
    OpenDB : TOpenDB;
    CloseDB : TCloseDB;

    GetDBInfo : TGetDBInfo;
    FreeDBInfo : TFreeDBInfo;

    CreateDBObjectsList : TCreateDBObjectsList;
    GetDBObjectInfo : TGetDBObjectInfo;
    FreeDBObjectsList : TFreeDBObjectsList;

    CreateTableFieldsList : TCreateTableFieldsList;
    GetTableFieldInfo : TGetTableFieldInfo;
    FreeTableFieldsList : TFreeTableFieldsList;

    CreateConstraintsList : TCreateConstraintsList;
    GetConstraintInfo : TGetConstraintInfo;
    FreeConstraintsList : TFreeConstraintsList;

    CreateTriggersList : TCreateTriggersList;
    GetTriggerInfo : TGetTriggerInfo;
    FreeTriggersList : TFreeTriggersList;

    CreateIndicesList : TCreateIndicesList;
    GetIndexInfo : TGetIndexInfo;
    FreeIndicesList : TFreeIndicesList;

    CreateTransaction : TCreateTransaction2;
    StartTransaction : TStartTransaction2;
    CommitTransaction : TCommitTransaction2;
    RollbackTransaction : TRollbackTransaction2;
    FreeTransaction : TFreeTransaction2;

    CreateQuery : TCreateQuery2;
    SetQuerySQL : TSetQuerySQL2;
    PrepareQuery : TPrepareQuery2;
    GetQueryPlan : TGetQueryPlan;
    ExecQuery : TExecQuery2;
    QueryNext : TQueryNext2;
    QueryEof : TQueryEof2;
    GetQueryFieldByIndex : TGetQueryFieldByIndex;
    GetQueryFieldByName : TGetQueryFieldByName;
    GetFieldSQLType : TGetFieldSQLType;
    GetFieldName : TGetFieldName;
    GetFieldValueAsString : TGetFieldValueAsString;
    GetFieldValueAsInteger : TGetFieldValueAsInteger;
    GetFieldValueAsDouble : TGetFieldValueAsDouble;
    GetFieldValueSize : TGetFieldValueSize;
    GetFieldValueToBuffer : TGetFieldValueToBuffer;

    GetQueryParamByIndex : TGetQueryParamByIndex;
    GetQueryParamByName : TGetQueryParamByName;
    SetParamAsString : TSetParamAsString;
    SetParamAsInteger : TSetParamAsInteger;
    SetParamAsDouble : TSetParamAsDouble;
    SetParamAsNULL : TSetParamAsNULL;

    FieldIsNull : TFieldIsNull;
    FreeQuery : TFreeQuery2;

    GetCurrentCodeEditor : TGetCurrentCodeEditor;
    GetCodeEditorKeywords : TGetCodeEditorKeywords;
    CodeEditorAddKeyword : TCodeEditorAddKeyword;
    CodeEditorBeginUpdate : TCodeEditorBeginUpdate;
    CodeEditorEndUpdate : TCodeEditorEndUpdate;
    GetCodeEditorText : TGetCodeEditorText;
    GetCodeEditorSelectedText : TGetCodeEditorSelectedText;
    SetCodeEditorSelectedText : TSetCodeEditorSelectedText;
    SetCodeEditorText : TSetCodeEditorText;
    GetCodeEditorLineCount : TGetCodeEditorLineCount;
    GetCodeEditorLine : TGetCodeEditorLine;
    SetCodeEditorLine : TSetCodeEditorLine;
    GetCodeEditorBlockBegin : TGetCodeEditorBlockBegin;
    GetCodeEditorBlockEnd : TGetCodeEditorBlockEnd;
    SetCodeEditorBlockBegin : TSetCodeEditorBlockBegin;
    SetCodeEditorBlockEnd : TSetCodeEditorBlockEnd;

    GetLngStringDef : TGetLngStringDef;
    CreateCodeEditor : TCreateCodeEditor;

    MainScreen : pointer;

    FreeCodeEditor : TFreeCodeEditor;
    GetCodeEditorWindowHandle : TGetCodeEditorWindowHandle;
    SetCodeEditorDatabase : TSetCodeEditorDatabase;

    CreateMDIChildForm : TCreateMDIChildForm;
    SetPluginControlParent : TSetPluginControlParent;

    MainAPPHandle : TMainAPPHandle;

    SetQueryParamCheck : TSetQueryParamCheck;

    CreateDomain : TCreateDomain;
    AlterDomain : TAlterDomain;
    DropDomain : TDropDomain;

    CreateTable : TCreateTable;
    AlterTable : TAlterTable;
    DropTable : TDropTable;

    CreateView : TCreateView;
    DropView : TDropView;

    CreateProcedure : TCreateProcedure;
    AlterProcedure : TAlterProcedure;
    DropProcedure : TDropProcedure;

    CreateTrigger : TCreateTrigger;
    AlterTrigger : TAlterTrigger;
    DropTrigger : TDropTrigger;

    CreateException : TCreateException;
    AlterException : TAlterException;
    DropException : TDropException;

    CreateGenerator : TCreateGenerator;
    DropGenerator : TDropGenerator;
    SetGeneratorValue : TSetGeneratorValue;

    CreateUDF : TCreateUDF;
    DropUDF : TDropUDF;

    Reserved : array [111..2000] of TDummyProc;
  end;

  TGetPluginInfoProcEx = procedure(Intf : TIBEInterfaceEx; PluginInfoEx: PIBEPluginInfoEx); stdcall;
  TPluginExecuteProcEx = procedure(Intf : TIBEInterfaceEx); stdcall;
  TPluginUpdateActionFuncEx = function(Intf : TIBEInterfaceEx) : integer; stdcall;
  TPluginCommonProcEx = procedure(Intf : TIBEInterfaceEx); stdcall;

implementation

end.
