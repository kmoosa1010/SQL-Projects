select * from Nashville_housing;


--standardise date format-----------------

SELECT SaleDate, CONVERT(date, saleDate)
FROM Nashville_housing;

ALTER TABLE Nashville_housing
ADD modifiedSaleDate Date;

UPDATE Nashville_housing
SET modifiedSaleDate = CONVERT(date, saleDate);

SELECT modifiedSaleDate
FROM Nashville_housing;

---------------------------------------------------------------------


-----populate property address--------

SELECT a.PropertyAddress,b.parcelID,b.PropertyAddress,  ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM Nashville_housing a 
JOIN Nashville_housing b
	ON a.parcelID = b.parcelID
	AND a.[UniqueID] != b.[UniqueID]
WHERE a.PropertyAddress IS NULL;

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM Nashville_housing a 
JOIN Nashville_housing b
	ON a.parcelID = b.parcelID
	AND a.[UniqueID] != b.[UniqueID]
WHERE a.PropertyAddress IS NULL;

------------------------------------------------------------------------------------------------

-----seperating property address into individual columns( address, city)

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1) "Address"
, SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress)) "City"
FROM Nashville_housing;

ALTER TABLE Nashville_housing
ADD NewPropertyAddress NVARCHAR(200);

ALTER TABLE Nashville_housing
ADD NewPropertyCity NVARCHAR(200)

UPDATE Nashville_housing
SET NewPropertyAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1);

UPDATE Nashville_housing
SET NewPropertyCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress));


---------------seperating owner address into individual columns( address, city, state)

SELECT
PARSENAME(REPLACE(OwnerAddress,',','.'), 3)
, PARSENAME(REPLACE(OwnerAddress,',','.'), 2)
,PARSENAME(REPLACE(OwnerAddress,',','.'), 1)
FROM Nashville_housing;

ALTER TABLE Nashville_housing
ADD NewOwnerAddress NVARCHAR(200);

ALTER TABLE Nashville_housing
ADD NewOwnerCity NVARCHAR(200);

ALTER TABLE Nashville_housing
ADD NewOwnerState NVARCHAR(200);


UPDATE Nashville_housing
SET NewOwnerAddress = PARSENAME(REPLACE(OwnerAddress,',','.'), 3);

UPDATE Nashville_housing
SET NewOwnerCity = PARSENAME(REPLACE(OwnerAddress,',','.'), 2);

UPDATE Nashville_housing
SET NewOwnerState = PARSENAME(REPLACE(OwnerAddress,',','.'), 1);

-------------------------------------------------------------------------------------------

---change Y and N to Yes and No in "sold as vacant" column

SELECT SoldAsVacant, 
CASE
WHEN  SoldAsVacant = 'Y' THEN 'Yes'
WHEN  SoldAsVacant = 'N' THEN 'No'
ELSE  SoldAsVacant
END
FROM Nashville_housing;

UPDATE Nashville_housing
SET SoldAsVacant = CASE
WHEN  SoldAsVacant = 'Y' THEN 'Yes'
WHEN  SoldAsVacant = 'N' THEN 'No'
ELSE  SoldAsVacant
END


--------------------------------------------------------------

--delete unused columns

ALTER TABLE Nashville_housing
DROP COLUMN OwnerAddress, PropertyAddress, SaleDate

SELECT * FROM Nashville_housing