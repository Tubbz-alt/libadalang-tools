-- F392A00.A
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
-- FOUNDATION DESCRIPTION:
--      This foundation provides a basis for tests needing a hierarchy of
--      types to check object-oriented features.
--
-- CHANGE HISTORY:
--      06 Dec 94   SAIC    ACVC 2.0
--
--!

package F392a00 is          -- package Accounts

   --
   -- Types and subtypes.
   --

   type Dollar_Amount is new Float;
   type Interest_Rate is delta 0.001 range 0.000 .. 1.000;
   type Account_Types is (Bank, Savings, Preferred, Total);
   type Account_Counter is array (Account_Types) of Integer;
   type Account_Rep is (President, Manager, New_Account_Manager, Teller);

   --
   -- Constants.
   --

   Opening_Balance           : constant Dollar_Amount := 100.00;
   Current_Rate              : constant Interest_Rate := 0.030;
   Preferred_Minimum_Balance : constant Dollar_Amount := 1_000.00;

   --
   -- Global Variables
   --

   Bank_Reserve         : Dollar_Amount   := 0.00;
   Daily_Representative : Account_Rep     := New_Account_Manager;
   Number_Of_Accounts   : Account_Counter :=
     (Bank => 0, Savings => 0, Preferred => 0, Total => 0);
   --
   -- Account types and their primitive operations.
   --

   -- Root type.

   type Bank_Account is tagged record
      Balance : Dollar_Amount;
   end record;

   -- Primitive operations of Bank_Account.

   procedure Increment_Bank_Reserve (Acct : in Bank_Account);
   procedure Assign_Representative (Acct : in Bank_Account);
   procedure Increment_Counters (Acct : in Bank_Account);
   procedure Open (Acct : in out Bank_Account);

   --

   type Savings_Account is new Bank_Account with record
      Rate : Interest_Rate;
   end record;

   -- Procedure Increment_Bank_Reserve inherited from parent (Bank_Account).

   -- Primitive operations (Overridden).
   procedure Assign_Representative (Acct : in Savings_Account);
   procedure Increment_Counters (Acct : in Savings_Account);
   procedure Open (Acct : in out Savings_Account);

   --

   type Preferred_Account is new Savings_Account with record
      Minimum_Balance : Dollar_Amount;
   end record;

   -- Procedure Increment_Bank_Reserve inherited twice.
   -- Procedure Assign_Representative inherited from parent (Savings_Account).

   -- Primitive operations (Overridden).
   procedure Increment_Counters (Acct : in Preferred_Account);
   procedure Open (Acct : in out Preferred_Account);

   -- Function used to verify Open operation for Preferred_Account objects.
   function Verify_Open (Acct : in Preferred_Account) return Boolean;

end F392a00;