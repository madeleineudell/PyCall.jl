using PyCall
require("../src/pyoverload.jl")
using PyOverload

@pyimport cvxpy
m,n = 4,3;
a = cvxpy.Variable(m,n)
b = cvxpy.Variable(m,n)

a+b
a-b
a<=b
a>=b
a>=1
a+1
a*2
2*a
a==4
a[1,1] = 4
# find a python variable that's not an array that allows index setting to test this
# a[1,1] == 4
a'+1
b.'
(a')*b
a*b'
length(a)
size(a)