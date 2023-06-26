select * 
from portfolioproject..NashvilleHousing

select saledateconverted1, convert(smalldatetime, saledate)
from portfolioproject..NashvilleHousing

update portfolioproject..NashvilleHousing
set SaleDate=convert(smalldatetime, SaleDate)

alter table portfolioproject..nashvillehousing
add saledateupdated1 date

update portfolioproject..NashvilleHousing
set SaleDateupdated1=convert(date, SaleDate)



--populate property address data

select *
from portfolioproject..NashvilleHousing
--where PropertyAddress is null
order by ParcelID


select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, isnull(a.PropertyAddress,b.PropertyAddress)
from portfolioproject..NashvilleHousing as a
join portfolioproject..NashvilleHousing as b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null

update a 
set propertyaddress = isnull(a.propertyaddress,b.propertyaddress)
from portfolioproject..NashvilleHousing as a
join portfolioproject..NashvilleHousing as b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null


--breaking out address into individual columns (address, city, state)


select PropertyAddress
from portfolioproject..NashvilleHousing
--where PropertyAddress is null
--order by ParcelID

select
SUBSTRING(propertyaddress, 1, charindex(',', propertyaddress) -1) as address,
substring(propertyaddress, charindex(',', propertyaddress)+1, len(propertyaddress)) as address
from portfolioproject..nashvillehousing


alter table portfolioproject..nashvillehousing
add propertysplitaddress varchar(255);

update portfolioproject..nashvillehousing
set propertysplitaddress =SUBSTRING(propertyaddress, 1, charindex(',', propertyaddress) -1)

alter table portfolioproject..nashvillehousing
add propertysplitcity nvarchar(255);

update portfolioproject..nashvillehousing
set propertysplitcity =substring(propertyaddress, charindex(',', propertyaddress)+1, len(propertyaddress))


select *
from portfolioproject..NashvilleHousing






select OwnerAddress
from portfolioproject..NashvilleHousing

select 
parsename(replace(OwnerAddress,',','.'),3),
parsename(replace(OwnerAddress,',','.'),2),
parsename(replace(OwnerAddress,',','.'),1)
from portfolioproject..NashvilleHousing

alter table portfolioproject..nashvillehousing
add ownerplitaddress varchar(255);

update portfolioproject..nashvillehousing
set ownerplitaddress =parsename(replace(OwnerAddress,',','.'),3)

alter table portfolioproject..nashvillehousing
add ownersplitcity nvarchar(255);

update portfolioproject..nashvillehousing
set ownersplitcity =parsename(replace(OwnerAddress,',','.'),2)

alter table portfolioproject..nashvillehousing
add ownersplitstate nvarchar(255);

update portfolioproject..nashvillehousing
set ownersplitstate =parsename(replace(OwnerAddress,',','.'),1)


select *
from portfolioproject..NashvilleHousing



--Changes Y and N to yes and no in "sold and vacant " filed

select distinct(soldasvacant),  count(soldasvacant)
from portfolioproject..NashvilleHousing
group by SoldAsVacant
order by 2


select SoldAsVacant,
case when SoldAsVacant='Y' then 'Yes'
when soldasvacant ='N' then 'No'
else SoldAsVacant
end
from portfolioproject..NashvilleHousing

update portfolioproject..NashvilleHousing
set soldasvacant =case when SoldAsVacant='Y' then 'Yes'
when soldasvacant ='N' then 'No'
else SoldAsVacant
end



--remove Duplicates
--make an temp table and then delete anything due to data saftey 


WITH ajay_CTE  AS
(select * ,
ROW_NUMBER() over(
             partition by 
			 ParcelID,
			 propertyaddress,
			 saleprice,
			 saledate,
			 legalreference
			 order by 
			 UniqueID
			 ) as row_num
from portfolioproject..NashvilleHousing
--order by ParcelID
--where row_num >1
)
select *
from ajay_CTE
where row_num >1
order by PropertyAddress

-- now delete those duplicate   entries 


WITH ajay_CTE  AS
(select * ,
ROW_NUMBER() over(
             partition by 
			 ParcelID,
			 propertyaddress,
			 saleprice,
			 saledate,
			 legalreference
			 order by 
			 UniqueID
			 ) as row_num
from portfolioproject..NashvilleHousing
--order by ParcelID
)
delete
from ajay_CTE
where row_num >1

--Delete unused column (never alter or delete raw data , make an temp table and then do all these operations)


select *
from portfolioproject..NashvilleHousing


alter table portfolioproject..NashvilleHousing
drop column owneraddress, Taxdistrict , propertyaddress

alter table portfolioproject..NashvilleHousing
drop column saledate