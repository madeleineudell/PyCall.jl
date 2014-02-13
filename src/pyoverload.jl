module PyOverload

using PyCall

export *,/,-,+,<=,>=,==,getindex,setindex!,ctranspose,transpose

# symmetric operations
for (jlop,pyop1,pyop2) in ((:*,:(:__mul__),:(:__rmul__)),
                           (:/,:(:__div__),:(:__rdiv__)),
                           (:+,:(:__add__),:(:__radd__)),
                           (:-,:(:__sub__),:(:__rsub__)),
                           (:>=,:(:__ge__),:(:__le__)),
                           (:<=,:(:__le__),:(:__ge__)),
                           (:(==),:(:__eq__),:(:__eq__)))
    @eval begin
        let jlop = $jlop, pyop1 = $pyop1, pyop2 = $pyop2
        function (jlop)(a::PyObject,b::PyObject)
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
end

for (jlop,pyop) in ((:*,:(:__mul__)),(:/,:(:__div__)),(:+,:(:__add__)),(:-,:(:__sub__)),
                    (:>=,:(:__ge__)),(:<=,:(:__le__)),(:(==),:(:__eq__)))
    @eval begin
        let jlop = $jlop, pyop = $pyop
        function (jlop)(a::PyObject,b)
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
end

# unary operations
for (jlop,pyop) in ((:size,:(:size)),)
    @eval begin
        let jlop = $jlop, pyop = $pyop
            function (jlop)(a::PyObject)
            if pyop in keys(a)
                return a[pyop]
            else
                error("No method $jlop for $a")
            end
        end
        end
    end
end

# unary functions (ie f(self))
for (jlop,pyop) in ((:length,:(:__len__)),)
    @eval begin
        let jlop = $jlop, pyop = $pyop
            function (jlop)(a::PyObject)
            if pyop in keys(a)
                return a[pyop]()
            else
                error("No method $jlop for $a")
            end
        end
        end
    end
end

# indexing
for (jlop,pyop) in ((:getindex,:(:__getitem__)),(:setindex!,:(:__setitem__)))
    @eval begin
        let jlop = $jlop, pyop = $pyop
            function (jlop)(a::PyObject,args...)
            if pyop in keys(a)
                return a[pyop](tuple(args...))
            else
                error("No method $jlop for $a")
            end
        end
        end
    end
end

# most functions XXX to do
# for :__*__ in keys(a), function ($*) = a[:__*__]
# then functions can be called as f(a)(args...;kwargs...)
for (jlop,pyop) in ((:length,:(:__len__)),)
    @eval begin
        let jlop = $jlop, pyop = $pyop
            function (jlop)(a::PyObject,args...;kwargs...)
                if pyop in keys(a)
                    if (length(args)>0 || length(kwargs)>0)
                        return a[pyop](args...;kwargs...)
                    else
                        return a[pyop]()
                    end
                else
                    error("No method $jlop for $a")
                end
            end
        end
    end
end

# linear algebra
for (jlop,pyop) in ((:ctranspose,:(:T)),(:transpose,:(:T)))
    @eval begin
        let jlop = $jlop, pyop = $pyop
            function (jlop)(a::PyObject)
                if pyop in keys(a)
                    return a[pyop]
                else
                    error("No method $jlop for $a")
                end
            end
        end
    end
end

end # module