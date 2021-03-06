"""
    dominates(p1::Array, p2::Array)

    Return true if each element in p1 is not less than the corresponding element in p2 and at least one element in p1 is bigger than the corresponding element in p2.

# Arguments
- `p1::Array`: Numeric array of n elements.
- `p2::Array`: Numeric array of n elements.

# Examples
```julia-repl
julia> dominates([1,2,3], [1,2,1])
true
julia> dominates([0,0,0,0], [1,0,0,0])
false
```

# References
Deb, Kalyanmoy, et al. "A fast elitist non-dominated sorting genetic algorithm for multi-objective optimization: NSGA-II." 
International conference on parallel problem solving from nature. Springer, Berlin, Heidelberg, 2000.
"""
function dominates(p1::Array, p2::Array)::Bool
    n = length(p1)
    notworse = count(i -> p1[i] < p2[i], 1:n)
    better   = count(i -> p1[i] > p2[i], 1:n)
    return (notworse == 0) && (better > 0)
end



"""
    ndsranks(data)

    Sort multidimensional data usin non-dominated sorting algorithm.

# Arguments
- `data::DataFrame`: DataFrame of variables.

# References
Deb, Kalyanmoy, et al. "A fast elitist non-dominated sorting genetic algorithm for multi-objective optimization: NSGA-II." 
International conference on parallel problem solving from nature. Springer, Berlin, Heidelberg, 2000.
"""
function ndsranks(data::DataFrame)::Array{Int}
    
    mat = convert(Matrix, data)
    
    return ndsranks(mat)

end



"""
    ndsranks(data)

    Sort multidimensional data usin non-dominated sorting algorithm.

# Arguments
- `data::Matrix`: n x k matrix of observations where n is number of observations and k is number of variables.

# Examples
```julia-repl
  
```

# References
Deb, Kalyanmoy, et al. "A fast elitist non-dominated sorting genetic algorithm for multi-objective optimization: NSGA-II." 
International conference on parallel problem solving from nature. Springer, Berlin, Heidelberg, 2000.
"""
function ndsranks(data::Matrix)::Array{Int64}
    
    n, p = size(data)

    ranks = zeros(Int64, n)
    
    mat = convert(Matrix, data)
    
    @inbounds for i in 1:n
        @inbounds for j in 1:n
            if i != j 
                if dominates(mat[i,:], mat[j,:])
                    ranks[i] += 1
                end
            end
        end
    end

    return ranks
end



function nds(data::DataFrame)

    ranks = ndsranks(data)

    bestIndex = sortperm(ranks) |> last

    result = NDSResult(
        ranks,
        bestIndex
    )

    return result
end


