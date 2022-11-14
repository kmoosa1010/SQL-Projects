/*
For this project, I used Nashville housing data from Kaggle to demonstrate data cleaning using SQL.  
I have identified a couple of things to change when I was exploring the data in MS SQL Management Studio:  
*/

--Firstly, convert the date format to a standardised date format.

SELECT SaleDate, CONVERT(date, saleDate)
FROM projectDB.dbo.Nashville_Housing;

ALTER TABLE projectDB.dbo.Nashville_Housing
ADD modifiedSaleDate Date;

UPDATE projectDB.dbo.Nashville_Housing
SET modifiedSaleDate = CONVERT(date, saleDate);

---------------------------------------------------------------------


/*
Secondly, replace the Null value address of properties with the same “parcel ID” 
but with a different “Unique Id”.
*/

SELECT a.PropertyAddress,b.parcelID,b.PropertyAddress,  ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM projectDB.dbo.Nashville_Housing a 
JOIN projectDB.dbo.Nashville_Housing b
	ON a.parcelID = b.parcelID
	AND a.[UniqueID] != b.[UniqueID]
WHERE a.PropertyAddress IS NULL;

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM projectDB.dbo.Nashville_Housing a 
JOIN projectDB.dbo.Nashville_Housing b
	ON a.parcelID = b.parcelID
	AND a.[UniqueID] != b.[UniqueID]
WHERE a.PropertyAddress IS NULL;

------------------------------------------------------------------------------------------------

/*	
And then, I am going to separate the property address into single columns: street address and city. 

*/

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1) "Address"
, SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress)) "City"
FROM projectDB.dbo.Nashville_Housing;

ALTER TABLE projectDB.dbo.Nashville_Housing
ADD NewPropertyAddress NVARCHAR(200);

ALTER TABLE projectDB.dbo.Nashville_Housing
ADD NewPropertyCity NVARCHAR(200);

UPDATE projectDB.dbo.Nashville_Housing
SET NewPropertyAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1);

UPDATE projectDB.dbo.Nashville_Housing
SET NewPropertyCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress));


--Also separate the owner’s address into single columns of the street address, city, and state.

SELECT
PARSENAME(REPLACE(OwnerAddress,',','.'), 3)
, PARSENAME(REPLACE(OwnerAddress,',','.'), 2)
,PARSENAME(REPLACE(OwnerAddress,',','.'), 1)
FROM projectDB.dbo.Nashville_Housing;

ALTER TABLE projectDB.dbo.Nashville_housing
ADD NewOwnerAddress NVARCHAR(200);

ALTER TABLE projectDB.dbo.Nashville_housing
ADD NewOwnerCity NVARCHAR(200);

ALTER TABLE projectDB.dbo.Nashville_housing
ADD NewOwnerState NVARCHAR(200);


UPDATE projectDB.dbo.Nashville_Housing
SET NewOwnerAddress = PARSENAME(REPLACE(OwnerAddress,',','.'), 3);

UPDATE projectDB.dbo.Nashville_housing
SET NewOwnerCity = PARSENAME(REPLACE(OwnerAddress,',','.'), 2);

UPDATE projectDB.dbo.Nashville_housing
SET NewOwnerState = PARSENAME(REPLACE(OwnerAddress,',','.'), 1);

-------------------------------------------------------------------------------------------

/*
The “sold as vacant” column had multiple values( N, No, Y, Yes), 
so I am going to change N to No and Y to Yes.
*/

SELECT SoldAsVacant, 
CASE
WHEN  SoldAsVacant = 'Y' THEN 'Yes'
WHEN  SoldAsVacant = 'N' THEN 'No'
ELSE  SoldAsVacant
END
FROM projectDB.dbo.Nashville_housing;

UPDATE projectDB.dbo.Nashville_housing
SET SoldAsVacant = CASE
WHEN  SoldAsVacant = 'Y' THEN 'Yes'
WHEN  SoldAsVacant = 'N' THEN 'No'
ELSE  SoldAsVacant
END;


--------------------------------------------------------------

--and Lastly, delete unused columns.

ALTER TABLE projectDB.dbo.Nashville_housing
DROP COLUMN OwnerAddress, PropertyAddress, SaleDate;
