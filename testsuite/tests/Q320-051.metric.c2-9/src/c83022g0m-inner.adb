-- C83022G1.ADA

--                             Grant of Unlimited Rights
--
--     Under contracts F33600-87-D-0337, F33600-84-D-0280, MDA903-79-C-0687,
--     F08630-91-C-0015, and DCA100-97-D-0025, the U.S. Government obtained 
--     unlimited rights in the software and documentation contained herein.
--     Unlimited rights are defined in DFAR 252.227-7013(a)(19).  By making 
--     this public release, the Government intends to confer upon all 
--     recipients unlimited rights  equal to those held by the Government.  
--     These rights include rights to use, duplicate, release or disclose the 
--     released technical data and computer software in whole or in part, in 
--     any manner and for any purpose whatsoever, and to have or permit others 
--     to do so.
--
--                                    DISCLAIMER
--
--     ALL MATERIALS OR INFORMATION HEREIN RELEASED, MADE AVAILABLE OR
--     DISCLOSED ARE AS IS.  THE GOVERNMENT MAKES NO EXPRESS OR IMPLIED 
--     WARRANTY AS TO ANY MATTER WHATSOEVER, INCLUDING THE CONDITIONS OF THE
--     SOFTWARE, DOCUMENTATION OR OTHER INFORMATION RELEASED, MADE AVAILABLE 
--     OR DISCLOSED, OR THE OWNERSHIP, MERCHANTABILITY, OR FITNESS FOR A
--     PARTICULAR PURPOSE OF SAID MATERIAL.
--*
-- OBJECTIVE:
--     CHECK THAT A DECLARATION IN A SUBPROGRAM FORMAL PART OR BODY
--     HIDES AN OUTER DECLARATION OF A HOMOGRAPH. ALSO CHECK THAT THE
--     OUTER DECLARATION IS DIRECTLY VISIBLE IN BOTH DECLARATIVE
--     REGIONS BEFORE THE DECLARATION OF THE INNER HOMOGRAPH AND THE
--     OUTER DECLARATION IS VISIBLE BY SELECTION AFTER THE INNER
--     HOMOGRAPH DECLARATION, IF THE SUBPROGRAM BODY IS COMPILED
--     SEPARATELY AS A SUBUNIT.

-- HISTORY:
--     BCB 08/26/88  CREATED ORIGINAL TEST.

SEPARATE (C83022G0M)
PROCEDURE INNER (X : IN OUT INTEGER) IS
     C : INTEGER := A;
     A : INTEGER := IDENT_INT(3);
BEGIN
     IF A /= IDENT_INT(3) THEN
          FAILED ("INCORRECT VALUE FOR INNER HOMOGRAPH - 1");
     END IF;

     IF C83022G0M.A /= IDENT_INT(2) THEN
          FAILED ("INCORRECT VALUE FOR OUTER HOMOGRAPH - 2");
     END IF;

     IF C83022G0M.B /= IDENT_INT(2) THEN
          FAILED ("INCORRECT VALUE FOR OUTER VARIABLE - 3");
     END IF;

     IF C /= IDENT_INT(2) THEN
          FAILED ("INCORRECT VALUE FOR INNER VARIABLE - 4");
     END IF;

     IF X /= IDENT_INT(2) THEN
          FAILED ("INCORRECT VALUE PASSED IN - 5");
     END IF;

     IF EQUAL(1,1) THEN
          X := A;
     ELSE
          X := C83022G0M.A;
     END IF;
END INNER;
