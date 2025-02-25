export norme, diste, disth, ur_wo

norme(x) = √((x[1])^2 + (x[2])^2)
diste(x, y) = norme(x .- y)
disth((r, θ), (r′, θ′)) = acosh(cosh(r) * cosh(r′) - sinh(r) * sinh(r′) * cos(π - abs(π - abs(θ - θ′))))

# UnitRangeWithOut
ur_wo(ur, without) = Iterators.flatten((ur.start:(without-1), (without+1):ur.stop))