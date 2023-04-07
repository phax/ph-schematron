@ECHO OFF

set which_xalan=xalan-j_2_3_1

if '%1 == ' goto no-params

if %1 == help goto myhelp

if not exist %1 goto no-xml-file

if not exist %2 goto no-xsl-file

set rootdir=..\..\..\

if not exist %rootdir%jre\1.2\lib\rt.jar goto no-rt

if not exist %rootdir%xslProcessors\%which_xalan%\bin\xercesImpl.jar goto no-xer-jar
if not exist %rootdir%xslProcessors\%which_xalan%\bin\xml-apis.jar goto no-xmlapis-jar
if not exist %rootdir%xslProcessors\%which_xalan%\bin\xalan.jar goto no-xal-jar

set oldPath=%path%
set oldCLASSPATH=%CLASSPATH%

set path=%rootdir%jre\1.2\bin

set CLASSPATH=%rootdir%jre\1.2\lib\rt.jar
set CLASSPATH=%CLASSPATH%;%rootdir%xslProcessors\%which_xalan%\bin\xercesImpl.jar
set CLASSPATH=%CLASSPATH%;%rootdir%xslProcessors\%which_xalan%\bin\xml-apis.jar
set CLASSPATH=%CLASSPATH%;%rootdir%xslProcessors\%which_xalan%\bin\xalan.jar
set CLASSPATH=%CLASSPATH%;.

echo.
echo ---------------------------------------------------------
echo Running the XSL Processor, xalan, with the following specifications:
echo    - XML File: %1
echo    - XSL File: %2
echo    - Output File: %3
echo ---------------------------------------------------------

java -classpath %CLASSPATH% org.apache.xalan.xslt.Process  -IN %1 -XSL %2 -OUT %3 

set path=%oldPath%
set CLASSPATH=%oldCLASSPATH%

goto eof

:no-params
    cls
    echo Oops! You need to run the batch file with 3 arguments.
    echo Here's how to use it ...
    echo.
    echo Usage: "run-xalan <xml filename> <xsl filename> <output filename>"
    echo.
    goto eof

:myhelp
    cls
    echo Usage: "run-xalan <xml filename> <xsl filename> <output filename>"
    echo.
    goto eof

:no-xml-file
   cls
   echo Oops! %1 does not exist
   echo Most likely reason: mistyped filename
   echo Exiting ...
   echo.
   goto eof

:no-xsl-file
   cls
   echo Oops! %2 does not exist
   echo Most likely reason: mistyped filename
   echo Exiting ...
   echo.
   goto eof

:no-rt
   cls
   echo Oops! Missing this Java jre file: %rootdir%jre\1.1\lib\rt.jar
   echo Most likely reason: jre not installed in the correct directory
   echo Exiting ...
   goto eof

:no-xer-jar
   cls
   echo Oops! Missing this xerces file: %rootdir%xslProcessors\%which_xalan%\bin\xercesImpl.jar
   echo Most likely reason: xerces not installed in the correct directory
   echo Exiting ...
   goto eof

:no-xmlapis-jar
   cls
   echo Oops! Missing this xerces file: %rootdir%xslProcessors\%which_xalan%\bin\xml-apis.jar
   echo Most likely reason: xerces not installed in the correct directory
   echo Exiting ...
   goto eof

:no-xal-jar
   cls
   echo Oops! Missing this xalan file: %rootdir%xslProcessors\%which_xalan%\bin\xalan.jar
   echo Most likely reason: xalan not installed in the correct directory
   echo Exiting ...
   goto eof

:eof

