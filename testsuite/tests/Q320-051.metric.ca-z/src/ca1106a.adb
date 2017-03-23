
WITH REPORT; USE REPORT;
WITH CA1106A_1, CA1106A_2, CA1106A_3;
USE CA1106A_1;
PROCEDURE CA1106A IS

     PACKAGE CA1106A_2X IS NEW CA1106A_2 (INTEGER);
     FUNCTION CA1106A_3X IS NEW CA1106A_3 (INTEGER);

     USE CA1106A_2X;

BEGIN
     TEST ("CA1106A", "CHECK THAT A WITH CLAUSE FOR A PACKAGE BODY " &
                      "(GENERIC OR NONGENERIC) OR FOR A GENERIC " &
                      "SUBPROGRAM BODY CAN NAME THE CORRESPONDING " &
                      "SPECIFICATION, AND A USE CLAUSE CAN ALSO BE " &
                      "GIVEN");

     IF I /= 1 THEN
          FAILED ("INCORRECT VALUE FROM NONGENERIC PACKAGE");
     END IF;

     IF J /= 2 THEN
          FAILED ("INCORRECT VALUE FROM GENERIC PACKAGE");
     END IF;

     IF CA1106A_3X /= 3 THEN
          FAILED ("INCORRECT VALUE FROM GENERIC SUBPROGRAM");
     END IF;

     RESULT;
END CA1106A;