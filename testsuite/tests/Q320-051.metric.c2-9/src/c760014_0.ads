-- C760014.A
--                             Grant of Unlimited Rights
--
--     The Ada Conformity Assessment Authority (ACAA) holds unlimited
--     rights in the software and documentation contained herein. Unlimited
--     rights are the same as those granted by the U.S. Government for older
--     parts of the Ada Conformity Assessment Test Suite, and are defined
--     in DFAR 252.227-7013(a)(19). By making this public release, the ACAA
--     intends to confer upon all recipients unlimited rights equal to those
--     held by the ACAA. These rights include rights to use, duplicate,
--     release or disclose the released technical data and computer software
--     in whole or in part, in any manner and for any purpose whatsoever, and
--     to have or permit others to do so.
--
--                                    DISCLAIMER
--
--     ALL MATERIALS OR INFORMATION HEREIN RELEASED, MADE AVAILABLE OR
--     DISCLOSED ARE AS IS. THE ACAA MAKES NO EXPRESS OR IMPLIED
--     WARRANTY AS TO ANY MATTER WHATSOEVER, INCLUDING THE CONDITIONS OF THE
--     SOFTWARE, DOCUMENTATION OR OTHER INFORMATION RELEASED, MADE AVAILABLE
--     OR DISCLOSED, OR THE OWNERSHIP, MERCHANTABILITY, OR FITNESS FOR A
--     PARTICULAR PURPOSE OF SAID MATERIAL.
--
--                                     Notice
--
--     The ACAA has created and maintains the Ada Conformity Assessment Test
--     Suite for the purpose of conformity assessments conducted in accordance
--     with the International Standard ISO/IEC 18009 - Ada: Conformity
--     assessment of a language processor. This test suite should not be used
--     to make claims of conformance unless used in accordance with
--     ISO/IEC 18009 and any applicable ACAA procedures.
--*
--
-- OBJECTIVE:
--    Check that Ada.Finalization is a declared pure package.
--
-- TEST DESCRIPTION:
--    We declare a controlled type within a pure package, override
--    Initialize and Finalize, and check that those routines are called on
--    the object. We have to use an access discriminant to track calling
--    of routines, as no state is allowed within the pure package, and we
--    can't read the object after it is implicitly finalized.
--
--    This is intended to model likely usage of a controlled type declared
--    in a pure package. That is most useful when the
--    initialization/finalization has some effect on a linked object
--    (such as the container tampering checks for function Reference).
--
-- CHANGE HISTORY:
--    25 JAN 2001   PHL   Initial version.
--    29 AUG 2014   RLB   Repurposed test for Ada 2012.
--
--!
with Ada.Finalization;
package C760014_0 with Pure is

   type TC_Count is record
      Init_Count, Fin_Count : Natural := 0;
   end record;

   type Test_Type (TC_Data : access TC_Count) is tagged limited private;

private

   type Test_Type (TC_Data : access TC_Count) is
      new Ada.Finalization.Limited_Controlled with record
      Dummy : Natural := 0;
   end record;

   overriding
   procedure Initialize (Obj : in out Test_Type);

   overriding
   procedure Finalize (Obj : in out Test_Type);

end C760014_0;
