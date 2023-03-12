Sub populateSpreadsheet():
    Dim sht As Worksheet
    For Each ws In ThisWorkbook.Worksheets
        
        'Getting the last nonemtpy row in the sheet
        'https://www.exceltip.com/cells-ranges-rows-and-columns-in-vba/3-best-ways-to-find-last-non-blank-row-and-column-using-vba.html
        Dim lastRow As Long
        lastRow = ws.Cells(Rows.Count, 1).End(xlUp).Row
    
        'Setting labels
        ws.Range("I1") = "Ticker"
        ws.Range("J1") = "Yearly Change"
        ws.Range("K1") = "Percent Change"
        ws.Range("L1") = "Total Stock Value"
        ws.Range("I1:L1").Font.Bold = True
        
        ws.Range("O2").Value = "Greatest % Increase"
        ws.Range("O3").Value = "Greatest % Decrease"
        ws.Range("O4").Value = "Greatest Total Volume"
        ws.Range("O2:O4").Font.Bold = True
        
        ws.Range("P1").Value = "Ticker"
        ws.Range("Q1").Value = "Value"
        ws.Range("P1:Q1").Font.Bold = True
        
            'Getting the indices of the first range
            Dim curTicker As String
            Dim nextTicker As String
            Dim firstIndex As Long
            Dim lastIndex As Long
            
            firstIndex = 2
            Dim i As Long
            i = 2
            recordToAdd = 2
            
            curTicker = ws.Cells(i, 1)
            nextTicker = ws.Cells(i + 1, 1)
            Do While Not StrComp(curTicker, nextTicker)
                i = i + 1
                curTicker = ws.Cells(i, 1)
                nextTicker = ws.Cells(i + 1, 1)
            Loop
            lastIndex = i
            
            'Initializing variables
            Dim openVar As Double
            Dim high As Double
            Dim low As Double
            Dim closeVar As Double
            Dim vol As Double
            
            Dim ticker As String
            Dim yearlyChange As Double
            Dim percentChange As Double
            Dim totalStockValue As Double
            
            'Popoulating cells
            ticker = ws.Cells(firstIndex, 1)
            yearlyChange = ws.Cells(lastIndex, 6).Value - ws.Cells(firstIndex, 3)
            percentChange = yearlyChange / ws.Cells(firstIndex, 6)
            totalStockValue = Application.WorksheetFunction.Sum(ws.Range("G" & firstIndex & ":G" & lastIndex))
            
            ws.Range("I" & recordToAdd) = ticker
            ws.Range("J" & recordToAdd) = yearlyChange
            If yearlyChange >= 0 Then
                ws.Range("J" & recordToAdd).Interior.ColorIndex = 4
            Else
                ws.Range("J" & recordToAdd).Interior.ColorIndex = 3
            End If
            
            ws.Range("K" & recordToAdd) = FormatPercent(percentChange)
            ws.Range("L" & recordToAdd) = totalStockValue
            
            'Getting the indices of each range until the end
            'https://excelchamps.com/vba/do-while/
            Do While lastIndex < lastRow
                firstIndex = lastIndex + 1
                recordToAdd = recordToAdd + 1
                
                i = firstIndex
                curTicker = ws.Cells(i, 1)
                nextTicker = ws.Cells(i + 1, 1)
                'https://learn.microsoft.com/en-us/office/vba/language/reference/user-interface-help/strcomp-function
                Do While Not StrComp(curTicker, nextTicker)
                    i = i + 1
                    curTicker = ws.Cells(i, 1)
                    'https://www.techonthenet.com/excel/formulas/isempty.php
                    If Not IsEmpty(ws.Cells(i + 1, 1).Value) Then
                        nextTicker = ws.Cells(i + 1, 1)
                    End If
                Loop
                lastIndex = i
                
                'Populating cells
                ticker = ws.Cells(firstIndex, 1)
                yearlyChange = ws.Cells(lastIndex, 6).Value - ws.Cells(firstIndex, 3)
                percentChange = yearlyChange / ws.Cells(firstIndex, 6)
                totalStockValue = Application.WorksheetFunction.Sum(ws.Range("G" & firstIndex & ":G" & lastIndex))
                
                ws.Range("I" & recordToAdd) = ticker
                ws.Range("J" & recordToAdd) = yearlyChange
                If yearlyChange >= 0 Then
                    ws.Range("J" & recordToAdd).Interior.ColorIndex = 4
                Else
                    ws.Range("J" & recordToAdd).Interior.ColorIndex = 3
                End If
                
                ws.Range("K" & recordToAdd) = FormatPercent(percentChange)
                ws.Range("L" & recordToAdd) = totalStockValue
            Loop
            
        'Getting maxes
        Dim maxPercent As Double
        Dim maxPercentIndex As Integer
        Dim minPercent As Double
        Dim minPercentIndex As Integer
        Dim maxVolume As Double
        Dim maxVolumeIndex As Integer
        
        maxPercent = -1
        minPercent = 9999
        maxVolume = -1
        
        For i = 2 To 3001
            If ws.Cells(i, 11) > maxPercent Then
                maxPercent = ws.Cells(i, 11)
                maxPercentIndex = i
            End If
            
            If ws.Cells(i, 11) < minPercent Then
                minPercent = ws.Cells(i, 11)
                minPercentIndex = i
            End If
            
            If ws.Cells(i, 12) > maxVolume Then
                maxVolume = ws.Cells(i, 12)
                maxVolumeIndex = i
            End If
        Next i

        ws.Range("P2") = ws.Cells(maxPercentIndex, 9)
        ws.Range("P3") = ws.Cells(minPercentIndex, 9)
        ws.Range("P4") = ws.Cells(maxVolumeIndex, 9)
        
        ws.Range("Q2") = FormatPercent(maxPercent)
        ws.Range("Q3") = FormatPercent(minPercent)
        ws.Range("Q4") = maxVolume
    Next ws
End Sub
