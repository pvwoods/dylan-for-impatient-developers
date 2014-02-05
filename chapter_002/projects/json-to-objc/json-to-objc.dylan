Module: json-to-objc
Synopsis: 
Author: 
Copyright: 

define function main (name :: <string>, arguments :: <vector>)
  
  if(arguments.size == 0)
    show-help();
  else
    let filename = arguments[0];
    format-out("%=\n", arguments);
  end;

  exit-application(0);
end function main;

define function show-help()
  format-out("json-to-objc usage:\n\n\tjson-to-objc <filename>\n\n");
end;

main(application-name(), application-arguments());
