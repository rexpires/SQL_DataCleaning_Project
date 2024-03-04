
-- Padronizar formato de data:

SELECT
	SaleDate,
	CONVERT(date,SaleDate)
FROM Portfolio1.dbo.NashvilleHousing


ALTER TABLE NashvilleHousing
ADD	SalesDateConverted Date	

UPDATE NashvilleHousing
SET SalesDateConverted = CONVERT(date,SaleDate)

SELECT
	SalesDateConverted
FROM Portfolio1.dbo.NashvilleHousing



--Preencher dados nulos em "Property Address":

SELECT
	*
FROM Portfolio1.dbo.NashvilleHousing
--WHERE PropertyAddress is null
ORDER BY ParcelID


SELECT
	a.ParcelID,
	a.PropertyAddress,
	b.ParcelID,
	b.PropertyAddress,
	ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM Portfolio1.dbo.NashvilleHousing a
JOIN Portfolio1.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM Portfolio1.dbo.NashvilleHousing a
JOIN Portfolio1.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null



--Quebrar "OwnerAddress" e "PropertyAddress" em colunas individuais (address, city, state):

SELECT
	OwnerAddress
FROM Portfolio1.dbo.NashvilleHousing

SELECT
	PARSENAME(REPLACE(OwnerAddress,',','.'),3),
	PARSENAME(REPLACE(OwnerAddress,',','.'),2),
	PARSENAME(REPLACE(OwnerAddress,',','.'),1)
FROM Portfolio1.dbo.NashvilleHousing


SELECT
	PropertyAddress
FROM Portfolio1.dbo.NashvilleHousing

SELECT
	PARSENAME(REPLACE(PropertyAddress,',','.'),2),
	PARSENAME(REPLACE(PropertyAddress,',','.'),1)
FROM Portfolio1.dbo.NashvilleHousing


ALTER TABLE NashvilleHousing
ADD	PropertySplitAddress NVarchar(255);	

UPDATE NashvilleHousing
SET PropertySplitAddress = PARSENAME(REPLACE(PropertyAddress,',','.'),2)

ALTER TABLE NashvilleHousing
ADD	PropertySplitCity NVarchar(255)	

UPDATE NashvilleHousing
SET PropertySplitCity = PARSENAME(REPLACE(PropertyAddress,',','.'),1)

SELECT
	*
FROM Portfolio1.dbo.NashvilleHousing


ALTER TABLE NashvilleHousing
ADD	OwnerSplitAddress NVarchar(255);	

UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

ALTER TABLE NashvilleHousing
ADD	OwnerSplitCity NVarchar(255)	

UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

ALTER TABLE NashvilleHousing
ADD	OwnerSplitState NVarchar(255)	

UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)

SELECT
	*
FROM Portfolio1.dbo.NashvilleHousing



-- Mudar Y ou N para Yes e NO no campo "Sold as Vacant":

SELECT DISTINCT 
	SoldAsVacant,
	COUNT(SoldAsVacant)
FROM Portfolio1.dbo.NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant,
	CASE When SoldAsVacant = 'Y' THEN 'Yes'
	When SoldAsVacant = 'N' THEN 'No'
	Else SoldAsVacant
	END
FROM Portfolio1.dbo.NashvilleHousing

UPDATE NashvilleHousing
SET SoldAsVacant = 	CASE When SoldAsVacant = 'Y' THEN 'Yes'
	When SoldAsVacant = 'N' THEN 'No'
	Else SoldAsVacant
	END



-- Remover valores duplicados:

WITH RowNumCTE AS(
SELECT
	*,
	ROW_NUMBER() 
	OVER (PARTITION BY ParcelID,
					   PropertyAddress,
				       SalePrice,
				       SaleDate,
				       LegalReference
				       ORDER BY
						UniqueID
						) as row_num
FROM Portfolio1.dbo.NashvilleHousing
)
SELECT
	*
FROM RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress



--Deletar colunas não usadas

SELECT
	*
FROM Portfolio1.dbo.NashvilleHousing

ALTER TABLE Portfolio1.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, PropertyAddress, TaxDistrict, SaleDate

