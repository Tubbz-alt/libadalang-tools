
WITH REPORT, OTHER_PKG;
USE REPORT, OTHER_PKG;
PRAGMA ELABORATE (OTHER_PKG);
PACKAGE CA1108A_PKG IS

     J : INTEGER := 2;
     PROCEDURE PROC;
     PROCEDURE CALL_SUBS (X, Y : IN OUT INTEGER);

END CA1108A_PKG;
