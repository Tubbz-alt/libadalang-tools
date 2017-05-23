with C413002p;
package C413002q is
   type Tq is new C413002p.Tp with record
      Value : Float := 0.0;
   end record;

   procedure Prim_Proc (X : in out Tq);
   procedure Prim_Proc (X : in out Tq; Value : Integer);
   function Prim_Func (X : Tq) return Integer;
   function Prim_Func (X : Tq; Value : Integer) return Integer;

   procedure Class_Wide_Proc (X : in out Tq'Class; Value : Float);
   function Class_Wide_Func (X : Tq'Class; Value : Float) return Float;
   --  Note: Formals of these class-wide subprograms are different from the
   --        class-wide subprograms defined in the ancestor.

   function Prim_New_Func (X : Tq) return Integer;
   --  This is a new primitive operation.

   package Local is
      type Tpp is new Tq with null record;
      procedure Prim_Proc (X : in out Tpp);
      procedure Prim_Proc (X : in out Tpp; Value : Integer);
      function Prim_Func (X : Tpp) return Integer;
      function Prim_Func (X : Tpp; Value : Integer) return Integer;
   end Local;
end C413002q;