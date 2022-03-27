using Plots
using Measures
using ColorSchemes
gr()

include("generate_HRG.jl")

function main()
    g, (peers, edges) = generate_hyperbolic_graph(100, 0.7, 1.0, 0.2)
    begin
        p = plot(legend=false, aspect_ratio=1.0, proj=:polar, ticks=false, ylabel="Foo", xlabel="Bar", margin=3mm)
        for (s, t) in edges
            plot!([s[2], t[2]], [s[1], t[1]], lc=:gray, lw=0.5)
        end
        p
        scatter!(last.(peers), first.(peers), ms=3.0) # series_annotations=text.(1:length(peers), :bottom)

    end

    let
        N = 100
        ν = 1.0
        R = 2log(N / ν)
        @show R
        ρ = LinRange(0.0, R, 500)
        θ = LinRange(0.0, 2π, 3600)
        pt = (R / 2, 2)
        # contourf currently doesn't work with GR backend, so we have to cheat...
        funp(ρ, θ) = disth(pt, (ρ, θ)) < R ? (isapprox(disth(pt, (ρ, θ)), R, atol=2e-1) ? 0 : floor(disth(pt, (ρ, θ)))) : 1.1R
        # funp(ρ, θ) = floor(disth(pt, (ρ, θ)))
        heatmap(θ, ρ, (θ, ρ) -> funp(ρ, θ), proj=:polar, colorbar=false, color=cgrad(:tempo, rev=true))
        scatter!([0], [0], mc=:brown, label="Origin", shape=:hexagon, ms=5, msw=2.0)
        scatter!([pt[2]], [pt[1]], mc=:white, label="Centre", shape=:diamond, msw=2.0)
        plot!([2, 2 + π], [R / 2, R / 2], lw=2, lc=:black)
        plot!(size=(300, 300), margin=3mm, yticks=[0]) # set yticks instead of hiding as this bugs the plot
        # plot!(title = "Distance from Point Half-way to Radius") # put the title as caption
        savefig("out/hyperbolic_ball.pdf")
    end

    # The coolest thing I've made by accident:
    # let
    #     N = 100
    #     ν = 1.0
    #     R = 2log(N/ν)
    #     ρ = LinRange(0., 7, 200)
    #     θ = LinRange(0., 2π, 360)
    #     funp(ρ, θ) = round(disth((3, 0), (ρ, θ)))
    #     Plots.heatmap(ρ, θ, funp, proj = :polar)
    # end
    return p
end