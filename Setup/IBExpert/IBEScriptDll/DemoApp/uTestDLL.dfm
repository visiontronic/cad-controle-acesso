object Form1: TForm1
  Left = 461
  Top = 230
  Width = 555
  Height = 454
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Pages: TPageControl
    Left = 0
    Top = 0
    Width = 547
    Height = 427
    ActivePage = TabSheet2
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Execute from file'
      object Label1: TLabel
        Left = 8
        Top = 5
        Width = 47
        Height = 13
        Caption = 'File Name'
      end
      object fne: TEdit
        Left = 8
        Top = 23
        Width = 361
        Height = 21
        TabOrder = 0
      end
      object Button1: TButton
        Left = 392
        Top = 22
        Width = 129
        Height = 25
        Caption = 'Execute!'
        TabOrder = 1
        OnClick = Button1Click
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Execute text'
      ImageIndex = 1
      object mScript: TMemo
        Left = 0
        Top = 41
        Width = 539
        Height = 358
        Align = alClient
        Lines.Strings = (
          'execute ibeblock'
          'as'
          'begin'
          '  ibec_showmessage('#39'test'#39');'
          'end')
        TabOrder = 0
      end
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 539
        Height = 41
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 1
        object Label2: TLabel
          Left = 0
          Top = 24
          Width = 51
          Height = 13
          Caption = 'Script Text'
        end
        object Button2: TButton
          Left = 400
          Top = 8
          Width = 129
          Height = 25
          Caption = 'Execute!'
          TabOrder = 0
          OnClick = Button2Click
        end
      end
    end
    object tsOutput: TTabSheet
      Caption = 'Output'
      ImageIndex = 2
      object mLog: TMemo
        Left = 0
        Top = 0
        Width = 539
        Height = 399
        Align = alClient
        Lines.Strings = (
          '')
        TabOrder = 0
      end
    end
  end
end
