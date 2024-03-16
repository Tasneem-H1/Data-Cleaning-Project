-- Cleaning Data in SQL Queries
Select *
From PortfolioProject.dbo.NashvilleHousing

		-- Standardize Date Format

Select SaleDate, Convert( Date, SaleDate) as SaleDate1

From PortfolioProject.dbo.NashvilleHousing
Update PortfolioProject.dbo.NashvilleHousing
Set SaleDate= Convert( Date, SaleDate) 

		-- Populate Property Address data
Select * from PortfolioProject.dbo.NashvilleHousing
Where PropertyAddress is null
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing as a
Join PortfolioProject.dbo.NashvilleHousing as b
On a.ParcelID= b.ParcelID
And a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null
Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null



		-- Breaking out Address into Individual Columns (Address, City, State)
		--PropertyAddress

Select SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

From PortfolioProject.dbo.NashvilleHousing


Alter Table  PortfolioProject.dbo.NashvilleHousing
Add PropertySplitAddress Nvarchar(255);
Update  PortfolioProject.dbo.NashvilleHousing
Set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )

Alter Table  PortfolioProject.dbo.NashvilleHousing
Add PropertySplitCity Nvarchar(255);
Update  PortfolioProject.dbo.NashvilleHousing
Set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))

Select *
From PortfolioProject.dbo.NashvilleHousing


			-- Breaking out Address into Individual Columns (Address, City, State)
			--OwnerAddress

Select 
ParseName (Replace(OwnerAddress,',','.'),3),
ParseName (Replace(OwnerAddress,',','.'),2),
ParseName (Replace(OwnerAddress,',','.'),1)
From PortfolioProject.dbo.NashvilleHousing

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);
Update PortfolioProject.dbo.NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add OwnerSplitCity Nvarchar(255);
Update PortfolioProject.dbo.NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add OwnerSplitState Nvarchar(255);
Update PortfolioProject.dbo.NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)


Select *
From PortfolioProject.dbo.NashvilleHousing 


		-- Change Y and N to Yes and No in "Sold as Vacant" field
Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject.dbo.NashvilleHousing
Group by SoldAsVacant
order by 2

Select SoldAsVacant,
Case 
When SoldAsVacant= 'Y' Then 'Yes'
When SoldAsVacant= 'N' Then 'No'
Else SoldAsVacant
End
From PortfolioProject.dbo.NashvilleHousing

Update PortfolioProject.dbo.NashvilleHousing
SET SoldAsVacant =  
Case 
When SoldAsVacant= 'Y' Then 'Yes'
When SoldAsVacant= 'N' Then 'No'
Else SoldAsVacant
End
From PortfolioProject.dbo.NashvilleHousing


		-- Remove Duplicates

With RowNumCTE as(
Select *,
	Row_Number() Over (
	Partition bY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) as row_num

From PortfolioProject.dbo.NashvilleHousing
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress


		-- Delete Unused Columns

Alter Table PortfolioProject.dbo.NashvilleHousing
Drop column OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

Select * From PortfolioProject.dbo.NashvilleHousing

