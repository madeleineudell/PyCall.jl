using PyCall

export *,-,+,<=,>=,==

# symmetric operations
for (jlop,pyop1,pyop2) in ((:*,:__mul__,:__rmul__),
                           (:+,:__add__,:__radd__),
                           (:-,:__sub__,:__rsub__),
                            (:>=,:__ge__,:__le__),
                            (:<=,:__le__,:__ge__),
                            (:(==),:__eq__,:__eq__))
    @eval begin
        function ($jlop)(a::PyObject,b::PyObject)
            if pyop2 in keys(b)
                return b[pyop2](a)
            end
            try
                return a[pyop1](b)
            catch
                try
                    return b[pyop2](a)
                catch
                    error("No method $jlop for $a")
                end
            end
        end
    end
end

# one-sided operations
for (jlop,pyop) in ((:*,:__mul__),(:+,:__add__),(:-,:__sub__),(:>=,:__ge__),(:<=,:__le__),(:(==),:__eq__))
    @eval begin
        function ($jlop)(a::PyObject,b)
            if pyop in keys(a)
                return a[pyop](b)
            else
                error("No method $jlop for $a")
            end
        end
        function ($jlop)(b,a::PyObject)
            if pyop in keys(a)
                return a[pyop](b)
            else
                error("No method $jlop for $a")
            end
        end
    end
end