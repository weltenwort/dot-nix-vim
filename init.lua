if nixCats('common') then
  require('user.common')
end

if nixCats('nixdev') then
  require('user.nixdev')
end

-- late config
if nixCats('common') then
  require('user.common.after')
end
