Module: json-to-objc
Synopsis: 
Author: 
Copyright: 

define function main (name :: <string>, arguments :: <vector>)
  
  if(arguments.size == 0)
    show-help();
  else
    let json-file-stream = make-file-stream(arguments.first);
    let json = parse-json(json-file-stream);

    let (objc-model-header, objc-model-implementation) = render-objc-model(json);

    format-out("%s\n", concatenate(
      "\n/* HEADER */\n\n", 
      objc-model-header, 
      "\n\n/* IMPLEMENTATION */\n\n", 
      objc-model-implementation)
    );

  end;

  exit-application(0);

end function main;

define function render-objc-model(json :: <object>) => (header :: <string>, implementation :: <string>)
  let (header, implementation) = string-table-to-objc-model-header(json, "JSONBaseModel");
  values(
    concatenate(
      "#import <Foundation/Foundation.h>\n\n", 
      header
    ), 
    concatenate(
      "#import 'JSONBaseModel.h'\n\n", 
      implementation
    )
  );
end;

define function string-table-to-objc-model-header(json :: <string-table>, model-name :: <string>) => (header :: <string>, implementation :: <string>)
  
  let header-string = concatenate("@interface ", model-name, " : NSObject\n\n");
  let implementation-string = concatenate("@implmentation ", model-name, "\n\n");
  let implementation-constructor-string =
    "\n- (id) initWithDictionary:(NSDictionary*)dictionary {\n"
    "    self = [super init];\n"
    "    if(self) {\n";
  
  let other-model-headers = "";
  let other-model-implementations = "";
  
  for (value keyed-by key in json)
    implementation-string := concatenate(implementation-string, "@synthesize ", key, ";\n");
    select (value by instance?)
      <string-table> =>
        let model = concatenate("JSON", key);
        model[4] := uppercase(model[4]);
        let (h, i) = string-table-to-objc-model-header(value, model);
        other-model-headers := concatenate(h, other-model-headers);
        other-model-implementations := concatenate(i, other-model-implementations);
        header-string := concatenate(header-string, "@property (nonatomic, strong) ", model, " *", key, ";\n");
        implementation-constructor-string := 
          concatenate(
            implementation-constructor-string,
            "        ", key, " = [[", model, " alloc] initWithDictionary:[dictionary objectForKey:@\"", key, "\"]];\n"
          );
      otherwise =>
        header-string := concatenate(header-string, "@property (nonatomic, strong) ", map-object-to-objc-type(value), " *", key, ";\n");
        implementation-constructor-string :=
          concatenate(
            implementation-constructor-string,
            "        ", key, " = [dictionary objectForKey:@\"", key, "\"];\n"
          );
    end;
  end;
  
  values(
    concatenate(
      other-model-headers, 
      header-string, 
      "\n+ (id) objectWithDictionary:(NSDictionary*)dictionary;"
      "\n- (id) initWithDictionary:(NSDictionary*)dictionary;\n"
      "\n@end\n\n"
    ),
    concatenate(
      other-model-implementations,
      implementation-string,
      implementation-constructor-string,
      "    }\n}\n\n+ (id) objectWithDictionary:(NSDictionary*)dictionary {\n"
      "    return [[", model-name," alloc] initWithDictionary:dictionary];\n"
      "}\n\n@end\n\n"
    )
  );
end;


define function map-object-to-objc-type(object :: <object>) => (objcType :: <string>)
  select (object by instance?)
    <string> => "NSString";
    <vector> => "NSMutableArray";
    <integer> => "NSNumber";
    <float> => "NSNumber";
    <boolean> => "NSNumber";
    otherwise => "NSObject";
  end;
end;

define function make-file-stream (name :: <string>) => (stream :: <stream>)
  make(<file-stream>, locator: name)
end function;

define function show-help()
  format-out(
    "json-to-objc usage:\n"
    "\n\tjson-to-objc <filename>\n\n"
  );
end;

main(application-name(), application-arguments());
