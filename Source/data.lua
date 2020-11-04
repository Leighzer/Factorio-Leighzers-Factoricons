if not leighzermods then -- generic mod variable to store information that may be needed later
    leighzermods = {}
end

if not leighzermods.leighzerfactoricons then
    leighzermods.leighzerfactoricons = {}
end
leighzermods.leighzerfactoricons.precursorIngredients = settings.startup["precursorIngredients"].value

-- crafting tabs and rows
leighzermods.utils.createItemGroup("leighzerfactoricons","zz","zz","__leighzerlib__/graphics/item-group/factoricon-item-group.png",128,"Factoricons")
leighzermods.utils.createItemSubgroup("leighzerfactoricons-top-row","leighzerfactoricons","a")
leighzermods.utils.createItemSubgroup("leighzerfactoricons","leighzerfactoricons","b")

-- create factoricon technology
local factoriconTechIcons = {{icon="__leighzerlib__/graphics/item-group/factoricon-item-group.png", icon_size=128}}
local factoriconTechEffects = {}
local factoriconTechUnit = {
      count = 500,
      ingredients =
      {
        {"automation-science-pack", 1},
        {"logistic-science-pack", 1},
        {"chemical-science-pack", 1},
        {"production-science-pack", 1},
        {"utility-science-pack", 1}
      },
      time = 45
}
local factoriconTechPrereqs = {"rocket-control-unit"}
local factoriconTechLocName = "Factoricon technology"
local factoriconTechLocDesc = "The secret to space travel is in the planet's water..." -- \(e.e)/
leighzermods.utils.createTechnology("factoricon",factoriconTechIcons,true,factoriconTechEffects,factoriconTechUnit,factoriconTechPrereqs,"a",factoriconTechLocName,factoriconTechLocDesc)
-- END create factoricon technology

-- create precursor factoricon fluids
local factoriconGelIcons = {{icon="__leighzerlib__/graphics/icons/factoricons/factoricon-gel.png",icon_size=32}}
local autoBarrel = false
local topRowSubgroup = "leighzerfactoricons-top-row"
leighzermods.utils.createFluid("factoricon-gel",leighzermods.tints.white,leighzermods.tints.white,factoriconGelIcons,autoBarrel,topRowSubgroup,"a","Factoricon gel")

local factoriconInkIcons = {{icon="__leighzerlib__/graphics/icons/factoricons/factoricon-ink.png",icon_size=32}}
leighzermods.utils.createFluid("factoricon-ink",leighzermods.tints.black,leighzermods.tints.black,factoriconInkIcons,autoBarrel,topRowSubgroup,"b","Factoricon ink")
-- END create precursor factoricon fluids

-- create precursor factoricon fluid recipes
local gelIngredients = {} 
local inkIngredients = {}
if leighzermods.leighzerfactoricons.precursorIngredients == "Water & iron & copper plates" then
    gelIngredients = {{type="fluid",name="water",amount=10},{type="item",name="iron-plate",amount=2},{type="item",name="copper-plate",amount=2}}
    inkIngredients = {{type="fluid",name="water",amount=5},{type="item",name="iron-plate",amount=1},{type="item",name="copper-plate",amount=1}}
else
    gelIngredients = {{type="fluid",name="water",amount=10}}
    inkIngredients = {{type="fluid",name="water",amount=5}}
end

local gelResults = {{type="fluid",name="factoricon-gel",amount=10}}
local inkResults = {{type="fluid",name="factoricon-ink",amount=10}}

-- nil icons so will use icon from fluid - reasoning for nil locale
-- nil main product, not really applicable for this kind of recipe
leighzermods.utils.createRecipeComplex("factoricon-gel",1,false,"chemistry",gelIngredients,nil,gelResults,topRowSubgroup,"a",nil,true,nil)
leighzermods.utils.addEffect('factoricon',{type = 'unlock-recipe', recipe = 'factoricon-gel'})

leighzermods.utils.createRecipeComplex("factoricon-ink",1,false,"chemistry",inkIngredients,nil,inkResults,topRowSubgroup,"b",nil,true,nil)
leighzermods.utils.addEffect('factoricon',{type = 'unlock-recipe', recipe = 'factoricon-ink'})
-- END create precursor factoricon fluid recipes

-- PROGRAMMATICALLY GENERATED LUA
require("generated-factoricons")
-- END PROGRAMMATICALLY GENERATED LUA

-- reference for linking final factoricons to the factoricon rocket part
-- create factoricon rocket part
-- FINAL factoricon ingredients for factoricon rocket part
-- factoricon-grey-wrap_text
-- factoricon-grey-youtube_searched_for
-- factoricon-grey-zoom_in
-- factoricon-grey-zoom_out
-- factoricon-grey-zoom_out_map

leighzermods.utils.createItemFromGeneric("factoricon","white","rocket-part",topRowSubgroup,"c",100)
local factoriconRocketPartIngredients = {
    {
        name="factoricon-grey-wrap_text", amount=1
    },
    {
        name="factoricon-grey-youtube_searched_for", amount=1
    },
    {
        name="factoricon-grey-zoom_in", amount=1
    },
    {
        name="factoricon-grey-zoom_out", amount=1
    },
    {
        name="factoricon-grey-zoom_out_map", amount=1
    }
}
leighzermods.utils.createRecipe("factoricon-rocket-part",10,false,"crafting",factoriconRocketPartIngredients,"factoricon-rocket-part",1,topRowSubgroup,"c",true)
leighzermods.utils.addEffect('factoricon',{type = 'unlock-recipe', recipe = 'factoricon-rocket-part'})
-- END create factoricon rocket part

-- VANILLA UPDATES
-- make vanilla rocket part require factoricon rocket part
leighzermods.utils.addIngredientToRecipe("rocket-part",{name="factoricon-rocket-part",amount=1})

-- shift around tech tree a LITTLE bit to make some more sense given our new tech
leighzermods.utils.setPrerequisites("space-science-pack",factoriconTechPrereqs)
leighzermods.utils.addPrerequisite("rocket-silo","factoricon")
leighzermods.utils.removePrerequisite("rocket-silo","rocket-control-unit")

-- update space pack recipe so folks can still infinite research without launching a rocket
local spaceSciencePackIngredients = {
    {name="rocket-control-unit", amount=1},
    {name="low-density-structure", amount=2},
    {name="rocket-fuel", amount=2},
    {name="radar", amount=3},
}
leighzermods.utils.createRecipe("space-science-pack",50,false,"crafting",spaceSciencePackIngredients,"space-science-pack",1,nil,nil,true)
data.raw.tool["space-science-pack"].localised_description = "Used by labs for research."
leighzermods.utils.addEffect('space-science-pack',{type = 'unlock-recipe', recipe = 'space-science-pack'})

-- launching a rocket is the ultimate goal of the mod - there is no item that we can provide that covers the cost to launch the rocket
if data.raw.item["satellite"] then
    data.raw.item["satellite"].rocket_launch_product = nil --make launching a satellite return nothing - we already have a way to get space science
end
-- END VANILLA UPDATES