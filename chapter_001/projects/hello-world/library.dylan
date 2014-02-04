Module: dylan-user

define library hello-world
  use common-dylan;
  use io;
end library;

define module hello-world
  use common-dylan, exclude: { format-to-string };
  use format-out;
end module;
