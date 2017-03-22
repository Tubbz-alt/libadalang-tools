-- C761001.A
--
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
--
-- OBJECTIVE:
--      Check that controlled objects declared immediately within a library
--      package are finalized following the completion of the environment
--      task (and prior to termination of the program).
--
-- TEST DESCRIPTION:
--      This test derives a type from Ada.Finalization.Controlled, and
--      declares an object of that type in the body of a library package.
--      The dispatching procedure Finalize is redefined for the derived
--      type to perform a check that it has been called only once, and in
--      turn calls Report.Result.  This test may fail by not calling
--      Report.Result.  This test may also fail by calling Report.Result
--      twice, the first call will report a false pass.
--
--
-- CHANGE HISTORY:
--      06 Dec 94   SAIC    ACVC 2.0
--      13 Nov 95   SAIC    Updated for ACVC 2.0.1
--
--!

with Ada.Finalization;
package C761001_0 is

  type Global is new Ada.Finalization.Controlled with null record;
  procedure Finalize( It: in out Global );

end C761001_0;
