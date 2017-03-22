
package body C413003P is

   procedure Base_Proc (X : access TP) is
   begin
      X.Data := 10;
   end Base_Proc;

   procedure Base_Proc  (X : access TP; Value : Integer) is
   begin
      X.Data := Value;
   end Base_Proc;

   function Base_Func (X : access constant TP) return Integer is
   begin
      return 1;
   end Base_Func;

   function  Base_Func  (X : access constant TP; Value : Integer) return Integer is
   begin
      return Value;
   end Base_Func;

   procedure Prim_Proc (X: access TP) is
   begin
      X.Data := 11;
   end Prim_Proc;

   procedure Prim_Proc (X: access TP; Value : Integer) is
   begin
      X.Data := Value;
   end Prim_Proc;

   function Prim_Func (X : access constant TP) return Integer is
   begin
      return 2;
   end Prim_Func;

   function Prim_Func (X : access constant TP; Value : Integer) return Integer is
   begin
      return Value;
   end Prim_Func;

   procedure Class_Wide_Proc (X: access TP'Class) is
   begin
      X.Data := -1;
   end Class_Wide_Proc;

   procedure Class_Wide_Proc (X: access TP'Class; Value : Integer) is
   begin
      X.Data := 3 * Value;
   end Class_Wide_Proc;

   function Class_Wide_Func (X : access constant TP'Class) return Integer is
   begin
      return -2;
   end Class_Wide_Func;

   function Class_Wide_Func
     (X : access constant TP'Class; Value : Integer) return Integer is
   begin
      return 3 * Value;
   end Class_Wide_Func;

end C413003P;
