for _,force in pairs(game.forces) do
    if force.recipes["space-science-pack"] then
        force.recipes["space-science-pack"].enabled = force.technologies["space-science-pack"].researched
    end
end