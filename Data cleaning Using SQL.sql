alter table nashvillehousing
add propertysplitaddress nvarchar(255);

update nashvillehousing
set propertysplitaddress =SUBSTRING(propertyaddress, 1, charindex(',', propertyaddress) -1)

alter table nashvillehousing
add propertysplitcity nvarchar(255);

update nashvillehousing
set propertysplitcity =substring(propertyaddress, charindex(',', propertyaddress)+1, len(propertyaddress))
