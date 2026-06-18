Attribute VB_Name = "AutomatedChartPlotter"
Sub chartmaker()
Attribute chartmaker.VB_Description = "make chart without error bars"
Attribute chartmaker.VB_ProcData.VB_Invoke_Func = "g\n14"
'
' chartmaker 매크로
' make chart without error bars
'
' 바로 가기 키: Ctrl+g
'

    Set rMulti = Selection.Cells()
    
    Sheets(ActiveSheet.Name).Shapes.AddChart2(-1, xlXYScatter).Select

    ActiveChart.SetSourceData Source:=Sheets(ActiveSheet.Name).Range(rMulti.Cells.Address)

    With ActiveChart
        'title
        .HasTitle = True
        .ChartTitle.Characters.Text = "Title"
        .ChartTitle.Characters.Font.Name = "Bahnschrift"
        'X axis name
        .Axes(xlCategory, xlPrimary).HasTitle = True
        .Axes(xlCategory, xlPrimary).AxisTitle.Characters.Text = "X []"
        .Axes(xlCategory, xlPrimary).AxisTitle.Characters.Font.Name = "Bahnschrift"
        'y-axis name
        .Axes(xlValue, xlPrimary).HasTitle = True
        .Axes(xlValue, xlPrimary).AxisTitle.Characters.Text = "Y []"
        .Axes(xlValue, xlPrimary).AxisTitle.Characters.Font.Name = "Bahnschrift"
        'grid is none
        .SetElement (msoElementPrimaryValueGridLinesNone)
        .SetElement (msoElementPrimaryCategoryGridLinesNone)
        'linest
        .FullSeriesCollection(1).Trendlines.Add Type:=xlLinear, Forward _
        :=0, Backward:=0, DisplayEquation:=0, DisplayRSquared:=0, Name:= _
        "선형 (계열1)"
        'area line
        .PlotArea.Select
        With Selection.Format.Line
            .Visible = msoTrue
            .ForeColor.ObjectThemeColor = msoThemeColorText1
            .ForeColor.TintAndShade = 0
            .ForeColor.Brightness = 0
        End With
        
        .FullSeriesCollection(1).Trendlines(1).Select
        With Selection.Format.Line
            .Visible = msoTrue
            .ForeColor.ObjectThemeColor = msoThemeColorText1
            .ForeColor.TintAndShade = 0
            .ForeColor.Brightness = 0
            .Transparency = 0
        End With
        .FullSeriesCollection(1).Select
        With Selection.Format.Line
            .Visible = msoTrue
            .ForeColor.ObjectThemeColor = msoThemeColorText1
            .ForeColor.TintAndShade = 0
            .ForeColor.Brightness = 0
        End With
        Selection.Format.Line.Visible = msoFalse
        With Selection.Format.Fill
            .Visible = msoTrue
            .ForeColor.ObjectThemeColor = msoThemeColorText1
            .ForeColor.TintAndShade = 0
'        .Transparency = 0
'        .Solid
        End With
        With Selection
            .MarkerStyle = 8
            .MarkerSize = 4
        End With
        .FullSeriesCollection(1).Trendlines(1).Select
        Selection.DisplayEquation = True
        Selection.DisplayRSquared = True
        .FullSeriesCollection(1).Trendlines(1).DataLabel.Select
        Selection.Left = 273
        Selection.Top = 141
    End With
    

End Sub
Sub chartmaker_errb()
Attribute chartmaker_errb.VB_Description = "make chart with error bars"
Attribute chartmaker_errb.VB_ProcData.VB_Invoke_Func = "G\n14"
'
' chartmaker_errb 매크로
' make chart with error bars
'
' 바로 가기 키: Ctrl+Shift+G
'

    Set rMulti = Selection.Cells()
    
    Sheets(ActiveSheet.Name).Shapes.AddChart2(-1, xlXYScatter).Select

    ActiveChart.SetSourceData Source:=Sheets(ActiveSheet.Name).Range(rMulti.Cells.Address)

    With ActiveChart
        'title
        .HasTitle = True
        .ChartTitle.Characters.Text = "Title"
        .ChartTitle.Characters.Font.Name = "Bahnschrift"
        'X axis name
        .Axes(xlCategory, xlPrimary).HasTitle = True
        .Axes(xlCategory, xlPrimary).AxisTitle.Characters.Text = "X []"
        .Axes(xlCategory, xlPrimary).AxisTitle.Characters.Font.Name = "Bahnschrift"
        'y-axis name
        .Axes(xlValue, xlPrimary).HasTitle = True
        .Axes(xlValue, xlPrimary).AxisTitle.Characters.Text = "Y []"
        .Axes(xlValue, xlPrimary).AxisTitle.Characters.Font.Name = "Bahnschrift"
        'grid is none
        .SetElement (msoElementPrimaryValueGridLinesNone)
        .SetElement (msoElementPrimaryCategoryGridLinesNone)
        'linest
        .FullSeriesCollection(1).Trendlines.Add Type:=xlLinear, Forward _
        :=0, Backward:=0, DisplayEquation:=0, DisplayRSquared:=0, Name:= _
        "선형 (계열1)"
        'area line
        .PlotArea.Select
        With Selection.Format.Line
            .Visible = msoTrue
            .ForeColor.ObjectThemeColor = msoThemeColorText1
            .ForeColor.TintAndShade = 0
            .ForeColor.Brightness = 0
        End With
        
        .FullSeriesCollection(1).Trendlines(1).Select
        With Selection.Format.Line
            .Visible = msoTrue
            .ForeColor.ObjectThemeColor = msoThemeColorText1
            .ForeColor.TintAndShade = 0
            .ForeColor.Brightness = 0
            .Transparency = 0
        End With
        .FullSeriesCollection(1).Select
        With Selection.Format.Line
            .Visible = msoTrue
            .ForeColor.ObjectThemeColor = msoThemeColorText1
            .ForeColor.TintAndShade = 0
            .ForeColor.Brightness = 0
        End With
        Selection.ErrorBar Direction:=xlY, Include:=xlErrorBarIncludeBoth, _
        Type:=xlErrorBarTypeStError
        Selection.ErrorBar Direction:=xlX, Include:=xlErrorBarIncludeBoth, _
        Type:=xlErrorBarTypeStError
        Selection.Format.Line.Visible = msoFalse
        With Selection.Format.Fill
            .Visible = msoTrue
            .ForeColor.ObjectThemeColor = msoThemeColorText1
            .ForeColor.TintAndShade = 0
'        .Transparency = 0
'        .Solid
        End With
        With Selection
            .MarkerStyle = 8
            .MarkerSize = 4
        End With
        .FullSeriesCollection(1).Trendlines(1).Select
        Selection.DisplayEquation = True
        Selection.DisplayRSquared = True
        .FullSeriesCollection(1).Trendlines(1).DataLabel.Select
        Selection.Left = 273
        Selection.Top = 141
    End With

End Sub

