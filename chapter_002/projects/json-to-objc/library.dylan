Module: dylan-user

define library json-to-objc
  use common-dylan;
  use system;
  use io;
  use strings;
  use json;
end library;

define module json-to-objc
  use common-dylan, exclude: { format-to-string };
  use format-out;
  use file-system;
  use strings;
  use json;
end module;
