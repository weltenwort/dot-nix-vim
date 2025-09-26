if nixCats('common') then
  require('user.common')
end

if nixCats('lang-nix') then
  require('user.lang-nix')
end

if nixCats('lang-lua') then
  require('user.lang-lua')
end

-- late config
if nixCats('common') then
  require('user.common.after')
end
