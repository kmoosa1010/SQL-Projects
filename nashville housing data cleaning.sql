select * from nashvillehousing


--populate the property address
select * 
from nashvillehousing
where propertyaddress is null
order by parcelid

select a.parcelid, a.propertyaddress, b.parcelid, b.propertyaddress, nvl2(a.propertyaddress, b.propertyaddress,b.propertyaddress )
from nashvillehousing a
join nashvillehousing b
on a.parcelid = b.parcelid
and a.uniqueid_ != b.uniqueid_
where a.propertyaddress is null

select uniqueid_,parcelid, propertyaddress
from nashvillehousing
where propertyaddress =any ( select  nvl2(a.propertyaddress, b.propertyaddress,b.propertyaddress )
                            from nashvillehousing a, nashvillehousing b
                            where (a.parcelid = b.parcelid
                            and a.uniqueid_ != b.uniqueid_ and a.propertyaddress is null)
                            --where a.propertyaddress is null
                            )


update a
set propertyaddress = nvl2(a.propertyaddress, b.propertyaddress,b.propertyaddress)
from nashvillehousing a
join nashvillehousing b
    on a.parcelid = b.parcelid
    and a.uniqueid_ != b.uniqueid_
--where a.propertyaddress is null

update nashvillehousing
set propertyaddress =any( select  b.propertyaddress
                            from nashvillehousing a, nashvillehousing b
                            where (a.parcelid = b.parcelid
                            and a.uniqueid_ != b.uniqueid_ and  a.propertyaddress is null)
                            --where a.propertyaddress is null
                            )
from nashvillehousing

merge into nashvillehousing a
    using nashvillehousing b
        on (a.parcelid = b.parcelid) and (a.uniqueid_ != b.uniqueid_)
    when matched then
        update set propertyaddress =  nvl2(a.propertyaddress, b.propertyaddress,b.propertyaddress)
          where a.propertyaddress is null
  
 rollback
-------------------------------------------------------------------------------

--breaking out property address into address and city columns

select propertyaddress
from nashvillehousing

select
substr(propertyaddress, 1, instr(propertyaddress, ',')-1) as address
,substr(propertyaddress, instr(propertyaddress, ',')+1, length(propertyaddress)) as address
from nashvillehousing


alter table nashvillehousing
add property_address varchar2(255)

alter table nashvillehousing
add property_city varchar2(255)

update nashvillehousing
set property_address = substr(propertyaddress, 1, instr(propertyaddress, ',')-1)

update nashvillehousing
set property_city = substr(propertyaddress, instr(propertyaddress, ',')+1, length(propertyaddress))

--------------------------------------------------------------------------
--breaking owner address into address, city and state columns
select owneraddress
from nashvillehousing

select
substr(owneraddress, 1, instr(owneraddress, ',')-1) as address
,substr(owneraddress,instr(owneraddress, ',')+2, instr(owneraddress, ',',1,2)- instr(owneraddress,',')-2) as address
,substr(owneraddress,instr(owneraddress, ',',1,2)+2, length(owneraddress))"state"
from nashvillehousing

alter table nashvillehousing
add owner_address varchar2(255)

alter table nashvillehousing
add owner_city varchar2(255)

alter table nashvillehousing
add owner_state varchar2(255)

update nashvillehousing
set owner_address = substr(owneraddress, 1, instr(owneraddress, ',')-1)

update nashvillehousing
set owner_city = substr(owneraddress,instr(owneraddress, ',')+2, instr(owneraddress, ',',1,2)- instr(owneraddress,',')-2)

update nashvillehousing
set owner_state = substr(owneraddress,instr(owneraddress, ',',1,2)+2, length(owneraddress))

----change Y and N to Yes and No in "sold as vacant" column---------------------

select distinct(SoldAsVacant), count(SoldAsVacant)
from nashvillehousing
group by SoldAsVacant
order by 2

select SoldAsVacant,
	case
		when SoldAsVacant = 'Y' then 'Yes'
        when SoldAsVacant = 'N' then 'No'
        else SoldAsVacant
        end
from nashvillehousing;

update nashvillehousing
set SoldAsVacant = case
		when SoldAsVacant = 'Y' then 'Yes'
        when SoldAsVacant = 'N' then 'No'
        else SoldAsVacant
        end
---------------------------------------------------
--remove duplicates
with rownumCTE as(
select *,
row_number() over (
partition by parcelid, propertyAdress, saleprice, saledate, legalreference
order by uniqueid) row_num
from nashvillehousing
)
select *  --checking
from rownumCTE
where row_num >1
order by propertyddress
order by parcelid

with rownumCTE as(
select *,
row_number() over (
partition by parcelid, propertyAdress, saleprice, saledate, legalreference
order by uniqueid) row_num
from nashvillehousing
)
delete
from rownumCTE
where row_num >1
order by propertyddress
--order by parcelid

---delete unused columns

select *
from nashvillehousing

alter table nashvillehousing
drop column owneraddress, taxdistrict, property address