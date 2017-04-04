-- FDB0A00.A
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
--      This foundation provides the basis for testing package
--      System.Storage_Pools.  It provides simple implementations of
--      Allocate and Deallocate that have the side effect of calling
--      TCTouch.Touch when they are called.
--
-- CHANGE HISTORY:
--      02 JUN 95   SAIC   Initial version
--      05 APR 96   SAIC   Fixed header for 2.1
--      02 JUL 98   EDS    Swapped Pool.Avail change with overflow check
--!

---------------------------------------------------------------- FDB0A00

with Report;
with System.Storage_Pools;
with System.Storage_Elements;
package Fdb0a00 is

   type Stack_Heap (Water_Line : System.Storage_Elements.Storage_Count) is
     new System.Storage_Pools.Root_Storage_Pool with private;

   procedure Allocate
     (Pool                     : in out Stack_Heap;
      Storage_Address          :    out System.Address;
      Size_In_Storage_Elements : in     System.Storage_Elements.Storage_Count;
      Alignment                : in     System.Storage_Elements.Storage_Count);

   procedure Deallocate
     (Pool                     : in out Stack_Heap;
      Storage_Address          : in     System.Address;
      Size_In_Storage_Elements : in     System.Storage_Elements.Storage_Count;
      Alignment                : in     System.Storage_Elements.Storage_Count);

   function Storage_Size
     (Pool : in Stack_Heap) return System.Storage_Elements.Storage_Count;

   function Tc_Largest_Request return System.Storage_Elements.Storage_Count;

   Pool_Overflow : exception;

private

   type Data_Array is
     array
       (System.Storage_Elements
          .Storage_Count range <>) of System.Storage_Elements
       .Storage_Element;

   type Stack_Heap
     (Water_Line : System.Storage_Elements.Storage_Count)
   is new System.Storage_Pools.Root_Storage_Pool with
   record
      Data  : Data_Array (1 .. Water_Line);
      Avail : System.Storage_Elements.Storage_Count := 1;
   end record;

end Fdb0a00;