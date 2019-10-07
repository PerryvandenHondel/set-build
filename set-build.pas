program SetBuild;


{$mode objfpc}
{$H+}


uses
    Classes,
    Crt,
    DateUtils,
    Dos,
    UBuild,
    USupLib,        // Unit Support Library.
    UTextFile,      // Unit Text Files
    SysUtils;


var
    currentApp: Ansistring;
    pathConfig: Ansistring;
    pathUnit: Ansistring;
    folderCounter: Ansistring;
    pathCounter: Ansistring;
    currentBuild: integer;
    versionMajor: Ansistring;
    versionMinor: Ansistring;


procedure ShowTitle();
begin
    writeln('set-build version ', VERSION_MAJOR, '.', VERSION_MINOR, '.', BUILD);
end; // of procedure ShowTitle();

procedure ShowUsage();
begin
    writeln;
    writeln('Usage:');
    writeln(#9, 'set-build <appname>');
    writeln;
    Halt();
end; // of procedure ShowUsage()


function GetCurrentBuild(f: Ansistring; n: Ansistring): integer;
var
    b: integer;
    p: Ansistring;
    tf: TextFile;
    buffer: Ansistring;
begin
    // Build the path from f (folder) + n (File name)
    p := f + n + '.counter';
    if not FileExists(p) then
    begin
        b := 1; // Set build to 1.
        //writeln('file ', p, ' does not exist, set build to 1');
        //create dir should it not exist.
        ForceDirectories(f);

        Assign(tf, p);
        Rewrite(tf); // Open file as write.
        writeln(tf, b); // Write the build number to the file.
        Close(tf);  // Close the file.
        // write 0 to file p
    end
    else
    begin
        //writeln('file ', p, ' exists');
        // Assign the file pointer to tf.
        Assign(tf, p);
        
        // Open the file for reading.
        Reset(tf);

        // Read the current line into a buffer
        Readln(tf, buffer);
        //writeln('buffer=', buffer);

        b := StrToInt(buffer);
        //writeln('currentBuild=', currentBuild);
        // Add one to the build.
        Inc(b);
       
        // Reopen the file to write from an empty file.
        Rewrite(tf);
        writeln(tf, b);

        // Close the file.
        Close(tf)
    end; // if 


    Result := b;
end; // of function GetCurrentBuild()


procedure WriteUBuild(p: Ansistring; b: integer; versionMajor: Ansistring; versionMinor: Ansistring);
var
    tf: TextFile;
begin
    Assign(tf, p);
    Rewrite(tf);

    writeln(tf, 'unit UBuild;');
    writeln(tf);
    writeln(tf, 'interface');
    writeln(tf);
    writeln(tf, 'const');
    writeln(tf, #9, 'VERSION_MAJOR = ', versionMajor, ';');
    writeln(tf, #9, 'VERSION_MINOR = ', versionMinor, ';');
    writeln(tf, #9, 'BUILD = ', b, ';');
    writeln(tf, #9, 'BUILD_DT = ''', GetCurrentDateTimeMicro(), ''';');
    writeln(tf);
    writeln(tf, 'implementation');
    writeln(tf);
    writeln(tf, 'end.');
    

    close(tf);
end; // of procedure WriteUBuild()


begin
    ShowTitle();

    if ParamCount = 0 then
        ShowUsage();
    
    currentApp := ParamStr(1);
    writeln(currentApp);

    pathConfig := Paramstr(0) + '.conf';
    writeln(pathConfig);

    pathUnit := ReadSettingKey(pathConfig, currentApp, 'pathUnit');

    folderCounter := ReadSettingKey(pathConfig, currentApp, 'folderCounter');
    pathCounter := folderCounter + currentApp + '.counter';

    versionMajor := ReadSettingKey(pathConfig, currentApp, 'versionMajor');
    versionMinor := ReadSettingKey(pathConfig, currentApp, 'versionMinor');
    

    writeln('pathUnit=', pathUnit);
    writeln('folderCounter=', folderCounter);
    writeln('pathCounter=', pathCounter);
    
    currentBuild := GetCurrentBuild(folderCounter, currentApp);
    writeln('currentBuild=', currentBuild);

    WriteUBuild(pathUnit, currentBuild, versionMajor, versionMinor);

end.  // of program SetBuild