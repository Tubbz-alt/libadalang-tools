-- C95065B.ADA

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
-- CHECK THAT CONSTRAINT_ERROR IS NOT RAISED WHEN AN ENTRY IS DECLARED
-- IF THE VALUE OF THE DEFAULT EXPRESSION FOR THE FORMAL PARAMETER DOES
-- NOT SATISFY THE CONSTRAINTS OF THE TYPE MARK, BUT IS RAISED WHEN THE
-- ENTRY IS CALLED AND THE DEFAULT VALUE IS USED.

-- CASE (B) A SCALAR PARAMETER WITH NON-STATIC RANGE CONSTRAINTS
--          INITIALIZED WITH A STATIC VALUE.

-- JWC 6/19/85

with Report; use Report;
procedure C95065b is

begin

   Test
     ("C95065B",
      "CHECK THAT CONSTRAINT_ERROR IS NOT RAISED IF " &
      "AN INITIALIZATION VALUE DOES NOT SATISFY " &
      "CONSTRAINTS ON A FORMAL PARAMETER WHEN THE " &
      "FORMAL PART IS ELABORATED");

   begin

      declare

         subtype Int is Integer range Ident_Int (0) .. Ident_Int (63);

         task T is
            entry E1 (I : Int := -1);
         end T;

         task body T is
         begin
            select
               accept E1 (I : Int := -1) do
                  Failed ("ACCEPT E1 EXECUTED");
               end E1;
            or
               terminate;
            end select;
         exception
            when others =>
               Failed ("EXCEPTION RAISED IN TASK T");
         end T;

      begin
         T.E1;
         Failed ("CONSTRAINT ERROR NOT RAISED ON CALL TO T.E1");
      exception
         when Constraint_Error =>
            null;
         when others =>
            Failed ("WRONG EXCEPTION RAISED - E1");
      end;

   exception
      when Constraint_Error =>
         Failed ("CONSTRAINT_ERROR RAISED (BY ENTRY DECL)");
      when Tasking_Error =>
         Failed ("TASKING_ERROR RAISED");
      when others =>
         Failed ("UNEXPECTED EXCEPTION RAISED");
   end;

   Result;

end C95065b;