# mPrefs

mPrefs is here to help macOS SysAdmin to check the managed settings of a preferrences domain, usually not shown by the `defaults` command line.

## Help

```
mPrefs is a simple command line allowing system administrator to check a target domain with managed preferences applied.

-d com.github.ygini.Hello-IT				Use the -d to specify the target domain to read
-o read							The -o option allow you to select your operation:
								"list" to list all managed keys
								"listall" to list all keys, managed or not
								"read" to read all keys, managed or not
-k content						With -k, you can specify the key to read
								(usable with operation listall and read)
-k 1							When -pk is set to 1, you can use a keypath with -k

More informations on keypath available here: https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/KeyValueCoding/CollectionOperators.html
``` 
