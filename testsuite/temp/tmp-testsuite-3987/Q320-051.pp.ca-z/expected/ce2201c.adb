-- CE2201C.ADA

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
--     CHECK THAT READ, WRITE, AND END_OF_FILE ARE SUPPORTED FOR
--     SEQUENTIAL FILES WITH ELEMENT_TYPE FLOAT.

-- APPLICABILITY CRITERIA:
--     THIS TEST IS APPLICABLE ONLY TO IMPLEMENTATIONS WHICH SUPPORT
--     SEQUENTIAL FILES.

-- HISTORY:
--     ABW 08/17/82
--     SPS 11/10/82
--     JBG 20/22/84  CHANGED TO .ADA TEST.
--     EG  05/16/85
--     TBN 11/04/86  REVISED TEST TO OUTPUT A NOT_APPLICABLE
--                   RESULT WHEN FILES ARE NOT SUPPORTED.
--     JLH 08/03/87  REMOVED DEPENDENCE OF RESET AND CREATED AN EXTERNAL
--                   FILE RATHER THAN A TEMPORARY FILE.

with Report; use Report;
with Sequential_Io;

procedure Ce2201c is
begin

   Test
     ("CE2201C",
      "CHECK THAT READ, WRITE, AND " &
      "END_OF_FILE ARE SUPPORTED FOR " &
      "SEQUENTIAL FILES - FLOAT");

   declare
      package Seq_Flt is new Sequential_Io (Float);
      use Seq_Flt;
      File_Flt : File_Type;
      Incomplete : exception;
      Flt      : Float := 65.0;
      Item_Flt : Float;
   begin
      begin
         Create (File_Flt, Out_File, Legal_File_Name);
      exception
         when Use_Error | Name_Error =>
            Not_Applicable
              ("CREATE OF SEQUENTIAL FILE WITH " &
               "MODE OUT_FILE NOT SUPPORTED");
            raise Incomplete;
      end;

      Write (File_Flt, Flt);
      Close (File_Flt);

      begin
         Open (File_Flt, In_File, Legal_File_Name);
      exception
         when Use_Error =>
            Not_Applicable
              ("OPEN OF SEQUENTIAL FILE WITH " & "MODE IN_FILE NOT SUPPORTED");
            raise Incomplete;
      end;

      if End_Of_File (File_Flt) then
         Failed ("WRONG END_OF_FILE VALUE FOR FLOATING POINT");
      end if;

      Read (File_Flt, Item_Flt);

      if Item_Flt /= 65.0 then
         Failed ("READ WRONG VALUE - FLOAT");
      end if;

      if not End_Of_File (File_Flt) then
         Failed ("END OF FILE NOT TRUE - FLOAT");
      end if;

      begin
         Delete (File_Flt);
      exception
         when Use_Error =>
            null;
      end;

   exception
      when Incomplete =>
         null;

   end;

   Result;

end Ce2201c;