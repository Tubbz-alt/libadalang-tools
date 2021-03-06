------------------------------------------------------------------------------
--                                                                          --
--                             Libadalang Tools                             --
--                                                                          --
--                       Copyright (C) 2020, AdaCore                        --
--                                                                          --
-- Libadalang Tools  is free software; you can redistribute it and/or modi- --
-- fy  it  under  terms of the  GNU General Public License  as published by --
-- the Free Software Foundation;  either version 3, or (at your option) any --
-- later version. This software  is distributed in the hope that it will be --
-- useful but  WITHOUT  ANY  WARRANTY; without even the implied warranty of --
-- MERCHANTABILITY  or  FITNESS  FOR A PARTICULAR PURPOSE.                  --
--                                                                          --
-- As a special  exception  under  Section 7  of  GPL  version 3,  you are  --
-- granted additional  permissions described in the  GCC  Runtime  Library  --
-- Exception, version 3.1, as published by the Free Software Foundation.    --
--                                                                          --
-- You should have received a copy of the GNU General Public License and a  --
-- copy of the GCC Runtime Library Exception along with this program;  see  --
-- the files COPYING3 and COPYING.RUNTIME respectively.  If not, see        --
-- <http://www.gnu.org/licenses/>.                                          --
------------------------------------------------------------------------------
--
--  This package contains LAL_Tools utilities to be used by refactoring
--  rename tools.

with Ada.Containers; use Ada.Containers;
with Ada.Containers.Indefinite_Hashed_Maps;
with Ada.Containers.Indefinite_Vectors;
with Ada.Containers.Ordered_Maps;
with Ada.Containers.Ordered_Sets;

with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Strings.Wide_Wide_Unbounded; use Ada.Strings.Wide_Wide_Unbounded;

with Laltools.Common; use Laltools.Common;
with Laltools.Refactor.Problems; use Laltools.Refactor.Problems;

with Langkit_Support.Slocs; use Langkit_Support.Slocs;
with Langkit_Support.Text; use Langkit_Support.Text;

with Libadalang.Analysis; use Libadalang.Analysis;

package Laltools.Refactor.Rename is

   type Rename_Problem is abstract new Refactor_Problem with
      record
         Canonical_Definition : Defining_Name;
         New_Name             : Unbounded_Text_Type;
         Conflicting_Id       : Name;
      end record;

   overriding
   function Filename (Self : Rename_Problem) return String is
     (Self.Conflicting_Id.Unit.Get_Filename);
   --  Returns the filename of the analysis unit where Self happens.

   overriding
   function Location (Self : Rename_Problem)
                      return Source_Location_Range is
     (Self.Conflicting_Id.Sloc_Range);
   --  Return a location in the file where Self happens.

   package Rename_Problem_Vectors is new Ada.Containers.Indefinite_Vectors
     (Index_Type   => Natural,
      Element_Type => Rename_Problem'Class);

   type Problem_Finder_Algorithm_Kind is
     (Map_References,
      Analyse_AST);

   function "<" (Left, Right : Source_Location_Range)
                 return Boolean;
   --  Starts by comparing if both Left and Right start lines. If equal, start
   --  columns are compared.

   package Slocs_Sets is new Ada.Containers.Ordered_Sets
     (Element_Type => Source_Location_Range,
      "<"          => "<");

   package Slocs_Maps is new
     Ada.Containers.Ordered_Maps
       (Key_Type     => Positive,
        Element_Type => Slocs_Sets.Set,
        "="          => Slocs_Sets."=");

   function "<" (Left, Right : Analysis_Unit) return Boolean is
     (Left.Get_Filename < Right.Get_Filename);

   package Unit_Slocs_Maps is new Ada.Containers.Ordered_Maps
     (Key_Type     => Analysis_Unit,
      Element_Type => Slocs_Maps.Map,
      "<"          => "<",
      "="          => Slocs_Maps."=");

   type Renamable_References is
      record
         References : Unit_Slocs_Maps.Map;
         Problems   : Rename_Problem_Vectors.Vector;
      end record;

   function Find_All_Renamable_References
     (Node           : Ada_Node'Class;
      New_Name       : Unbounded_Text_Type;
      Units          : Analysis_Unit_Array;
      Algorithm_Kind : Problem_Finder_Algorithm_Kind)
      return Renamable_References;
   --  Finds all references of Node and checks for problems caused by renaming
   --  such references.
   --  If Node is a primitive subrogram of a type, then the return refereces
   --  include references of supbprograms that Node is overriding or that is
   --  being overridden by.
   --  If Node is a parameter of a subprogram 'Foo' that is a primitive of a
   --  type, then the return refereces include parameter spec references of
   --  supbprograms that 'Foo' is overriding or that is being overridden by.

private

   type Dummy_Rename_Problem is new Rename_Problem with null record;

   overriding
   function Filename (Self : Dummy_Rename_Problem) return String is
     ("Dummy rename problem. No filename.");
   --  This is a dummy function and shall never be used.

   overriding
   function Location (Self : Dummy_Rename_Problem)
                      return Source_Location_Range is ((0, 0, 0, 0));
   --  This is a dummy function and shall never be used.

   overriding
   function Info (Self : Dummy_Rename_Problem) return String is
     ("Dummy rename problem");
   --  This is a dummy function and shall never be used.

   No_Rename_Problem : constant Rename_Problem'Class :=
     Dummy_Rename_Problem'
       (Canonical_Definition => No_Defining_Name,
        New_Name             => Null_Unbounded_Wide_Wide_String,
        Conflicting_Id       => No_Name);

   type Missing_Reference is new Rename_Problem with null record;

   overriding
   function Info (Self : Missing_Reference) return String;
   --  Returns a human readable message with the description of Self.

   type New_Reference is new Rename_Problem with null record;

   overriding
   function Info (Self : New_Reference) return String;
   --  Returns a human readable message with the description of Self.

   type Name_Collision is new Rename_Problem with null record;

   overriding
   function Info (Self : Name_Collision) return String;
   --  Returns a human readable message with the description of Self.

   type Overriding_Subprogram is new Rename_Problem with null record;

   overriding
   function Info (Self : Overriding_Subprogram) return String;
   --  Returns a human readable message with the description of Self.

   type Hiding_Name is new Rename_Problem with null record;

   overriding
   function Info (Self : Hiding_Name) return String;
   --  Returns a human readable message with the description of Self.

   type Hidden_Name is new Rename_Problem with null record;

   overriding
   function Info (Self : Hidden_Name) return String;
   --  Returns a human readable message with the description of Self.

   type Problem_Finder_Algorithm is interface;

   function Find (Self : in out Problem_Finder_Algorithm)
                  return Rename_Problem_Vectors.Vector is abstract;
   --  Finds problems caused by renaming a definition.

   function Get_Original_References (Self : in out Problem_Finder_Algorithm)
                                     return Unit_Slocs_Maps.Map is abstract;
   --  Gets all references of a definition before attempting to rename it.

   package Unit_Buffers is new Ada.Containers.Indefinite_Hashed_Maps
     (Key_Type        => Analysis_Unit,
      Element_Type    => Unbounded_String,
      Hash            => Hash,
      Equivalent_Keys => "=");

   type Unit_Slocs_Maps_Diff is
      record
         Minus : Unit_Slocs_Maps.Map;
         Plus  : Unit_Slocs_Maps.Map;
      end record;

   type Reference_Mapper (Units_Length : Integer) is new
     Problem_Finder_Algorithm with
      record
         Canonical_Definition      : Defining_Name;
         Canonical_Definition_Unit : Analysis_Unit;
         Canonical_Definition_Sloc : Source_Location_Range;
         Units                     : Analysis_Unit_Array (1 .. Units_Length);
         Original_Name             : Unbounded_Text_Type;
         New_Name                  : Unbounded_Text_Type;
         Original_References       : Unit_Slocs_Maps.Map;
         New_References            : Unit_Slocs_Maps.Map;
         Temporary_Buffers         : Unit_Buffers.Map;
         References_Diff           : Unit_Slocs_Maps_Diff;
      end record;

   procedure Initialize
     (Self                 : out Reference_Mapper;
      Canonical_Definition : Defining_Name;
      New_Name             : Unbounded_Text_Type;
      Units                : Analysis_Unit_Array)
     with Pre => Canonical_Definition /= No_Defining_Name
     and then Canonical_Definition.P_Canonical_Part = Canonical_Definition;
   --  Initializes the Reference_Mapper algorithm by filling its elements
   --  with the necessary information to perform the Find function.

   overriding
   function Find (Self : in out Reference_Mapper)
                  return Rename_Problem_Vectors.Vector;
   --  Finds problems caused by renaming a definition. The strategy of this
   --  algorithm is to compare references before and after the rename.
   --  IMPORTANT NOTE: This function reparses all analysis units given to the
   --  Initialize procedure. All active references of nodes created before
   --  running thiss function will then be unreferenced.

   overriding
   function Get_Original_References
     (Self : in out Reference_Mapper)
      return Unit_Slocs_Maps.Map is (Self.Original_References);
   --  Returns a map, ordered by filename and line number, of references before
   --  doing the rename.

   procedure Update_Canonical_Definition (Self : in out Reference_Mapper);
   --  Function Find of Self calls Parse_Temporary_Buffers which will
   --  invalidates all nodes. This procedure restores the canonical
   --  definition that the algorithm is checking for rename problems.

   procedure Parse_Temporary_Buffers (Self : in out Reference_Mapper);
   --  For every unit, parses a temporary buffer with all the references
   --  renamed.

   procedure Parse_Original_Buffers (Self : in out Reference_Mapper);
   --  For every unit, parses it's original buffer.

   procedure Diff (Self : in out Reference_Mapper);
   --  Creates a diff between the original references and the new references
   --  after the rename is applied. Some references can be lost and some
   --  can be gained, therefore, they are stored seperately.

   type AST_Analyser (Units_Length : Integer) is new
     Problem_Finder_Algorithm with
      record
         Canonical_Definition    : Defining_Name;
         New_Name                : Unbounded_Text_Type;
         Units                   : Analysis_Unit_Array (1 .. Units_Length);
         Original_References     : Unit_Slocs_Maps.Map;
         Original_References_Ids : Base_Id_Vectors.Vector;
      end record;

   procedure Initialize
     (Self                 : out AST_Analyser;
      Canonical_Definition : Defining_Name;
      New_Name             : Unbounded_Text_Type;
      Units                : Analysis_Unit_Array)
     with Pre => Canonical_Definition /= No_Defining_Name
     and then Canonical_Definition.P_Canonical_Part = Canonical_Definition;
   --  Initializes the Reference_Mapper algorithm by filling its elements
   --  with the necessary information to perform the Find function.

   overriding
   function Find (Self : in out AST_Analyser)
                  return Rename_Problem_Vectors.Vector;
   --  Finds problems caused by renaming a definition. The strategy of this
   --  algorithm is to analyse the AST and look for specific problems.

   overriding
   function Get_Original_References
     (Self : in out AST_Analyser)
      return Unit_Slocs_Maps.Map is (Self.Original_References);
   --  Returns a map, ordered by filename and line number, of references before
   --  doing the rename.

   type Specific_Problem_Finder is interface;

   function Find (Self : Specific_Problem_Finder)
                  return Rename_Problem'Class is abstract;
   --  Finds specific problems cause by renaming a definition.

   package Specific_Rename_Problem_Finder_Vectors is new
     Ada.Containers.Indefinite_Vectors
       (Index_Type   => Natural,
        Element_Type => Specific_Problem_Finder'Class);

   type Name_Collision_Finder is new Specific_Problem_Finder with
      record
         Canonical_Definition : Defining_Name;
         New_Name             : Unbounded_Text_Type;
      end record;

   overriding
   function Find (Self : Name_Collision_Finder) return Rename_Problem'Class;
   --  Find name collisions created by a rename operation in the same scope.

   type Collision_With_Compilation_Unit_Finder (Units_Length : Integer) is new
     Specific_Problem_Finder with
      record
         Canonical_Definition : Defining_Name;
         New_Name             : Unbounded_Text_Type;
         Units                : Analysis_Unit_Array (1 .. Units_Length);
      end record;

   overriding
   function Find (Self : Collision_With_Compilation_Unit_Finder)
                  return Rename_Problem'Class;
   --  Find name collisions with a compilation unit created by a rename
   --  operation.
   --  Example: Is package Foo has a definition Bar, and a child compilation
   --  unit Foo.Baz, then renaming Bar to Baz creates a collision that is
   --  detected by this function.

   type Compilation_Unit_Collision_Finder (Units_Length : Integer) is new
     Specific_Problem_Finder with
      record
         Canonical_Definition : Defining_Name;
         New_Name             : Unbounded_Text_Type;
         Units                : Analysis_Unit_Array (1 .. Units_Length);
      end record;

   overriding
   function Find (Self : Compilation_Unit_Collision_Finder)
                  return Rename_Problem'Class;
 --  Find name collisions between a compilation units created by a rename
 --  operation.

   type Subp_Overriding_Finder is new Specific_Problem_Finder with
      record
         Canonical_Definition : Defining_Name;
         New_Name             : Unbounded_Text_Type;
      end record;

   overriding
   function Find (Self : Subp_Overriding_Finder) return Rename_Problem'Class;
   --  Checks if renaming a subprogram will start overriding another one.
   --  TODO: Also check if it will start being overriden.

   type Param_Spec_Collision_Finder is new Specific_Problem_Finder with
      record
         Canonical_Definition : Defining_Name;
         New_Name             : Unbounded_Text_Type;
         Reference            : Base_Id := No_Base_Id;
      end record;

   overriding
   function Find (Self : Param_Spec_Collision_Finder)
                  return Rename_Problem'Class;
   --  Checks if renaming a Param_Spec will cause a conflict with its type.

   type Name_Hiding_Finder is new Specific_Problem_Finder with
      record
         Canonical_Definition : Defining_Name;
         New_Name             : Unbounded_Text_Type;
      end record;

   overriding
   function Find (Self : Name_Hiding_Finder) return Rename_Problem'Class;
   --  Checks if renaming a definition will start hiding another one.

   type Subtype_Indication_Collision_Finder is new Specific_Problem_Finder with
      record
         Canonical_Definition : Defining_Name;
         References           : Base_Id_Vectors.Vector;
         New_Name             : Unbounded_Text_Type;
      end record;

   overriding
   function Find (Self : Subtype_Indication_Collision_Finder)
                  return Rename_Problem'Class;
   --  Renaming a rype operation will also rename its references in
   --  subtype indications of subprograms specs. This function checks if
   --  renaming such references will cause a collision with its paramater.

   type Name_Hidden_Finder is new Specific_Problem_Finder with
      record
         Canonical_Definition : Defining_Name;
         References           : Base_Id_Vectors.Vector;
         New_Name             : Unbounded_Text_Type;
      end record;

   overriding
   function Find (Self : Name_Hidden_Finder) return Rename_Problem'Class;
   --  Checks if renamin a definition will make it hidden by another one.

end Laltools.Refactor.Rename;
