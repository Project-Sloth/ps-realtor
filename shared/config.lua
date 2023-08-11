Config = Config or {}

-- Set your Real Estate here
Config.RealtorJobName = "realestate"

-- Set this value to true if you want to use the command to open the Housing Menu(Realtor Menu)
Config.UseCommand = true

-- Set this value to TRUE if you want to use the Config.ItemName as a usable Item to open the Housing Menu(Realtor Menu)
Config.UseItem = true

--Set this value to FALSE if u DON'T want to play the tablet animation when using /housing or the usable item
Config.PlayAnimation = true

--Change this to whatever prop u want to use for the animation
Config.AnimationProp = 'prop_cs_tablet'

Config.ItemName = "tablet"  -- Item name to make it usable. 
-- Change the uniqueness and the usability inside qb-core -> items.lua to TRUE
-- add this item to a shop or anything else!

--Commisions is handled in ps-housing config.

Config.RealtorPerms = {
    manageProperty = 1, --minimum grade to manage property | default 1
    changePropertyForSale = 0, --minimum grade to list property | default 0
    sellProperty = 0, --minimum grade to sell property | default 0
    listNewProperty = 2, --minimum grade to list property | default 2
    deleteProperty = 2, --minimum grade to delete property | default 2
    setApartments = 2, --minimum grade to set apartments for players | default 2
}
