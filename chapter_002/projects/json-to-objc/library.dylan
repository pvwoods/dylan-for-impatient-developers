Module: dylan-user

define library json-to-objc
  use common-dylan;
  use io;
end library;

define module json-to-objc
  use common-dylan, exclude: { format-to-string };
  use format-out;
end module;
