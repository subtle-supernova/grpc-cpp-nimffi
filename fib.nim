proc fib(a: cint): cint {.exportc.} =
  if a <= 2:
    result = 1
  else:
    result = fib(a - 1) + fib(a - 2)

type
  Person {.exportc, extern: "something$1" .} = object
    name: string
    age: int

proc mkperson(): Person {.exportc.} =
  Person(name: "Jeremy", age: 12)

