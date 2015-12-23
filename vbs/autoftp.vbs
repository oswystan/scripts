'======================================================================
' Auto ftp script which can be integrated in source insight
'
' input the following command in source insight user defined command:
'           wscript "$dir\autoftp.vbs" %f
'
' Limits: local directory structure need to be the same as the remote
'         directory structure, it will transfer the current opening
'         file to the corresponding directory at the remote host
'======================================================================
'remote host IP, username, password
ftpIP  = "192.168.204.120"
ftpUsr = "wong"
ftpPWD = "wongyu"

'the local base directory, need to be change to the corresponding directory without end slash '\'
localBaseDir = "E:\WongYu\VSS\KnowledgeBase\01 Code\01 C&C++"
baseDirLen = Len(localBaseDir) + 2
remoteBaseDir = "mycode"

Dim findPos
Dim upFile
Dim upDir

if WScript.Arguments.Count >= 1 then
    'Create a ftp command file
    Set fsObj   = CreateObject("Scripting.FileSystemObject")
    Set fileOut = fsObj.CreateTextFile("~ftp.txt")

    'Get upload file and upload directory
    upFile = WScript.Arguments(0)
    upDir  = mid(WScript.Arguments(0),baseDirLen)

    upDir   = replace(upDir, "\", "/")
    findPos = InstrRev(upDir, "/")
    upDir = mid(upDir, 1, findPos)

    'Write command ftp file
    fileOut.WriteLine "open "&ftpIP
    fileOut.WriteLine ftpUsr
    fileOut.WriteLine ftpPWD
    fileOut.WriteLine "asc"
    if len(remoteBaseDir) <> 0 then
        fileOut.WriteLine "cd "&remoteBaseDir
    end if
    fileOut.WriteLine "cd "&upDir
    fileOut.WriteLine "put """&upFile&""""
    fileOut.WriteLine "bye"
    fileOut.close

    'Execute ftp command
    Set objShell = CreateObject("Wscript.Shell")
    objShell.Run "ftp -i -s:~ftp.txt"
end if
'=============================== END ==================================
