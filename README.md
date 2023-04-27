# Mini Lisp REPL

This is a simple Ruby implementation of a Lisp-like language REPL (Read-Eval-Print Loop) that allows you to write and run simple Lisp-like expressions. It supports basic arithmetic operations, conditions, loops, and more.

## Features

* Basic arithmetic operations (+, -, *, /)
* Comparisons (<, >)
* Conditionals (if)
* Loops (loop)
* Repeated execution (repeat)
* Printing (print)

## Usage

1. Clone the repository or copy the code into a file named `lisp.rb`.
2. Run the script using Ruby:

```ruby lisp.rb```

3. The REPL will start, and you can enter Lisp-like expressions. Type `exit` to quit the REPL.

REPL supports multiline input

## Examples

### Basic arithmetic operations

```
(+ 1 2 3)
6
(* 2 3)
6
(- 10 5)
5
(/ 9 3)
3
```

### Comparisons

```
< 1 2)
true
(> 5 3)
true
```

### Conditionals

```
(if (> 1 2) "1 is greater than 2" "1 is not greater than 2")
"1 is not greater than 2"
```

### Loops

```
(loop (< _ 5)
(print "Loop iteration:")
(print _)
)
...
```

### Repeated execution

```
(repeat 3
(print "Hello, world!")
)

...
```


## Notes

This is a minimalistic implementation and does not cover all Lisp features. It is meant for educational purposes and should not be used for production code.


## Run the tests

```rspec spec/list_spec.rb```

## TODO

The Mini Lisp REPL currently provides a basic set of features for a Lisp-like language. However, there are several improvements and additions that could be implemented:

1. **Error handling**: Enhance error handling to provide more informative error messages for syntax errors, unrecognized tokens, or other issues.

2. **User-defined functions**: Implement a way for users to define their own functions using the Lisp-like syntax. This would involve adding support for `lambda`, `define`, or `let` expressions.

3. **Extended built-in functions**: Add more built-in functions to support a wider range of operations, such as string manipulation, list operations (map, reduce, filter), and more.

4. **Modules and imports**: Implement a module system that allows users to organize their code into separate files and import them as needed.

5. **Macros**: Add support for Lisp macros, which are a powerful metaprogramming feature that allows users to extend the language itself.

6. **Tail call optimization**: Optimize the interpreter to support proper tail calls, which would allow for more efficient recursion in user-defined functions.

