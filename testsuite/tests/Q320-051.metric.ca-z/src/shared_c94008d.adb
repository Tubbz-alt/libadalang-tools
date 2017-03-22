
PACKAGE BODY SHARED_C94008D IS
     TASK SHARE IS
          ENTRY SET    (VALUE : IN HOLDER_TYPE);
          ENTRY UPDATE (VALUE : IN VALUE_TYPE);
          ENTRY READ   (VALUE : OUT HOLDER_TYPE);
     END SHARE;

     TASK BODY SHARE IS SEPARATE;

     PROCEDURE SET (VALUE : IN HOLDER_TYPE) IS
     BEGIN
          SHARE.SET (VALUE);
     END SET;

     PROCEDURE UPDATE (VALUE : IN VALUE_TYPE) IS
     BEGIN
          SHARE.UPDATE (VALUE);
     END UPDATE;

     FUNCTION GET RETURN HOLDER_TYPE IS
          VALUE : HOLDER_TYPE;
     BEGIN
          SHARE.READ (VALUE);
          RETURN VALUE;
     END GET;

BEGIN
     SHARE.SET (INITIAL_VALUE);    -- SET INITIAL VALUE
END SHARED_C94008D;
