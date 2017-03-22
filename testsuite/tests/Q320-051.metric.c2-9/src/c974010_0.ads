-- C974010.A
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
--      Check that the abortable part of an asynchronous select statement
--      is not started if the triggering statement is a task entry call to
--      a task that has already terminated.
--
--      Check that Tasking_Error is properly propagated to the asynchronous
--      select statement and thus the sequence of statements of the triggering
--      alternative is not executed after the abortable part is left. 
--
--      Check that Tasking_Error is re-raised immediately following the 
--      asynchronous select.
--
-- TEST DESCRIPTION:
--
--      Use a small subset of the base Automated Teller Machine simulation
--      which is shown in greater detail in other tests of this series.  
--      Declare a main procedure containing an asynchronous select with a task
--      entry call as triggering statement.  Ensure that the task is
--      terminated before the entry call.  Use stripped down versions of
--      the  called procedures to check the correct path in the test.
--
--
-- CHANGE HISTORY:
--      06 Dec 94   SAIC    ACVC 2.0
--
--!

package C974010_0 is  -- Automated teller machine abstraction.


   Transaction_Canceled : exception;

   type Key_Enum is (None, Cancel, Deposit, Withdraw);

   type Card_Number_Type is private;
   type Card_PIN_Type    is private;
   type ATM_Card_Type    is private;

   task type ATM_Keyboard_Task is
      entry Cancel_Pressed;
   end ATM_Keyboard_Task;


   procedure Validate_Card (Card : in ATM_Card_Type);

   procedure Perform_Transaction (Card : in ATM_Card_Type);


private

   type Card_Number_Type is range   1 .. 9999;
   type Card_PIN_Type    is range 100 ..  999;

   type ATM_Card_Type is record
      Number : Card_Number_Type;
      PIN    : Card_PIN_Type;
   end record;

end C974010_0;
