--==================================================================--

with Cxc3004_0;

with Ada.Interrupts;

with Impdef.Annex_C;
with Report;
procedure Cxc3004 is
   package Ai renames Ada.Interrupts;
begin -- CXC3004.

   Report.Test
     ("CXC3004",
      "Check that an exception propagated from " &
      "a handler invoked by an interrupt has no effect. " &
      "Check that the exception causes further execution " &
      "of the handler to be abandoned");

   Impdef.Annex_C.Enable_Interrupts;  -- Enable interrupts, if necessary.

--  The pragma Attach_Handler within the protected object (Static_Handler)
--  has attached Static_Handler.Handle_Interrupt to Interrupt_To_Generate.

   begin

-- (1) Generate the interrupt:

      Impdef.Annex_C.Generate_Interrupt;
      delay Impdef.Annex_C.Wait_For_Interrupt;

-- (2) CXC3004_0.User_Exception is raised within the interrupt handler.

-- (3) Verify that Static_Handler.Handle_Interrupt was called, and that its
--     execution was abandoned when the exception was raised:

      if not Cxc3004_0.Static_Handler.Handled then
         Report.Failed ("Handler in Static_Handler was not called");
      elsif not Cxc3004_0.Static_Handler.Abandoned then
         Report.Failed
           ("Execution of handler in Static_Handler was " & "not abandoned");
      end if;

-- (4) Verify that the exception has no effect:

   exception
      when Cxc3004_0.User_Exception =>
         Report.Failed
           ("User_Exception propagated from " & "Static_Handler was raised");
      when others =>
         Report.Failed
           ("Unexpected exception was propagated from " &
            "Static_Handler and raised");
   end;

   Report.Result;

end Cxc3004;