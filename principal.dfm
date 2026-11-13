object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 654
  ClientWidth = 1178
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  TextHeight = 15
  object pnl1: TPanel
    Left = 0
    Top = 148
    Width = 1178
    Height = 53
    Align = alTop
    Caption = 'pnl1'
    TabOrder = 0
    ExplicitWidth = 1173
    object lbl1: TLabel
      AlignWithMargins = True
      Left = 9
      Top = 17
      Width = 69
      Height = 27
      Margins.Left = 8
      Margins.Top = 16
      Margins.Bottom = 8
      Align = alLeft
      Caption = 'Pasta origem'
      ExplicitHeight = 15
    end
    object lbl2: TLabel
      AlignWithMargins = True
      Left = 464
      Top = 17
      Width = 70
      Height = 27
      Margins.Left = 8
      Margins.Top = 16
      Margins.Bottom = 8
      Align = alLeft
      Caption = 'Pasta destino'
      ExplicitHeight = 15
    end
    object edt_pasta: TEdit
      AlignWithMargins = True
      Left = 97
      Top = 13
      Width = 356
      Height = 27
      Margins.Left = 16
      Margins.Top = 12
      Margins.Bottom = 12
      Align = alLeft
      TabOrder = 0
      Text = 'K:\Imagens_Charles'
      ExplicitHeight = 23
    end
    object edt_destino: TEdit
      AlignWithMargins = True
      Left = 553
      Top = 13
      Width = 356
      Height = 27
      Margins.Left = 16
      Margins.Top = 12
      Margins.Bottom = 12
      Align = alLeft
      TabOrder = 1
      Text = 'Z:\fotos_resultado'
      ExplicitHeight = 23
    end
    object btn_salvar: TButton
      AlignWithMargins = True
      Left = 928
      Top = 13
      Width = 114
      Height = 27
      Margins.Left = 16
      Margins.Top = 12
      Margins.Bottom = 12
      Align = alLeft
      Caption = 'Salvar memo'
      TabOrder = 2
      OnClick = btn_salvarClick
    end
  end
  object dbgrd1: TDBGrid
    Left = 0
    Top = 201
    Width = 1178
    Height = 255
    Align = alClient
    DataSource = ds_arquivos
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'id'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Diretorio'
        Width = 220
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Name'
        Width = 197
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Name_novo'
        Width = 184
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'tamanho_kb'
        Width = 90
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'horario'
        Width = 133
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'novo_horario'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'fl_pode_alterar_data'
        Title.Alignment = taCenter
        Width = 77
        Visible = True
      end>
  end
  object mmo_saida: TMemo
    Left = 0
    Top = 456
    Width = 1178
    Height = 198
    Align = alBottom
    Lines.Strings = (
      'mmo_saida')
    ScrollBars = ssBoth
    TabOrder = 2
    ExplicitWidth = 1173
  end
  object pnl_ajuste_de_data: TPanel
    Left = 0
    Top = 0
    Width = 1178
    Height = 148
    Align = alTop
    TabOrder = 3
    ExplicitWidth = 1173
    object rg_opcoes: TRadioGroup
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 589
      Height = 140
      Align = alLeft
      Caption = 'Tipo Processamento'
      ItemIndex = 0
      Items.Strings = (
        'So listar - sem processar'
        'copiar e trocar nome (YYYY_MM_nnnnn.JPG) para pasta destino'
        'trocar data criacao do arquivo no diretorio de origem'
        'Criar lista arquivos acima de 900k')
      TabOrder = 0
    end
    object btn_processa: TButton
      AlignWithMargins = True
      Left = 612
      Top = 13
      Width = 137
      Height = 122
      Margins.Left = 16
      Margins.Top = 12
      Margins.Bottom = 12
      Align = alLeft
      Caption = 'inciar'
      TabOrder = 1
      OnClick = btn_processaClick
    end
    object chk_nao_mude_nome: TCheckBox
      Left = 771
      Top = 13
      Width = 230
      Height = 17
      Caption = 'Deixe o nome original intacto'
      TabOrder = 2
    end
    object btn_close: TButton
      AlignWithMargins = True
      Left = 1059
      Top = 17
      Width = 115
      Height = 114
      Margins.Top = 16
      Margins.Bottom = 16
      Align = alRight
      Caption = 'Fechar Tabela'
      TabOrder = 3
      OnClick = btn_closeClick
      ExplicitLeft = 1104
    end
  end
  object qy_arquivos: TFDMemTable
    FieldDefs = <>
    IndexDefs = <>
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    StoreDefs = True
    Left = 440
    Top = 120
    object qy_arquivosid: TIntegerField
      FieldName = 'id'
    end
    object qy_arquivosDiretorio: TStringField
      FieldName = 'Diretorio'
      Size = 256
    end
    object qy_arquivosName: TStringField
      FieldName = 'Name'
      Size = 256
    end
    object qy_arquivosName_novo: TStringField
      FieldName = 'Name_novo'
      Size = 256
    end
    object qy_arquivoshorario: TDateTimeField
      FieldName = 'horario'
    end
    object qy_arquivosnovo_horario: TDateTimeField
      DisplayLabel = 'Novo horario'
      FieldName = 'novo_horario'
    end
    object qy_arquivosfl_pode_alterar_data: TBooleanField
      Alignment = taCenter
      DisplayLabel = 'Altera Data'
      FieldName = 'fl_pode_alterar_data'
      OnGetText = qy_arquivosfl_pode_alterar_dataGetText
    end
    object qy_arquivostamanho_kb: TLargeintField
      DisplayLabel = 'Tamanho (KB)'
      FieldName = 'tamanho_kb'
      DisplayFormat = '#,##0'
    end
  end
  object ds_arquivos: TDataSource
    DataSet = qy_arquivos
    Left = 608
    Top = 136
  end
  object dlgSave1: TSaveDialog
    FileName = 'processa.bat'
    Left = 688
    Top = 192
  end
end
