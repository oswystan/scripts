Function sid(strIn As String)
    Set x = CreateObject("ScriptControl"): x.Language = "JScript"
    Set y = x.eval("eval(" & strIn & ")")
    sid = y.sid
End Function
