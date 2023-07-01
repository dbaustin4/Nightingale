vector2 = {}

function vector2.new(bx, by)
    return {x = bx, y = by}
end

function vector2.add(vec, inc)
    local result = vector2.new(0, 0)
    result.x = vec.x + inc.x
    result.y = vec.y + inc.y
    return result
end

function vector2.sub(vec, dec)
    local result = vector2.new(0, 0)
    result.x = vec.x - dec.x
    result.y = vec.y - dec.y
    return result
end

function vector2.mult(vec, n)
    local result = vector2.new(0, 0)
    result.x = vec.x * n
    result.y = vec.y * n
    return result
end

function vector2.div(vec, n)
    local result = vector2.new(0, 0)
    result.x = vec.x / n
    result.y = vec.y / n
    return result
end

function vector2.magnitude(vec)
    return math.sqrt(vec.x * vec.x + vec.y * vec.y)
end

function vector2.normalize(vec)
    local m = vector2.magnitude(vec)
    if m ~= 0 then
        return vector2.div(vec , m)
    end
    return vec
end

function vector2.limit(vec, max)
    local result = vec
    if (vector2.magnitude(vec) > max) then
        result = vector2.normalize(vec)
        result = vector2.mult(result, max)
    end
    return result
end

function vector2.dot(vec1, vec2)
    return (vec1.x * vec2.x) + (vec1.y * vec2.y)
end