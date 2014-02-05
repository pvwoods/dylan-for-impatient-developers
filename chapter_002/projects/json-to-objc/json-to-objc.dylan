Module: json-to-objc
Synopsis: 
Author: 
Copyright: 

define function main (name :: <string>, arguments :: <vector>)
  
  if(arguments.size == 0)
    format-out("please provide a source file\n");
  else
    let filename = arguments[0];
    format-out(filename);
  end;

  exit-application(0);
end function main;

main(application-name(), application-arguments());
