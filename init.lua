-- common
if nixCats("common") then
	require("user.common")
end

-- languages
if nixCats("lang-lua") then
	require("user.lang-lua")
end

if nixCats("lang-nix") then
	require("user.lang-nix")
end

if nixCats("lang-typescript") then
	require("user.lang-typescript")
end

-- features
if nixCats("feature-llm") then
	require("user.feature-llm")
end

-- late common
if nixCats("common") then
	require("user.common.after")
end
