#Diving in head first

Enough fooling around.  It is time to dive into writing some real dylan code, and at the end of this chapter, actually having something useful.  That something useful will be an application that takes a JSON file and converts it to an Objective-C model that will parse the JSON (actually an NSDictionary)

##Building a JSON to Objective-C model generator

###Creating a project
Create a project using make-dylan-app called json-to-objc in the same way we created a hello world app in Chapter 001.  After creating the project, open json-to-objc.dylan

###Getting the filename
We can grab the filename from the command line arguments.  To do this we will use the 'arguments' vector (basically an array in any other language).  We will check if arguments have been provided, and if so, we will start out by printint out that file name.  If not, we will show an error.

we can do this by adding the following snippet to json-to-objc.dylan:

```dylan
if(arguments.size == 0)
  format-out("please provide a source file\n");
else
  let filename = arguments[0];
  format-out(filename);
end;
```

_notice:_ We have learned in the last statement how to check a vectors size, how to print to the terminal, and access specific elements of a vector.

###A better error handler

lets add a better way to show our error.  We can add a help message with some nice formatting by adding a new function:

```dylan
define function show-help()
  format-out(
    "json-to-objc usage:\n"
    "\n\tjson-to-objc <filename>\n\n"
  );
end;
```

Notice that there are the two seperate strings in the format-out.  In Dylan, strings next to each other are concantenatedby the compiler, so we can take advantage of that to make some of the formatting a little easier to read.

Now we'll change our line that prints 'please provide a source file' to

```dylan
show-help()
```
 
###File IO

We can open files and read them using the io library and stream type.  We are going to create another function called make-file-stream.

```dylan
define function make-file-stream (name :: <string>) => (stream :: <stream>)
   make(<file-stream>, locator: name)
end function;
```

notice a couple of things here in this function.  '(name :: <string>)' are the function arguments.  '=> (stream :: <stream>)' defines the return type. make is the way to create a new data type (in this case <file-stream>) and we pass in the "locator" as an argument when making the new object.  Also note that returns are not needed in dylan, as each function returns whatever piece of data that was last dealt with before the function terminated (in this case, the file-stream we just created with make).

Lets go ahead and use that new function to open our json file for parsing by replacing "let filename = arguments[0]" with the following:

```dylan
let json-file-stream = make-file-stream(arguments.first);
```

as you can see, we can also access the 0 element in the vector using the first method.

Now we need to tell the dylan compiler we need to include some libraries and modules.  Open up library.dylan, and change the file to look like so:

```dylan
Module: dylan-user

define library json-to-objc
  use common-dylan;
  use system;
  use io;
end library;

define module json-to-objc
  use common-dylan, exclude: { format-to-string };
  use format-out;
  use file-system;
end module;
```

As you can see, we are now using the system library, and the file-system module from the system library.

###JSON parsing

Before we can start parsing the JSON, we need a file to parse.  Add a file to the directory called test.json, and copy paste the following into it:

```json
{
  "name": "Albert Einstein",
  "age": 13,
  "isResident": false,
  "accessPoints": [12,334,525,1654],
  "meta": {
    "homepage":"http://example.com"
  }
}
```

We also need to include the json library, which is an external library.  The easiest way to include the json library is to add it as a git submodule, and then adding a registry file to tell the dylan compiler where to find the external library.

```bash
git submodule add https://github.com/dylan-lang/json.git
echo 'abstract://dylan/submodules/json/json.lid' > registry/generic/json
```

Now, to get the values out of the json object, we can just parse the stream, and then iterate over the resulting object with the following code:

```dylan
let json = parse-json(json-file-stream);
for (value keyed-by key in json) 
  format-out("%=, %=\n", key, value);
end;
```

note that we could have also accessed the value of the various keys using the line

```dylan
format-out("%=, %=\n", key, json[key]);
```

####JSON to NS type mapping

we need a way to map the objects type to the equivilant Objective-C type.  We can do this fairly trivially with a function that takes advantage of Dylans select by idiom:

```dylan
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
```

that otherwise is more of a sanity check, since our application should probably never get there, but you never know!

###Setting up the output

Before moving forward, we will need to import dylans string manipulation library, so add the line "use strings;" to the library and modules definitions in library.dylan

In Objective C, we have a header file, and an implementation file that we will need to generate off of a single json object.  We are going to take advantage of a cool feature in Dylan that allows us to return multiple values from a single function.  In your main function, just under where you called parse-json, we will now add:

```dylan
let (objc-model-header, objc-model-implementation) = render-objc-model(json);
format-out("%s\n", concatenate("\n/* HEADER */\n\n", objc-model-header, "\n\n/* IMPLEMENTATION */\n\n", objc-model-implementation));
```

and then add a stub function for now:

```dylan
define function render-objc-model(json :: <object>) => (header :: <string>, implementation :: <string>)
  values("header", "implementation");
end;
```

###Generating the output

###A poor-man debugging implementation in Dylan

If for any reason you get stuck and need to output something in Dylan, you can use the poor-man debugging solution: format-out.  format-out can be thought of as printf (or even more accurately, NSLog) with different symbols.  In most cases, you can just use the following to serialize an object and print it to the terminal (note the \n is just a line break):

```dylan
format-out("%=\n", my-thing);
```
