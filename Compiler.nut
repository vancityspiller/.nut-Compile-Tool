// ------------------------------------------------------- //

/*
*   .nut Compiler Tool
*   Throw all of your scripts and run compiler.bat.
*
*   created by Spiller
*
*   + Notes
*   - All .nut files in all subdirectories will be compiled.
*   - Compiled files with the same directory structure will be placed in Compiled folder.
*   - Errors from all files will be displayed and put into error.txt.
*
*   + Attributions
*   - Find And Replace Text (fart-it : https://github.com/lionello/fart-it)
*   - Error Handler inspired from ysc3839.
*/

// ------------------------------------------------------- //

// Variables //

local   Data =      "",
        Lines =     null,
        Builds =    null,
        
        Compiling = true,
        Success =   0,
        Errored =   [];

// ------------------------------------------------------- //

// Input - Output //

function Read()
{
    local Reader = file("data.dat", "rb");

    if(Reader.len() == 0) 
    {
        Compiling = false;
        throw "Please run \"compiler.bat\"";
    } 

    local Blob_ = Reader.readblob(Reader.len());

    for(local i = 0 ; i < Reader.len() ; i++)
    Data += format("%c", Blob_.readn('b'));

    Reader.close();
    return 1;
}

function Write(filePath, textToWrite, append)
{
    local Writer = file(filePath, (append ? "a+" : "w+"));

    foreach(alphabet in textToWrite)
    Writer.writen(alphabet, 'c'); 

    if(append) Writer.writen('\n', 'c');
    
    Writer.close();
    return 1;
}

// ------------------------------------------------------- //

// Compile Sequence //

function Process()
{
    Lines = split(Data, "\n");

    local rem = Lines[0].len();
    foreach (i, line in Lines) 
    {
        if(i == 0) continue;

        Lines[i] = line.slice(rem);
        Lines[i] = Lines[i].slice(0, Lines[i].len() - 1)
    }

    // Display pre-compile information //
    print(format("Compiling %d files.", Lines.len() - 2));
    print("----------------------------------------------------------------\n");

    return 1;
}

function CompileFiles()
{
    for(local i = 0 ; i < Lines.len() ; i++) 
    {
        if(i == 0 || Lines[i] == "Compiler.nut") continue;

        try 
        {
            Compile(Lines[i], Replace(Lines[i], ".nut", ".cnut"));
            Success++;
        }
        catch(_) 
        {
            print(format("[ERROR] %s", Lines[i]));
            Errored.append(i);
        }
    }

    return 1;
}

function Report()
{
    Compiling = false;

    print("----------------------------------------------------------------\n");
    print(format("Total (%d) Compiled (%d) Errored (%d).", Lines.len() - 2, Success, Errored.len()));
    print(format("%s", Errored.len() == 0 ? "All files compiled succesfully, exiting..." : "Beginning to log errors..."));
    print("----------------------------------------------------------------\n");

    if(Errored.len() == 0) NewTimer("ShutdownServer", 5000, 1);
    else
    {
        local Timer = 2000;

        foreach (i, e in Errored)
        {
            NewTimer("LogError", Timer, 1, Lines[e]);
            Timer += 1500; 
        } 
    }

    return 1;
}

// ------------------------------------------------------- //

// Separated for Error Handling //

function Compile(scriptPath, buildPath)
{
    local   script = format("Compiled/%s", buildPath), 
            bytecode = loadfile(scriptPath, true);

    writeclosuretofile(script, bytecode);

    print(format("[BUILD] %s", script));
}

function LogError(scriptPath)
{
    print(format("\nFile (%s)\n", scriptPath));
    Write("error.txt", format("File (%s)\n", scriptPath), true);
    Compile(scriptPath, Replace(scriptPath, ".nut", ".cnut"));
}

// Replace extension //

function Replace(str, strFind, strReplace) 
{
    while(str.find(strFind) != null)
    {   
        local pos = str.find(strFind);
        str = str.slice(0, pos) + strReplace + str.slice(pos + strFind.len(), str.len()); 
    }

    return str;
}

// Custom Error Handler //

function errorHandling(err)
{
	local stackInfos = getstackinfos(2);
    if(Compiling) print("FATAL ERROR: Please contact the author.");

	if (stackInfos)
	{
		local locals = "", callStacks = "", level = 2;

		foreach (index, value in stackInfos.locals)
		{
			if (index != "this")
			locals = locals + "[" + index + "] " + value + "\n";
		}

		do
		{
			callStacks += "ln (" + stackInfos.line + ") [" + stackInfos.func + "()] " + stackInfos.src + "\n";
			level++;
		} 
		while ((stackInfos = getstackinfos(level)));

		local errorMsg = "[" + err + "]\n";
		errorMsg += "\nCallStack\n";
		errorMsg += callStacks;
		errorMsg += "\nLocals\n";
		errorMsg += locals;

        Write("error.txt", errorMsg, true);
	}
}

seterrorhandler(errorHandling);

// ------------------------------------------------------- //

// Driver //

function onScriptLoad()
{
    Write("error.txt", "", false);

    Read();
    Process();
    CompileFiles();
    Report();
}

// Exfil //

function onScriptUnload()
{
    Write("data.dat", "", false);
}

// ------------------------------------------------------- //